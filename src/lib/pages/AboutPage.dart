import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:growthtracker/helper/Branding.dart';
import 'package:growthtracker/theme/app_theme.dart';
import 'package:growthtracker/widgets/app_widgets.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  Future<void> _openUrl(String url) async {
    try {
      final launched = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
      if (!launched && mounted) {
        AppSnack.error('failed'.tr);
      }
    } catch (_) {
      if (mounted) AppSnack.error('failed'.tr);
    }
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
              AppPageHeader(
                title: 'about_app'.tr,
              ),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 36),
                  children: [
                    _buildBrandHero(context),
                    const SizedBox(height: 26),
                    AppSectionHeader(title: 'about_this_app'.tr),
                    const SizedBox(height: 12),
                    _buildDescriptionCard(context),
                    const SizedBox(height: 20),
                    _buildDisclaimer(context),
                    const SizedBox(height: 26),
                    AppSectionHeader(title: 'contact_us'.tr),
                    const SizedBox(height: 12),
                    _buildContactCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandHero(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        boxShadow: AppShadows.primary,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        child: Container(
          decoration: const BoxDecoration(gradient: AppColors.brandGradient),
          child: Stack(
            children: [
              Positioned(
                top: -54,
                right: -40,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -60,
                left: -36,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: AppColors.teal.withValues(alpha: 0.24),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 82,
                      height: 82,
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Image.asset(
                        'images/logo_mark.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'app_name'.tr,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.6,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'app_tagline'.tr,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                        color: Colors.white.withValues(alpha: 0.78),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        'version'.tr,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                          color: Colors.white,
                        ),
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

  Widget _buildDescriptionCard(BuildContext context) {
    return AppCard(
      child: Text(
        'about_description'.tr,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.65,
              color: AppColors.inkSoft,
            ),
      ),
    );
  }

  Widget _buildDisclaimer(BuildContext context) {
    return AppCard(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFEAF8F4), Color(0xFFEAF1FF)],
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.verified_user_rounded,
              size: 20,
              color: AppColors.mint,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'about_disclaimer'.tr,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.55,
                    color: AppColors.inkSoft,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        children: [
          AppListTile(
            icon: Icons.mail_outline_rounded,
            title: 'email'.tr,
            subtitle: kSupportEmail,
            tone: AppTone.primary,
            onTap: () => _openUrl(kSupportMailto),
            trailing: const Icon(
              Icons.arrow_outward_rounded,
              size: 18,
              color: AppColors.inkMuted,
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                _SocialButton(
                  icon: Icons.smart_display_rounded,
                  label: 'YouTube',
                  tone: AppTone.amber,
                  onTap: () => _openUrl(kYouTubeUrl),
                ),
                _SocialButton(
                  icon: Icons.public_rounded,
                  label: 'website'.tr,
                  tone: AppTone.mint,
                  onTap: () => _openUrl(kWebsiteUrl),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
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
    return Expanded(
      child: AnimatedPressable(
        onTap: onTap,
        haptic: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: tone.background,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 21, color: tone.foreground),
              ),
              const SizedBox(height: 7),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
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
