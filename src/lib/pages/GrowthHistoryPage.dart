import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:growthtracker/controller/GrowthHistoryController.dart';
import 'package:growthtracker/pages/GrowthDetailPage.dart';
import 'package:growthtracker/pages/GrowthEditorPage.dart';
import 'package:growthtracker/services/GrowthStatus.dart';
import 'package:growthtracker/services/LocalStore.dart';
import 'package:growthtracker/theme/app_theme.dart';
import 'package:growthtracker/widgets/app_widgets.dart';

class GrowthHistoryPage extends StatefulWidget {
  final String anak_id;
  final String tinggi_badan_ibu;
  final String tinggi_badan_ayah;

  const GrowthHistoryPage({
    super.key,
    required this.anak_id,
    required this.tinggi_badan_ayah,
    required this.tinggi_badan_ibu,
  });

  @override
  State<GrowthHistoryPage> createState() => _GrowthHistoryPageState();
}

class _GrowthHistoryPageState extends State<GrowthHistoryPage> {
  final GrowthHistoryController growthController =
      Get.put(GrowthHistoryController());
  final LocalStore _store = LocalStore();

  bool _loading = true;
  bool _newestFirst = true;
  String _childName = '';
  List<Map<String, dynamic>> _records = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await growthController.getPertumbuhanAnak(widget.anak_id);
    final child = await _store.childById(widget.anak_id);
    if (!mounted) return;
    setState(() {
      _records = growthController.riwayatPertumbuhan
          .map((record) => Map<String, dynamic>.from(record))
          .toList();
      _childName = '${child?['nama_anak'] ?? ''}';
      _loading = false;
    });
  }

  DateTime _recordDate(Map<String, dynamic> record) {
    return DateTime.tryParse('${record['tanggal_pertumbuhan'] ?? ''}') ??
        DateTime.tryParse('${record['created_date'] ?? ''}') ??
        DateTime(1970);
  }

  List<Map<String, dynamic>> get _sortedRecords {
    final sorted = [..._records]..sort((a, b) {
        final comparison = _recordDate(a).compareTo(_recordDate(b));
        return _newestFirst ? -comparison : comparison;
      });
    return sorted;
  }

  List<double> get _weightTrend {
    final sorted = [..._records]
      ..sort((a, b) => _recordDate(a).compareTo(_recordDate(b)));
    final values = sorted
        .map((record) => double.tryParse('${record['berat_badan'] ?? ''}'))
        .whereType<double>()
        .toList();
    return values.length > 10 ? values.sublist(values.length - 10) : values;
  }

  Map<String, dynamic>? get _latest {
    if (_records.isEmpty) return null;
    final sorted = [..._records]
      ..sort((a, b) => _recordDate(a).compareTo(_recordDate(b)));
    return sorted.last;
  }

  String _formatNumber(dynamic value) {
    final parsed = value is num ? value.toDouble() : double.tryParse('$value');
    if (parsed == null) return '$value';
    if (parsed == parsed.truncateToDouble()) return parsed.toStringAsFixed(0);
    return parsed.toStringAsFixed(1);
  }

  String _formatDate(DateTime date) => DateFormat('d MMM y').format(date);

  ({String label, AppTone tone})? _statusFor(Map<String, dynamic> record) {
    final raw = record['status_pertumbuhan_tinggi']?.toString();
    final label = GrowthStatus.labelKey(raw)?.tr;
    if (label == null) return null;
    if (GrowthStatus.isNormal(raw)) {
      return (label: label, tone: AppTone.mint);
    }
    final code = GrowthStatus.codeFor(raw);
    final severe = code == GrowthStatus.sangatPendek ||
        code == GrowthStatus.giziBuruk ||
        code == GrowthStatus.mikrosefali;
    return (
      label: _shortLabel(raw, label),
      tone: severe ? AppTone.coral : AppTone.amber
    );
  }

  String _shortLabel(String? raw, String fallback) {
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
        return fallback;
    }
  }

  Future<void> _openEditor() async {
    await Get.to(
      () => GrowthEditorPage(
        anakID: widget.anak_id,
        tinggiBadanAyah: widget.tinggi_badan_ayah,
        tinggiBadanIbu: widget.tinggi_badan_ibu,
      ),
    );
    if (mounted) _loadData();
  }

  Future<void> _openRecord(Map<String, dynamic> record) async {
    await Get.to(
      () => GrowthDetailPage(
        pertumbuhanAnakId: '${record['pertumbuhan_anak_id']}',
        anakId: widget.anak_id,
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

  @override
  Widget build(BuildContext context) {
    final bottomInset = systemBottomInset(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          AppPageHeader(
            title: 'growth_history'.tr,
            subtitle: _childName.isEmpty ? null : _childName,
          ),
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.surface,
              onRefresh: _loadData,
              child: _loading
                  ? _buildSkeleton()
                  : _records.isEmpty
                      ? _buildEmpty()
                      : _buildContent(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(20, 8, 20, 12 + bottomInset),
        child: AppButton(
          label: 'add_growth'.tr,
          icon: Icons.add_rounded,
          onPressed: _openEditor,
        ),
      ),
    );
  }

  Widget _buildSkeleton() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        SkeletonBox(height: 150, radius: 24),
        SizedBox(height: 16),
        SkeletonBox(height: 92, radius: 20),
        SizedBox(height: 12),
        SkeletonBox(height: 92, radius: 20),
        SizedBox(height: 12),
        SkeletonBox(height: 92, radius: 20),
      ],
    );
  }

  Widget _buildEmpty() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.sizeOf(context).height * 0.12),
        EmptyState(
          icon: Icons.show_chart_rounded,
          title: 'no_history'.tr,
          message: 'add_growth_data'.tr,
          actionLabel: 'add_growth'.tr,
          onAction: _openEditor,
        ),
      ],
    );
  }

  Widget _buildContent() {
    final latest = _latest;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      children: [
        _buildSummary(latest),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Text(
                '${'growth_history'.tr} · ${_records.length}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            _SortButton(
              ascending: !_newestFirst,
              onTap: () => setState(() => _newestFirst = !_newestFirst),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (final record in _sortedRecords)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _RecordCard(
              record: record,
              date: _formatDate(_recordDate(record)),
              status: _statusFor(record),
              formatNumber: _formatNumber,
              onTap: () => _openRecord(record),
            ),
          ),
      ],
    );
  }

  Widget _buildSummary(Map<String, dynamic>? latest) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: AppColors.brandGradient,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.insights_rounded,
                  color: Colors.white,
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'summary'.tr,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      latest == null
                          ? 'no_history'.tr
                          : 'last_measured'.trParams({
                              'date': _formatDate(_recordDate(latest)),
                            }),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (latest != null) ...[
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
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'growth_trend'.tr,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  Text(
                    'weight'.tr,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Sparkline(
                values: _weightTrend,
                color: AppColors.primary,
                height: 52,
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  const _SortButton({required this.ascending, required this.onTap});

  final bool ascending;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: AppColors.line),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                ascending
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                size: 15,
                color: AppColors.primary,
              ),
              const SizedBox(width: 5),
              Text(
                ascending ? 'sort_oldest'.tr : 'sort_newest'.tr,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.inkSoft,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  const _RecordCard({
    required this.record,
    required this.date,
    required this.status,
    required this.formatNumber,
    required this.onTap,
  });

  final Map<String, dynamic> record;
  final String date;
  final ({String label, AppTone tone})? status;
  final String Function(dynamic value) formatNumber;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
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
                      date,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${record['umur'] ?? ''}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (status != null)
                StatusPill(
                  label: status!.label,
                  tone: status!.tone,
                  dense: true,
                ),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.inkMuted,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _InlineMetric(
                icon: Icons.monitor_weight_rounded,
                value: '${formatNumber(record['berat_badan'])} kg',
                tone: AppTone.primary,
              ),
              const SizedBox(width: 8),
              _InlineMetric(
                icon: Icons.straighten_rounded,
                value: '${formatNumber(record['tinggi_badan'])} cm',
                tone: AppTone.mint,
              ),
              const SizedBox(width: 8),
              _InlineMetric(
                icon: Icons.circle_outlined,
                value: '${formatNumber(record['lingkar_kepala'])} cm',
                tone: AppTone.amber,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InlineMetric extends StatelessWidget {
  const _InlineMetric({
    required this.icon,
    required this.value,
    required this.tone,
  });

  final IconData icon;
  final String value;
  final AppTone tone;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
        decoration: BoxDecoration(
          color: tone.background,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Row(
          children: [
            Icon(icon, size: 13, color: tone.foreground),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
