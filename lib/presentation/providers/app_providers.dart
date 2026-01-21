import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eyadflix/services/addon_service.dart';
import 'package:eyadflix/services/local_storage_service.dart';
import 'package:eyadflix/data/models/installed_addon.dart';

// Service Providers
final addonServiceProvider = Provider((ref) => AddonService());

final localStorageProvider = Provider((ref) => LocalStorageService());

// Addon List Provider
final installedAddonsProvider = StateNotifierProvider<InstalledAddonsNotifier, List<InstalledAddon>>(
  (ref) => InstalledAddonsNotifier(ref.watch(localStorageProvider)),
);

class InstalledAddonsNotifier extends StateNotifier<List<InstalledAddon>> {
  final LocalStorageService _storage;

  InstalledAddonsNotifier(this._storage) : super(_storage.getAllAddons());

  Future<void> refreshAddons() async {
    state = _storage.getAllAddons();
  }

  Future<void> addAddon(InstalledAddon addon) async {
    await _storage.saveAddon(addon);
    await refreshAddons();
  }

  Future<void> removeAddon(String id) async {
    await _storage.deleteAddon(id);
    await refreshAddons();
  }

  Future<void> toggleAddonStatus(String id) async {
    final addon = _storage.getAddon(id);
    if (addon != null) {
      await _storage.updateAddonStatus(id, !addon.isEnabled);
      await refreshAddons();
    }
  }

  List<InstalledAddon> getEnabledAddons() {
    return state.where((addon) => addon.isEnabled).toList();
  }
}

// Theme Provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, String>(
  (ref) {
    final storage = ref.watch(localStorageProvider);
    return ThemeModeNotifier(storage);
  },
);

class ThemeModeNotifier extends StateNotifier<String> {
  final LocalStorageService _storage;

  ThemeModeNotifier(this._storage)
      : super(_storage.getThemeMode() ?? 'system');

  Future<void> setThemeMode(String mode) async {
    await _storage.setThemeMode(mode);
    state = mode;
  }
}

// Language Provider
final languageProvider = StateNotifierProvider<LanguageNotifier, String>(
  (ref) {
    final storage = ref.watch(localStorageProvider);
    return LanguageNotifier(storage);
  },
);

class LanguageNotifier extends StateNotifier<String> {
  final LocalStorageService _storage;

  LanguageNotifier(this._storage)
      : super(_storage.getLanguage() ?? 'en');

  Future<void> setLanguage(String language) async {
    await _storage.setLanguage(language);
    state = language;
  }
}
