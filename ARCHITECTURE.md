# EyadFlix - شرح البنية المعمارية بالتفصيل

## 🏗️ النمط المعماري: Clean Architecture + Riverpod

```
┌─────────────────────────────────────────────────┐
│          Presentation Layer (UI)                │
│  Pages, Widgets, Dialogs, Navigation            │
└─────────────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────┐
│        Riverpod Providers (State)                │
│  Managing app state and user interactions       │
└─────────────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────┐
│        Domain Layer (Business Logic)             │
│  Entities, Repositories Interfaces, UseCases   │
└─────────────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────┐
│        Data Layer (Data Management)              │
│  Models, Repositories, DataSources              │
└─────────────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────┐
│        Services Layer (External APIs)            │
│  AddonService, StorageService, etc.             │
└─────────────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────┐
│        Core Layer (Utilities & Errors)           │
│  Constants, Exceptions, Enums, Helpers         │
└─────────────────────────────────────────────────┘
```

## 📦 الطبقة الأساسية (Core Layer)

### `lib/core/constants/app_constants.dart`
يحتوي على:
- **AppConstants**: الثوابت العامة للتطبيق
  ```dart
  - appName = 'EyadFlix'
  - developerName = 'Eyad AI Juhani'
  - addonTimeoutDuration = 30 seconds
  - maxResolution = 2160 (2K)
  ```

- **AddonProtocolKeys**: مفاتيح بروتوكول Stremio
  ```dart
  - catalogHandler = 'catalog'
  - metaHandler = 'meta'
  - streamHandler = 'stream'
  - subtitleHandler = 'subtitles'
  ```

### `lib/core/errors/exceptions.dart`
أصناف الأخطاء المخصصة:
```dart
AppException (الأساس)
├── NetworkException (مشاكل الشبكة)
├── InvalidAddonException (إضافة غير صحيحة)
├── CacheException (مشاكل التخزين)
├── ParseException (فشل التحليل)
└── PlayerException (مشاكل المشغل)
```

### `lib/core/utils/enums.dart`
التعريفات:
```dart
ContentType
├── movie ('movie')
├── series ('series')
└── unknown ('unknown')

HandlerType
├── catalog ('catalog')
├── meta ('meta')
├── stream ('stream')
├── subtitles ('subtitles')
└── action ('action')
```

## 📊 طبقة البيانات (Data Layer)

### `lib/data/models/`
نماذج JSON مع Serialization:

1. **addon_manifest.dart**
   - `AddonManifest`: بيان الإضافة الكامل
   - `CatalogResource`: معلومات الكتالوج

2. **meta_model.dart**
   - `MetaModel`: البيانات الوصفية (الملخص، المثلون، إلخ)
   - `VideoInfo`: معلومات الفيديو/الحلقة

3. **stream_model.dart**
   - `StreamModel`: مصدر البث مع خصائصه
   - `StreamsResponse`: رد الخادم

4. **subtitle_model.dart**
   - `SubtitleModel`: ملف ترجمة واحد
   - `SubtitlesResponse`: قائمة الترجمات

5. **installed_addon.dart** (Hive Model)
   - `InstalledAddon`: بيانات الإضافة المثبتة محلياً

6. **watch_history.dart** (Hive Model)
   - `WatchHistoryItem`: عنصر سجل المشاهدة

### `lib/data/datasources/`
(جاهز للتوسع)
- استدعاءات API المباشرة
- معالجة البيانات الخام

### `lib/data/repositories/`
(جاهز للتوسع)
- تطبيق واجهات المستودعات
- دمج datasources محتلفة

## 🎯 طبقة النطاق (Domain Layer)

### `lib/domain/entities/`
(جاهز للتوسع)
- كيانات العمل المستقلة عن التطبيق

### `lib/domain/repositories/`
(جاهز للتوسع)
- واجهات المستودعات

### `lib/domain/usecases/`
(جاهز للتوسع)
- حالات الاستخدام المنطقية

## 🔧 طبقة الخدمات (Services Layer)

### `lib/services/addon_service.dart`
**المسؤول الأساسي عن معالجة بروتوكول Stremio**

الوظائف الرئيسية:
```dart
fetchManifest()        → جلب بيان الإضافة
fetchCatalog()         → جلب قائمة الأفلام/المسلسلات
fetchMeta()            → جلب البيانات الوصفية الكاملة
fetchStreams()         → جلب مصادر البث المتاحة
fetchSubtitles()       → جلب الترجمات المتاحة
normalizeAddonUrl()    → تنسيق رابط الإضافة
```

**مثال على الاستخدام:**
```dart
final addonService = AddonService();

// الخطوة 1: جلب البيان
final manifest = await addonService.fetchManifest(
  'https://torrentio.strem.fun/manifest.json'
);

// الخطوة 2: جلب الكتالوج
final metas = await addonService.fetchCatalog(
  addonUrl: 'https://torrentio.strem.fun',
  type: 'movie',
  catalogId: 'top',
);

// الخطوة 3: جلب البيانات التفصيلية
final meta = await addonService.fetchMeta(
  addonUrl: 'https://torrentio.strem.fun',
  type: 'movie',
  mediaId: metas.first.id,
);

// الخطوة 4: جلب المصادر
final streams = await addonService.fetchStreams(
  addonUrl: 'https://torrentio.strem.fun',
  type: 'movie',
  mediaId: metas.first.id,
);

// الخطوة 5: جلب الترجمات
final subtitles = await addonService.fetchSubtitles(
  addonUrl: 'https://torrentio.strem.fun',
  type: 'movie',
  mediaId: metas.first.id,
);
```

### `lib/services/local_storage_service.dart`
**إدارة قاعدة البيانات المحلية مع Hive**

