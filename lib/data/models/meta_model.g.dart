// GENERATED FILE - DO NOT EDIT MANUALLY

part of 'meta_model.dart';

MetaModel _$MetaModelFromJson(Map<String, dynamic> json) => MetaModel(
      id: json['id'] as String,
      type: json['type'] as String,
      name: json['name'] as String,
      poster: json['poster'] as String?,
      background: json['background'] as String?,
      logo: json['logo'] as String?,
      description: json['description'] as String?,
      releaseInfo: json['releaseInfo'] as String?,
      genre: (json['genre'] as List?)?.map((e) => e as String).toList(),
      imdbRating: json['imdbRating'] as String?,
      runtime: json['runtime'] as String?,
      cast: (json['cast'] as List?)?.map((e) => e as String).toList(),
      director: (json['director'] as List?)?.map((e) => e as String).toList(),
      writer: (json['writer'] as List?)?.map((e) => e as String).toList(),
      videos: (json['videos'] as List?)
          ?.map((e) => VideoInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      links: (json['links'] as List?)?.map((e) => Map<String, dynamic>.from(e as Map)).toList(),
    );

Map<String, dynamic> _$MetaModelToJson(MetaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'poster': instance.poster,
      'background': instance.background,
      'logo': instance.logo,
      'description': instance.description,
      'releaseInfo': instance.releaseInfo,
      'genre': instance.genre,
      'imdbRating': instance.imdbRating,
      'runtime': instance.runtime,
      'cast': instance.cast,
      'director': instance.director,
      'writer': instance.writer,
      'videos': instance.videos,
      'links': instance.links,
    };

VideoInfo _$VideoInfoFromJson(Map<String, dynamic> json) => VideoInfo(
      id: json['id'] as String,
      title: json['title'] as String,
      season: json['season'] as int?,
      episode: json['episode'] as int?,
      released: json['released'] as String?,
      thumbnail: json['thumbnail'] as String?,
      overview: json['overview'] as String?,
    );

Map<String, dynamic> _$VideoInfoToJson(VideoInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'season': instance.season,
      'episode': instance.episode,
      'released': instance.released,
      'thumbnail': instance.thumbnail,
      'overview': instance.overview,
    };
