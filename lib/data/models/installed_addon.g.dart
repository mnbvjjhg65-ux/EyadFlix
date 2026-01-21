// GENERATED FILE - DO NOT EDIT MANUALLY

part of 'installed_addon.dart';

class InstalledAddonAdapter extends TypeAdapter<InstalledAddon> {
  @override
  final int typeId = 0;

  @override
  InstalledAddon read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InstalledAddon(
      id: fields[0] as String,
      manifestUrl: fields[1] as String,
      name: fields[2] as String,
      logo: fields[3] as String?,
      installedAt: fields[4] as DateTime,
      isEnabled: fields[5] as bool? ?? true,
      version: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, InstalledAddon obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.manifestUrl)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.logo)
      ..writeByte(4)
      ..write(obj.installedAt)
      ..writeByte(5)
      ..write(obj.isEnabled)
      ..writeByte(6)
      ..write(obj.version);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InstalledAddonAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
