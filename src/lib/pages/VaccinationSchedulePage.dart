import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:growthtracker/controller/VaccinationScheduleByIdaiController.dart';
import 'package:growthtracker/controller/VaccinationScheduleController.dart';
import 'package:growthtracker/helper/AgeHelper.dart';
import 'package:growthtracker/pages/VaccinationDetailPage.dart';
import 'package:growthtracker/pages/VaccinationScheduleByIdaiPage.dart';
import 'package:growthtracker/services/LocalStore.dart';
import 'package:growthtracker/theme/app_theme.dart';
import 'package:growthtracker/widgets/app_widgets.dart';

/// Overview of a child's immunization schedule.
///
/// The gradient header summarises the child's progress, the chips filter the
/// periods and every vaccine row opens the detail screen where the vaccination
/// can be recorded or updated.
class VaccinationSchedulePage extends StatefulWidget {
  final String anak_id;

  const VaccinationSchedulePage({super.key, required this.anak_id});

  @override
  State<VaccinationSchedulePage> createState() =>
      _VaccinationSchedulePageState();
}

class _VaccinationSchedulePageState extends State<VaccinationSchedulePage> {
  var jadwalVaksinasiController = Get.put(VaccinationScheduleController());
  var jadwalVaksinasiIDAIController =
      Get.put(VaccinationScheduleByIdaiController());
  final LocalStore _store = LocalStore();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _headerKey = GlobalKey();

  bool isDataInitialized = false;
  bool _loadingPdf = false;
  bool _lightStatusBar = true;
  double _headerHeight = 320;
  String? _namaAnak;
  String? _photo;
  DateTime? _birthDate;

  /// Age in months the list is filtered on; `null` shows every period.
  int? selectedMonth;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadData();
    _measureHeader();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  /// The status bar sits on the gradient header while it is visible and needs
  /// light icons, then switches to dark icons over the page background.
  void _onScroll() {
    final light = _scrollController.offset < _headerHeight - 1;
    if (light != _lightStatusBar) {
      setState(() => _lightStatusBar = light);
    }
  }

