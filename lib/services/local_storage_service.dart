import 'package:hive_flutter/hive_flutter.dart';
import 'package:eyadflix/core/constants/app_constants.dart';
import 'package:eyadflix/data/models/installed_addon.dart';
import 'package:eyadflix/data/models/watch_history.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();

  factory LocalStorageService() {
    return _instance;
  }

  LocalStorageService._internal();

  Future<void> init() async {
    await Hive.initFlutter();
    
    Hive.registerAdapter(InstalledAddonAdapter());
    Hive.registerAdapter(WatchHistoryItemAdapter());

    await Hive.openBox<InstalledAddon>(AppConstants.hiveAddonsBox);
    await Hive.openBox<WatchHistoryItem>(AppConstants.hiveWatchHistoryBox);
    await Hive.openBox(AppConstants.hiveUserPrefsBox);
    await Hive.openBox(AppConstants.hiveFavoritesBox);
  }

  // Addon Operations
  Future<void> saveAddon(InstalledAddon addon) async {
    final box = Hive.box<InstalledAddon>(AppConstants.hiveAddonsBox);
    await box.put(addon.id, addon);
  }

  InstalledAddon? getAddon(String id) {
    final box = Hive.box<InstalledAddon>(AppConstants.hiveAddonsBox);
    return box.get(id);
  }

  List<InstalledAddon> getAllAddons() {
    final box = Hive.box<InstalledAddon>(AppConstants.hiveAddonsBox);
    return box.values.toList();
  }

  Future<void> deleteAddon(String id) async {
    final box = Hive.box<InstalledAddon>(AppConstants.hiveAddonsBox);
    await box.delete(id);
  }

  Future<void> updateAddonStatus(String id, bool isEnabled) async {
    final addon = getAddon(id);
    if (addon != null) {
      addon.isEnabled = isEnabled;
      await addon.save();
    }
  }

  // Watch History Operations
  Future<void> saveWatchHistory(WatchHistoryItem item) async {
    final box = Hive.box<WatchHistoryItem>(AppConstants.hiveWatchHistoryBox);
    await box.put(item.mediaId, item);
  }

  WatchHistoryItem? getWatchHistory(String mediaId) {
    final box = Hive.box<WatchHistoryItem>(AppConstants.hiveWatchHistoryBox);
    return box.get(mediaId);
  }

  List<WatchHistoryItem> getAllWatchHistory() {
    final box = Hive.box<WatchHistoryItem>(AppConstants.hiveWatchHistoryBox);
    return box.values.toList()
      ..sort((a, b) => b.lastWatchedAt.compareTo(a.lastWatchedAt));
  }

  Future<void> deleteWatchHistory(String mediaId) async {
    final box = Hive.box<WatchHistoryItem>(AppConstants.hiveWatchHistoryBox);
    await box.delete(mediaId);
  }

  // User Preferences
  Future<void> setLanguage(String language) async {
    final box = Hive.box(AppConstants.hiveUserPrefsBox);
    await box.put('language', language);
  }

  String? getLanguage() {
    final box = Hive.box(AppConstants.hiveUserPrefsBox);
    return box.get('language');
  }

  Future<void> setThemeMode(String mode) async {
    final box = Hive.box(AppConstants.hiveUserPrefsBox);
    await box.put('theme_mode', mode);
  }

  String? getThemeMode() {
    final box = Hive.box(AppConstants.hiveUserPrefsBox);
    return box.get('theme_mode');
  }

  // Favorites/Library
  Future<void> addToFavorites(String mediaId) async {
    final box = Hive.box(AppConstants.hiveFavoritesBox);
    final favorites = Set<String>.from(box.get('favorites') ?? []);
    favorites.add(mediaId);
    await box.put('favorites', favorites.toList());
  }

  Future<void> removeFromFavorites(String mediaId) async {
    final box = Hive.box(AppConstants.hiveFavoritesBox);
    final favorites = Set<String>.from(box.get('favorites') ?? []);
    favorites.remove(mediaId);
    await box.put('favorites', favorites.toList());
  }

  List<String> getFavorites() {
    final box = Hive.box(AppConstants.hiveFavoritesBox);
    return List<String>.from(box.get('favorites') ?? []);
  }

  bool isFavorite(String mediaId) {
    return getFavorites().contains(mediaId);
  }

  Future<void> clearAll() async {
    await Hive.deleteBoxFromDisk(AppConstants.hiveAddonsBox);
    await Hive.deleteBoxFromDisk(AppConstants.hiveWatchHistoryBox);
    await Hive.deleteBoxFromDisk(AppConstants.hiveUserPrefsBox);
    await Hive.deleteBoxFromDisk(AppConstants.hiveFavoritesBox);
  }
}
