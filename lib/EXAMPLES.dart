/// EyadFlix - أمثلة الاستخدام الشاملة
/// 
/// هذا الملف يوضح كيفية استخدام جميع مكونات التطبيق

// مثال 1: استخدام AddonService
import 'package:eyadflix/services/addon_service.dart';
import 'package:eyadflix/core/constants/app_constants.dart';

void exampleAddonService() async {
  final addonService = AddonService();

  try {
    // 1. جلب بيان الإضافة
    final manifest = await addonService.fetchManifest(
      'https://torrentio.strem.fun/manifest.json',
    );
    print('Addon: ${manifest.name}');

    // 2. جلب الكتالوج
    final catalogs = await addonService.fetchCatalog(
      addonUrl: AddonService.normalizeAddonUrl('https://torrentio.strem.fun'),
      type: 'movie',
      catalogId: 'top',
    );
    print('Found ${catalogs.length} movies');

    // 3. جلب بيانات وسيط
    if (catalogs.isNotEmpty) {
      final meta = await addonService.fetchMeta(
        addonUrl: AddonService.normalizeAddonUrl('https://torrentio.strem.fun'),
        type: 'movie',
        mediaId: catalogs.first.id,
      );
      print('Movie: ${meta.name}');

      // 4. جلب المصادر
      final streams = await addonService.fetchStreams(
        addonUrl: AddonService.normalizeAddonUrl('https://torrentio.strem.fun'),
        type: 'movie',
        mediaId: catalogs.first.id,
      );
      print('Found ${streams.length} streams');

      // 5. جلب الترجمات
      final subtitles = await addonService.fetchSubtitles(
        addonUrl: AddonService.normalizeAddonUrl('https://torrentio.strem.fun'),
        type: 'movie',
        mediaId: catalogs.first.id,
      );
      print('Found ${subtitles.length} subtitles');
    }
  } catch (e) {
    print('Error: $e');
  }
}

// مثال 2: استخدام LocalStorageService
import 'package:eyadflix/services/local_storage_service.dart';
import 'package:eyadflix/data/models/installed_addon.dart';
import 'package:eyadflix/data/models/watch_history.dart';

void exampleStorageService() async {
  final storage = LocalStorageService();

  // حفظ إضافة
  final addon = InstalledAddon(
    id: 'torrentio',
    manifestUrl: 'https://torrentio.strem.fun',
    name: 'Torrentio',
    logo: 'https://example.com/logo.png',
    installedAt: DateTime.now(),
    version: '1.0.0',
  );
  await storage.saveAddon(addon);

  // استرجاع الإضافات
  final addons = storage.getAllAddons();
  print('Installed addons: ${addons.map((a) => a.name).join(', ')}');

  // حفظ سجل المشاهدة
  final historyItem = WatchHistoryItem(
    mediaId: 'tt1234567',
    addonId: 'torrentio',
    mediaName: 'The Matrix',
    poster: 'https://example.com/poster.jpg',
    lastWatchedAt: DateTime.now(),
    watchDurationSeconds: 1800,
    totalDurationSeconds: 7200,
  );
  await storage.saveWatchHistory(historyItem);

  // استرجاع السجل
  final history = storage.getAllWatchHistory();
  print('Watch progress: ${history.first.watchProgress}%');

  // إدارة المفضلات
  await storage.addToFavorites('tt1234567');
  print('Is favorite: ${storage.isFavorite('tt1234567')}');
}

// مثال 3: استخدام Riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eyadflix/presentation/providers/app_providers.dart';

void exampleRiverpod(WidgetRef ref) {
  // قراءة الإضافات المثبتة
  final addons = ref.watch(installedAddonsProvider);
  print('Addons: ${addons.map((a) => a.name)}');

  // تحديث الإضافات
  ref.read(installedAddonsProvider.notifier).addAddon(myAddon);
  ref.read(installedAddonsProvider.notifier).removeAddon(addonId);
  ref.read(installedAddonsProvider.notifier).toggleAddonStatus(addonId);

  // إدارة اللغة
  final language = ref.watch(languageProvider);
  ref.read(languageProvider.notifier).setLanguage('ar');

  // إدارة المظهر
  final theme = ref.watch(themeModeProvider);
  ref.read(themeModeProvider.notifier).setThemeMode('dark');
}

// مثال 4: استخدام التوطين
import 'package:easy_localization/easy_localization.dart';

void exampleLocalization(BuildContext context) {
  // ترجمة بسيطة
  Text('home'.tr()); // عرض: "Home" أو "الرئيسية"

  // ترجمة متداخلة
  Text('homeScreen.title'.tr()); // عرض: "Home" أو "الرئيسية"

  // تغيير اللغة
  context.setLocale(const Locale('ar')); // تبديل للعربية
  context.setLocale(const Locale('en')); // تبديل للإنجليزية
}

