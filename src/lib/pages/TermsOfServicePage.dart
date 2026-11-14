import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:growthtracker/controller/ParameterController.dart';
import 'package:growthtracker/helper/Branding.dart';
import 'package:growthtracker/theme/app_theme.dart';
import 'package:growthtracker/widgets/app_widgets.dart';

class TermsOfServicePage extends StatefulWidget {
  const TermsOfServicePage({super.key});

  @override
  State<TermsOfServicePage> createState() => _TermsOfServicePageState();
}

class _TermsOfServicePageState extends State<TermsOfServicePage> {
  final ParameterController parameterController =
      Get.put(ParameterController());

  bool _loading = true;
  bool _failed = false;
  String _content = '';

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    if (mounted && !_loading) {
      setState(() {
        _loading = true;
        _failed = false;
      });
    }

    // Clear the shared cache so a failed request cannot show a stale
    // document from another static page.
    parameterController.parameterValue = '';
    await parameterController.getParameter('1');

    if (!mounted) return;
    final value = parameterController.parameterValue.trim();
    setState(() {
      _content = rebrandServerCopy(value);
      _loading = false;
      _failed = value.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          top: false,
          left: false,
          right: false,
          child: Column(
            children: [
              AppPageHeader(title: 'terms_conditions'.tr),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 36),
                  children: [
                    _buildDocumentHeader(context),
                    const SizedBox(height: 16),
                    _buildContentCard(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentHeader(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                  Icons.description_outlined,
                  size: 22,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  'terms_full_title'.tr,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.4,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                size: 14,
                color: AppColors.inkMuted,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'terms_last_updated'.tr,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
      child: _loading
          ? const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(height: 14, radius: 6),
                SizedBox(height: 10),
                SkeletonBox(height: 14, radius: 6),
                SizedBox(height: 10),
                SkeletonBox(width: 230, height: 14, radius: 6),
                SizedBox(height: 20),
                SkeletonBox(height: 14, radius: 6),
                SizedBox(height: 10),
                SkeletonBox(height: 14, radius: 6),
                SizedBox(height: 10),
                SkeletonBox(width: 190, height: 14, radius: 6),
              ],
            )
          : _failed
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.cloud_off_rounded,
                          size: 20,
                          color: AppColors.coral,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'failed'.tr,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    AppButton(
                      label: 'retry'.tr,
                      icon: Icons.refresh_rounded,
                      variant: AppButtonVariant.soft,
                      height: 48,
                      onPressed: () => initializeData(),
                    ),
                  ],
                )
              : _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontSize: 15,
          height: 1.75,
          color: AppColors.inkSoft,
        );

    final paragraphs = _content
        .split(RegExp(r'\r?\n\s*\r?\n'))
        .map((paragraph) => paragraph.trim())
        .where((paragraph) => paragraph.isNotEmpty)
        .toList();

    if (paragraphs.length <= 1) {
      return Text(_content, style: style);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < paragraphs.length; index++) ...[
          if (index > 0) const SizedBox(height: 14),
          Text(paragraphs[index], style: style),
        ],
      ],
    );
  }
}
