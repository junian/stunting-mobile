import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:growthtracker/controller/ArticleController.dart';
import 'package:growthtracker/models/MGetArticle.dart';
import 'package:growthtracker/models/MGetArticleCategory.dart';
import 'package:growthtracker/pages/ArticleDetailPage.dart';
import 'package:growthtracker/theme/app_theme.dart';
import 'package:growthtracker/widgets/app_widgets.dart';

/// Sentinel used for the "all categories" chip. It matches the value used by
/// the existing data model, while the visible label comes from `all.tr`.
const String _allCategories = 'Semua';

const String _articleImageHost = 'https://mystantapp.siuinsa.com';

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  String selectedCategory = _allCategories;
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ArticleController artikelController = Get.put(ArticleController());

  List<MGetArticle> filteredList = [];
  List<MGetArticleCategory> categories = [];

  List<MGetArticle> _allArticles = [];
  bool _loading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    // Revisits can render the cached list immediately while a fresh copy is
    // fetched in the background.
    _hydrateFromController();
    initializeData(showSkeleton: false);

    // Work around a platform compositing quirk: the first frame after an
    // opaque route transition can leave a stale strip at the bottom of the
    // screen. A sub-pixel scroll forces the viewport to repaint it.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future<void>.delayed(const Duration(milliseconds: 350), () {
        if (!mounted || !_scrollController.hasClients) return;
        final position = _scrollController.position;
        if (position.pixels <= position.minScrollExtent) {
          _scrollController.jumpTo(position.minScrollExtent + 0.5);
        }
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _hydrateFromController() {
    categories = artikelController.kategori.toList();
    final cachedArticles = artikelController.artikel.toList();
    if (cachedArticles.isEmpty) return;
    _allArticles = cachedArticles;
    filteredList = cachedArticles;
    _loading = false;
  }

  /// Loads articles and categories concurrently. The old implementation only
  /// fetched the categories, so the list stayed empty forever.
  Future<void> initializeData({bool showSkeleton = true}) async {
    if (showSkeleton && mounted) {
      setState(() {
        _loading = true;
        _hasError = false;
      });
    }

    await Future.wait([
      artikelController.getArtikel(),
      artikelController.getArtikelKategori(),
    ]);

    if (!mounted) return;

    final loadedArticles = artikelController.artikel.toList();
    final loadedCategories = artikelController.kategori.toList();
    final failed = loadedArticles.isEmpty && loadedCategories.isEmpty;
    final hadCachedArticles = _allArticles.isNotEmpty;

    setState(() {
      _loading = false;
      if (failed) {
        _hasError = !hadCachedArticles;
      } else {
        _allArticles = loadedArticles;
        categories = loadedCategories;
        _hasError = false;
        _resetCategoryIfMissing();
        filteredList = _filterArticles();
      }
    });

    if (failed && hadCachedArticles) {
      // Keep the content that is already on screen; a failed refresh should
      // not strand the reader on an error page.
      AppSnack.error('failed'.tr);
    }
  }

  Future<void> _refresh() => initializeData(showSkeleton: false);

  List<String> get _categoryNames {
    final names = <String>[];

    void add(String? raw) {
      final name = (raw ?? '').trim();
      if (name.isEmpty) return;
      final exists = names.any(
        (item) => item.toLowerCase() == name.toLowerCase(),
      );
      if (!exists) names.add(name);
    }

    for (final category in categories) {
      add(category.namaKategori);
    }
    for (final article in _allArticles) {
      add(article.namaKategori);
    }
    return names;
  }

  void _resetCategoryIfMissing() {
    if (selectedCategory == _allCategories) return;
    final exists = _categoryNames.any(
      (name) => name.toLowerCase() == selectedCategory.toLowerCase(),
    );
    if (!exists) selectedCategory = _allCategories;
  }

  List<MGetArticle> _filterArticles() {
    final keyword = searchController.text.trim().toLowerCase();
    final category = selectedCategory.trim().toLowerCase();

    return _allArticles.where((article) {
      final categoryMatches = selectedCategory == _allCategories ||
          article.namaKategori.trim().toLowerCase() == category;
      final keywordMatches =
          keyword.isEmpty || article.judul.toLowerCase().contains(keyword);
      return categoryMatches && keywordMatches;
    }).toList();
  }

  void _applyFilter() {
    setState(() => filteredList = _filterArticles());
  }

  void _selectCategory(String category) {
    if (selectedCategory == category) return;
    selectedCategory = category;
    _applyFilter();
  }

  void _clearFilters() {
    searchController.clear();
    selectedCategory = _allCategories;
    setState(() => filteredList = _allArticles);
  }

  void _openArticle(MGetArticle article) {
    Get.to(
      ArticleDetailPage(
        category: article.namaKategori,
        title: article.judul,
        author: article.fullname,
        date: _formatDate(article.createdDate),
        description: article.konten,
        imageUrl: _thumbnailUrl(article.thumbnail) ?? '',
      ),
    );
  }

  String _formatDate(String raw) {
    final date = DateTime.tryParse(raw.trim());
    if (date == null) return raw;
    return DateFormat('d MMM y').format(date);
  }

  String? _thumbnailUrl(String? raw) {
    final value = (raw ?? '').trim();
    if (value.isEmpty || value.toLowerCase() == 'null') return null;
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }
    return '$_articleImageHost${value.startsWith('/') ? '' : '/'}$value';
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: ColoredBox(
        color: AppColors.background,
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.background,
              body: SafeArea(
                top: false,
                left: false,
                right: false,
                child: Column(
                  children: [
                    _buildHeader(context),
                    _buildCategoryBar(),
                    Expanded(
                      child: RefreshIndicator(
                        color: AppColors.primary,
                        backgroundColor: AppColors.surface,
                        onRefresh: _refresh,
                        child: _buildContent(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Soft fade at the bottom of the feed. It also keeps the shell's
            // floating bar from showing through while the feed is on top.
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 78 + MediaQuery.paddingOf(context).bottom,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.background.withValues(alpha: 0),
                        AppColors.background,
                        AppColors.background,
                      ],
                      stops: const [0, 0.45, 1],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return AppHeader(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppBackButton(
                background: Colors.white.withValues(alpha: 0.16),
                foreground: Colors.white,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.auto_stories_rounded,
                      size: 15,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'app_name'.tr,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'articles'.tr,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'recommended_articles'.tr,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 18),
          _buildSearchField(),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: searchController,
      onChanged: (_) => _applyFilter(),
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      cursorColor: AppColors.primary,
      style: const TextStyle(
        fontSize: 14.5,
        fontWeight: FontWeight.w500,
        color: AppColors.ink,
      ),
      decoration: InputDecoration(
        hintText: 'search_articles'.tr,
        filled: true,
        fillColor: AppColors.surface,
        prefixIcon: const Icon(
          Icons.search_rounded,
          size: 20,
          color: AppColors.inkMuted,
        ),
        suffixIcon: searchController.text.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  searchController.clear();
                  _applyFilter();
                },
                tooltip: 'close'.tr,
                icon: const Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: AppColors.inkMuted,
                ),
              ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
        ),
      ),
    );
  }

  Widget _buildCategoryBar() {
    final names = _categoryNames;
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 2),
      child: SizedBox(
        height: 42,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: names.length + 1,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            if (index == 0) {
              return _CategoryChip(
                label: 'all'.tr,
                icon: Icons.grid_view_rounded,
                selected: selectedCategory == _allCategories,
                onTap: () => _selectCategory(_allCategories),
              );
            }
            final name = names[index - 1];
            return _CategoryChip(
              label: name,
              selected: selectedCategory.toLowerCase() == name.toLowerCase(),
              onTap: () => _selectCategory(name),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_loading && _allArticles.isEmpty) {
      return _buildSkeletonList();
    }

    if (_hasError) {
      return _buildState(
        icon: Icons.cloud_off_rounded,
        title: 'failed'.tr,
        message: 'no_articles'.tr,
        actionLabel: 'retry'.tr,
        actionIcon: Icons.refresh_rounded,
        tone: AppTone.coral,
        onAction: () => initializeData(),
      );
    }

    if (filteredList.isEmpty) {
      final hasArticles = _allArticles.isNotEmpty;
      return _buildState(
        icon: hasArticles
            ? Icons.search_off_rounded
            : Icons.auto_stories_outlined,
        title: 'no_articles'.tr,
        message: hasArticles ? 'search_articles'.tr : null,
        actionLabel: hasArticles ? 'all'.tr : 'retry'.tr,
        actionIcon:
            hasArticles ? Icons.grid_view_rounded : Icons.refresh_rounded,
        tone: hasArticles ? AppTone.primary : AppTone.neutral,
        onAction: hasArticles ? _clearFilters : () => initializeData(),
      );
    }

    return ListView.separated(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
      itemCount: filteredList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final article = filteredList[index];
        return _ArticleCard(
          article: article,
          dateLabel: _formatDate(article.createdDate),
          imageUrl: _thumbnailUrl(article.thumbnail),
          onTap: () => _openArticle(article),
        );
      },
    );
  }

  Widget _buildSkeletonList() {
    return ListView.separated(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        return const AppCard(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(height: 154, radius: AppRadius.md),
              SizedBox(height: 14),
              SkeletonBox(width: 90, height: 20, radius: 10),
              SizedBox(height: 10),
              SkeletonBox(height: 18, radius: 6),
              SizedBox(height: 8),
              SkeletonBox(width: 220, height: 18, radius: 6),
              SizedBox(height: 14),
              SkeletonBox(width: 100, height: 12, radius: 6),
            ],
          ),
        );
      },
    );
  }

  Widget _buildState({
    required IconData icon,
    required String title,
    String? message,
    String? actionLabel,
    IconData actionIcon = Icons.refresh_rounded,
    AppTone tone = AppTone.primary,
    VoidCallback? onAction,
  }) {
    return CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
              child: _ArticleStatePanel(
                icon: icon,
                title: title,
                message: message,
                actionLabel: actionLabel,
                actionIcon: actionIcon,
                tone: tone,
                onAction: onAction,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({
    required this.article,
    required this.dateLabel,
    required this.onTap,
    this.imageUrl,
  });

  final MGetArticle article;
  final String dateLabel;
  final String? imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final excerpt = _plainText(article.konten);
    final category = article.namaKategori.trim();

    return AppCard(
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: _ArticleThumbnail(url: imageUrl),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 14, 6, 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (category.isNotEmpty)
                      Flexible(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: StatusPill(
                            label: category,
                            tone: AppTone.primary,
                            dense: true,
                          ),
                        ),
                      ),
                    if (category.isNotEmpty && dateLabel.isNotEmpty)
                      const SizedBox(width: 10),
                    if (dateLabel.isNotEmpty)
                      Text(
                        dateLabel,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  article.judul,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 17,
                        height: 1.3,
                      ),
                ),
                if (excerpt.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    excerpt,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          height: 1.5,
                          color: AppColors.inkSoft,
                        ),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'read_more'.tr,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 15,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticleThumbnail extends StatelessWidget {
  const _ArticleThumbnail({this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final source = url;
    if (source == null || source.isEmpty) {
      return const _ThumbnailFallback();
    }

    return Image.network(
      source,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        final total = progress.expectedTotalBytes;
        final value =
            total == null ? null : progress.cumulativeBytesLoaded / total;
        return Container(
          color: AppColors.surfaceAlt,
          alignment: Alignment.center,
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              value: value,
              color: AppColors.primary,
            ),
          ),
        );
      },
      errorBuilder: (_, __, ___) => const _ThumbnailFallback(),
    );
  }
}

