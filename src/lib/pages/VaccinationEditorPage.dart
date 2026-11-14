import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:growthtracker/controller/VaccinationController.dart';
import 'package:growthtracker/theme/app_theme.dart';
import 'package:growthtracker/widgets/app_widgets.dart';

/// Form used to record or update one vaccination of a child.
///
/// The date, doctor and place are required; the batch number and a photo of the
/// vaccination book are optional. The save action stays pinned above the
/// navigation bar so the form can grow without hiding it.
class VaccinationEditorPage extends StatefulWidget {
  final String anak_id;
  final String vaksin_id;
  final String? vaksin_anak_id;

  const VaccinationEditorPage({
    super.key,
    required this.anak_id,
    required this.vaksin_id,
    this.vaksin_anak_id,
  });

  @override
  State<VaccinationEditorPage> createState() => _VaccinationEditorPageState();
}

class _VaccinationEditorPageState extends State<VaccinationEditorPage> {
  var vaksinasiController = Get.put(VaccinationController());

  bool _saving = false;
  final Map<String, String> _errors = {};

  Future<void> _save() async {
    final errors = <String, String>{};

    final tanggal = vaksinasiController.dateinput.text.trim();
    if (tanggal.isEmpty) {
      errors['date'] = 'validation_required'.tr;
    } else {
      final date = DateTime.tryParse(tanggal);
      if (date == null) {
        errors['date'] = 'validation_date'.tr;
      } else if (date.isAfter(DateTime.now())) {
        errors['date'] = 'validation_date_future'.tr;
      }
    }

    if (vaksinasiController.nama_dokter.text.trim().isEmpty) {
      errors['doctor'] = 'validation_required'.tr;
    }
    if (vaksinasiController.tempat.text.trim().isEmpty) {
      errors['place'] = 'validation_required'.tr;
    }

    setState(() {
      _errors
        ..clear()
        ..addAll(errors);
    });

    if (errors.isNotEmpty) {
      AppSnack.error('complete_form_message'.tr);
      return;
    }

    setState(() => _saving = true);

    final saved = await vaksinasiController.addVaksinAnak(
      vaksin_anak_id: widget.vaksin_anak_id,
      anak_id: widget.anak_id,
      vaksin_id: widget.vaksin_id,
      tanggal_vaksin: tanggal,
      name_dokter: vaksinasiController.nama_dokter.text.trim(),
      tempat: vaksinasiController.tempat.text.trim(),
      no_batch: vaksinasiController.no_batch.text.trim(),
      pickedImage: vaksinasiController.pickedImage,
    );

    if (!mounted) return;
    setState(() => _saving = false);

    if (!saved) {
      AppSnack.error('vaccine_added_failed'.tr);
      return;
    }

    AppSnack.success('saved'.tr);
    Get.back();
  }

  void _clearError(String field) {
    if (_errors.containsKey(field)) {
      setState(() => _errors.remove(field));
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final current = DateTime.tryParse(
      vaksinasiController.dateinput.text.trim(),
    );
    final initial = current == null || current.isAfter(now) ? now : current;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: now,
    );
    if (picked == null || !mounted) return;

    setState(() {
      vaksinasiController.dateinput.text =
          DateFormat('yyyy-MM-dd').format(picked);
      _errors.remove('date');
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(source: source);
      if (pickedFile == null || !mounted) return;

      setState(() {
        vaksinasiController.pickedImage = File(pickedFile.path);
      });
    } catch (_) {
      if (mounted) AppSnack.error('failed'.tr);
    }
  }

  void _showPhotoSource() {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return AppSheet(
          title: 'upload_photo'.tr,
          subtitle: 'vaccination_photo_hint'.tr,
          child: Column(
            children: [
              AppListTile(
                icon: Icons.photo_camera_rounded,
                title: 'take_photo'.tr,
                tone: AppTone.primary,
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              const Divider(),
              AppListTile(
                icon: Icons.photo_library_rounded,
                title: 'choose_from_gallery'.tr,
                tone: AppTone.mint,
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _removePhoto() {
    setState(() => vaksinasiController.pickedImage = null);
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.vaksin_anak_id != null;
    final picked = vaksinasiController.pickedImage;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          AppPageHeader(
            title:
                editing ? 'update_vaccination'.tr : 'add_child_vaccination'.tr,
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
              children: [
                AppCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FormSectionHeader(
                        icon: Icons.vaccines_rounded,
                        title: 'vaccination_details'.tr,
                      ),
                      const SizedBox(height: 20),
                      AppTextField(
                        label: 'vaccination_date'.tr,
                        controller: vaksinasiController.dateinput,
                        hint: 'select_date'.tr,
                        required: true,
                        readOnly: true,
                        onTap: _pickDate,
                        prefixIcon: Icons.calendar_today_rounded,
                        error: _errors['date'],
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'doctor_name'.tr,
                        controller: vaksinasiController.nama_dokter,
                        hint: 'doctor_name'.tr,
                        required: true,
                        prefixIcon: Icons.person_outline_rounded,
                        textInputAction: TextInputAction.next,
                        error: _errors['doctor'],
                        onChanged: (_) => _clearError('doctor'),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'place'.tr,
                        controller: vaksinasiController.tempat,
                        hint: 'place_name'.tr,
                        required: true,
                        prefixIcon: Icons.location_on_outlined,
                        textInputAction: TextInputAction.next,
                        error: _errors['place'],
                        onChanged: (_) => _clearError('place'),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'no_batch'.tr,
                        controller: vaksinasiController.no_batch,
                        hint: 'no_batch'.tr,
                        prefixIcon: Icons.qr_code_2_rounded,
                        textInputAction: TextInputAction.done,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                AppCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _FormSectionHeader(
                              icon: Icons.photo_camera_rounded,
                              title: 'photo'.tr,
                              tone: AppTone.mint,
                            ),
                          ),
                          Text(
                            'optional'.tr,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (picked != null) ...[
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              child: Image.file(
                                picked,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: AppIconButton(
                                icon: Icons.close_rounded,
                                size: 36,
                                background:
                                    AppColors.ink.withValues(alpha: 0.72),
                                foreground: Colors.white,
                                onTap: _removePhoto,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: _showPhotoSource,
                            icon: const Icon(Icons.sync_rounded, size: 18),
                            label: Text('change_photo'.tr),
                          ),
                        ),
                      ] else
                        AnimatedPressable(
                          onTap: _showPhotoSource,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 26,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceAlt,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.md + 2),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primarySoft,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add_a_photo_rounded,
                                    color: AppColors.primary,
                                    size: 23,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'upload_photo'.tr,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'vaccination_photo_hint'.tr,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildSaveBar(),
        ],
      ),
    );
  }

  Widget _buildSaveBar() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: AppButton(
          label: 'save'.tr,
          icon: Icons.check_rounded,
          loading: _saving,
          onPressed: _saving ? null : _save,
        ),
      ),
    );
  }
}

class _FormSectionHeader extends StatelessWidget {
  const _FormSectionHeader({
    required this.icon,
    required this.title,
    this.tone = AppTone.primary,
  });

  final IconData icon;
  final String title;
  final AppTone tone;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: tone.background,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, size: 18, color: tone.foreground),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}
