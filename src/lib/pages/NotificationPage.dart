import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:growthtracker/controller/NotificationController.dart';
import 'package:growthtracker/controller/SessionController.dart';
import 'package:growthtracker/theme/app_theme.dart';
import 'package:growthtracker/widgets/app_widgets.dart';

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  final NotificationController notificationController =
      Get.put(NotificationController());
  final SessionController sessionController = Get.put(SessionController());

  bool _loading = true;
  bool _refreshing = false;
  List<Map<String, dynamic>> _lastItems = [];

  @override
  void initState() {
    super.initState();
    _lastItems = notificationController.notification.toList();
    initializeData();
  }

  /// HomePage preloads the list, but opening this page directly (or pulling to
  /// refresh) needs its own fetch, so both paths stay functional.
  Future<void> initializeData({bool force = false}) async {
    final userId = sessionController.user_id.value;
    final hasItems = notificationController.notification.isNotEmpty;

    if ((force || !hasItems) && userId.isNotEmpty) {
      if (force && mounted) {
        setState(() => _refreshing = true);
      } else if (!hasItems && mounted) {
        setState(() => _loading = true);
      }
      await notificationController.getNotifikasi(userId);
    }

    if (!mounted) return;
    setState(() {
      _lastItems = notificationController.notification.toList();
      _loading = false;
      _refreshing = false;
    });
  }

  Future<void> _refresh() => initializeData(force: true);

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
                title: 'notifications'.tr,
                action: AppIconButton(
                  icon: Icons.refresh_rounded,
                  background: AppColors.primarySoft,
                  foreground: AppColors.primary,
                  tooltip: 'retry'.tr,
                  onTap: () => initializeData(force: true),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  onRefresh: _refresh,
                  child: Obx(() {
                    final items = notificationController.notification.toList();
                    if (_refreshing && items.isEmpty && _lastItems.isNotEmpty) {
                      return _buildList(_lastItems);
                    }
                    if ((_loading || _refreshing) && items.isEmpty) {
                      return _buildSkeletons();
                    }
                    if (items.isEmpty) {
                      return _buildEmpty();
                    }
                    return _buildList(items);
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> items) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _NotificationCard(item: items[index]);
      },
    );
  }

  Widget _buildSkeletons() {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return const AppCard(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(width: 48, height: 48, radius: 15),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(height: 16, radius: 6),
                    SizedBox(height: 10),
                    SkeletonBox(height: 13, radius: 6),
                    SizedBox(height: 6),
                    SkeletonBox(width: 180, height: 13, radius: 6),
                    SizedBox(height: 12),
                    SkeletonBox(width: 100, height: 11, radius: 6),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmpty() {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: EmptyState(
            icon: Icons.notifications_none_rounded,
            title: 'no_notifications'.tr,
            tone: AppTone.primary,
          ),
        ),
      ],
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    final title = '${item['judul'] ?? ''}'.trim();
    final body = '${item['isi'] ?? ''}'.trim();
    final date = _parseDate(item['created_date']);
    final dateLabel = _formatDate(date);
    final visual = _visualFor(title);
    final isRecent = _isRecent(date);

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: visual.tone.background,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  visual.icon,
                  size: 23,
                  color: visual.tone.foreground,
                ),
              ),
              if (isRecent)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 11,
                    height: 11,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.isEmpty ? 'notifications'.tr : title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                      ),
                ),
                if (body.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Text(
                    body,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                        ),
                  ),
                ],
                if (dateLabel.isNotEmpty) ...[
                  const SizedBox(height: 9),
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule_rounded,
                        size: 13,
                        color: AppColors.inkMuted,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          dateLabel,
                          style: Theme.of(context).textTheme.bodySmall,
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
    );
  }
}

({IconData icon, AppTone tone}) _visualFor(String title) {
  final value = title.toLowerCase();
  if (value.contains('imunisasi') || value.contains('vaksin')) {
    return (icon: Icons.vaccines_rounded, tone: AppTone.mint);
  }
  if (value.contains('pertumbuhan') || value.contains('growth')) {
    return (icon: Icons.show_chart_rounded, tone: AppTone.amber);
  }
  return (icon: Icons.notifications_none_rounded, tone: AppTone.primary);
}

DateTime? _parseDate(dynamic value) {
  final raw = '${value ?? ''}'.trim();
  if (raw.isEmpty) return null;
  return DateTime.tryParse(raw) ??
      DateTime.tryParse(raw.replaceFirst(' ', 'T'));
}

String _formatDate(DateTime? date) {
  if (date == null) return '';
  return DateFormat('d MMM y · HH:mm').format(date);
}

/// The API has no per-user read flag, so a notification from the last day is
/// surfaced with a soft dot as the closest available "unread" signal.
bool _isRecent(DateTime? date) {
  if (date == null) return false;
  final difference = DateTime.now().difference(date);
  return !difference.isNegative && difference.inHours < 24;
}
