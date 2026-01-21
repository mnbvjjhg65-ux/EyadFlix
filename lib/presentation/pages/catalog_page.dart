import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eyadflix/presentation/providers/app_providers.dart';
import 'package:eyadflix/presentation/pages/media_detail_page.dart';
import 'package:eyadflix/data/models/meta_model.dart';
import 'package:eyadflix/data/models/addon_manifest.dart';
import 'package:eyadflix/core/constants/app_constants.dart';

class CatalogPage extends ConsumerStatefulWidget {
  final InstalledAddon addon;
  final CatalogResource catalog;

  const CatalogPage({
    Key? key,
    required this.addon,
    required this.catalog,
  }) : super(key: key);

  @override
  ConsumerState<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends ConsumerState<CatalogPage> {
  late final _scrollController = ScrollController();
  List<MetaModel> _medias = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadMoreMedias();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_hasMore && !_isLoading) {
        _loadMoreMedias();
      }
    }
  }

  Future<void> _loadMoreMedias() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final addonService = ref.read(addonServiceProvider);
      final baseUrl = widget.addon.manifestUrl;

      final newMedias = await addonService.fetchCatalog(
        addonUrl: baseUrl,
        type: widget.catalog.type,
        catalogId: widget.catalog.id,
        extra: {
          'skip': (_page - 1) * 20,
          'search': _searchQuery.isNotEmpty ? _searchQuery : null,
        },
      );

      setState(() {
        if (_page == 1) {
          _medias = newMedias;
        } else {
          _medias.addAll(newMedias);
        }
        _hasMore = newMedias.length >= 20;
        _page++;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading catalog: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _onSearch(String query) async {
    setState(() {
      _searchQuery = query;
      _page = 1;
      _medias = [];
      _isLoading = true;
    });
    await _loadMoreMedias();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.catalog.name ?? 'Catalog'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'search'.tr(),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: _onSearch,
            ),
          ),
          // Media Grid
          Expanded(
            child: _medias.isEmpty && !_isLoading
                ? Center(
                    child: Text('homeScreen.noResults'.tr()),
                  )
                : GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: AppConstants.posterAspectRatio,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    itemCount: _medias.length + (_isLoading && _medias.isNotEmpty ? 2 : 0),
                    itemBuilder: (context, index) {
                      if (index >= _medias.length) {
                        return const _SkeletonPosterCard();
                      }

                      final media = _medias[index];
                      return _MediaCard(
                        media: media,
                        addonUrl: widget.addon.manifestUrl,
                        addonId: widget.addon.id,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MediaDetailPage(
                                media: media,
                                addonUrl: widget.addon.manifestUrl,
                                addonId: widget.addon.id,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _MediaCard extends StatelessWidget {
  final MetaModel media;
  final String addonUrl;
  final String addonId;
  final VoidCallback onTap;

  const _MediaCard({
    required this.media,
    required this.addonUrl,
    required this.addonId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.posterBorderRadius),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Poster Image
            if (media.poster != null)
              CachedNetworkImage(
                imageUrl: media.poster!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  child: const Center(
                    child: Icon(Icons.image_not_supported),
                  ),
                ),
              )
            else
              Container(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: const Center(
                  child: Icon(Icons.movie, size: 48),
                ),
              ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            // Title and Rating
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      media.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (media.imdbRating != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 12,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              media.imdbRating!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Play Button Overlay on Hover
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.play_circle_filled,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonPosterCard extends StatelessWidget {
  const _SkeletonPosterCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.posterBorderRadius),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppConstants.posterBorderRadius),
        ),
        child: Center(
          child: SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