  /// The header height depends on the child data and the current locale, so it
  /// is measured after layout instead of hardcoding a scroll threshold.
  void _measureHeader() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final height = _headerKey.currentContext?.size?.height;
      if (height == null) return;
      _headerHeight = height;
      _onScroll();
    });
  }

  Future<void> _loadData() async {
    try {
      final child = await _store.childById(widget.anak_id);
      final nama = '${child?['nama_anak'] ?? ''}'.trim();
      final photo = '${child?['photo'] ?? ''}'.trim();
      final birthDate = DateTime.tryParse('${child?['tanggal_lahir'] ?? ''}');

      await jadwalVaksinasiController.getJadwalVaksin(widget.anak_id);

      if (!mounted) return;
      setState(() {
        _namaAnak = nama.isEmpty ? null : nama;
        _photo = photo.isEmpty ? null : photo;
        _birthDate = birthDate;
        isDataInitialized = true;
      });
      _measureHeader();
    } catch (_) {
      if (!mounted) return;
      setState(() => isDataInitialized = true);
      AppSnack.error('failed'.tr);
    }
  }

  /// Opens the immunization reference PDF. Downloaded on demand so the
  /// schedule itself never waits on the network; a previously downloaded copy
  /// is reused when the device is offline.
  Future<void> _openPdfReference() async {
    if (_loadingPdf) return;
    setState(() => _loadingPdf = true);
    try {
      final file = await jadwalVaksinasiIDAIController.createFileOfPdfUrl();
      if (!mounted) return;
      setState(() => _loadingPdf = false);
      await Get.to(VaccinationScheduleByIdaiPage(path: file.path));
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingPdf = false);
      AppSnack.error('pdf_download_failed'.tr);
    }
  }

  // ---------------------------------------------------------------------------
  // Derived data
  // ---------------------------------------------------------------------------

  int get _totalVaccines {
    var total = 0;
    for (final period in jadwalVaksinasiController.jadwalVaksinasi) {
      total += ((period['vaksin'] as List?) ?? const []).length;
    }
    return total;
  }

  int get _doneVaccines {
    var done = 0;
    for (final period in jadwalVaksinasiController.jadwalVaksinasi) {
      for (final vaccine in (period['vaksin'] as List?) ?? const []) {
        if (vaccine is Map && vaccine['status'] == 'Sudah') done++;
      }
    }
    return done;
  }

  String? get _nextVaccine {
    for (final period in jadwalVaksinasiController.jadwalVaksinasi) {
      for (final vaccine in (period['vaksin'] as List?) ?? const []) {
        if (vaccine is Map && vaccine['status'] != 'Sudah') {
          return '${vaccine['nama_vaksin'] ?? ''}';
        }
      }
    }
    return null;
  }

  Future<void> _openVaccine(
    Map<String, dynamic> period,
    Map vaccine,
  ) async {
    await Get.to(
      VaccinationDetailPage(
        anak_id: widget.anak_id,
        vaksin_id: '${vaccine['vaksin_id']}',
        tgl_rekomendasi: '${period['rekomendasi'] ?? ''}',
        nama_vaksinasi: '${vaccine['nama_vaksin'] ?? ''}',
        status: '${vaccine['status']}' == 'Sudah' ? 'Sudah' : 'Belum',
      ),
    );
    if (!mounted) return;
    await _loadData();
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final vaccinationData = jadwalVaksinasiController.jadwalVaksinasi.toList();
    final filteredData = selectedMonth == null
        ? vaccinationData
        : vaccinationData
            .where((item) => item['bulan_ke'] == '$selectedMonth')
            .toList();

    final overlay = _lightStatusBar
        ? SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: AppColors.background,
            systemNavigationBarIconBrightness: Brightness.dark,
          )
        : SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: AppColors.background,
            systemNavigationBarIconBrightness: Brightness.dark,
          );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          top: false,
          child: RefreshIndicator(
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
                _buildHeader(context),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                  child: !isDataInitialized
                      ? _buildLoading(context)
                      : vaccinationData.isEmpty
                          ? EmptyState(
                              icon: Icons.event_available_rounded,
                              title: 'no_vaccination_schedule'.tr,
                              message: 'vaccination_schedule_hint'.tr,
                              tone: AppTone.primary,
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFilter(vaccinationData),
                                const SizedBox(height: 18),
                                for (var index = 0;
                                    index < filteredData.length;
                                    index++) ...[
                                  if (index > 0) const SizedBox(height: 14),
                                  _buildPeriodCard(
                                    context,
                                    filteredData[index],
                                  ),
                                ],
                              ],
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final total = _totalVaccines;
    final done = _doneVaccines;
    final progress = total == 0 ? 0.0 : done / total;
    final percent = (progress * 100).round();

    return AppHeader(
      key: _headerKey,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppBackButton(
                background: Colors.white.withValues(alpha: 0.16),
                foreground: Colors.white,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  'vaccination_schedule'.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              const SizedBox(width: 12),
              _buildDocumentButton(),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              AppAvatar(
                photo: _photo,
                name: _namaAnak,
                size: 48,
                ring: true,
                icon: Icons.child_care_rounded,
                gradient: const LinearGradient(
                  colors: [Color(0xFF6B93FF), Color(0xFF2EC4B6)],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _namaAnak ?? 'child_profile'.tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    if (_birthDate != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        ageLabel(_birthDate, DateTime.now()),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.78),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: !isDataInitialized
                ? const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonBox(width: 152, height: 11),
                      SizedBox(height: 12),
                      SkeletonBox(height: 7, radius: 4),
                      SizedBox(height: 12),
                      SkeletonBox(width: 124, height: 10),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'vaccines_completed'.trParams({
                                'done': '$done',
                                'total': '$total',
                              }),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '$percent%',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      AppProgressBar(
                        value: progress,
                        color: Colors.white,
                        background: Colors.white.withValues(alpha: 0.24),
                        height: 7,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _nextVaccine == null
                            ? 'no_upcoming_vaccine'.tr
                            : '${'next_vaccine'.tr}: ${_nextVaccine!}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                size: 15,
                color: Colors.white.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'vaccination_schedule_hint'.tr,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w400,
                    height: 1.45,
                    color: Colors.white.withValues(alpha: 0.72),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentButton() {
    if (_loadingPdf) {
      return Container(
        width: 44,
        height: 44,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.16),
          shape: BoxShape.circle,
        ),
        child: const CircularProgressIndicator(
          strokeWidth: 2.2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }
    return AppIconButton(
      icon: Icons.description_outlined,
      background: Colors.white.withValues(alpha: 0.16),
      foreground: Colors.white,
      tooltip: 'document'.tr,
      onTap: _openPdfReference,
    );
  }

  Widget _buildFilter(List<Map<String, dynamic>> vaccinationData) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        clipBehavior: Clip.none,
        padding: EdgeInsets.zero,
        itemCount: vaccinationData.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _PeriodChip(
              label: 'all'.tr,
              selected: selectedMonth == null,
              onTap: () => setState(() => selectedMonth = null),
            );
          }
          final item = vaccinationData[index - 1];
          final month = int.tryParse('${item['bulan_ke']}');
          return _PeriodChip(
            label: '${item['periode']}',
            selected: selectedMonth == month,
            onTap: () => setState(() => selectedMonth = month),
          );
        },
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            SkeletonBox(width: 64, height: 38, radius: 19),
            SizedBox(width: 8),
            SkeletonBox(width: 92, height: 38, radius: 19),
            SizedBox(width: 8),
            SkeletonBox(width: 78, height: 38, radius: 19),
          ],
        ),
        const SizedBox(height: 18),
        for (var index = 0; index < 3; index++) ...[
          if (index > 0) const SizedBox(height: 14),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SkeletonBox(width: 46, height: 46, radius: 14),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          SkeletonBox(width: 110, height: 14),
                          SizedBox(height: 8),
                          SkeletonBox(width: 160, height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const SkeletonBox(height: 7, radius: 4),
                const SizedBox(height: 18),
                const SkeletonBox(height: 40, radius: 12),
                const SizedBox(height: 8),
                const SkeletonBox(height: 40, radius: 12),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPeriodCard(
    BuildContext context,
    Map<String, dynamic> item,
  ) {
    final vaccines = (item['vaksin'] as List?) ?? const [];
    final rekomendasi = '${item['rekomendasi'] ?? ''}'.trim();
    var done = 0;
    for (final vaccine in vaccines) {
      if (vaccine is Map && vaccine['status'] == 'Sudah') done++;
    }
    final total = vaccines.length;
    final complete = total > 0 && done == total;
    final progress = total == 0 ? 0.0 : done / total;

    return AppCard(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: complete ? AppColors.mintSoft : AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  complete ? Icons.verified_rounded : Icons.vaccines_rounded,
                  size: 23,
                  color: complete ? AppColors.mint : AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item['periode']}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (rekomendasi.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(
                            Icons.event_outlined,
                            size: 13,
                            color: AppColors.inkMuted,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              rekomendasi,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              StatusPill(
                label: '$done/$total',
                tone: complete ? AppTone.mint : AppTone.amber,
                icon: complete ? Icons.check_rounded : null,
                dense: true,
              ),
            ],
          ),
          const SizedBox(height: 14),
          AppProgressBar(
            value: progress,
            color: complete ? AppColors.mint : AppColors.primary,
            height: 7,
          ),
          const SizedBox(height: 4),
          for (final vaccine in vaccines)
            if (vaccine is Map)
              _VaccineRow(
                name: '${vaccine['nama_vaksin'] ?? ''}',
                done: vaccine['status'] == 'Sudah',
                onTap: () => _openVaccine(item, vaccine),
              ),
        ],
      ),
    );
  }
}

class _PeriodChip extends StatelessWidget {
  const _PeriodChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedPressable(
      onTap: onTap,
      haptic: false,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.line,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.24),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            color: selected ? Colors.white : AppColors.inkSoft,
          ),
        ),
      ),
    );
  }
}

class _VaccineRow extends StatelessWidget {
  const _VaccineRow({
    required this.name,
    required this.done,
    required this.onTap,
  });

  final String name;
  final bool done;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tone = done ? AppTone.mint : AppTone.amber;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 2),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: tone.background,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  done ? Icons.check_rounded : Icons.medication_liquid_rounded,
                  size: 18,
                  color: tone.foreground,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const SizedBox(width: 8),
              StatusPill(
                label: done ? 'status_done'.tr : 'status_not_yet'.tr,
                tone: tone,
                dense: true,
              ),
              const SizedBox(width: 2),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppColors.inkMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
