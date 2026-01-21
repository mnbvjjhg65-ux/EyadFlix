# 🔌 دليل API البرامج الإضافية

## مقدمة

هذا الدليل يشرح كيفية استخدام خدمة البرامج الإضافية (AddonService) للتفاعل مع بروتوكول Stremio.

## الدوال الأساسية

### 1. جلب بيانات البرنامج (fetchManifest)

**الوصف**: جلب معلومات البرنامج الإضافي مثل الاسم والإصدار والفهارس المدعومة.

```dart
final service = AddonService();

try {
  final manifest = await service.fetchManifest(
    'https://torrentio.strem.fun/manifest.json'
  );
  
  print('اسم البرنامج: ${manifest.name}');
  print('الإصدار: ${manifest.version}');
  print('الفهارس: ${manifest.catalogs.length}');
} on NetworkException catch (e) {
  print('خطأ الشبكة: ${e.message}');
} on AddonException catch (e) {
  print('خطأ البرنامج: ${e.message}');
}
```

**القيم المرجعة**:
```dart
AddonManifest(
  id: 'org.stremio.torrentio',
  name: 'Torrentio',
  version: '1.0.0',
  description: 'فهرس التورنت',
  catalogs: [CatalogItem(...)],
  resources: [ResourceItem(...)],
)
```

---

### 2. جلب الفهرس (fetchCatalog)

**الوصف**: جلب قائمة المحتوى من الفهرس المحدد مع إمكانية التصفية والبحث.

```dart
final service = AddonService();

try {
  final catalog = await service.fetchCatalog(
    url: 'https://torrentio.strem.fun/manifest.json',
    type: ContentType.movie,           // movie أو series
    catalogId: 'torrentio_movies',     // معرف الفهرس
    extra: {
      'search': 'عنوان الفيلم',       // اختياري: البحث
      'genre': 'action',               // اختياري: النوع
      'skip': '0',                     // اختياري: الترقيم
    },
  );
  
  for (var media in catalog) {
    print('${media.name} (${media.year})');
    print('الملصق: ${media.poster}');
  }
} on NetworkException catch (e) {
  print('خطأ: ${e.message}');
}
```

**معاملات الفهرس (Extra)** الشائعة:
- `search`: البحث حسب الاسم
- `genre`: التصفية حسب النوع
- `skip`: الترقيم (للصفحات)
- `sort`: الترتيب

---

### 3. جلب تفاصيل المحتوى (fetchMeta)

**الوصف**: جلب معلومات مفصلة عن فيلم أو مسلسل معين.

```dart
final service = AddonService();

try {
  final meta = await service.fetchMeta(
    url: 'https://torrentio.strem.fun/manifest.json',
    type: ContentType.movie,
    mediaId: 'tt1234567',  // معرف IMDb أو معرف فريد
  );
  
  print('الاسم: ${meta.name}');
  print('السنة: ${meta.year}');
  print('الملخص: ${meta.description}');
  print('الممثلون: ${meta.cast}');
  print('المخرج: ${meta.director}');
  print('التقييم: ${meta.imdbRating}');
  
  // إذا كان مسلسلاً
  if (meta.videos != null && meta.videos!.isNotEmpty) {
    print('عدد الحلقات: ${meta.videos!.length}');
  }
} on NetworkException catch (e) {
  print('خطأ الاتصال: ${e.message}');
}
```

**البيانات المرجعة**:
```dart
MetaModel(
  id: 'tt1234567',
  name: 'اسم الفيلم',
  year: '2024',
  description: 'الملخص',
  poster: 'URL الملصق',
  background: 'URL الخلفية',
  cast: ['الممثل 1', 'الممثل 2'],
  director: 'اسم المخرج',
  imdbRating: '8.5',
  videos: [VideoInfo(...)],  // للمسلسلات فقط
)
```

---

### 4. جلب مصادر التشغيل (fetchStreams)

**الوصف**: جلب روابط التشغيل (فيديو) للمحتوى.

```dart
final service = AddonService();

try {
  final streams = await service.fetchStreams(
    url: 'https://torrentio.strem.fun/manifest.json',
    type: ContentType.movie,
    mediaId: 'tt1234567',
    videoId: 'tt1234567',  // معرف الفيديو (نفس المحتوى للأفلام)
  );
  
  for (var stream in streams) {
    print('المصدر: ${stream.name ?? "بدون اسم"}');
    print('الرابط: ${stream.url ?? stream.magnet}');
    print('الجودة: ${stream.title}');
    
    // اختيار أول مصدر متاح
    if (stream.url != null) {
      print('سيتم تشغيل: ${stream.url}');
      break;
    }
  }
} on NetworkException catch (e) {
  print('خطأ: ${e.message}');
}
```

