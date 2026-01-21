// GENERATED FILE - DO NOT EDIT MANUALLY

part of 'stream_model.dart';

StreamModel _$StreamModelFromJson(Map<String, dynamic> json) => StreamModel(
      url: json['url'] as String,
      name: json['name'] as String?,
      externalUrl: json['externalUrl'] as String?,
      title: json['title'] as String?,
    );

Map<String, dynamic> _$StreamModelToJson(StreamModel instance) =>
    <String, dynamic>{
      'url': instance.url,
      'name': instance.name,
      'externalUrl': instance.externalUrl,
      'title': instance.title,
    };

StreamsResponse _$StreamsResponseFromJson(Map<String, dynamic> json) =>
    StreamsResponse(
      streams: (json['streams'] as List)
          .map((e) => StreamModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StreamsResponseToJson(StreamsResponse instance) =>
    <String, dynamic>{
      'streams': instance.streams,
    };
