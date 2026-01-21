import 'package:hive/hive.dart';

part 'installed_addon.g.dart';

@HiveType(typeId: 0)
class InstalledAddon extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String manifestUrl;

  @HiveField(2)
  String name;

  @HiveField(3)
  String? logo;

  @HiveField(4)
  DateTime installedAt;

  @HiveField(5)
  bool isEnabled;

  @HiveField(6)
  String version;

  InstalledAddon({
    required this.id,
    required this.manifestUrl,
    required this.name,
    this.logo,
    required this.installedAt,
    this.isEnabled = true,
    required this.version,
  });
}
