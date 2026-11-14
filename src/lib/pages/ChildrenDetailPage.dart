import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:growthtracker/controller/ChildrenController.dart';
import 'package:growthtracker/controller/GrowthHistoryController.dart';
import 'package:growthtracker/controller/SessionController.dart';
import 'package:growthtracker/controller/VaccinationScheduleController.dart';
import 'package:growthtracker/pages/ChildrenEditorPage.dart';
import 'package:growthtracker/pages/GrowthDetailPage.dart';
import 'package:growthtracker/pages/GrowthEditorPage.dart';
import 'package:growthtracker/pages/GrowthHistoryPage.dart';
import 'package:growthtracker/pages/VaccinationSchedulePage.dart';
import 'package:growthtracker/services/GrowthStatus.dart';
import 'package:growthtracker/theme/app_theme.dart';
import 'package:growthtracker/widget/BottomNavbar.dart';
import 'package:growthtracker/widgets/app_widgets.dart';

/// Full profile of one child: growth summary, vaccination progress, recent
/// measurements and personal details.
class ChildrenDetailPage extends StatefulWidget {
  /// Child to open initially. When omitted, the first child is selected.
  final String? anakId;

  const ChildrenDetailPage({super.key, this.anakId});

  @override
  State<ChildrenDetailPage> createState() => _ChildrenDetailPageState();
}

class _ChildrenDetailPageState extends State<ChildrenDetailPage> {
  final childrenController = Get.put(ChildrenController());
  final sessionController = Get.put(SessionController());

  late final GrowthHistoryController growthController =
      Get.isRegistered<GrowthHistoryController>(tag: 'child_detail')
          ? Get.find<GrowthHistoryController>(tag: 'child_detail')
          : Get.put(GrowthHistoryController(), tag: 'child_detail');

  late final VaccinationScheduleController vaccinationController =
      Get.isRegistered<VaccinationScheduleController>(tag: 'child_detail')
          ? Get.find<VaccinationScheduleController>(tag: 'child_detail')
          : Get.put(VaccinationScheduleController(), tag: 'child_detail');

  final ScrollController _scrollController = ScrollController();
  bool _lightStatusBar = true;

  bool _loading = true;
  String? _selectedId;
  Map<String, dynamic>? _child;
  List<Map<String, dynamic>> _records = [];
  List<Map<String, dynamic>> _schedule = [];

