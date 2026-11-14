import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:growthtracker/theme/app_theme.dart';
import 'package:growthtracker/widgets/app_widgets.dart';

/// Full-screen viewer for the immunization reference document.
///
/// The PDF is shown on a dark surface with a floating page navigator. While the
/// document renders the screen shows a loader; a failed render can be retried
/// without leaving the page.
class VaccinationScheduleByIdaiPage extends StatefulWidget {
  final String? path;

  const VaccinationScheduleByIdaiPage({Key? key, required this.path})
      : super(key: key);

  @override
  State<VaccinationScheduleByIdaiPage> createState() =>
      _VaccinationScheduleByIdaiPageState();
}

class _VaccinationScheduleByIdaiPageState
    extends State<VaccinationScheduleByIdaiPage> {
  static const Color _surface = AppColors.ink;

  Completer<PDFViewController> _controller = Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  int? previousPage = 0;
  bool isReady = false;
  String errorMessage = '';
  double scrollPosition = 0.0;
  double scrollThreshold = 50.0;
  int _reloadToken = 0;

  int get _pageCount => pages ?? 0;
  int get _pageIndex => currentPage ?? 0;

  bool get _hasPreviousPage => _pageIndex > 0;
  bool get _hasNextPage => _pageIndex + 1 < _pageCount;
  bool get _canRestorePreviousPage =>
      previousPage != null &&
      pages != null &&
      previousPage != currentPage &&
      previousPage! >= 0 &&
      previousPage! < _pageCount;

  void _goToPage(int page) {
    if (pages == null || page < 0 || page >= _pageCount) return;
    _controller.future.then((controller) {
      if (!mounted) return;
      controller.setPage(page);
      setState(() => currentPage = page);
    });
  }

  void _handleBack() {
    if (_canRestorePreviousPage) {
      _goToPage(previousPage!);
      return;
    }
    Get.back();
  }

  void _retry() {
    setState(() {
      _controller = Completer<PDFViewController>();
      errorMessage = '';
      isReady = false;
      pages = 0;
      currentPage = 0;
      previousPage = 0;
      scrollPosition = 0;
      _reloadToken++;
    });
  }

  void _showLegend() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'how_to_read_age_column'.tr,
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'age_column_example'.tr,
                style: Theme.of(dialogContext).textTheme.bodyMedium,
              ),
              const SizedBox(height: 18),
              _LegendRow(
                color: AppColors.primary,
                label: 'child_age'.tr,
              ),
              _LegendRow(
                color: const Color(0xFF82B1FF),
                label: 'primary'.tr,
              ),
              _LegendRow(
                color: AppColors.surface,
                label: 'catch_up'.tr,
                outlined: true,
              ),
              _LegendRow(
                color: const Color(0xFFF8BBD0),
                label: 'booster'.tr,
              ),
              _LegendRow(
                color: const Color(0xFFFFB74D),
                label: 'endemic_area'.tr,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('close'.tr),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_canRestorePreviousPage,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_canRestorePreviousPage) {
          _goToPage(previousPage!);
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: _surface,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: _surface,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildTopBar(context),
                Expanded(child: _buildViewer()),
                if (isReady && errorMessage.isEmpty)
                  SafeArea(
                    top: false,
                    child: _buildPageBar(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Row(
        children: [
          AppBackButton(
            background: Colors.white.withValues(alpha: 0.10),
            foreground: Colors.white,
            onTap: _handleBack,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'document'.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  'immunization'.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          AppIconButton(
            icon: Icons.info_outline_rounded,
            background: Colors.white.withValues(alpha: 0.10),
            foreground: Colors.white,
            tooltip: 'how_to_read_age_column'.tr,
            onTap: _showLegend,
          ),
        ],
      ),
    );
  }

  Widget _buildViewer() {
    final path = widget.path;
    if (path == null || path.isEmpty) {
      return _buildError('pdf_download_failed'.tr, canRetry: false);
    }
    if (errorMessage.isNotEmpty) {
      return _buildError(errorMessage);
    }

    return Stack(
      children: [
        Positioned.fill(
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification) {
                scrollPosition += notification.scrollDelta ?? 0;
                if (scrollPosition.abs() > scrollThreshold) {
                  final nextPage = _pageIndex + (scrollPosition > 0 ? 1 : -1);
                  if (nextPage >= 0 && nextPage < _pageCount) {
                    setState(() {
                      previousPage = currentPage;
                      currentPage = nextPage;
                    });
                  }
                  scrollPosition = 0;
                }
              }
              return true;
            },
            child: PDFView(
              key: ValueKey<int>(_reloadToken),
              filePath: path,
              backgroundColor: _surface,
              enableSwipe: false,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: true,
              pageSnap: true,
              defaultPage: _pageIndex,
              fitPolicy: FitPolicy.BOTH,
              preventLinkNavigation: false,
              onRender: (_pages) {
                if (!mounted) return;
                setState(() {
                  pages = _pages;
                  isReady = true;
                });
              },
              onError: (error) {
                if (!mounted) return;
                setState(() => errorMessage = error.toString());
              },
              onPageError: (page, error) {
                if (!mounted) return;
                setState(() => errorMessage = '$page: $error');
              },
              onViewCreated: (pdfViewController) {
                if (!_controller.isCompleted) {
                  _controller.complete(pdfViewController);
                }
              },
              onLinkHandler: (_) {},
              onPageChanged: (page, total) {
                if (!mounted) return;
                setState(() {
                  previousPage = currentPage;
                  currentPage = page;
                });
              },
            ),
          ),
        ),
        if (!isReady)
          Positioned.fill(
            child: ColoredBox(
              color: _surface.withValues(alpha: 0.55),
              child: Center(
                child: Container(
                  width: 64,
                  height: 64,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.6,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildError(String message, {bool canRetry = true}) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.coral.withValues(alpha: 0.16),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.description_outlined,
                color: AppColors.coral,
                size: 38,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'document_load_failed'.tr,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.5,
                color: Colors.white.withValues(alpha: 0.65),
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: 190,
              child: AppButton(
                label: canRetry ? 'retry'.tr : 'back'.tr,
                icon:
                    canRetry ? Icons.refresh_rounded : Icons.arrow_back_rounded,
                onPressed: canRetry ? _retry : Get.back,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppIconButton(
            icon: Icons.chevron_left_rounded,
            background: Colors.white.withValues(alpha: 0.10),
            foreground: _hasPreviousPage
                ? Colors.white
                : Colors.white.withValues(alpha: 0.3),
            onTap: _hasPreviousPage ? () => _goToPage(_pageIndex - 1) : null,
          ),
          const SizedBox(width: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              '${_pageIndex + 1} / $_pageCount',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 18),
          AppIconButton(
            icon: Icons.chevron_right_rounded,
            background: Colors.white.withValues(alpha: 0.10),
            foreground: _hasNextPage
                ? Colors.white
                : Colors.white.withValues(alpha: 0.3),
            onTap: _hasNextPage ? () => _goToPage(_pageIndex + 1) : null,
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.color,
    required this.label,
    this.outlined = false,
  });

  final Color color;
  final String label;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
              border: outlined ? Border.all(color: AppColors.lineStrong) : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ],
      ),
    );
  }
}
