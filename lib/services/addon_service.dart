import 'package:dio/dio.dart';
import 'package:eyadflix/core/constants/app_constants.dart';
import 'package:eyadflix/core/errors/exceptions.dart';
import 'package:eyadflix/data/models/addon_manifest.dart';
import 'package:eyadflix/data/models/meta_model.dart';
import 'package:eyadflix/data/models/stream_model.dart';
import 'package:eyadflix/data/models/subtitle_model.dart';

class AddonService {
  final Dio _dio;

  AddonService({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(connectTimeout: AppConstants.addonTimeoutDuration));

  Future<AddonManifest> fetchManifest(String manifestUrl) async {
    try {
      final response = await _dio.get(manifestUrl);
      return AddonManifest.fromJson(response.data);
    } on DioException catch (e) {
      throw NetworkException('Failed to fetch addon manifest: ${e.message}');
    } catch (e) {
      throw ParseException('Failed to parse addon manifest: $e');
    }
  }

  Future<List<MetaModel>> fetchCatalog({
    required String addonUrl,
    required String type,
    required String catalogId,
    Map<String, dynamic>? extra,
  }) async {
    try {
      String query = '';
      if (extra != null && extra.isNotEmpty) {
        query = '&${_buildQueryString(extra)}';
      }

      final url = '$addonUrl/catalog/$type/$catalogId.json$query';
      final response = await _dio.get(url);

      if (response.data is Map && response.data.containsKey('metas')) {
        final metas = (response.data['metas'] as List)
            .map((m) => MetaModel.fromJson(m as Map<String, dynamic>))
            .toList();
        return metas;
      }
      return [];
    } on DioException catch (e) {
      throw NetworkException('Failed to fetch catalog: ${e.message}');
    } catch (e) {
      throw ParseException('Failed to parse catalog: $e');
    }
  }

  Future<MetaModel> fetchMeta({
    required String addonUrl,
    required String type,
    required String mediaId,
  }) async {
    try {
      final url = '$addonUrl/meta/$type/$mediaId.json';
      final response = await _dio.get(url);

      if (response.data is Map && response.data.containsKey('meta')) {
        return MetaModel.fromJson(response.data['meta']);
      }
      throw ParseException('Invalid meta response');
    } on DioException catch (e) {
      throw NetworkException('Failed to fetch meta: ${e.message}');
    } catch (e) {
      throw ParseException('Failed to parse meta: $e');
    }
  }

  Future<List<StreamModel>> fetchStreams({
    required String addonUrl,
    required String type,
    required String mediaId,
    String? videoId,
  }) async {
    try {
      final idPart = videoId != null ? '$mediaId/$videoId' : mediaId;
      final url = '$addonUrl/stream/$type/$idPart.json';
      final response = await _dio.get(url);

      if (response.data is Map && response.data.containsKey('streams')) {
        final streams = (response.data['streams'] as List)
            .map((s) => StreamModel.fromJson(s as Map<String, dynamic>))
            .toList();
        return streams;
      }
      return [];
    } on DioException catch (e) {
      throw NetworkException('Failed to fetch streams: ${e.message}');
    } catch (e) {
      throw ParseException('Failed to parse streams: $e');
    }
  }

  Future<List<SubtitleModel>> fetchSubtitles({
    required String addonUrl,
    required String type,
    required String mediaId,
    String? videoId,
  }) async {
    try {
      final idPart = videoId != null ? '$mediaId/$videoId' : mediaId;
      final url = '$addonUrl/subtitles/$type/$idPart.json';
      final response = await _dio.get(url);

      if (response.data is Map && response.data.containsKey('subtitles')) {
        final subtitles = (response.data['subtitles'] as List)
            .map((s) => SubtitleModel.fromJson(s as Map<String, dynamic>))
            .toList();
        return subtitles;
      }
      return [];
    } on DioException catch (e) {
      throw NetworkException('Failed to fetch subtitles: ${e.message}');
    } on ParseException {
      // Some addons may not have subtitles endpoint
      return [];
    } catch (e) {
      throw ParseException('Failed to parse subtitles: $e');
    }
  }

  String _buildQueryString(Map<String, dynamic> params) {
    final parts = <String>[];
    params.forEach((key, value) {
      if (value is List) {
        parts.add('$key=${value.join(',')}');
      } else {
        parts.add('$key=$value');
      }
    });
    return parts.join('&');
  }

  /// Normalizes addon base URL (removes manifest.json and trailing slashes)
  static String normalizeAddonUrl(String url) {
    var normalized = url.trim();
    if (normalized.endsWith('/manifest.json')) {
      normalized = normalized.replaceAll('/manifest.json', '');
    }
    if (normalized.endsWith('/')) {
      normalized = normalized.substring(0, normalized.length - 1);
    }
    return normalized;
  }
}
