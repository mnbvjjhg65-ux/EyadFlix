import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eyadflix/presentation/providers/app_providers.dart';
import 'package:eyadflix/presentation/providers/library_providers.dart';
import 'package:eyadflix/data/models/meta_model.dart';
import 'package:eyadflix/core/utils/enums.dart';

class MediaDetailPage extends ConsumerStatefulWidget {
  final MetaModel media;
  final String addonUrl;
  final String addonId;

  const MediaDetailPage({
    Key? key,
    required this.media,
    required this.addonUrl,
    required this.addonId,
  }) : super(key: key);

  @override
  ConsumerState<MediaDetailPage> createState() => _MediaDetailPageState();
}

class _MediaDetailPageState extends ConsumerState<MediaDetailPage> {
  bool _isLoadingStreams = false;

  @override
  Widget build(BuildContext context) {
    final isFavorite = ref.watch(favoritesProvider).contains(widget.media.id);
    final addonService = ref.watch(addonServiceProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildMediaHeader(isFavorite),
                const SizedBox(height: 24),
                _buildRatingRow(),
                const SizedBox(height: 24),
                if (widget.media.description != null) ...[
                  Text(
                    'mediaDetail.synopsis'.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.media.description!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                ],
                if (widget.media.genre != null && widget.media.genre!.isNotEmpty) ...[
                  Text(
                    'mediaDetail.genre'.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: widget.media.genre!
                        .map((genre) => Chip(label: Text(genre)))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                ],
                if (widget.media.cast != null && widget.media.cast!.isNotEmpty) ...[
                  Text(
                    'mediaDetail.cast'.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  _buildCastList(),
                  const SizedBox(height: 24),
                ],
                if (widget.media.director != null && widget.media.director!.isNotEmpty) ...[
                  Text(
                    'mediaDetail.director'.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.media.director!.join(', '),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                ],
                if (widget.media.type == 'series' &&
                    widget.media.videos != null &&
                    widget.media.videos!.isNotEmpty) ...[
                  Text(
                    'mediaDetail.episodes'.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  _buildEpisodesList(),
                  const SizedBox(height: 24),
                ],
                _buildPlayButton(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: _buildBackgroundImage(),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (widget.media.background != null)
          CachedNetworkImage(
            imageUrl: widget.media.background!,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
            errorWidget: (context, url, error) => Container(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: const Icon(Icons.image_not_supported),
            ),
          )
        else
          Container(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            child: Center(
              child: Icon(
                Icons.movie,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Theme.of(context).scaffoldBackgroundColor,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMediaHeader(bool isFavorite) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.media.poster != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: widget.media.poster!,
                  width: 120,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.media.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (widget.media.releaseInfo != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      widget.media.releaseInfo!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  if (widget.media.runtime != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      widget.media.runtime!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _playMedia(),
                icon: const Icon(Icons.play_arrow),
                label: Text('mediaDetail.play'.tr()),
              ),
            ),
            const SizedBox(width: 12),
            IconButton.filled(
              onPressed: () {
                ref.read(favoritesProvider.notifier).toggleFavorite(widget.media.id);
              },
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingRow() {
    return Row(
      children: [
        if (widget.media.imdbRating != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'mediaDetail.rating'.tr(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    widget.media.imdbRating!,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildCastList() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.media.cast!.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(right: 8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Center(
                child: Text(widget.media.cast![index]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEpisodesList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.media.videos!.length,
      itemBuilder: (context, index) {
        final video = widget.media.videos![index];
        return ListTile(
          leading: video.thumbnail != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(
                    imageUrl: video.thumbnail!,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                )
              : const Icon(Icons.videocam),
          title: Text(video.title),
          subtitle: video.season != null && video.episode != null
              ? Text('S${video.season}:E${video.episode}')
              : null,
          onTap: () => _playVideo(video.id),
        );
      },
    );
  }

  Widget _buildPlayButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isLoadingStreams ? null : () => _playMedia(),
        icon: _isLoadingStreams
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.play_circle_fill),
        label: Text(
          _isLoadingStreams
              ? 'loading'.tr()
              : 'mediaDetail.play'.tr(),
        ),
      ),
    );
  }

  Future<void> _playMedia() async {
    setState(() => _isLoadingStreams = true);
    try {
      final addonService = ref.read(addonServiceProvider);
      
      final streams = await addonService.fetchStreams(
        addonUrl: widget.addonUrl,
        type: widget.media.type,
        mediaId: widget.media.id,
      );

      if (mounted && streams.isNotEmpty) {
        // عرض نافذة اختيار الجودة
        _showStreamSelectionDialog(streams);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('player.errors.streamUnavailable'.tr())),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('player.errors.loadingFailed'.tr())),
        );
      }
    } finally {
      setState(() => _isLoadingStreams = false);
    }
  }

  Future<void> _playVideo(String videoId) async {
    setState(() => _isLoadingStreams = true);
    try {
      final addonService = ref.read(addonServiceProvider);
      
      final streams = await addonService.fetchStreams(
        addonUrl: widget.addonUrl,
        type: widget.media.type,
        mediaId: widget.media.id,
        videoId: videoId,
      );

      if (mounted && streams.isNotEmpty) {
        _showStreamSelectionDialog(streams);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('player.errors.loadingFailed'.tr())),
        );
      }
    } finally {
      setState(() => _isLoadingStreams = false);
    }
  }

  void _showStreamSelectionDialog(dynamic streams) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('mediaDetail.selectStream'.tr()),
        content: ListView.builder(
          shrinkWrap: true,
          itemCount: streams.length,
          itemBuilder: (context, index) {
            final stream = streams[index];
            return ListTile(
              title: Text(stream.name ?? 'Stream ${index + 1}'),
              subtitle: stream.externalUrl != null
                  ? Text(stream.externalUrl!)
                  : null,
              onTap: () {
                Navigator.pop(context);
                // الانتقال إلى صفحة مشغل الفيديو
                // Navigator.push(...);
              },
            );
          },
        ),
      ),
    );
  }
}
