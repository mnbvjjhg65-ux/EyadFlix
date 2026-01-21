import 'package:json_annotation/json_annotation.dart';

part 'stream_model.g.dart';

@JsonSerializable()
class StreamModel {
  @JsonKey(name: 'url')
  final String url;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'externalUrl')
  final String? externalUrl;

  @JsonKey(name: 'title')
  final String? title;

  StreamModel({
    required this.url,
    this.name,
    this.externalUrl,
    this.title,
  });

  factory StreamModel.fromJson(Map<String, dynamic> json) =>
      _$StreamModelFromJson(json);

  Map<String, dynamic> toJson() => _$StreamModelToJson(this);

  bool get isUrl => url.startsWith('http');
  bool get isMagnet => url.startsWith('magnet:');
  bool get isTorrent => url.endsWith('.torrent');
}

@JsonSerializable()
class StreamsResponse {
  @JsonKey(name: 'streams')
  final List<StreamModel> streams;

  StreamsResponse({
    required this.streams,
  });

  factory StreamsResponse.fromJson(Map<String, dynamic> json) =>
      _$StreamsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StreamsResponseToJson(this);
}
