import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:growthtracker/controller/AuthController.dart';
import 'package:growthtracker/controller/ChildrenController.dart';
import 'package:growthtracker/helper/AppRouteObserver.dart';
import 'package:growthtracker/pages/ChildrenEditorPage.dart';
import 'package:growthtracker/pages/GrowthEditorPage.dart';
import 'package:growthtracker/pages/HomePage.dart';
import 'package:growthtracker/pages/SettingUserPage.dart';
import 'package:growthtracker/theme/app_theme.dart';
import 'package:growthtracker/widgets/app_widgets.dart';

/// App shell with a floating, modern bottom bar.
///
/// The two destinations stay alive in an [IndexedStack] so switching tabs is
/// instant. The raised center action opens a small quick-add sheet.
class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> with RouteAware {
  final childrenController = Get.put(ChildrenController());
  final authController = Get.put(AuthController());
  final GlobalKey<HomePageState> _homeKey = GlobalKey<HomePageState>();

  int _index = 0;
  bool _covered = false;
  bool _subscribed = false;

  void _select(int index) {
    if (_index == index) return;
    HapticFeedback.selectionClick();
    setState(() => _index = index);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_subscribed) return;
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      appRouteObserver.subscribe(this, route);
      _subscribed = true;
    }
  }

  @override
  void dispose() {
    if (_subscribed) appRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPushNext() {
    if (mounted && !_covered) setState(() => _covered = true);
  }

  @override
  void didPopNext() {
    if (mounted && _covered) setState(() => _covered = false);
  }

  Future<void> _openQuickAdd() async {
    HapticFeedback.mediumImpact();
    final children = childrenController.anakList;

    if (children.isEmpty) {
      await Get.to(() => ChildrenEditorPage(anak_id: null));
      await _homeKey.currentState?.refresh();
      return;
    }

    final child = children.first;
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return AppSheet(
          title: 'quick_actions'.tr,
          subtitle: '${child['nama_anak']} · ${child['umur'] ?? ''}',
          child: Column(
            children: [
              _QuickAction(
                icon: Icons.monitor_weight_rounded,
                tone: AppTone.primary,
                title: 'add_measurement'.tr,
                subtitle: 'weight'.tr + ' · ' + 'height'.tr,
                onTap: () {
                  Get.back();
                  Get.to(
                    () => GrowthEditorPage(
                      anakID: '${child['anak_id']}',
                      tinggiBadanAyah: '${child['tinggi_badan_ayah'] ?? ''}',
                      tinggiBadanIbu: '${child['tinggi_badan_ibu'] ?? ''}',
                    ),
                  )?.then((_) => _homeKey.currentState?.refresh());
                },
              ),
              const SizedBox(height: 10),
              _QuickAction(
                icon: Icons.child_care_rounded,
                tone: AppTone.mint,
                title: 'add_child_profile'.tr,
                subtitle: 'personal_information'.tr,
                onTap: () {
                  Get.back();
                  Get.to(() => ChildrenEditorPage(anak_id: null))
                      ?.then((_) => _homeKey.currentState?.refresh());
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: IndexedStack(
        index: _index,
        children: [
          HomePage(key: _homeKey),
          const SettingUserPage(),
        ],
      ),
      bottomNavigationBar: _covered
          ? const SizedBox.shrink()
          : _FloatingNavBar(
              index: _index,
              onSelect: _select,
              onAdd: _openQuickAdd,
              bottomInset: systemBottomInset(context),
            ),
    );
  }
}

class _FloatingNavBar extends StatelessWidget {
  const _FloatingNavBar({
    required this.index,
    required this.onSelect,
    required this.onAdd,
    required this.bottomInset,
  });

  final int index;
  final ValueChanged<int> onSelect;
  final VoidCallback onAdd;
  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18, 0, 18, 12 + bottomInset),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.xxl),
          border: Border.all(color: AppColors.line),
          boxShadow: AppShadows.floating,
        ),
        child: Row(
          children: [
            Expanded(
              child: _NavItem(
                icon: Icons.home_rounded,
                label: 'nav_home'.tr,
                selected: index == 0,
                onTap: () => onSelect(0),
              ),
            ),
            SizedBox(
              width: 78,
              child: Center(
                child: AnimatedPressable(
                  onTap: onAdd,
                  scale: 0.92,
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: AppColors.brandGradient,
                      shape: BoxShape.circle,
                      boxShadow: AppShadows.primary,
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _NavItem(
                icon: Icons.settings_rounded,
                label: 'nav_settings'.tr,
                selected: index == 1,
                onTap: () => onSelect(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedPressable(
      onTap: onTap,
      scale: 0.95,
      haptic: false,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? AppColors.primarySoft : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22,
                color: selected ? AppColors.primary : AppColors.inkMuted,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  color: selected ? AppColors.primary : AppColors.inkMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.tone,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final AppTone tone;
  final String title;
  final String subtitle;
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
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: tone.background,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: tone.foreground, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: AppColors.inkMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
