// GENERATED FILE - DO NOT EDIT MANUALLY

part of 'subtitle_model.dart';

SubtitleModel _$SubtitleModelFromJson(Map<String, dynamic> json) =>
    SubtitleModel(
      lang: json['lang'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$SubtitleModelToJson(SubtitleModel instance) =>
    <String, dynamic>{
      'lang': instance.lang,
      'url': instance.url,
    };

SubtitlesResponse _$SubtitlesResponseFromJson(Map<String, dynamic> json) =>
    SubtitlesResponse(
      subtitles: (json['subtitles'] as List)
          .map((e) => SubtitleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubtitlesResponseToJson(SubtitlesResponse instance) =>
    <String, dynamic>{
      'subtitles': instance.subtitles,
    };
