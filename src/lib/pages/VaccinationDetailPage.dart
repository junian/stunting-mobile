import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:growthtracker/controller/VaccinationController.dart';
import 'package:growthtracker/pages/VaccinationEditorPage.dart';
import 'package:growthtracker/theme/app_theme.dart';
import 'package:growthtracker/widget/AppPhoto.dart';
import 'package:growthtracker/widgets/app_widgets.dart';

/// Detail of one vaccine in the child's immunization schedule.
///
/// The hero card shows the current status, the details card reads the saved
/// record and the sticky actions record, edit or clear that vaccination.
class VaccinationDetailPage extends StatefulWidget {
  final String anak_id;
  final String vaksin_id;
  final String tgl_rekomendasi;
  final String nama_vaksinasi;
  final String status;

  const VaccinationDetailPage({
    super.key,
    required this.anak_id,
    required this.vaksin_id,
    required this.tgl_rekomendasi,
    required this.nama_vaksinasi,
    required this.status,
  });

  @override
  State<VaccinationDetailPage> createState() => _VaccinationDetailPageState();
}

class _VaccinationDetailPageState extends State<VaccinationDetailPage> {
  var vaksinasi = Get.put(VaccinationController());

  Map<String, dynamic>? _record;
  bool _initialLoading = true;
  late String _status;

  @override
  void initState() {
    super.initState();
    _status = widget.status;
    _refreshStatus();
  }

  /// Re-reads the saved record, so the screen always shows the current status
  /// and the recorded vaccination data.
  Future<void> _refreshStatus() async {
    final record = await vaksinasi.vaccinationRecord(
      anak_id: widget.anak_id,
      vaksin_id: widget.vaksin_id,
    );
    if (!mounted) return;
    setState(() {
      _record = record;
      _status = record == null ? 'Belum' : 'Sudah';
      _initialLoading = false;
    });
  }

  /// Starts a brand-new record. The shared controller keeps its fields between
  /// visits, so they are cleared before opening the form.
  Future<void> _openEditor() async {
    vaksinasi.dateinput.text = "";
    vaksinasi.nama_dokter.text = "";
    vaksinasi.no_batch.text = "";
    vaksinasi.tempat.text = "";
    vaksinasi.pickedImage = null;
    await Get.to(
      VaccinationEditorPage(
        anak_id: widget.anak_id,
        vaksin_id: widget.vaksin_id,
      ),
    );
    await _refreshStatus();
  }

  /// Opens the form for the already recorded vaccination, prefilled with the
  /// saved date, doctor, place and batch.
  Future<void> _openRecordForm() async {
    if (_status == 'Sudah') {
      vaksinasi.pickedImage = null;
      await vaksinasi.getVaksinAnak(
        anak_id: widget.anak_id,
        vaksin_id: widget.vaksin_id,
      );
      await _refreshStatus();
      return;
    }
    await _openEditor();
  }

  Future<void> _markNotDone() async {
    final confirmed = await showAppConfirm(
      context,
      title: 'mark_not_done'.tr,
      message: 'mark_not_done_confirm'.tr,
      confirmLabel: 'mark_not_done'.tr,
      icon: Icons.undo_rounded,
    );
    if (confirmed != true) return;

    await vaksinasi.removeVaksinAnak(
      anak_id: widget.anak_id,
      vaksin_id: widget.vaksin_id,
    );
    if (!mounted) return;
    await _refreshStatus();
    AppSnack.success('mark_not_done_success'.tr);
  }

  String _formatDate(dynamic value) {
    final raw = '${value ?? ''}'.trim();
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw.isEmpty ? '—' : raw;
    return DateFormat('d MMM yyyy').format(parsed);
  }

  String _textOrDash(dynamic value) {
    final text = '${value ?? ''}'.trim();
    return text.isEmpty ? '—' : text;
  }