  List<dynamic> get _children => childrenController.anakList;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    if (widget.anakId != null && widget.anakId!.isNotEmpty) {
      _selectedId = widget.anakId;
    } else if (_children.isNotEmpty) {
      _selectedId = '${_children.first['anak_id']}';
    }
    _loadData();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final light = _scrollController.offset < 250;
    if (light != _lightStatusBar) {
      setState(() => _lightStatusBar = light);
    }
  }

  Future<void> _loadData() async {
    final children = _children;
    if (children.isEmpty) {
      Get.offAll(() => const BottomNavbar());
      return;
    }

    if (_selectedId == null ||
        !children.any((child) => '${child['anak_id']}' == _selectedId)) {
      _selectedId = '${children.first['anak_id']}';
    }

    final id = _selectedId!;
    final detail = await childrenController.getAnakById(
      sessionController.user_id.value,
      id,
    );

    await Future.wait([
      growthController.getPertumbuhanAnak(id),
      vaccinationController.getJadwalVaksin(id),
    ]);

    if (!mounted) return;
    setState(() {
      _child = detail ??
          children.firstWhere(
            (child) => '${child['anak_id']}' == id,
            orElse: () => children.first,
          );
      _records = growthController.riwayatPertumbuhan
          .map((record) => Map<String, dynamic>.from(record))
          .toList();
      _schedule = vaccinationController.jadwalVaksinasi
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
      _loading = false;
    });
  }

  // ---------------------------------------------------------------------------
  // Derived data
  // ---------------------------------------------------------------------------

  DateTime _recordDate(Map<String, dynamic> record) {
    return DateTime.tryParse('${record['tanggal_pertumbuhan'] ?? ''}') ??
        DateTime.tryParse('${record['created_date'] ?? ''}') ??
        DateTime(1970);
  }

  List<Map<String, dynamic>> get _recordsAsc {
    final sorted = [..._records]
      ..sort((a, b) => _recordDate(a).compareTo(_recordDate(b)));
    return sorted;
  }

  List<Map<String, dynamic>> get _recordsDesc => _recordsAsc.reversed.toList();

  Map<String, dynamic>? get _latest =>
      _recordsAsc.isEmpty ? null : _recordsAsc.last;

  List<double> get _weightTrend {
    final values = _recordsAsc
        .map((record) => double.tryParse('${record['berat_badan'] ?? ''}'))
        .whereType<double>()
        .toList();
    return values.length > 8 ? values.sublist(values.length - 8) : values;
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

  String _formatBirthDate(dynamic raw) {
    final date = DateTime.tryParse('$raw');
    return date == null ? '$raw' : _formatDate(date);
  }

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

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  Future<void> _openEdit() async {
    final child = _child;
    if (child == null) return;
    final id = '${child['anak_id']}';
    await Get.to(() => ChildrenEditorPage(anak_id: id));
    if (mounted) await _loadData();
  }

  Future<void> _openGrowthEditor() async {
    final child = _child;
    if (child == null) return;
    await childrenController.getAnakById(
      sessionController.user_id.value,
      '${child['anak_id']}',
    );
    await Get.to(
      () => GrowthEditorPage(
        anakID: '${child['anak_id']}',
        tinggiBadanAyah: '${child['tinggi_badan_ayah'] ?? ''}',
        tinggiBadanIbu: '${child['tinggi_badan_ibu'] ?? ''}',
      ),
    );
    if (mounted) _loadData();
  }

  Future<void> _openGrowthHistory() async {
    final child = _child;
    if (child == null) return;
    await Get.to(
      () => GrowthHistoryPage(
        anak_id: '${child['anak_id']}',
        tinggi_badan_ayah: '${child['tinggi_badan_ayah'] ?? ''}',
        tinggi_badan_ibu: '${child['tinggi_badan_ibu'] ?? ''}',
      ),
    );
    if (mounted) _loadData();
  }

  Future<void> _openVaccination() async {
    final child = _child;
    if (child == null) return;
    await Get.to(
      () => VaccinationSchedulePage(anak_id: '${child['anak_id']}'),
    );
    if (mounted) _loadData();
  }

  Future<void> _openRecord(Map<String, dynamic> record) async {
    final child = _child;
    if (child == null) return;
    await Get.to(
      () => GrowthDetailPage(
        pertumbuhanAnakId: '${record['pertumbuhan_anak_id']}',
        anakId: '${child['anak_id']}',
        beratBadan: '${record['berat_badan'] ?? ''}',
        tinggiBadan: '${record['tinggi_badan'] ?? ''}',
        lingkarKepala: '${record['lingkar_kepala'] ?? ''}',
        createdDate:
            '${record['tanggal_pertumbuhan'] ?? record['created_date'] ?? ''}',
        statusPertumbuhanBerat: '${record['status_pertumbuhan_berat'] ?? ''}',
        statusPertumbuhanTinggi: '${record['status_pertumbuhan_tinggi'] ?? ''}',
        statusPertumbuhanLingkarKepala:
            '${record['status_pertumbuhan_lingkar_kepala'] ?? ''}',
        umur: '${record['umur'] ?? ''}',
      ),
    );
    if (mounted) _loadData();
  }

  Future<void> _deleteChild() async {
    final child = _child;
    if (child == null) return;
    final confirmed = await showAppConfirm(
      context,
      title: 'delete'.tr,
      message: 'delete_child_message'.tr,
      confirmLabel: 'delete'.tr,
    );
    if (confirmed != true) return;
    await childrenController.deleteAnak('${child['anak_id']}');
    Get.offAll(() => const BottomNavbar());
  }

  void _showActions() {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return AppSheet(
          title: '${_child?['nama_anak'] ?? ''}',
          subtitle: '${_child?['umur'] ?? ''}',
          child: Column(
            children: [
              _ActionRow(
                icon: Icons.edit_outlined,
                label: 'edit_child_account'.tr,
                tone: AppTone.primary,
                onTap: () {
                  Get.back();
                  _openEdit();
                },
              ),
              const SizedBox(height: 10),
              _ActionRow(
                icon: Icons.delete_outline_rounded,
                label: 'delete'.tr,
                tone: AppTone.coral,
                onTap: () {
                  Get.back();
                  _deleteChild();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSwitchChild() {
    if (_children.length < 2) return;
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return AppSheet(
          title: 'select_child'.tr,
          subtitle: 'all_children'.tr,
          child: Column(
            children: [
              for (final child in _children)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _ChildOption(
                    child: child,
                    selected: '${child['anak_id']}' == _selectedId,
                    onTap: () {
                      Get.back();
                      if ('${child['anak_id']}' != _selectedId) {
                        setState(() {
                          _selectedId = '${child['anak_id']}';
                          _loading = true;
                        });
                        _loadData();
                      }
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final child = _child;
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
        body: _loading || child == null
            ? _buildLoading(context)
            : RefreshIndicator(
                color: AppColors.primary,
                backgroundColor: AppColors.surface,
                onRefresh: _loadData,
                child: ListView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: EdgeInsets.zero,
                  children: [
                    _buildHeader(context, child),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildGrowthCard(context, child),
                          const SizedBox(height: 22),
                          _buildVaccinationCard(context),
                          const SizedBox(height: 26),
                          _buildHistorySection(context),
                          const SizedBox(height: 26),
                          _buildInfoSection(context, child),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              const SkeletonBox(width: 44, height: 44, radius: 22),
              const Spacer(),
              const SkeletonBox(width: 44, height: 44, radius: 22),
              const SizedBox(width: 8),
              const SkeletonBox(width: 44, height: 44, radius: 22),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: const [
              SkeletonBox(width: 68, height: 68, radius: 34),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(width: 150, height: 20),
                    SizedBox(height: 8),
                    SkeletonBox(width: 100, height: 12),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const SkeletonBox(height: 220, radius: 24),
          const SizedBox(height: 20),
          const SkeletonBox(height: 120, radius: 24),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Map<String, dynamic> child) {
    final status = _statusFor(_latest);
    final name = '${child['nama_anak'] ?? ''}';
    final photo = child['photo']?.toString();

    return AppHeader(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIconButton(
                icon: Icons.arrow_back_rounded,
                background: Colors.white.withValues(alpha: 0.16),
                foreground: Colors.white,
                onTap: () => Get.back(),
              ),
              const Spacer(),
              AppIconButton(
                icon: Icons.edit_outlined,
                background: Colors.white.withValues(alpha: 0.16),
                foreground: Colors.white,
                tooltip: 'edit_child_account'.tr,
                onTap: _openEdit,
              ),
              const SizedBox(width: 8),
              AppIconButton(
                icon: Icons.more_horiz_rounded,
                background: Colors.white.withValues(alpha: 0.16),
                foreground: Colors.white,
                onTap: _showActions,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppAvatar(
                photo: photo,
                name: name,
                size: 70,
                ring: true,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'child_book'.tr,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        color: Colors.white.withValues(alpha: 0.65),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '${child['umur'] ?? ''}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.78),
                            ),
                          ),
                        ),
                        if (_children.length > 1) ...[
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: _showSwitchChild,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.16),
                                borderRadius: BorderRadius.circular(
                                  AppRadius.pill,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.swap_horiz_rounded,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'select_child'.tr,
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (_latest != null)
                StatusPill(
                  label: status.label,
                  tone: status.tone,
                  icon: Icons.monitor_heart_outlined,
                ),
              if ('${child['jenis_kelamin'] ?? ''}'.isNotEmpty)
                StatusPill(
                  label: _genderLabel('${child['jenis_kelamin']}'),
                  tone: AppTone.neutral,
                  icon: Icons.wc_rounded,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthCard(BuildContext context, Map<String, dynamic> child) {
    final latest = _latest;
    final status = _statusFor(latest);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: 'growth_results'.tr,
          actionLabel: 'see_all'.tr,
          onAction: _openGrowthHistory,
        ),
        const SizedBox(height: 12),
        AppCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          latest == null
                              ? 'no_measurement'.tr
                              : 'last_update'.tr,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        if (latest != null) ...[
                          const SizedBox(height: 3),
                          Text(
                            _formatDate(_recordDate(latest)),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                  StatusPill(
                    label: _shortStatusLabel(latest),
                    tone: status.tone,
                    dense: true,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: MetricTile(
                      icon: Icons.monitor_weight_rounded,
                      label: 'weight'.tr,
                      value: _formatNumber(
                        latest?['berat_badan'] ?? child['berat_badan'] ?? '-',
                      ),
                      unit: 'kg',
                      tone: AppTone.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: MetricTile(
                      icon: Icons.straighten_rounded,
                      label: 'height'.tr,
                      value: _formatNumber(
                        latest?['tinggi_badan'] ?? child['tinggi_badan'] ?? '-',
                      ),
                      unit: 'cm',
                      tone: AppTone.mint,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: MetricTile(
                      icon: Icons.circle_outlined,
                      label: 'head_short'.tr,
                      value: _formatNumber(
                        latest?['lingkar_kepala'] ??
                            child['lingkar_kepala'] ??
                            '-',
                      ),
                      unit: 'cm',
                      tone: AppTone.amber,
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
                  height: 54,
                ),
              ],
              const SizedBox(height: 18),
              AppButton(
                label: latest == null ? 'add_measurement'.tr : 'update'.tr,
                icon: latest == null ? Icons.add_rounded : Icons.edit_rounded,
                onPressed: _openGrowthEditor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVaccinationCard(BuildContext context) {
    final total = _vaccinationTotal;
    final done = _vaccinationDone;
    final progress = total == 0 ? 0.0 : done / total;
    final next = _nextVaccine;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: 'vaccination'.tr,
          actionLabel: 'see_detail'.tr,
          onAction: _openVaccination,
        ),
        const SizedBox(height: 12),
        AppCard(
          onTap: _openVaccination,
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              SizedBox(
                width: 66,
                height: 66,
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
                      'vaccination_schedule'.tr,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      total == 0
                          ? 'vaccination_schedule_hint'.tr
                          : 'vaccines_completed'.trParams({
                              'done': '$done',
                              'total': '$total',
                            }),
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      next == null
                          ? 'no_upcoming_vaccine'.tr
                          : '${'next_vaccine'.tr}: $next',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.mint,
                      ),
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

  Widget _buildHistorySection(BuildContext context) {
    final preview = _recordsDesc.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: 'growth_history'.tr,
          actionLabel: 'see_all'.tr,
          onAction: _openGrowthHistory,
        ),
        const SizedBox(height: 12),
        if (preview.isEmpty)
          AppCard(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.show_chart_rounded,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'no_history'.tr,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                AppIconButton(
                  icon: Icons.add_rounded,
                  onTap: _openGrowthEditor,
                ),
              ],
            ),
          )
        else
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Column(
              children: [
                for (var index = 0; index < preview.length; index++) ...[
                  _RecordRow(
                    record: preview[index],
                    date: _formatDate(_recordDate(preview[index])),
                    onTap: () => _openRecord(preview[index]),
                  ),
                  if (index != preview.length - 1) const Divider(),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    Map<String, dynamic> child,
  ) {
    final rows = <({IconData icon, String label, String value})>[];
    final birth = '${child['tanggal_lahir'] ?? ''}'.trim();
    if (birth.isNotEmpty) {
      rows.add((
        icon: Icons.cake_outlined,
        label: 'birth_date'.tr,
        value: _formatBirthDate(birth),
      ));
    }
    final gender = '${child['jenis_kelamin'] ?? ''}'.trim();
    if (gender.isNotEmpty) {
      rows.add((
        icon: Icons.wc_rounded,
        label: 'gender'.tr,
        value: _genderLabel(gender),
      ));
    }
    final blood = '${child['gol_darah'] ?? ''}'.trim();
    if (blood.isNotEmpty &&
        blood != 'Pilih Golongan Darah' &&
        blood != 'Select Blood Type') {
      rows.add((
        icon: Icons.bloodtype_outlined,
        label: 'blood_group'.tr,
        value: blood,
      ));
    }
    final allergy = '${child['alergi'] ?? ''}'.trim();
    if (allergy.isNotEmpty) {
      rows.add((
        icon: Icons.warning_amber_rounded,
        label: 'has_allergy'.tr,
        value: _yesNo(allergy),
      ));
    }
    final premature = '${child['prematur'] ?? ''}'.trim();
    if (premature.isNotEmpty) {
      rows.add((
        icon: Icons.child_friendly_outlined,
        label: 'is_premature'.tr,
        value: _yesNo(premature),
      ));
    }

    if (rows.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(title: 'details'.tr),
        const SizedBox(height: 12),
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Column(
            children: [
              for (var index = 0; index < rows.length; index++) ...[
                _InfoRow(
                  icon: rows[index].icon,
                  label: rows[index].label,
                  value: rows[index].value,
                ),
                if (index != rows.length - 1) const Divider(),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _genderLabel(String value) {
    final normalized = value.toLowerCase();
    if (normalized.contains('laki') || normalized.contains('male')) {
      return 'male'.tr;
    }
    if (normalized.contains('perempuan') || normalized.contains('female')) {
      return 'female'.tr;
    }
    return value;
  }

  String _yesNo(String value) {
    final normalized = value.toLowerCase();
    if (normalized == 'ya' || normalized == 'yes' || normalized == 'true') {
      return 'yes'.tr;
    }
    if (normalized == 'tidak' || normalized == 'no' || normalized == 'false') {
      return 'no'.tr;
    }
    return value;
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
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
    return Material(
      color: AppColors.surfaceAlt,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: tone.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: tone.foreground, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.inkMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChildOption extends StatelessWidget {
  const _ChildOption({
    required this.child,
    required this.selected,
    required this.onTap,
  });

  final dynamic child;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primarySoft : AppColors.surfaceAlt,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              AppAvatar(
                photo: child['photo']?.toString(),
                name: '${child['nama_anak'] ?? ''}',
                size: 42,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${child['nama_anak'] ?? ''}',
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${child['umur'] ?? ''}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (selected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecordRow extends StatelessWidget {
  const _RecordRow({
    required this.record,
    required this.date,
    required this.onTap,
  });

  final Map<String, dynamic> record;
  final String date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.monitor_heart_outlined,
                  color: AppColors.primary,
                  size: 19,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      date,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${record['umur'] ?? ''}',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${record['berat_badan'] ?? '-'} kg',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${record['tinggi_badan'] ?? '-'} cm',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.inkMuted,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 2),
      child: Row(
        children: [
          Icon(icon, size: 19, color: AppColors.inkMuted),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.titleSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
