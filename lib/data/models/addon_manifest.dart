import 'package:json_annotation/json_annotation.dart';
import 'package:eyadflix/core/utils/enums.dart';

part 'addon_manifest.g.dart';

@JsonSerializable()
class AddonManifest {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'version')
  final String version;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'logo')
  final String? logo;

  @JsonKey(name: 'author')
  final String? author;

  @JsonKey(name: 'resources')
  final List<Map<String, dynamic>> resources;

  @JsonKey(name: 'types')
  final List<String> types;

  @JsonKey(name: 'idPrefixes')
  final List<String>? idPrefixes;

  @JsonKey(name: 'catalogs')
  final List<CatalogResource>? catalogs;

  AddonManifest({
    required this.id,
    required this.version,
    required this.name,
    this.description,
    this.logo,
    this.author,
    required this.resources,
    required this.types,
    this.idPrefixes,
    this.catalogs,
  });

  factory AddonManifest.fromJson(Map<String, dynamic> json) =>
      _$AddonManifestFromJson(json);

  Map<String, dynamic> toJson() => _$AddonManifestToJson(this);

  List<ContentType> get contentTypes =>
      types.map((t) => ContentType.fromString(t)).toList();
}

@JsonSerializable()
class CatalogResource {
  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'extra')
  final List<Map<String, dynamic>>? extra;

  CatalogResource({
    required this.type,
    required this.id,
    this.name,
    this.extra,
  });

  factory CatalogResource.fromJson(Map<String, dynamic> json) =>
      _$CatalogResourceFromJson(json);

  Map<String, dynamic> toJson() => _$CatalogResourceToJson(this);
}
