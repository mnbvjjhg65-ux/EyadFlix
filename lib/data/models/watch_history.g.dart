// GENERATED FILE - DO NOT EDIT MANUALLY

part of 'watch_history.dart';

class WatchHistoryItemAdapter extends TypeAdapter<WatchHistoryItem> {
  @override
  final int typeId = 1;

  @override
  WatchHistoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WatchHistoryItem(
      mediaId: fields[0] as String,
      addonId: fields[1] as String,
      mediaName: fields[2] as String,
      poster: fields[3] as String?,
      lastWatchedAt: fields[4] as DateTime,
      watchDurationSeconds: fields[5] as int,
      totalDurationSeconds: fields[6] as int,
      seasonId: fields[7] as String?,
      episodeId: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WatchHistoryItem obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.mediaId)
      ..writeByte(1)
      ..write(obj.addonId)
      ..writeByte(2)
      ..write(obj.mediaName)
      ..writeByte(3)
      ..write(obj.poster)
      ..writeByte(4)
      ..write(obj.lastWatchedAt)
      ..writeByte(5)
      ..write(obj.watchDurationSeconds)
      ..writeByte(6)
      ..write(obj.totalDurationSeconds)
      ..writeByte(7)
      ..write(obj.seasonId)
      ..writeByte(8)
      ..write(obj.episodeId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchHistoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
