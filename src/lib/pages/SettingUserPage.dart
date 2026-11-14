import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:growthtracker/controller/AuthController.dart';
import 'package:growthtracker/controller/LanguageController.dart';
import 'package:growthtracker/controller/SessionController.dart';
import 'package:growthtracker/helper/AppVersion.dart';
import 'package:growthtracker/helper/Branding.dart';
import 'package:growthtracker/pages/AboutPage.dart';
import 'package:growthtracker/pages/TermsOfServicePage.dart';
import 'package:growthtracker/theme/app_theme.dart';
import 'package:growthtracker/widgets/app_widgets.dart';

class SettingUserPage extends StatefulWidget {
  const SettingUserPage({super.key});

  @override
  State<SettingUserPage> createState() => _SettingUserPageState();
}

class _SettingUserPageState extends State<SettingUserPage> {
  final authController = Get.put(AuthController());
  final sessionController = Get.put(SessionController());
  final languageController = Get.find<LanguageController>();

  @override
  void initState() {
    super.initState();
    authController.isParent;
  }

  void _showLanguageSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return AppSheet(
          title: 'language'.tr,
          subtitle: 'preferences'.tr,
          child: Obx(
            () => Column(
              children: [
                for (final code in [
                  LanguageController.system,
                  LanguageController.english,
                  LanguageController.indonesian,
                ])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _LanguageOption(
                      label: languageController.labelFor(code),
                      selected: languageController.preference.value == code,
                      onTap: () {
                        languageController.setLanguage(code);
                        Get.back();
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _contactSupport() async {
    try {
      final launched = await launchUrl(
        Uri.parse(kSupportMailto),
        mode: LaunchMode.externalApplication,
      );
      if (!launched) AppSnack.info(kSupportEmail);
    } catch (_) {
      AppSnack.info(kSupportEmail);
    }
  }

  Future<void> _logout() async {
    final confirmed = await showAppConfirm(
      context,
      title: 'logout'.tr,
      message: 'logout_confirm'.tr,
      confirmLabel: 'logout'.tr,
      icon: Icons.logout_rounded,
    );
    if (confirmed == true) {
      await authController.logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          bottom: false,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 130),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'account_settings'.tr,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'preferences'.tr,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  AppIconButton(
                    icon: Icons.translate_rounded,
                    background: AppColors.primarySoft,
                    foreground: AppColors.primary,
                    tooltip: 'language'.tr,
                    onTap: _showLanguageSheet,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildProfileCard(context),
              const SizedBox(height: 26),
              _buildSectionLabel(context, 'preferences'.tr),
              const SizedBox(height: 10),
              AppCard(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(
                  () => AppListTile(
                    icon: Icons.language_rounded,
                    title: 'language'.tr,
                    subtitle: languageController.currentLabel,
                    tone: AppTone.primary,
                    onTap: _showLanguageSheet,
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.inkMuted,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              _buildSectionLabel(context, 'general'.tr),
              const SizedBox(height: 10),
              AppCard(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    AppListTile(
                      icon: Icons.description_outlined,
                      title: 'terms_conditions'.tr,
                      tone: AppTone.amber,
                      onTap: () => Get.to(() => const TermsOfServicePage()),
                    ),
                    const Divider(),
                    AppListTile(
                      icon: Icons.info_outline_rounded,
                      title: 'about_app'.tr,
                      tone: AppTone.mint,
                      onTap: () => Get.to(() => AboutPage()),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              _buildSectionLabel(context, 'support'.tr),
              const SizedBox(height: 10),
              AppCard(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AppListTile(
                  icon: Icons.mail_outline_rounded,
                  title: 'help_support'.tr,
                  subtitle: kSupportEmail,
                  tone: AppTone.mint,
                  onTap: _contactSupport,
                ),
              ),
              if (sessionController.email.value.isNotEmpty) ...[
                const SizedBox(height: 26),
                AppButton(
                  label: 'logout'.tr,
                  icon: Icons.logout_rounded,
                  variant: AppButtonVariant.danger,
                  onPressed: _logout,
                ),
              ],
              const SizedBox(height: 28),
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'images/logo_mark.png',
                      width: 42,
                      height: 42,
                      opacity: const AlwaysStoppedAnimation(0.55),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${'app_name'.tr} · ${AppVersion.label('version_prefix'.tr)}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String label) {
    return Text(
      label.toUpperCase(),
      style: AppTextStyles.overline.copyWith(
        color: AppColors.inkMuted,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    final parent = authController.isParent;
    final name =
        parent.isNotEmpty ? '${parent[0]['nama_orang_tua'] ?? ''}'.trim() : '';
    final email = sessionController.email.value;
    final displayName = name.isNotEmpty
        ? name
        : (email.isNotEmpty ? email.split('@').first : 'greeting_parent'.tr);
    final subtitle = email.isNotEmpty ? email : 'app_tagline'.tr;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.primary,
      ),
      child: Row(
        children: [
          AppAvatar(
            photo: parent.isNotEmpty ? '${parent[0]['photo'] ?? ''}' : null,
            name: name.isNotEmpty ? name : null,
            size: 58,
            ring: true,
            icon: Icons.person_rounded,
            gradient: const LinearGradient(
              colors: [Color(0xFF6B93FF), Color(0xFF2EC4B6)],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.75),
                    height: 1.4,
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

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? AppColors.primaryDeep : AppColors.ink,
                  ),
                ),
              ),
              if (selected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