class _ThumbnailFallback extends StatelessWidget {
  const _ThumbnailFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primarySoft, AppColors.mintSoft],
        ),
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.auto_stories_rounded,
        size: 34,
        color: AppColors.primary,
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return AnimatedPressable(
      onTap: onTap,
      haptic: false,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          gradient: selected ? AppColors.brandGradient : null,
          color: selected ? null : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: selected ? Colors.transparent : AppColors.line,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.22),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 15,
                color: selected ? Colors.white : AppColors.inkMuted,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : AppColors.inkSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticleStatePanel extends StatelessWidget {
  const _ArticleStatePanel({
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.actionIcon = Icons.refresh_rounded,
    this.tone = AppTone.primary,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final IconData actionIcon;
  final AppTone tone;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 86,
          height: 86,
          decoration: BoxDecoration(
            color: tone.background,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 38, color: tone.foreground),
        ),
        const SizedBox(height: 20),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        if (message != null) ...[
          const SizedBox(height: 8),
          Text(
            message!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
        if (actionLabel != null) ...[
          const SizedBox(height: 22),
          SizedBox(
            width: 190,
            child: AppButton(
              label: actionLabel!,
              icon: actionIcon,
              onPressed: onAction,
            ),
          ),
        ],
      ],
    );
  }
}

String _plainText(String html) {
  return html
      .replaceAll(RegExp(r'<[^>]*>'), ' ')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}
