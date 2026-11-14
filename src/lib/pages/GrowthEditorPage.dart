import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:growthtracker/controller/GrowthEditorController.dart';
import 'package:growthtracker/services/LocalStore.dart';
import 'package:growthtracker/theme/app_theme.dart';
import 'package:growthtracker/widget/DecimalInputFormatter.dart';
import 'package:growthtracker/widgets/app_widgets.dart';

class GrowthEditorPage extends StatefulWidget {
  final String anakID;
  final String tinggiBadanAyah;
  final String tinggiBadanIbu;

  const GrowthEditorPage({
    super.key,
    required this.anakID,
    required this.tinggiBadanAyah,
    required this.tinggiBadanIbu,
  });

  @override
  State<GrowthEditorPage> createState() => _GrowthEditorPageState();
}

class _GrowthEditorPageState extends State<GrowthEditorPage> {
  final tambahPertumbuhanAnak = Get.put(GrowthEditorController());
  final LocalStore _store = LocalStore();

  final TextEditingController dateinput = TextEditingController();

  bool _isSaving = false;
  String? _dateLabel;
  String _childName = '';
  final Map<String, String> _errors = {};

  @override
  void initState() {
    super.initState();
    // The controller is shared for the lifetime of the app; a fresh page
    // should start with an empty measurement.
    tambahPertumbuhanAnak.beratBadan.clear();
    tambahPertumbuhanAnak.tinggiBadan.clear();
    tambahPertumbuhanAnak.lingkarKepala.clear();
    tambahPertumbuhanAnak.pickedImage = null;
    _loadChildName();
  }

  Future<void> _loadChildName() async {
    final child = await _store.childById(widget.anakID);
    if (!mounted) return;
    setState(() => _childName = '${child?['nama_anak'] ?? ''}');
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          tambahPertumbuhanAnak.pickedImage = File(pickedFile.path);
        });
      }
    } catch (_) {
      AppSnack.error('save_failed'.tr);
    }
  }

  double _toDouble(String value) =>
      double.parse(value.trim().replaceAll(',', '.'));

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
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    setState(() {
      dateinput.text = DateFormat('yyyy-MM-dd').format(picked);
      _dateLabel = DateFormat('d MMM y').format(picked);
      _errors.remove('date');
    });
  }

  Future<void> _save() async {
    HapticFeedback.mediumImpact();
    final errors = <String, String>{};

    if (dateinput.text.trim().isEmpty) {
      errors['date'] = 'validation_required'.tr;
    } else {
      final date = DateTime.tryParse(dateinput.text.trim());
      if (date == null) {
        errors['date'] = 'validation_date'.tr;
      } else if (date.isAfter(DateTime.now())) {
        errors['date'] = 'validation_date_future'.tr;
      }
    }

    _validateNumber(errors, 'weight', tambahPertumbuhanAnak.beratBadan.text);
    _validateNumber(errors, 'height', tambahPertumbuhanAnak.tinggiBadan.text);
    _validateNumber(errors, 'head', tambahPertumbuhanAnak.lingkarKepala.text);

    setState(() {
      _errors
        ..clear()
        ..addAll(errors);
    });

    if (errors.isNotEmpty) return;

    setState(() => _isSaving = true);

    final saved = await tambahPertumbuhanAnak.addPertumbuhanAnak(
      anakID: widget.anakID,
      selectedDate: dateinput.text,
      pickedImage: tambahPertumbuhanAnak.pickedImage,
      beratBadan: _toDouble(tambahPertumbuhanAnak.beratBadan.text),
      tinggiBadan: _toDouble(tambahPertumbuhanAnak.tinggiBadan.text),
      lingkarKepala: _toDouble(tambahPertumbuhanAnak.lingkarKepala.text),
      tinggiBadanIbu: widget.tinggiBadanIbu,
      tinggiBadanAyah: widget.tinggiBadanAyah,
    );

    if (!saved) {
      if (mounted) setState(() => _isSaving = false);
      AppSnack.error('save_failed'.tr);
      return;
    }

    AppSnack.success('saved'.tr);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = systemBottomInset(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          AppPageHeader(
            title: 'add_growth_data'.tr,
            subtitle: _childName.isEmpty ? null : _childName,
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              children: [
                AppCard(
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
                            child: const Icon(
                              Icons.event_available_rounded,
                              size: 19,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'growth_date'.tr,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          const Text(
                            '*',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.coral,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _DateSelector(
                        label: _dateLabel,
                        error: _errors['date'],
                        onTap: _pickDate,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.mintSoft,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.monitor_heart_outlined,
                              size: 19,
                              color: AppColors.mint,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'growth_results'.tr,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      AppTextField(
                        label: 'weight_kg'.tr,
                        required: true,
                        controller: tambahPertumbuhanAnak.beratBadan,
                        hint: 'example_weight'.tr,
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
                        label: 'height_cm'.tr,
                        required: true,
                        controller: tambahPertumbuhanAnak.tinggiBadan,
                        hint: 'example_height'.tr,
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
                        label: 'head_cm'.tr,
                        required: true,
                        controller: tambahPertumbuhanAnak.lingkarKepala,
                        hint: 'example_height'.tr,
                        suffixText: 'cm',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [DecimalInputFormatter()],
                        error: _errors['head'],
                        onChanged: (_) => _clearError('head'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildPhotoCard(context),
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
    final image = tambahPertumbuhanAnak.pickedImage;
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
                  color: AppColors.amberSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.photo_camera_outlined,
                  size: 19,
                  color: AppColors.amber,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'photo'.tr,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Text(
                'optional'.tr,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (image == null)
            _UploadTile(onTap: () => _pickImage(ImageSource.gallery))
          else
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: Image.file(
                    image,
                    width: double.infinity,
                    height: 170,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: AppIconButton(
                    icon: Icons.close_rounded,
                    size: 34,
                    background: Colors.black.withValues(alpha: 0.45),
                    foreground: Colors.white,
                    onTap: () => setState(
                        () => tambahPertumbuhanAnak.pickedImage = null),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: AnimatedPressable(
                    onTap: () => _pickImage(ImageSource.gallery),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.photo_camera_outlined,
                            size: 15,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'change_photo'.tr,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _DateSelector extends StatelessWidget {
  const _DateSelector({
    required this.label,
    required this.onTap,
    this.error,
  });

  final String? label;
  final String? error;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasError = error != null && error!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: hasError ? AppColors.coral : Colors.transparent,
                  width: 1.4,
                ),
              ),
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
                        color:
                            label == null ? AppColors.inkMuted : AppColors.ink,
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
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 6),
            child: Text(
              error!,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: AppColors.coral,
              ),
            ),
          ),
      ],
    );
  }
}

class _UploadTile extends StatelessWidget {
  const _UploadTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceAlt,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 16),
          child: Column(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  color: AppColors.primarySoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_a_photo_outlined,
                  color: AppColors.primary,
                  size: 21,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'upload_photo'.tr,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 3),
              Text(
                'optional'.tr,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
