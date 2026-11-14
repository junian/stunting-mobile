import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:growthtracker/controller/ChildrenController.dart';
import 'package:growthtracker/controller/SessionController.dart';
import 'package:growthtracker/pages/ChildrenDetailPage.dart';
import 'package:growthtracker/theme/app_theme.dart';
import 'package:growthtracker/widget/AppPhoto.dart';
import 'package:growthtracker/widget/DecimalInputFormatter.dart';
import 'package:growthtracker/widgets/app_widgets.dart';

class ChildrenEditorPage extends StatefulWidget {
  final dynamic anak_id;

  const ChildrenEditorPage({super.key, required this.anak_id});

  @override
  State<ChildrenEditorPage> createState() => _ChildrenEditorPageState();
}

class _ChildrenEditorPageState extends State<ChildrenEditorPage> {
  final childernController = Get.put(ChildrenController());
  final sessionController = Get.put(SessionController());

  final TextEditingController nama_anak = TextEditingController();
  final TextEditingController tanggal_lahir = TextEditingController();
  final TextEditingController jenis_kelamin = TextEditingController();
  final TextEditingController berat_badan = TextEditingController();
  final TextEditingController tinggi_badan = TextEditingController();
  final TextEditingController lingkar_kepala = TextEditingController();
  final TextEditingController tinggi_badan_ibu = TextEditingController();
  final TextEditingController tinggi_badan_ayah = TextEditingController();

  bool _isSaving = false;
  final Map<String, String> _errors = {};

  String? _selectedGender;
  String? _selectedPrematur;
  String? _selectedAllergy;
  String? _selectedBloodGroup;

  static const List<String> _blood = ['A', 'B', 'AB', 'O'];

  final TextEditingController dateinput = TextEditingController();
  String? _dateLabel;

  List<dynamic> isChildern = [];
  File? image;

