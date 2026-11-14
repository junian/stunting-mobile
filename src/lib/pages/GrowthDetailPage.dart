import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:growthtracker/controller/GrowthEditorController.dart';
import 'package:growthtracker/services/GrowthStatus.dart';
import 'package:growthtracker/theme/app_theme.dart';
import 'package:growthtracker/widgets/app_widgets.dart';

class GrowthDetailPage extends StatelessWidget {
  final String pertumbuhanAnakId;
  final String anakId;
  final String beratBadan;
  final String tinggiBadan;
  final String lingkarKepala;
  final String createdDate;
  final String statusPertumbuhanBerat;
  final String statusPertumbuhanTinggi;
  final String statusPertumbuhanLingkarKepala;
  final String umur;

  const GrowthDetailPage({
    super.key,
    required this.pertumbuhanAnakId,
    required this.anakId,
    required this.beratBadan,
    required this.tinggiBadan,
    required this.lingkarKepala,
    required this.createdDate,
    required this.statusPertumbuhanBerat,
    required this.statusPertumbuhanTinggi,
    required this.statusPertumbuhanLingkarKepala,
    required this.umur,
  });

  String get _formattedDate {
    final date = DateTime.tryParse(createdDate);
    if (date == null) return createdDate;
    return DateFormat('d MMM y').format(date);
  }

  String _number(String value) {
    final parsed = double.tryParse(value.replaceAll(',', '.'));
    if (parsed == null) return value;
    if (parsed == parsed.truncateToDouble()) return parsed.toStringAsFixed(0);
    return parsed.toStringAsFixed(1);
  }

  String _statusText(String? status) {
    final key = GrowthStatus.labelKey(status);
    return key == null ? 'status_tidak_ada'.tr : key.tr;
  }

  AppTone _toneFor(String? status) {
    if (!GrowthStatus.hasReference(status)) return AppTone.neutral;
    if (GrowthStatus.isNormal(status)) return AppTone.mint;
    final code = GrowthStatus.codeFor(status);
    final severe = code == GrowthStatus.sangatPendek ||
        code == GrowthStatus.giziBuruk ||
        code == GrowthStatus.mikrosefali;
    return severe ? AppTone.coral : AppTone.amber;
  }

  Future<void> _delete(BuildContext context) async {
    final confirmed = await showAppConfirm(
      context,
      title: 'delete'.tr,
      message: 'delete_growth_message'.tr,
      confirmLabel: 'delete'.tr,
    );
    if (confirmed != true) return;

    await GrowthEditorController().deletePertumbuhanAnak(pertumbuhanAnakId);
    if (!context.mounted) return;
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          AppPageHeader(
            title: 'growth_detail'.tr,
            subtitle: umur.isEmpty ? null : umur,
            action: AppIconButton(
              icon: Icons.delete_outline_rounded,
              background: AppColors.coralSoft,
              foreground: AppColors.coral,
              tooltip: 'delete'.tr,
              onTap: () => _delete(context),
            ),
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
              children: [
                _buildSummary(context),
                const SizedBox(height: 26),
                AppSectionHeader(title: 'growth_status'.tr),
                const SizedBox(height: 12),
                _buildStatusCard(
                  context,
                  icon: Icons.monitor_weight_rounded,
                  title: 'weight'.tr,
                  value: '${_number(beratBadan)} kg',
                  status: statusPertumbuhanBerat,
                ),
                const SizedBox(height: 12),
                _buildStatusCard(
                  context,
                  icon: Icons.straighten_rounded,
                  title: 'height'.tr,
                  value: '${_number(tinggiBadan)} cm',
                  status: statusPertumbuhanTinggi,
                ),
                const SizedBox(height: 12),
                _buildStatusCard(
                  context,
                  icon: Icons.circle_outlined,
                  title: 'head_circumference'.tr,
                  value: '${_number(lingkarKepala)} cm',
                  status: statusPertumbuhanLingkarKepala,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: AppColors.brandGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.monitor_heart_outlined,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formattedDate,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      umur,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
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
                  value: _number(beratBadan),
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
                  value: _number(tinggiBadan),
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
                  value: _number(lingkarKepala),
                  unit: 'cm',
                  tone: AppTone.amber,
                  compact: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required String status,
  }) {
    final tone = _toneFor(status);
    final noteKey = GrowthStatus.noteKey(status);
    final normal = GrowthStatus.isNormal(status);
    final hasReference = GrowthStatus.hasReference(status);

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: tone.background,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: tone.foreground, size: 21),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    Text(
                      value,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                StatusPill(
                  label: _statusText(status),
                  tone: tone,
                  icon: hasReference
                      ? (normal
                          ? Icons.check_circle_outline_rounded
                          : Icons.error_outline_rounded)
                      : Icons.help_outline_rounded,
                ),
                if (noteKey != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    noteKey.tr,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          height: 1.45,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
