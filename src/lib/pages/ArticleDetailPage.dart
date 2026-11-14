import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// The `html` package ships transitively with Flutter's ecosystem packages.
// ignore: depend_on_referenced_packages
import 'package:html/parser.dart' as html;

import 'package:growthtracker/theme/app_theme.dart';
import 'package:growthtracker/widgets/app_widgets.dart';

const String _articleImageHost = 'https://mystantapp.siuinsa.com';

class ArticleDetailPage extends StatefulWidget {
  final String category;
  final String title;
  final String author;
  final String date;
  final String description;
  final String imageUrl;

  const ArticleDetailPage({
    super.key,
    required this.category,
    required this.title,
    required this.author,
    required this.date,
    required this.description,
    required this.imageUrl,
  });

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  late final String cleanedDescription;

  final ScrollController _scrollController = ScrollController();
  bool _lightStatusBar = true;

  String cleanHtml(String htmlString) {
    if (htmlString.trim().isEmpty) return '';
    try {
      // Preserve paragraph boundaries before flattening the markup so long
      // articles keep a comfortable rhythm.
      final normalized = htmlString
          .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
          .replaceAll(
            RegExp(
              r'</(p|div|li|h[1-6]|blockquote|tr)>',
              caseSensitive: false,
            ),
            '\n\n',
          );
      final document = html.parse(normalized);
      final text = document.body?.text ?? '';
      return text
          .replaceAll(RegExp(r'[ \t]+'), ' ')
          .replaceAll(RegExp(r'\n[ \t]+'), '\n')
          .replaceAll(RegExp(r'\n{3,}'), '\n\n')
          .trim();
    } catch (_) {
      return htmlString.replaceAll(RegExp(r'<[^>]*>'), ' ').trim();
    }
  }

  @override
  void initState() {
    super.initState();
    cleanedDescription = cleanHtml(widget.description);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  /// The hero image sits under the status bar; once the light content card
  /// scrolls up, the system icons need to flip to dark for contrast.
  void _onScroll() {
    final light = _scrollController.offset < 250;
    if (light != _lightStatusBar) {
      setState(() => _lightStatusBar = light);
    }
  }

  String? _resolvedImageUrl() {
    final value = widget.imageUrl.trim();
    if (value.isEmpty || value.toLowerCase() == 'null') return null;
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }
    return '$_articleImageHost${value.startsWith('/') ? '' : '/'}$value';
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _resolvedImageUrl();
    final overlay = _lightStatusBar
        ? SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: AppColors.background,
            systemNavigationBarIconBrightness: Brightness.dark,
          )
        : SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: AppColors.background,
            systemNavigationBarIconBrightness: Brightness.dark,
          );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          top: false,
          left: false,
          right: false,
          child: ListView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              _buildHero(imageUrl),
              Transform.translate(
                offset: const Offset(0, -30),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildContent(context),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHero(String? imageUrl) {
    return SizedBox(
      height: 310,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (imageUrl == null)
            const _HeroFallback()
          else
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const _HeroFallback(loading: true);
              },
              errorBuilder: (_, __, ___) => const _HeroFallback(),
            ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x66000000),
                  Color(0x00000000),
                  Color(0xCC000000),
                ],
                stops: [0, 0.45, 1],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Row(
                  children: [
                    AppBackButton(
                      background: Colors.white.withValues(alpha: 0.18),
                      foreground: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final category = widget.category.trim();
    final author = widget.author.trim();
    final date = widget.date.trim();

    return AppCard(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (category.isNotEmpty) ...[
            StatusPill(
              label: category,
              tone: AppTone.primary,
              dense: true,
            ),
            const SizedBox(height: 14),
          ],
          Text(
            widget.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.24,
                ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              AppAvatar(
                name: author.isEmpty ? null : author,
                size: 40,
                icon: Icons.person_rounded,
                gradient: AppColors.mintGradient,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author.isEmpty
                          ? 'articles'.tr
                          : 'author_by'.trParams({'author': author}),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    if (date.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        date,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(height: 1),
          ),
          if (cleanedDescription.isEmpty)
            Text(
              'no_articles'.tr,
              style: Theme.of(context).textTheme.bodyMedium,
            )
          else
            Text(
              cleanedDescription,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 15.5,
                    height: 1.8,
                    color: AppColors.inkSoft,
                  ),
            ),
        ],
      ),
    );
  }
}

class _HeroFallback extends StatelessWidget {
  const _HeroFallback({this.loading = false});

  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.brandGradient),
      alignment: Alignment.center,
      child: loading
          ? const SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Container(
              width: 112,
              height: 112,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.96),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Image.asset(
                'images/logo.png',
                fit: BoxFit.contain,
              ),
            ),
    );
  }
}
