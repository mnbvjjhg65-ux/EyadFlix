# EyadFlix - دليل التطوير الشامل

## أولاً: هيكل المشروع

```
EyadFlix/
├── android/              # Android-specific configuration
│   ├── app/
│   │   ├── src/main/
│   │   │   ├── AndroidManifest.xml
│   │   │   └── kotlin/
│   │   ├── build.gradle
│   │   └── proguard-rules.pro
│   ├── build.gradle
│   ├── gradle.properties
│   └── settings.gradle
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   │   └── app_constants.dart      # ثوابت التطبيق
│   │   ├── errors/
│   │   │   └── exceptions.dart         # معالجة الأخطاء
│   │   └── utils/
│   │       └── enums.dart              # التعريفات والـ Enums
│   ├── data/
│   │   ├── datasources/
│   │   │   └── remote_datasource.dart  # استدعاءات API
│   │   ├── models/
│   │   │   ├── addon_manifest.dart
│   │   │   ├── meta_model.dart
│   │   │   ├── stream_model.dart
│   │   │   ├── subtitle_model.dart
│   │   │   ├── installed_addon.dart    # Hive model
│   │   │   └── watch_history.dart      # Hive model
│   │   └── repositories/
│   │       └── repository_impl.dart    # تطبيق المستودعات
│   ├── domain/
│   │   ├── entities/
│   │   ├── repositories/
│   │   └── usecases/
│   ├── services/
│   │   ├── addon_service.dart          # معالج بروتوكول Stremio
│   │   ├── local_storage_service.dart  # Hive wrapper
│   │   ├── localization_service.dart   # إدارة اللغات
│   │   └── theme_service.dart          # ثيمات التطبيق
│   ├── presentation/
│   │   ├── pages/
│   │   │   ├── home_page.dart
│   │   │   ├── home_content_page.dart
│   │   │   ├── addons_page.dart
│   │   │   ├── library_page.dart
│   │   │   ├── settings_page.dart
│   │   │   ├── addon_detail_page.dart
│   │   │   ├── video_player_page.dart
│   │   │   └── media_detail_page.dart (قادم)
│   │   ├── widgets/
│   │   │   ├── bottom_nav_bar.dart
│   │   │   └── ... (widgets أخرى)
│   │   └── providers/
│   │       ├── app_providers.dart      # Riverpod providers
│   │       └── library_providers.dart  # library-related providers
│   └── main.dart                       # نقطة الدخول
├── assets/
│   ├── translations/
│   │   ├── en.json                     # الترجمات الإنجليزية
│   │   └── ar.json                     # الترجمات العربية
│   ├── icons/
│   └── images/
├── pubspec.yaml                        # المكتبات والمواد
├── analysis_options.yaml               # Linting rules
└── README.md                           # الدليل الأساسي
```

## المرحلة 1: إعداد البيئة ✅

### تثبيت الحزم
```bash
flutter pub get
```

### إنشاء كود JSON Serialization
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### إنشاء Hive Adapters
```bash
flutter pub run build_runner build
```

## المرحلة 2: شرح البنية المعمارية

### الطبقة الأساسية (Core Layer)
- **constants**: الثوابت والقيم الثابتة
- **errors**: معالجة الأخطاء المخصصة
- **utils**: الدوال المساعدة والـ enums

### طبقة البيانات (Data Layer)
- **models**: نماذج JSON مع serialization
- **datasources**: استدعاءات API والتخزين المحلي
- **repositories**: تطبيق المستودعات

### طبقة النطاق (Domain Layer)
- **entities**: كيانات العمل
- **repositories**: واجهات المستودعات
- **usecases**: حالات الاستخدام

### طبقة الخدمات (Services)
- **AddonService**: معالج بروتوكول Stremio الكامل
- **LocalStorageService**: إدارة قاعدة البيانات المحلية
- **LocalizationService**: إدارة اللغات
- **ThemeService**: إدارة المظهر

### طبقة العرض (Presentation Layer)
- **Pages**: الشاشات الرئيسية
- **Widgets**: مكونات UI قابلة لإعادة الاستخدام
- **Providers**: حالة التطبيق مع Riverpod

## المرحلة 3: شرح خدمة الإضافات (Addon Service)

