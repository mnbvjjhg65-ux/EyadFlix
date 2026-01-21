class AppConstants {
  // App Info
  static const String appName = 'EyadFlix';
  static const String appVersion = '1.0.0';
  static const String developerName = 'Eyad AI Juhani';

  // Stremio API
  static const String stremioProtoVersion = '1.0';
  static const Duration addonTimeoutDuration = Duration(seconds: 30);

  // Storage
  static const String hiveAddonsBox = 'addons';
  static const String hiveWatchHistoryBox = 'watch_history';
  static const String hiveUserPrefsBox = 'user_prefs';
  static const String hiveFavoritesBox = 'favorites';

  // Default Languages
  static const String defaultLanguage = 'en';
  static const String arabicLanguage = 'ar';

  // Player
  static const int maxResolution = 2160; // 2K
  static const Duration fastForwardStep = Duration(seconds: 10);

  // UI
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const double posterAspectRatio = 0.666;
  static const double posterBorderRadius = 12.0;
}

class AddonProtocolKeys {
  // Addon Manifest
  static const String id = 'id';
  static const String version = 'version';
  static const String name = 'name';
  static const String description = 'description';
  static const String logo = 'logo';
  static const String author = 'author';
  static const String resources = 'resources';
  static const String types = 'types';
  static const String handlers = 'handlers';

  // Handler Types
  static const String catalogHandler = 'catalog';
  static const String metaHandler = 'meta';
  static const String streamHandler = 'stream';
  static const String subtitleHandler = 'subtitles';
  static const String actionHandler = 'action';

  // Response Types
  static const String metas = 'metas';
  static const String meta = 'meta';
  static const String streams = 'streams';
  static const String subtitles = 'subtitles';

  // Meta Fields
  static const String id_meta = 'id';
  static const String type = 'type';
  static const String name_meta = 'name';
  static const String poster = 'poster';
  static const String background = 'background';
  static const String logo = 'logo_meta';
  static const String description = 'description';
  static const String releaseInfo = 'releaseInfo';
  static const String genre = 'genre';
  static const String imdbRating = 'imdbRating';
  static const String runtime = 'runtime';
  static const String cast = 'cast';
  static const String director = 'director';
  static const String writer = 'writer';

  // Stream Fields
  static const String url = 'url';
  static const String name_stream = 'name';
  static const String externalUrl = 'externalUrl';

  // Subtitle Fields
  static const String lang = 'lang';
  static const String url_sub = 'url';
}
