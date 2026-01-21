import 'package:json_annotation/json_annotation.dart';

part 'meta_model.g.dart';

@JsonSerializable()
class MetaModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'poster')
  final String? poster;

  @JsonKey(name: 'background')
  final String? background;

  @JsonKey(name: 'logo')
  final String? logo;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'releaseInfo')
  final String? releaseInfo;

  @JsonKey(name: 'genre')
  final List<String>? genre;

  @JsonKey(name: 'imdbRating')
  final String? imdbRating;

  @JsonKey(name: 'runtime')
  final String? runtime;

  @JsonKey(name: 'cast')
  final List<String>? cast;

  @JsonKey(name: 'director')
  final List<String>? director;

  @JsonKey(name: 'writer')
  final List<String>? writer;

  @JsonKey(name: 'videos')
  final List<VideoInfo>? videos;

  @JsonKey(name: 'links')
  final List<Map<String, dynamic>>? links;

  MetaModel({
    required this.id,
    required this.type,
    required this.name,
    this.poster,
    this.background,
    this.logo,
    this.description,
    this.releaseInfo,
    this.genre,
    this.imdbRating,
    this.runtime,
    this.cast,
    this.director,
    this.writer,
    this.videos,
    this.links,
  });

  factory MetaModel.fromJson(Map<String, dynamic> json) =>
      _$MetaModelFromJson(json);

  Map<String, dynamic> toJson() => _$MetaModelToJson(this);
}

@JsonSerializable()
class VideoInfo {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'season')
  final int? season;

  @JsonKey(name: 'episode')
  final int? episode;

  @JsonKey(name: 'released')
  final String? released;

  @JsonKey(name: 'thumbnail')
  final String? thumbnail;

  @JsonKey(name: 'overview')
  final String? overview;

  VideoInfo({
    required this.id,
    required this.title,
    this.season,
    this.episode,
    this.released,
    this.thumbnail,
    this.overview,
  });

  factory VideoInfo.fromJson(Map<String, dynamic> json) =>
      _$VideoInfoFromJson(json);

  Map<String, dynamic> toJson() => _$VideoInfoToJson(this);
}