**أنواع مصادر التشغيل**:
- **HTTP**: `stream.url` - رابط مباشر
- **BitTorrent**: `stream.torrent` - ملف تورنت
- **Magnet**: `stream.magnet` - رابط Magnet

---

### 5. جلب الترجمات (fetchSubtitles)

**الوصف**: جلب ملفات الترجمة بلغات مختلفة.

```dart
final service = AddonService();

try {
  final subtitles = await service.fetchSubtitles(
    url: 'https://torrentio.strem.fun/manifest.json',
    type: ContentType.movie,
    mediaId: 'tt1234567',
    videoId: 'tt1234567',
  );
  
  for (var subtitle in subtitles) {
    print('اللغة: ${subtitle.language}');
    print('الملف: ${subtitle.url}');
    
    // تجميع حسب اللغة
    if (subtitle.language == 'ar') {
      print('✓ ترجمة عربية متوفرة');
    }
  }
} on NetworkException catch (e) {
  print('خطأ: ${e.message}');
}
```

**صيغ الترجمة المدعومة**:
- VTT (Video Text Tracks)
- SRT (SubRip)
- ASS (Advanced SubStation Alpha)

---

## الاستخدام المتقدم

### دمج كامل مع الواجهة

```dart
// في صفحة تفاصيل المحتوى
class MediaDetailPage extends ConsumerWidget {
  final String addonUrl;
  final String mediaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.read(addonServiceProvider);
    
    return FutureBuilder<MetaModel>(
      future: service.fetchMeta(
        url: addonUrl,
        type: ContentType.movie,
        mediaId: mediaId,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(child: Text('خطأ: ${snapshot.error}'));
        }
        
        final meta = snapshot.data!;
        
        return SingleChildScrollView(
          child: Column(
            children: [
              // الخلفية
              Image.network(meta.background ?? '', fit: BoxFit.cover),
              
              // المعلومات
              Text(meta.name),
              Text(meta.description ?? ''),
              
              // الترجمات والتشغيل
              ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text('تشغيل'),
                onPressed: () => _playStream(context, addonUrl, mediaId),
              ),
            ],
          ),
        );
      },
    );
  }
  
  void _playStream(BuildContext context, String addonUrl, String mediaId) async {
    final service = AddonService();
    final streams = await service.fetchStreams(
      url: addonUrl,
      type: ContentType.movie,
      mediaId: mediaId,
    );
    
    if (streams.isNotEmpty) {
      Navigator.pushNamed(
        context,
        '/player',
        arguments: {'stream': streams.first, 'mediaId': mediaId},
      );
    }
  }
}
```

---

## معالجة الأخطاء

```dart
try {
  // أي عملية
} on NetworkException catch (e) {
  // خطأ الشبكة - تحقق من الاتصال
  print('فشل الاتصال: ${e.message}');
} on AddonException catch (e) {
  // خطأ البرنامج - البرنامج غير متوافق
  print('خطأ البرنامج: ${e.message}');
} on CacheException catch (e) {
  // خطأ في التخزين المؤقت
  print('خطأ التخزين: ${e.message}');
} on ParseException catch (e) {
  // خطأ في تحليل البيانات
  print('خطأ التحليل: ${e.message}');
} on TimeoutException catch (e) {
  // انتهاء المهلة الزمنية
  print('انتهت مهلة الانتظار');
}
```

---

## البرامج الإضافية الموصى بها

### للأفلام والمسلسلات:

| البرنامج | الرابط | الميزات |
|---------|--------|--------|
| Torrentio | https://torrentio.strem.fun/manifest.json | أفضل مصادر التورنت |
| Cinemeta | https://v3-cinemeta.strem.fun/manifest.json | بيانات IMDb الغنية |
| OpenSubtitles | https://opensubtitles-repro.strem.fun/manifest.json | ترجمات متعددة |

---

## ملاحظات مهمة

⚠️ **التوافقية**:
- ليس كل البرامج تدعم جميع الميزات
- تحقق دائماً من دعم `ContentType` (movie أو series)

⚠️ **الأداء**:
- استخدم التخزين المؤقت (Hive) لتقليل الطلبات
- حدد مهلة زمنية معقولة (30 ثانية افتراضياً)

⚠️ **الشرعية**:
- استخدم البرامج الشرعية فقط
- احترم حقوق النشر والملكية الفكرية

---

**آخر تحديث**: 2024
**الإصدار**: 1.0.0