  @override
  Widget build(BuildContext context) {
    final recorded = _status == 'Sudah';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          AppPageHeader(title: 'vaccination_status'.tr),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
              children: [
                _buildHero(context),
                const SizedBox(height: 24),
                AppSectionHeader(title: 'details'.tr),
                const SizedBox(height: 12),
                if (_initialLoading)
                  _buildDetailsSkeleton()
                else if (_record == null)
                  _buildNoRecord(context)
                else
                  _buildRecord(context, _record!),
              ],
            ),
          ),
          _buildActions(recorded),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    final done = _status == 'Sudah';
    final recommended = widget.tgl_rekomendasi.trim();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.primary,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Stack(
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(gradient: AppColors.brandGradient),
              ),
            ),
            Positioned(
              top: -44,
              right: -32,
              child: Container(
                width: 136,
                height: 136,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -56,
              left: -28,
              child: Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  color: AppColors.teal.withValues(alpha: 0.24),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: const Icon(
                          Icons.vaccines_rounded,
                          color: Colors.white,
                          size: 27,
                        ),
                      ),
                      const Spacer(),
                      StatusPill(
                        label: done ? 'status_done'.tr : 'status_not_yet'.tr,
                        tone: done ? AppTone.mint : AppTone.amber,
                        icon:
                            done ? Icons.check_rounded : Icons.schedule_rounded,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.nama_vaksinasi,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                        ),
                  ),
                  if (recommended.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Icon(
                            Icons.event_rounded,
                            size: 15,
                            color: Colors.white.withValues(alpha: 0.75),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${'recommended_date'.tr}: $recommended',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                              color: Colors.white.withValues(alpha: 0.82),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSkeleton() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SkeletonBox(width: 42, height: 42, radius: 13),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SkeletonBox(width: 120, height: 14),
                    SizedBox(height: 8),
                    SkeletonBox(width: 76, height: 10),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const SkeletonBox(height: 40, radius: 12),
          const SizedBox(height: 10),
          const SkeletonBox(height: 40, radius: 12),
          const SizedBox(height: 10),
          const SkeletonBox(height: 40, radius: 12),
        ],
      ),
    );
  }

  Widget _buildNoRecord(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.vaccines_outlined,
              color: AppColors.primary,
              size: 23,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'no_vaccination_record'.tr,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'no_vaccination_record_message'.tr,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecord(
    BuildContext context,
    Map<String, dynamic> record,
  ) {
    final photo = '${record['photo'] ?? ''}'.trim();
    final done = _status == 'Sudah';

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: done ? AppColors.mintSoft : AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  done
                      ? Icons.assignment_turned_in_rounded
                      : Icons.assignment_outlined,
                  size: 21,
                  color: done ? AppColors.mint : AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'vaccination_details'.tr,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _DetailRow(
            icon: Icons.event_available_rounded,
            label: 'vaccination_date'.tr,
            value: _formatDate(record['tanggal_vaksin']),
            tone: AppTone.mint,
          ),
          _DetailRow(
            icon: Icons.person_outline_rounded,
            label: 'doctor_name'.tr,
            value: _textOrDash(record['nama_dokter']),
            tone: AppTone.primary,
          ),
          _DetailRow(
            icon: Icons.location_on_outlined,
            label: 'place'.tr,
            value: _textOrDash(record['tempat']),
            tone: AppTone.amber,
          ),
          _DetailRow(
            icon: Icons.qr_code_2_rounded,
            label: 'no_batch'.tr,
            value: _textOrDash(record['no_batch']),
            tone: AppTone.neutral,
          ),
          if (photo.isNotEmpty) ...[
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: AppPhoto(
                photo,
                width: double.infinity,
                height: 190,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActions(bool recorded) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              label: recorded
                  ? 'update_vaccination'.tr
                  : 'add_child_vaccination'.tr,
              icon: recorded ? Icons.edit_rounded : Icons.add_rounded,
              onPressed: _initialLoading ? null : _openRecordForm,
            ),
            if (recorded) ...[
              const SizedBox(height: 10),
              AppButton(
                label: 'mark_not_done'.tr,
                icon: Icons.undo_rounded,
                variant: AppButtonVariant.danger,
                onPressed: _markNotDone,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.tone,
  });

  final IconData icon;
  final String label;
  final String value;
  final AppTone tone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: tone.background,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 18, color: tone.foreground),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.inkMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                    color: AppColors.ink,
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