الوظائف:
```dart
// الإضافات
saveAddon()           → حفظ إضافة
getAddon()            → استرجاع إضافة
getAllAddons()        → جميع الإضافات
deleteAddon()         → حذف إضافة

// سجل المشاهدة
saveWatchHistory()    → حفظ عنصر
getWatchHistory()     → استرجاع عنصر
getAllWatchHistory()  → السجل كاملاً

// تفضيلات المستخدم
setLanguage()         → حفظ اللغة
getLanguage()         → استرجاع اللغة
setThemeMode()        → حفظ المظهر
getThemeMode()        → استرجاع المظهر

// المفضلات
addToFavorites()      → إضافة للمفضلات
removeFromFavorites() → حذف من المفضلات
isFavorite()          → فحص المفضلات
```

### `lib/services/localization_service.dart`
**إدارة التوطين والتبديل بين اللغات**

الميزات:
- دعم اللغة الإنجليزية والعربية فقط
- RTL للعربية تلقائياً
- اكتشاف لغة الجهاز
- تغيير اللغة ديناميكياً

### `lib/services/theme_service.dart`
**تعريف المواضيع**

يتضمن:
- `lightTheme`: الوضع الفاتح (Material Design 3)
- `darkTheme`: الوضع الداكن
- ألوان، خطوط، وأنماط موحدة

## 🎨 طبقة العرض (Presentation Layer)

### `lib/presentation/pages/`

#### `home_page.dart`
الشاشة الرئيسية مع ملاح:
```
HomePage (Stateful)
├── HomeContentPage (catalog)
├── AddonsPage (manage)
├── LibraryPage (favorites)
└── SettingsPage (config)
```

#### `home_content_page.dart`
عرض الكتالوجات:
- قائمة الإضافات المفعلة
- عرض أفلامهم
- رابط إلى تفاصيل الإضافة

#### `addons_page.dart`
إدارة الإضافات:
- إدخال رابط البيان
- تثبيت الإضافات
- قائمة الإضافات
- تفعيل/تعطيل
- حذف

#### `library_page.dart`
المكتبة الشخصية:
- تبويب المفضلات
- تبويب سجل المشاهدة
- عرض التقدم

#### `settings_page.dart`
الإعدادات:
- تبديل اللغة
- تبديل المظهر
- معلومات التطبيق
- اسم المطور

#### `addon_detail_page.dart`
تفاصيل الإضافة:
- الشعار
- الاسم والإصدار
- رابط البيان
- معرف الإضافة
- تاريخ التثبيت

#### `video_player_page.dart`
مشغل الفيديو:
- عرض الفيديو مع BetterPlayer
- اختيار الترجمات
- تحكم السرعة
- تخطي المقدمة
- معايرة الترجمات

#### `media_detail_page.dart` (قيد الإنشاء)
سيحتوي على:
- الملصق والخلفية
- الملخص الكامل
- الممثلون والمخرج
- الحلقات (للمسلسلات)
- أزرار التشغيل والمفضلات

### `lib/presentation/widgets/`

#### `bottom_nav_bar.dart`
شريط التنقل السفلي:
- Home
- Addons
- Library
- Settings

### `lib/presentation/providers/`

#### `app_providers.dart`
**Riverpod Providers للتطبيق**

```dart
// Service Providers
addonServiceProvider         → instance واحد من AddonService
localStorageProvider        → instance واحد من LocalStorageService

// State Providers
installedAddonsProvider     → StateNotifier<List<InstalledAddon>>
themeModeProvider          → StateNotifier<String>
languageProvider           → StateNotifier<String>
```

#### `library_providers.dart`
**Riverpod Providers للمكتبة**

```dart
watchHistoryProvider       → StateNotifier<List<WatchHistoryItem>>
favoritesProvider          → StateNotifier<List<String>>
```

## 🔄 تدفق البيانات

```
User Action (Click Button)
        ↓
Widget Listens to Provider
        ↓
Provider Calls Service Method
        ↓
Service Fetches Data (HTTP/Local)
        ↓
Parse Response to Model
        ↓
Update Provider State
        ↓
Widget Rebuilds with New Data
```

## 🔌 كيفية إضافة ميزة جديدة

### مثال: إضافة ميزة البحث

1. **أضف في Provider** (`app_providers.dart`):
```dart
final searchQueryProvider = StateProvider<String>((ref) => '');
```

2. **أنشئ Notifier**:
```dart
final searchResultsProvider = FutureProvider((ref) async {
  final query = ref.watch(searchQueryProvider);
  // منطق البحث
});
```

3. **استخدم في Widget**:
```dart
final results = ref.watch(searchResultsProvider);
```

## 🧪 اختبار الأجزاء

### اختبار AddonService:
```dart
test('fetchManifest returns valid manifest', () async {
  final service = AddonService();
  final manifest = await service.fetchManifest(validUrl);
  expect(manifest.id, isNotEmpty);
});
```

### اختبار Storage:
```dart
test('saveAddon persists data', () async {
  final storage = LocalStorageService();
  await storage.saveAddon(testAddon);
  final retrieved = storage.getAddon(testAddon.id);
  expect(retrieved?.name, testAddon.name);
});
```

## 🚀 الأداء والتحسينات

1. **التخزين المؤقت**: تخزين الميتا البيانات
2. **التحميل الكسول**: تحميل الصور عند الحاجة
3. **إعادة الاستخدام**: استخدام `cached_network_image`
4. **الحد من إعادة البناء**: استخدام Riverpod بكفاءة
5. **Obfuscation**: حماية الكود مع ProGuard

---

**للمزيد من المعلومات، راجع الملفات الأخرى في المشروع!**
