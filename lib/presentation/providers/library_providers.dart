import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eyadflix/services/local_storage_service.dart';
import 'package:eyadflix/data/models/watch_history.dart';

final watchHistoryProvider = StateNotifierProvider<WatchHistoryNotifier, List<WatchHistoryItem>>(
  (ref) {
    final storage = LocalStorageService();
    return WatchHistoryNotifier(storage);
  },
);

class WatchHistoryNotifier extends StateNotifier<List<WatchHistoryItem>> {
  final LocalStorageService _storage;

  WatchHistoryNotifier(this._storage) : super(_storage.getAllWatchHistory());

  Future<void> addToHistory(WatchHistoryItem item) async {
    await _storage.saveWatchHistory(item);
    state = _storage.getAllWatchHistory();
  }

  Future<void> removeFromHistory(String mediaId) async {
    await _storage.deleteWatchHistory(mediaId);
    state = _storage.getAllWatchHistory();
  }

  Future<void> clearHistory() async {
    final items = _storage.getAllWatchHistory();
    for (var item in items) {
      await _storage.deleteWatchHistory(item.mediaId);
    }
    state = [];
  }

  Future<void> refresh() async {
    state = _storage.getAllWatchHistory();
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<String>>(
  (ref) {
    final storage = LocalStorageService();
    return FavoritesNotifier(storage);
  },
);

class FavoritesNotifier extends StateNotifier<List<String>> {
  final LocalStorageService _storage;

  FavoritesNotifier(this._storage) : super(_storage.getFavorites());

  Future<void> addToFavorites(String mediaId) async {
    await _storage.addToFavorites(mediaId);
    state = _storage.getFavorites();
  }

  Future<void> removeFromFavorites(String mediaId) async {
    await _storage.removeFromFavorites(mediaId);
    state = _storage.getFavorites();
  }

  Future<void> toggleFavorite(String mediaId) async {
    if (state.contains(mediaId)) {
      await removeFromFavorites(mediaId);
    } else {
      await addToFavorites(mediaId);
    }
  }

  bool isFavorite(String mediaId) {
    return state.contains(mediaId);
  }
}