  @override
  void initState() {
    super.initState();
    _selectedBloodGroup = null;

    if (widget.anak_id != null && childernController.dataAnak.isNotEmpty) {
      isChildern = List<dynamic>.from(childernController.dataAnak);
      final child = isChildern[0];

      nama_anak.text = '${child['nama_anak'] ?? ''}';
      dateinput.text = '${child['tanggal_lahir'] ?? ''}';
      final birth = DateTime.tryParse(dateinput.text);
      if (birth != null) {
        _dateLabel = DateFormat('d MMM y').format(birth);
      }
      berat_badan.text = '${child['berat_badan'] ?? ''}';
      tinggi_badan.text = '${child['tinggi_badan'] ?? ''}';
      lingkar_kepala.text = '${child['lingkar_kepala'] ?? ''}';
      tinggi_badan_ibu.text = '${child['tinggi_badan_ibu'] ?? ''}';
      tinggi_badan_ayah.text = '${child['tinggi_badan_ayah'] ?? ''}';

      final gender = '${child['jenis_kelamin'] ?? ''}';
      if (gender == 'Laki-Laki' || gender == 'Perempuan') {
        _selectedGender = gender;
      }

      final prematur = '${child['prematur'] ?? ''}';
      if (prematur == 'Ya' || prematur == 'Tidak') {
        _selectedPrematur = prematur;
      }

      final alergi = '${child['alergi'] ?? ''}';
      if (alergi == 'Ya' || alergi == 'Tidak') {
        _selectedAllergy = alergi;
      }

      final blood = '${child['gol_darah'] ?? ''}'.trim();
      if (_blood.contains(blood)) {
        _selectedBloodGroup = blood;
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final imagePicker = ImagePicker();
      final picked = await imagePicker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() => image = File(picked.path));
      }
    } catch (_) {
      AppSnack.error('save_failed'.tr);
    }
  }

  void _clearError(String field) {
    if (_errors.containsKey(field)) {
      setState(() => _errors.remove(field));
    }
  }

  void _validateNumber(
    Map<String, String> errors,
    String field,
    String value,
  ) {
    final raw = value.trim().replaceAll(',', '.');
    if (raw.isEmpty) {
      errors[field] = 'validation_required'.tr;
      return;
    }
    if (double.tryParse(raw) == null) {
      errors[field] = 'validation_number'.tr;
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(dateinput.text) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    setState(() {
      dateinput.text = DateFormat('yyyy-MM-dd').format(picked);
      _dateLabel = DateFormat('d MMM y').format(picked);
      _errors.remove('birth_date');
    });
  }

  Future<void> _save() async {
    if (_isSaving) return;
    final errors = <String, String>{};

    if (nama_anak.text.trim().isEmpty) {
      errors['name'] = 'validation_required'.tr;
    }

    final birthDateText = dateinput.text.trim();
    if (birthDateText.isEmpty) {
      errors['birth_date'] = 'validation_required'.tr;
    } else {
      final birthDate = DateTime.tryParse(birthDateText);
      if (birthDate == null) {
        errors['birth_date'] = 'validation_date'.tr;
      } else if (birthDate.isAfter(DateTime.now())) {
        errors['birth_date'] = 'validation_future_date'.tr;
      }
    }

    if (_selectedGender == null) {
      errors['gender'] = 'validation_select_option'.tr;
    }
    if (_selectedPrematur == null) {
      errors['prematur'] = 'validation_select_option'.tr;
    }
    _validateNumber(errors, 'weight', berat_badan.text);
    _validateNumber(errors, 'height', tinggi_badan.text);
    _validateNumber(errors, 'head', lingkar_kepala.text);
    if (_selectedBloodGroup == null) {
      errors['blood'] = 'validation_select_option'.tr;
    }
    if (_selectedAllergy == null) {
      errors['allergy'] = 'validation_select_option'.tr;
    }
    _validateNumber(errors, 'mother', tinggi_badan_ibu.text);
    _validateNumber(errors, 'father', tinggi_badan_ayah.text);

    setState(() {
      _errors
        ..clear()
        ..addAll(errors);
    });

    if (errors.isNotEmpty) return;

    setState(() => _isSaving = true);

    final savedChild = await childernController.registerAnak(
      sessionController.user_id.value,
      widget.anak_id,
      nama_anak.text.trim(),
      dateinput.text,
      _selectedGender.toString(),
      berat_badan.text.trim(),
      tinggi_badan.text.trim(),
      lingkar_kepala.text.trim(),
      tinggi_badan_ibu.text.trim(),
      tinggi_badan_ayah.text.trim(),
      _selectedBloodGroup.toString(),
      _selectedAllergy.toString(),
      _selectedPrematur.toString(),
      image,
    );

    if (savedChild == null) {
      if (mounted) setState(() => _isSaving = false);
      AppSnack.error('save_failed'.tr);
      return;
    }

    if (mounted) setState(() => _isSaving = false);

    final isNewChild = widget.anak_id == null;

    if (isNewChild) {
      AppSnack.success('child_added_success'.tr);
      // Replace the editor with the new child's detail page in one step, so
      // the editor closes immediately and the user lands on the saved profile.
      Get.off(
        () => ChildrenDetailPage(anakId: '${savedChild['anak_id']}'),
        transition: Transition.fadeIn,
      );
    } else {
      // Close first: Get.back() can otherwise dismiss a snackbar instead of
      // the editor when a toast was just shown.
      Get.back();
      AppSnack.success('saved'.tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = systemBottomInset(context);
    final editing = widget.anak_id != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          AppPageHeader(
            title: editing ? 'edit_child_account'.tr : 'add_child_profile'.tr,
            subtitle: 'child_profile'.tr,
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              children: [
                _buildPhotoCard(context),
                const SizedBox(height: 16),
                _buildSection(
                  context,
                  icon: Icons.person_outline_rounded,
                  title: 'personal_information'.tr,
                  children: [
                    AppTextField(
                      label: 'full_name'.tr,
                      required: true,
                      controller: nama_anak,
                      hint: 'child_name_hint'.tr,
                      error: _errors['name'],
                      textInputAction: TextInputAction.next,
                      onChanged: (_) => _clearError('name'),
                    ),
                    const SizedBox(height: 16),
                    AppField(
                      label: 'birth_date'.tr,
                      required: true,
                      error: _errors['birth_date'],
                      child: _DateField(
                        label: _dateLabel,
                        onTap: _pickDate,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppField(
                      label: 'gender'.tr,
                      required: true,
                      error: _errors['gender'],
                      child: AppSegmented<String>(
                        value: _selectedGender,
                        onChanged: (value) {
                          setState(() => _selectedGender = value);
                          _clearError('gender');
                        },
                        options: [
                          AppSegment(
                            value: 'Laki-Laki',
                            label: 'male'.tr,
                            icon: Icons.male_rounded,
                          ),
                          AppSegment(
                            value: 'Perempuan',
                            label: 'female'.tr,
                            icon: Icons.female_rounded,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSection(
                  context,
                  icon: Icons.child_friendly_outlined,
                  title: 'birth_data'.tr,
                  children: [
                    AppTextField(
                      label: 'birth_weight_label'.tr,
                      required: true,
                      controller: berat_badan,
                      hint: 'birth_weight_hint'.tr,
                      suffixText: 'kg',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [DecimalInputFormatter()],
                      error: _errors['weight'],
                      onChanged: (_) => _clearError('weight'),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'birth_height_label'.tr,
                      required: true,
                      controller: tinggi_badan,
                      hint: 'birth_height_hint'.tr,
                      suffixText: 'cm',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [DecimalInputFormatter()],
                      error: _errors['height'],
                      onChanged: (_) => _clearError('height'),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'birth_head_label'.tr,
                      required: true,
                      controller: lingkar_kepala,
                      hint: 'birth_height_hint'.tr,
                      suffixText: 'cm',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [DecimalInputFormatter()],
                      error: _errors['head'],
                      onChanged: (_) => _clearError('head'),
                    ),
                    const SizedBox(height: 16),
                    AppField(
                      label: 'is_premature'.tr,
                      required: true,
                      error: _errors['prematur'],
                      child: AppSegmented<String>(
                        value: _selectedPrematur,
                        onChanged: (value) {
                          setState(() => _selectedPrematur = value);
                          _clearError('prematur');
                        },
                        options: [
                          AppSegment(
                            value: 'Ya',
                            label: 'yes'.tr,
                            icon: Icons.check_rounded,
                          ),
                          AppSegment(
                            value: 'Tidak',
                            label: 'no'.tr,
                            icon: Icons.close_rounded,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSection(
                  context,
                  icon: Icons.medical_information_outlined,
                  title: 'additional_profile'.tr,
                  children: [
                    AppDropdownField<String>(
                      label: 'blood_group'.tr,
                      required: true,
                      value: _selectedBloodGroup,
                      hint: 'select_blood_group'.tr,
                      error: _errors['blood'],
                      items: [
                        for (final blood in _blood)
                          DropdownMenuItem(
                            value: blood,
                            child: Text(blood),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedBloodGroup = value);
                        _clearError('blood');
                      },
                    ),
                    const SizedBox(height: 16),
                    AppField(
                      label: 'has_allergy'.tr,
                      required: true,
                      error: _errors['allergy'],
                      child: AppSegmented<String>(
                        value: _selectedAllergy,
                        onChanged: (value) {
                          setState(() => _selectedAllergy = value);
                          _clearError('allergy');
                        },
                        options: [
                          AppSegment(
                            value: 'Ya',
                            label: 'yes'.tr,
                            icon: Icons.check_rounded,
                          ),
                          AppSegment(
                            value: 'Tidak',
                            label: 'no'.tr,
                            icon: Icons.close_rounded,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSection(
                  context,
                  icon: Icons.height_rounded,
                  title: 'parent_height'.tr,
                  note: 'parent_height_note'.tr,
                  children: [
                    AppTextField(
                      label: 'mother_height'.tr,
                      required: true,
                      controller: tinggi_badan_ibu,
                      hint: 'birth_height_hint'.tr,
                      suffixText: 'cm',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [DecimalInputFormatter()],
                      error: _errors['mother'],
                      onChanged: (_) => _clearError('mother'),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'father_height'.tr,
                      required: true,
                      controller: tinggi_badan_ayah,
                      hint: 'birth_height_hint'.tr,
                      suffixText: 'cm',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [DecimalInputFormatter()],
                      error: _errors['father'],
                      onChanged: (_) => _clearError('father'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(20, 8, 20, 12 + bottomInset),
        child: AppButton(
          label: 'save'.tr,
          icon: Icons.check_rounded,
          loading: _isSaving,
          onPressed: _isSaving ? null : _save,
        ),
      ),
    );
  }

  Widget _buildPhotoCard(BuildContext context) {
    final existingPhoto =
        isChildern.isNotEmpty ? isChildern[0]['photo']?.toString() : null;

    return AppCard(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      child: Column(
        children: [
          AnimatedPressable(
            onTap: _pickImage,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primarySoft, width: 3),
                  ),
                  child: image == null
                      ? (existingPhoto != null && existingPhoto.isNotEmpty
                          ? ClipOval(
                              child: AppPhoto(
                                existingPhoto,
                                width: 92,
                                height: 92,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              width: 92,
                              height: 92,
                              decoration: const BoxDecoration(
                                gradient: AppColors.brandGradient,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.child_care_rounded,
                                color: Colors.white,
                                size: 42,
                              ),
                            ))
                      : ClipOval(
                          child: Image.file(
                            image!,
                            width: 92,
                            height: 92,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.5),
                    ),
                    child: const Icon(
                      Icons.photo_camera_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            image == null ? 'upload_photo'.tr : 'change_photo'.tr,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required List<Widget> children,
    String? note,
  }) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 19, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          if (note != null) ...[
            const SizedBox(height: 10),
            Text(
              note,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    height: 1.5,
                  ),
            ),
          ],
          const SizedBox(height: 18),
          ...children,
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.label, required this.onTap});

  final String? label;
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                size: 19,
                color: AppColors.inkMuted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label ?? 'select_date'.tr,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                        label == null ? FontWeight.w500 : FontWeight.w600,
                    color: label == null ? AppColors.inkMuted : AppColors.ink,
                  ),
                ),
              ),
              const Icon(
                Icons.expand_more_rounded,
                color: AppColors.inkMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
