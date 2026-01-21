import 'package:json_annotation/json_annotation.dart';

part 'subtitle_model.g.dart';

@JsonSerializable()
class SubtitleModel {
  @JsonKey(name: 'lang')
  final String lang;

  @JsonKey(name: 'url')
  final String url;

  SubtitleModel({
    required this.lang,
    required this.url,
  });

  factory SubtitleModel.fromJson(Map<String, dynamic> json) =>
      _$SubtitleModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubtitleModelToJson(this);

  bool get isArabic => lang.toLowerCase().contains('ar');
  bool get isEnglish => lang.toLowerCase().contains('en');
}

@JsonSerializable()
class SubtitlesResponse {
  @JsonKey(name: 'subtitles')
  final List<SubtitleModel> subtitles;

  SubtitlesResponse({
    required this.subtitles,
  });

  factory SubtitlesResponse.fromJson(Map<String, dynamic> json) =>
      _$SubtitlesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubtitlesResponseToJson(this);
}
