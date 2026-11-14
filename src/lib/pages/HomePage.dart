import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:growthtracker/controller/AuthController.dart';
import 'package:growthtracker/controller/ChildrenController.dart';
import 'package:growthtracker/controller/GrowthHistoryController.dart';
import 'package:growthtracker/controller/NotificationController.dart';
import 'package:growthtracker/controller/SessionController.dart';
import 'package:growthtracker/controller/VaccinationScheduleController.dart';
import 'package:growthtracker/pages/ArticlePage.dart';
import 'package:growthtracker/pages/ChildrenDetailPage.dart';
import 'package:growthtracker/pages/ChildrenEditorPage.dart';
import 'package:growthtracker/pages/GrowthEditorPage.dart';
import 'package:growthtracker/pages/GrowthHistoryPage.dart';
import 'package:growthtracker/pages/NotificationPage.dart';
import 'package:growthtracker/pages/VaccinationSchedulePage.dart';
import 'package:growthtracker/services/GrowthStatus.dart';
import 'package:growthtracker/theme/app_theme.dart';
import 'package:growthtracker/widgets/app_widgets.dart';

/// Home dashboard.
///
/// Children are stored on the device, so this page renders immediately: the
/// only asynchronous work is reading local storage for the selected child's
/// growth and vaccination data.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final childrenController = Get.put(ChildrenController());
  final authController = Get.put(AuthController());
  final sessionController = Get.put(SessionController());
  final notificationController = Get.put(NotificationController());

  late final GrowthHistoryController growthController =
      Get.isRegistered<GrowthHistoryController>(tag: 'home')
          ? Get.find<GrowthHistoryController>(tag: 'home')
          : Get.put(GrowthHistoryController(), tag: 'home');

  late final VaccinationScheduleController vaccinationController =
      Get.isRegistered<VaccinationScheduleController>(tag: 'home')
          ? Get.find<VaccinationScheduleController>(tag: 'home')
          : Get.put(VaccinationScheduleController(), tag: 'home');

  final ScrollController _scrollController = ScrollController();
  bool _lightStatusBar = true;

  bool _loading = true;
  bool _childLoading = false;
  String? _selectedId;
  int _loadToken = 0;

  List<Map<String, dynamic>> _records = [];
  List<Map<String, dynamic>> _schedule = [];

  List<dynamic> get _children => childrenController.anakList;

  dynamic get _selectedChild {
    for (final child in _children) {
      if ('${child['anak_id']}' == _selectedId) return child;
    }
    return _children.isNotEmpty ? _children.first : null;
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadData();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  /// The gradient header sits under the status bar at the top of the page, so
  /// the icons switch to dark as soon as the light background scrolls in.
  void _onScroll() {
    final light = _scrollController.offset < 240;
    if (light != _lightStatusBar) {
      setState(() => _lightStatusBar = light);
    }
  }

  /// Used by the app shell after adding a measurement from the quick action.
  Future<void> refresh() => _loadData(showLoader: false);

  Future<void> _loadData({bool showLoader = true}) async {
    if (showLoader && mounted) setState(() => _loading = true);

    await childrenController.getAnak(sessionController.user_id.value, null);

    if (!mounted) return;
    final children = _children;
    final hasSelection =
        children.any((child) => '${child['anak_id']}' == _selectedId);
    setState(() {
      if (!hasSelection) {
        _selectedId = children.isEmpty ? null : '${children.first['anak_id']}';
      }
      _loading = false;
    });

    if (_selectedId != null) {
      await _loadChildData(_selectedId!);
    } else {
      setState(() {
        _records = [];
        _schedule = [];
        _childLoading = false;
      });
    }

    // The parent's name comes from the server; loading it must never block the
    // local dashboard.
    if (sessionController.user_id.value.isNotEmpty) {
      authController
          .getOrangTua(sessionController.user_id.value)
          .then((_) => mounted ? setState(() {}) : null);
    }
  }

  Future<void> _loadChildData(String anakId) async {
    final token = ++_loadToken;
    setState(() => _childLoading = true);

    await Future.wait([
      growthController.getPertumbuhanAnak(anakId),
      vaccinationController.getJadwalVaksin(anakId),
    ]);

    if (!mounted || token != _loadToken) return;
    setState(() {
      _records = growthController.riwayatPertumbuhan
          .map((record) => Map<String, dynamic>.from(record))
          .toList();
      _schedule = vaccinationController.jadwalVaksinasi
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
      _childLoading = false;
    });
  }

  void _selectChild(dynamic child) {
    final id = '${child['anak_id']}';
    if (id == _selectedId) return;
    setState(() => _selectedId = id);
    _loadChildData(id);
  }

  // ---------------------------------------------------------------------------
  // Derived data
  // ---------------------------------------------------------------------------

  DateTime _recordDate(Map<String, dynamic> record) {
    return DateTime.tryParse('${record['tanggal_pertumbuhan'] ?? ''}') ??
        DateTime.tryParse('${record['created_date'] ?? ''}') ??
        DateTime(1970);
  }

  List<Map<String, dynamic>> get _sortedRecords {
    final sorted = [..._records]
      ..sort((a, b) => _recordDate(a).compareTo(_recordDate(b)));
    return sorted;
  }

  Map<String, dynamic>? get _latestRecord =>
      _sortedRecords.isEmpty ? null : _sortedRecords.last;

  List<double> get _weightTrend {
    final sorted = _sortedRecords;
    final values = sorted
        .map((record) => double.tryParse('${record['berat_badan'] ?? ''}'))
        .whereType<double>()
        .toList();
    if (values.length > 8) {
      return values.sublist(values.length - 8);
    }
    return values;
  }

  int get _vaccinationTotal {
    var total = 0;
    for (final period in _schedule) {
      total += ((period['vaksin'] as List?) ?? const []).length;
    }
    return total;
  }

  int get _vaccinationDone {
    var done = 0;
    for (final period in _schedule) {
      for (final vaccine in (period['vaksin'] as List?) ?? const []) {
        if ('${vaccine['status']}' == 'Sudah') done++;
      }
    }
    return done;
  }

  String? get _nextVaccine {
    for (final period in _schedule) {
      for (final vaccine in (period['vaksin'] as List?) ?? const []) {
        if ('${vaccine['status']}' != 'Sudah') {
          return '${vaccine['nama_vaksin'] ?? ''}';
        }
      }
    }
    return null;
  }

  String _formatNumber(dynamic value) {
    final parsed = value is num ? value.toDouble() : double.tryParse('$value');
    if (parsed == null) return '$value';
    if (parsed == parsed.truncateToDouble()) return parsed.toStringAsFixed(0);
    return parsed.toStringAsFixed(1);
  }

  String _formatDate(DateTime date) => DateFormat('d MMM y').format(date);

  ({String label, AppTone tone}) _statusFor(Map<String, dynamic>? record) {
    final raw = record?['status_pertumbuhan_tinggi']?.toString();
    final label = GrowthStatus.labelKey(raw)?.tr;
    if (label == null) {
      return (label: 'status_tidak_ada'.tr, tone: AppTone.neutral);
    }
    if (GrowthStatus.isNormal(raw)) {
      return (label: label, tone: AppTone.mint);
    }
    final code = GrowthStatus.codeFor(raw);
    final severe = code == GrowthStatus.sangatPendek ||
        code == GrowthStatus.giziBuruk ||
        code == GrowthStatus.mikrosefali;
    return (label: label, tone: severe ? AppTone.coral : AppTone.amber);
  }

  String _shortStatusLabel(Map<String, dynamic>? record) {
    final raw = record?['status_pertumbuhan_tinggi']?.toString();
    final code = GrowthStatus.codeFor(raw);
    switch (code) {
      case GrowthStatus.sangatPendek:
        return 'status_short_sangat_pendek'.tr;
      case GrowthStatus.tinggiNormal:
        return 'status_short_tinggi_normal'.tr;
      case GrowthStatus.lingkarNormal:
        return 'status_short_lingkar_normal'.tr;
      case GrowthStatus.tidakAda:
        return 'status_short_tidak_ada'.tr;
      default:
        return GrowthStatus.labelKey(raw)?.tr ?? 'status_short_tidak_ada'.tr;
    }
  }

  String get _greeting {
    if (authController.isParent.isNotEmpty) {
      final name =
          '${authController.isParent[0]['nama_orang_tua'] ?? ''}'.trim();
      if (name.isNotEmpty) {
        return 'greeting'.trParams({'name': name});
      }
    }
    return 'greeting_parent'.tr;
  }

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  Future<void> _openChild(dynamic child) async {
    await childrenController.getAnakById(
      sessionController.user_id.value,
      child['anak_id'],
    );
    await Get.to(() => ChildrenDetailPage());
    if (mounted) refresh();
  }

  void _openNotifications() {
    notificationController.getNotifikasi(sessionController.user_id.value);
    Get.to(() => NotifikasiPage());
  }

  void _openGrowthHistory(dynamic child) {
    Get.to(
      () => GrowthHistoryPage(
        anak_id: '${child['anak_id']}',
        tinggi_badan_ayah: '${child['tinggi_badan_ayah'] ?? ''}',
        tinggi_badan_ibu: '${child['tinggi_badan_ibu'] ?? ''}',
      ),
    )?.then((_) => refresh());
  }

  void _openVaccination(dynamic child) {
    Get.to(() => VaccinationSchedulePage(anak_id: '${child['anak_id']}'))
        ?.then((_) => refresh());
  }

  Future<void> _addMeasurement(dynamic child) async {
    await Get.to(
      () => GrowthEditorPage(
        anakID: '${child['anak_id']}',
        tinggiBadanAyah: '${child['tinggi_badan_ayah'] ?? ''}',
        tinggiBadanIbu: '${child['tinggi_badan_ibu'] ?? ''}',
      ),
    );
    if (mounted) refresh();
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final overlay = _lightStatusBar
        ? SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.transparent,
          )
        : SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.transparent,
          );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          onRefresh: () => _loadData(showLoader: false),
          child: ListView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: EdgeInsets.zero,
            children: [
              _buildHeader(context),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 130),
                child: _loading
                    ? _buildSkeletons()
                    : _children.isEmpty
                        ? _buildNoChildren(context)
                        : _buildDashboard(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return AppHeader(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _greeting,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                height: 1.25,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'app_tagline'.tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.72),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AppIconButton(
                    icon: Icons.notifications_none_rounded,
                    background: Colors.white.withValues(alpha: 0.16),
                    foreground: Colors.white,
                    onTap: _openNotifications,
                  ),
                  Positioned(
                    top: 10,
                    right: 11,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFC24B),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary,
                          width: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (_children.isNotEmpty) ...[
            const SizedBox(height: 22),
            _buildChildSelector(context),
          ],
        ],
      ),
    );
  }

  Widget _buildChildSelector(BuildContext context) {
    return SizedBox(
      height: 106,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        clipBehavior: Clip.none,
        itemCount: _children.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          if (index == _children.length) {
            return _AddChildCard(
              onTap: () => Get.to(
                () => ChildrenEditorPage(anak_id: null),
              )?.then((_) => refresh()),
            );
          }
          final child = _children[index];
          final selected = '${child['anak_id']}' == _selectedId;
          return _ChildCard(
            child: child,
            selected: selected,
            status: selected
                ? (
                    label: _shortStatusLabel(_latestRecord),
                    tone: _statusFor(_latestRecord).tone,
                  )
                : null,
            onTap: () => _selectChild(child),
            onOpen: () => _openChild(child),
          );
        },
      ),
    );
  }

  Widget _buildSkeletons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SkeletonBox(width: 160, height: 20),
        const SizedBox(height: 14),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SkeletonBox(width: 120, height: 14),
              SizedBox(height: 16),
              SkeletonBox(height: 62, radius: 14),
              SizedBox(height: 10),
              SkeletonBox(height: 62, radius: 14),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SkeletonBox(width: 120, height: 20),
        const SizedBox(height: 14),
        AppCard(
          child: Row(
            children: [
              for (var i = 0; i < 4; i++) ...[
                Expanded(
                  child: Column(
                    children: const [
                      SkeletonBox(width: 46, height: 46, radius: 14),
                      SizedBox(height: 8),
                      SkeletonBox(width: 48, height: 10),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoChildren(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCard(
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 26),
          child: Column(
            children: [
              Container(
                width: 96,
                height: 106,
                decoration: const BoxDecoration(
                  gradient: AppColors.brandGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.child_care_rounded,
                  size: 48,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'no_child_profile'.tr,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'add_child_profile'.tr,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'add_child_profile'.tr,
                icon: Icons.add_rounded,
                onPressed: () => Get.to(
                  () => ChildrenEditorPage(anak_id: null),
                )?.then((_) => refresh()),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildTipCard(context),
      ],
    );
  }

  Widget _buildDashboard(BuildContext context) {
    final child = _selectedChild;
    if (child == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLatestMeasurement(context, child),
        const SizedBox(height: 26),
        AppSectionHeader(title: 'quick_actions'.tr),
        const SizedBox(height: 12),
        _buildQuickActions(child),
        if (_vaccinationTotal > 0) ...[
          const SizedBox(height: 26),
          _buildVaccinationCard(context, child),
        ],
        const SizedBox(height: 26),
        _buildTipCard(context),
      ],
    );
  }

  Widget _buildLatestMeasurement(BuildContext context, dynamic child) {
    final latest = _latestRecord;
    final status = _statusFor(latest);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: 'latest_measurement'.tr,
          actionLabel: latest == null ? null : 'see_all'.tr,
          onAction: () => _openGrowthHistory(child),
        ),
        const SizedBox(height: 12),
        AppCard(
          onTap: latest == null
              ? () => _addMeasurement(child)
              : () => _openChild(child),
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
          child: _childLoading
              ? const Column(
                  children: [
                    SkeletonBox(height: 18),
                    SizedBox(height: 14),
                    SkeletonBox(height: 66, radius: 14),
                  ],
                )
              : latest == null
                  ? _buildNoMeasurement(context, child)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'last_measured'.trParams({
                            'date': _formatDate(_recordDate(latest)),
                          }),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${child['nama_anak']}',
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        StatusPill(
                          label: status.label,
                          tone: status.tone,
                          icon: Icons.monitor_heart_outlined,
                          dense: true,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: MetricTile(
                                icon: Icons.monitor_weight_rounded,
                                label: 'weight'.tr,
                                value: _formatNumber(latest['berat_badan']),
                                unit: 'kg',
                                tone: AppTone.primary,
                                compact: true,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: MetricTile(
                                icon: Icons.straighten_rounded,
                                label: 'height'.tr,
                                value: _formatNumber(latest['tinggi_badan']),
                                unit: 'cm',
                                tone: AppTone.mint,
                                compact: true,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: MetricTile(
                                icon: Icons.circle_outlined,
                                label: 'head_short'.tr,
                                value: _formatNumber(latest['lingkar_kepala']),
                                unit: 'cm',
                                tone: AppTone.amber,
                                compact: true,
                              ),
                            ),
                          ],
                        ),
                        if (_weightTrend.length >= 2) ...[
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Text(
                                'growth_trend'.tr,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const Spacer(),
                              Text(
                                'weight'.tr,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Sparkline(
                            values: _weightTrend,
                            color: AppColors.primary,
                            height: 58,
                          ),
                        ],
                      ],
                    ),
        ),
      ],
    );
  }

  Widget _buildNoMeasurement(BuildContext context, dynamic child) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.monitor_heart_outlined,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'no_measurement'.tr,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 3),
              Text(
                'add_measurement'.tr,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        AppIconButton(
          icon: Icons.add_rounded,
          onTap: () => _addMeasurement(child),
        ),
      ],
    );
  }

  Widget _buildQuickActions(dynamic child) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: _QuickTile(
              icon: Icons.show_chart_rounded,
              label: 'growth_history'.tr,
              tone: AppTone.primary,
              onTap: () => _openGrowthHistory(child),
            ),
          ),
          Expanded(
            child: _QuickTile(
              icon: Icons.vaccines_rounded,
              label: 'vaccination'.tr,
              tone: AppTone.mint,
              onTap: () => _openVaccination(child),
            ),
          ),
          Expanded(
            child: _QuickTile(
              icon: Icons.menu_book_rounded,
              label: 'articles'.tr,
              tone: AppTone.amber,
              onTap: () => Get.to(
                () => const ArticlePage(),
                transition: Transition.fadeIn,
              ),
            ),
          ),
          Expanded(
            child: _QuickTile(
              icon: Icons.notifications_active_rounded,
              label: 'notifications'.tr,
              tone: AppTone.coral,
              onTap: _openNotifications,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVaccinationCard(BuildContext context, dynamic child) {
    final total = _vaccinationTotal;
    final done = _vaccinationDone;
    final progress = total == 0 ? 0.0 : done / total;
    final next = _nextVaccine;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: 'vaccination_progress'.tr,
          actionLabel: 'see_detail'.tr,
          onAction: () => _openVaccination(child),
        ),
        const SizedBox(height: 12),
        AppCard(
          onTap: () => _openVaccination(child),
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              SizedBox(
                width: 62,
                height: 62,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 6,
                      strokeCap: StrokeCap.round,
                      backgroundColor: AppColors.surfaceAlt,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.mint,
                      ),
                    ),
                    Center(
                      child: Text(
                        '${(progress * 100).round()}%',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'vaccines_completed'.trParams({
                        'done': '$done',
                        'total': '$total',
                      }),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      next == null
                          ? 'no_upcoming_vaccine'.tr
                          : '${'next_vaccine'.tr}: $next',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.inkMuted,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTipCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEAF8F4), Color(0xFFEAF1FF)],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              color: AppColors.mint,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'about_health_tip'.tr,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.mint,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'health_tip'.tr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.inkSoft,
                        height: 1.5,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Small home-only components
// -----------------------------------------------------------------------------

class _ChildCard extends StatelessWidget {
  const _ChildCard({
    required this.child,
    required this.selected,
    required this.onTap,
    required this.onOpen,
    this.status,
  });

  final dynamic child;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onOpen;
  final ({String label, AppTone tone})? status;

  @override
  Widget build(BuildContext context) {
    return AnimatedPressable(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: 242,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.surface
              : Colors.white.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color:
                selected ? Colors.white : Colors.white.withValues(alpha: 0.22),
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFF0B1E4B).withValues(alpha: 0.18),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppAvatar(
                  photo: child['photo']?.toString(),
                  name: '${child['nama_anak'] ?? ''}',
                  size: 38,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${child['nama_anak'] ?? ''}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: selected ? AppColors.ink : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${child['umur'] ?? ''}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: selected
                              ? AppColors.inkMuted
                              : Colors.white.withValues(alpha: 0.72),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (status != null)
                  Flexible(
                    child: StatusPill(
                      label: status!.label,
                      tone: status!.tone,
                      dense: true,
                    ),
                  ),
                GestureDetector(
                  onTap: onOpen,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primarySoft
                          : Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(
                      Icons.arrow_outward_rounded,
                      size: 15,
                      color: selected ? AppColors.primary : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AddChildCard extends StatelessWidget {
  const _AddChildCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedPressable(
      onTap: onTap,
      child: Container(
        width: 76,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'add'.tr,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickTile extends StatelessWidget {
  const _QuickTile({
    required this.icon,
    required this.label,
    required this.tone,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final AppTone tone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedPressable(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        child: Column(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: tone.background,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: tone.foreground, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                height: 1.25,
                color: AppColors.inkSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
