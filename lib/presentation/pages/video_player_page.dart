import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eyadflix/data/models/subtitle_model.dart';
import 'package:eyadflix/core/errors/exceptions.dart';

class VideoPlayerPage extends StatefulWidget {
  final String streamUrl;
  final String mediaTitle;
  final List<SubtitleModel>? subtitles;
  final String? mediaId;
  final String? videoId;

  const VideoPlayerPage({
    Key? key,
    required this.streamUrl,
    required this.mediaTitle,
    this.subtitles,
    this.mediaId,
    this.videoId,
  }) : super(key: key);

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late BetterPlayerController _betterPlayerController;
  SubtitleModel? _selectedSubtitle;
  bool _showSubtitleMenu = false;
  int _playbackSpeed = 100; // 1.0x
  bool _autoSkipIntro = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    try {
      final betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.streamUrl,
        subtitles: _buildSubtitles(),
        notificationConfiguration: const BetterPlayerNotificationConfiguration(
          showNotification: true,
          title: 'Playing video',
          author: 'EyadFlix',
          imageUrl: '',
        ),
      );

      _betterPlayerController = BetterPlayerController(
        const BetterPlayerConfiguration(
          aspectRatio: 16 / 9,
          fit: BoxFit.contain,
          autoPlay: true,
          looping: false,
          fullScreenByDefault: false,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            enableSkips: true,
            enableSubtitles: true,
            enablePlaybackSpeed: true,
            customControlsBuilder: null, // Use default controls
          ),
        ),
        betterPlayerDataSource: betterPlayerDataSource,
      );

      _betterPlayerController.addEventsListener(_handlePlayerEvents);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('player.errors.loadingFailed'.tr())),
      );
    }
  }

  void _handlePlayerEvents(BetterPlayerEvent event) {
    if (event.eventType == BetterPlayerEventType.progress) {
      // Handle progress for watch history
    }
  }

  List<BetterPlayerSubtitlesSource> _buildSubtitles() {
    final subtitles = <BetterPlayerSubtitlesSource>[];
    if (widget.subtitles != null && widget.subtitles!.isNotEmpty) {
      for (var subtitle in widget.subtitles!) {
        subtitles.add(
          BetterPlayerSubtitlesSource(
            type: BetterPlayerSubtitlesSourceType.network,
            url: subtitle.url,
            name: subtitle.lang,
            selectedByDefault: false,
          ),
        );
      }
    }
    return subtitles;
  }

  void _togglePlaybackSpeed() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'player.playbackSpeed'.tr(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                _buildSpeedButton(50, '0.5x'),
                _buildSpeedButton(75, '0.75x'),
                _buildSpeedButton(100, '1.0x'),
                _buildSpeedButton(125, '1.25x'),
                _buildSpeedButton(150, '1.5x'),
                _buildSpeedButton(200, '2.0x'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeedButton(int speed, String label) {
    return ElevatedButton(
      onPressed: () {
        _betterPlayerController.setPlaybackSpeed(speed / 100);
        setState(() => _playbackSpeed = speed);
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _playbackSpeed == speed
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surface,
      ),
      child: Text(label),
    );
  }

  void _toggleAutoSkipIntro() {
    setState(() => _autoSkipIntro = !_autoSkipIntro);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _autoSkipIntro ? 'Intro skip enabled' : 'Intro skip disabled',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mediaTitle),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Video Player
            Container(
              color: Colors.black,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: BetterPlayer(controller: _betterPlayerController),
              ),
            ),
            // Player Controls
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.mediaTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Subtitles Button
                      if (widget.subtitles != null && widget.subtitles!.isNotEmpty)
                        _buildControlButton(
                          icon: Icons.subtitles,
                          label: 'player.selectSubtitle'.tr(),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'player.selectSubtitle'.tr(),
                                      style:
                                          Theme.of(context).textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 16),
                                    ListTile(
                                      title: const Text('None'),
                                      onTap: () {
                                        _betterPlayerController
                                            .setSubtitles([]);
                                        setState(() => _selectedSubtitle = null);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ...widget.subtitles!.map(
                                      (subtitle) => ListTile(
                                        title: Text(subtitle.lang),
                                        trailing: _selectedSubtitle?.lang ==
                                                subtitle.lang
                                            ? const Icon(Icons.check)
                                            : null,
                                        onTap: () {
                                          setState(() =>
                                              _selectedSubtitle = subtitle);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      // Playback Speed Button
                      _buildControlButton(
                        icon: Icons.speed,
                        label: '${(_playbackSpeed / 100).toStringAsFixed(2)}x',
                        onPressed: _togglePlaybackSpeed,
                      ),
                      // Auto Skip Intro Button
                      _buildControlButton(
                        icon: Icons.skip_next,
                        label: 'player.skipIntro'.tr(),
                        onPressed: _toggleAutoSkipIntro,
                        isActive: _autoSkipIntro,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isActive = false,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? Theme.of(context).colorScheme.primary : null,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
