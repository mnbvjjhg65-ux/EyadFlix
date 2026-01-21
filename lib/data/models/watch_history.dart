import 'package:hive/hive.dart';

part 'watch_history.g.dart';

@HiveType(typeId: 1)
class WatchHistoryItem extends HiveObject {
  @HiveField(0)
  String mediaId;

  @HiveField(1)
  String addonId;

  @HiveField(2)
  String mediaName;

  @HiveField(3)
  String? poster;

  @HiveField(4)
  DateTime lastWatchedAt;

  @HiveField(5)
  int watchDurationSeconds;

  @HiveField(6)
  int totalDurationSeconds;

  @HiveField(7)
  String? seasonId;

  @HiveField(8)
  String? episodeId;

  WatchHistoryItem({
    required this.mediaId,
    required this.addonId,
    required this.mediaName,
    this.poster,
    required this.lastWatchedAt,
    required this.watchDurationSeconds,
    required this.totalDurationSeconds,
    this.seasonId,
    this.episodeId,
  });

  double get watchProgress => totalDurationSeconds > 0
      ? (watchDurationSeconds / totalDurationSeconds * 100)
      : 0.0;

  bool get isCompleted => watchProgress >= 90;
}