```dart
// مثال: جلب البيان
final manifest = await addonService.fetchManifest('https://torrentio.strem.fun/manifest.json');

// مثال: جلب الكتالوج
final metas = await addonService.fetchCatalog(
  addonUrl: 'https://torrentio.strem.fun',
  type: 'movie',
  catalogId: 'top',
);

// مثال: جلب البيانات الوصفية
final meta = await addonService.fetchMeta(
  addonUrl: 'https://torrentio.strem.fun',
  type: 'movie',
  mediaId: 'tt1234567',
);

// مثال: جلب المصادر
final streams = await addonService.fetchStreams(
  addonUrl: 'https://torrentio.strem.fun',
  type: 'movie',
  mediaId: 'tt1234567',
);

// مثال: جلب الترجمات
final subtitles = await addonService.fetchSubtitles(
  addonUrl: 'https://torrentio.strem.fun',
  type: 'movie',
  mediaId: 'tt1234567',
);
```

## المرحلة 4: استخدام Riverpod

```dart
// قراءة البيانات
final addons = ref.watch(installedAddonsProvider);

// تحديث البيانات
ref.read(installedAddonsProvider.notifier).addAddon(addon);

// تغيير اللغة
ref.read(languageProvider.notifier).setLanguage('ar');

// تغيير المظهر
ref.read(themeModeProvider.notifier).setThemeMode('dark');
```

## المرحلة 5: التوطين (Localization)

### استخدام الترجمات في الكود
```dart
import 'package:easy_localization/easy_localization.dart';

Text('home'.tr()),  // الترجمة البسيطة
Text('homeScreen.title'.tr()),  // الترجمة المتداخلة
```

### تغيير اللغة برمجياً
```dart
await context.setLocale(const Locale('ar'));
```

### اكتشاف لغة الجهاز تلقائياً
يتم هذا تلقائياً عند بدء التطبيق.

## المرحلة 6: التخزين المحلي (Hive)

```dart
final storage = LocalStorageService();

// حفظ إضافة
await storage.saveAddon(addon);

// استرجاع إضافة
final addon = storage.getAddon('addon-id');

// حفظ السجل
await storage.saveWatchHistory(historyItem);

// استرجاع السجل
final history = storage.getAllWatchHistory();

// إدارة المفضلات
await storage.addToFavorites('media-id');
final isFav = storage.isFavorite('media-id');
```

## المرحلة 7: مشغل الفيديو

تم استخدام `better_player` الذي يوفر:
- تشغيل ملفات HTTP والـ streams
- إدارة الترجمات
- تحكم سرعة التشغيل
- إدارة الشاشة الكاملة
- دعم PiP

## المرحلة 8: بناء APK

### Debug APK
```bash
flutter build apk --debug
```

### Release APK
```bash
flutter build apk --release
```

### Release APK مع تقسيم حسب البنية (ABI)
```bash
flutter build apk --release --split-per-abi
```

### تفعيل Code Obfuscation
```bash
flutter build apk --release --obfuscate --split-debug-info=./debug_symbols
```

## خطوات التطوير التالية

### 1. صفحة تفاصيل الوسيط (Media Detail Page)
```dart
// تعرض:
// - صورة الملصق الكبيرة
// - الملخص والوصف
// - معلومات الممثلين والمخرج
// - الحلقات (للمسلسلات)
// - أزرار التشغيل والإضافة للمفضلات
```

### 2. صفحة الكتالوج (Catalog Page)
```dart
// عرض الوسائط من الكتالوج المختار
// - عرض شبكي للملصقات
// - البحث والتصفية
// - التمرير اللانهائي
```

### 3. الإشعارات والحفظ التلقائي
```dart
// حفظ آخر موضع تشغيل تلقائياً
// - المتابعة من حيث توقفت
// - تتبع مدة المشاهدة
```

### 4. تحسين الأداء
```dart
// - التخزين المؤقت للبيانات
// - التحميل الكسول (Lazy Loading)
// - تحسين الصور والرسومات
```

## الإضافات الموصى بتثبيتها للاختبار

```
https://torrentio.strem.fun/manifest.json
https://mediafusion.strem.fun/manifest.json
https://orion.strem.fun/manifest.json
```

## استكشاف الأخطاء

### خطأ في البناء
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### الإضافات لا تحمل
1. تحقق من الاتصال بالإنترنت
2. تحقق من صحة رابط البيان
3. تحقق من سجلات التطبيق

### مشاكل مشغل الفيديو
1. امسح ذاكرة التطبيق
2. تحقق من مساحة التخزين
3. تحقق من إمكانية الوصول إلى رابط المصدر

## الموارد الإضافية

- [توثيق Stremio Addon Protocol](https://github.com/Stremio/stremio-addon-sdk)
- [توثيق Flutter](https://flutter.dev/docs)
- [توثيق Riverpod](https://riverpod.dev)
- [توثيق Hive](https://docs.hivedb.dev)

---

**تم بواسطة**: Eyad AI Juhani
**آخر تحديث**: يناير 2026