// مثال 5: بناء صفحة جديدة
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

class ExamplePage extends ConsumerWidget {
  const ExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addons = ref.watch(installedAddonsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('example.title'.tr()),
      ),
      body: ListView.builder(
        itemCount: addons.length,
        itemBuilder: (context, index) {
          final addon = addons[index];
          return ListTile(
            title: Text(addon.name),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                ref
                    .read(installedAddonsProvider.notifier)
                    .removeAddon(addon.id);
              },
            ),
          );
        },
      ),
    );
  }
}

// مثال 6: التعامل مع الأخطاء
import 'package:eyadflix/core/errors/exceptions.dart';

void exampleErrorHandling() async {
  try {
    final addonService = AddonService();
    final manifest = await addonService.fetchManifest(
      'https://invalid-url.com',
    );
  } on NetworkException catch (e) {
    print('Network error: ${e.message}');
  } on ParseException catch (e) {
    print('Parse error: ${e.message}');
  } on AppException catch (e) {
    print('App error: ${e.message}');
  } catch (e) {
    print('Unknown error: $e');
  }
}

// مثال 7: استخدام نموذج Meta
import 'package:eyadflix/data/models/meta_model.dart';

void exampleMetaModel(MetaModel meta) {
  // الوصول للبيانات
  print('Title: ${meta.name}');
  print('Rating: ${meta.imdbRating}');
  print('Description: ${meta.description}');
  
  // الممثلون والمخرج
  if (meta.cast != null) {
    print('Cast: ${meta.cast?.join(", ")}');
  }
  
  // الفيديوهات (الحلقات)
  if (meta.videos != null && meta.videos!.isNotEmpty) {
    for (var video in meta.videos!) {
      print('Episode: ${video.title} (Season ${video.season}, Episode ${video.episode})');
    }
  }
}

// مثال 8: استخدام نموذج Stream
import 'package:eyadflix/data/models/stream_model.dart';

void exampleStreamModel(List<StreamModel> streams) {
  // اختيار أول مصدر
  final firstStream = streams.first;
  
  // فحص نوع المصدر
  if (firstStream.isUrl) {
    print('Direct link: ${firstStream.url}');
  } else if (firstStream.isMagnet) {
    print('Magnet link: ${firstStream.url}');
  } else if (firstStream.isTorrent) {
    print('Torrent file: ${firstStream.url}');
  }
  
  // الاسم والعنوان
  print('Name: ${firstStream.name ?? "Unknown"}');
  print('Title: ${firstStream.title ?? "No title"}');
}

// مثال 9: استخدام نموذج Subtitle
import 'package:eyadflix/data/models/subtitle_model.dart';

void exampleSubtitleModel(List<SubtitleModel> subtitles) {
  // البحث عن ترجمات إنجليزية
  final englishSubs = subtitles.where((s) => s.isEnglish);
  print('English subtitles: ${englishSubs.length}');
  
  // البحث عن ترجمات عربية
  final arabicSubs = subtitles.where((s) => s.isArabic);
  print('Arabic subtitles: ${arabicSubs.length}');
  
  // اختيار أول ترجمة
  if (subtitles.isNotEmpty) {
    final sub = subtitles.first;
    print('Language: ${sub.lang}');
    print('URL: ${sub.url}');
  }
}

// مثال 10: بناء شاشة كاملة مع جميع الميزات
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eyadflix/services/addon_service.dart';
import 'package:eyadflix/presentation/providers/app_providers.dart';

class CompleteExamplePage extends ConsumerStatefulWidget {
  const CompleteExamplePage({Key? key}) : super(key: key);

  @override
  ConsumerState<CompleteExamplePage> createState() =>
      _CompleteExamplePageState();
}

class _CompleteExamplePageState extends ConsumerState<CompleteExamplePage> {
  @override
  Widget build(BuildContext context) {
    // مراقبة الإضافات
    final addons = ref.watch(installedAddonsProvider);
    final language = ref.watch(languageProvider);
    final theme = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('example.title'.tr()),
      ),
      body: addons.isEmpty
          ? Center(
              child: Text('example.noAddons'.tr()),
            )
          : ListView.builder(
              itemCount: addons.length,
              itemBuilder: (context, index) {
                final addon = addons[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: addon.logo != null
                        ? Image.network(
                            addon.logo!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.extension),
                    title: Text(addon.name),
                    subtitle: Text(addon.manifestUrl),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            addon.isEnabled
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            ref
                                .read(installedAddonsProvider.notifier)
                                .toggleAddonStatus(addon.id);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            ref
                                .read(installedAddonsProvider.notifier)
                                .removeAddon(addon.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
