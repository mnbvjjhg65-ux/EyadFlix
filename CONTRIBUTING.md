# 🚀 دليل المساهمة والتطوير المتقدم

## أضفة ميزة جديدة

### مثال 1: إضافة صفحة جديدة

#### الخطوة 1: إنشاء ملف الصفحة

```dart
// lib/presentation/pages/new_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

class NewPage extends ConsumerWidget {
  const NewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // استخدام الموفرين
    final theme = ref.watch(themeModeProvider);
    final language = ref.watch(languageProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('newPage.title').tr(),
      ),
      body: Center(
        child: Text('محتوى جديد'),
      ),
    );
  }
}
```

#### الخطوة 2: إضافة الترجمات

```json
// assets/translations/ar.json
{
  "newPage": {
    "title": "صفحة جديدة"
  }
}

// assets/translations/en.json
{
  "newPage": {
    "title": "New Page"
  }
}
```

#### الخطوة 3: تحديث التنقل

```dart
// lib/presentation/pages/home_page.dart

// أضف الصفحة الجديدة إلى TabBar
TabBar(
  tabs: [
    // ...
    const Tab(icon: Icon(Icons.new_icon), text: 'جديد'),
  ],
),
```

---

### مثال 2: إضافة موفر حالة جديد

```dart
// lib/presentation/providers/custom_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

// حالة بسيطة
final myStateProvider = StateProvider<String>((ref) => 'القيمة الافتراضية');

// حالة معقدة مع StateNotifier
class MyStateNotifier extends StateNotifier<List<String>> {
  MyStateNotifier() : super([]);
  
  void addItem(String item) {
    state = [...state, item];
  }
  
  void removeItem(String item) {
    state = state.where((e) => e != item).toList();
  }
}

final myListProvider = StateNotifierProvider<MyStateNotifier, List<String>>(
  (ref) => MyStateNotifier(),
);

// استخدام في الصفحة
class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(myListProvider);
    
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(items[index]),
          onTap: () {
            ref.read(myListProvider.notifier).removeItem(items[index]);
          },
        );
      },
    );
  }
}
```

---

### مثال 3: إضافة خدمة جديدة

```dart
// lib/services/custom_service.dart

import 'package:dio/dio.dart';
import '../core/constants/app_constants.dart';
import '../core/errors/exceptions.dart';

class CustomService {
  final Dio _dio;
  
  CustomService(this._dio);
  
  Future<String> fetchData(String url) async {
    try {
      final response = await _dio.get(
        url,
        options: Options(
          connectTimeout: const Duration(seconds: 30),
        ),
      );
      
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw AddonException('فشل الطلب');
      }
    } on DioException catch (e) {
      throw NetworkException(e.message ?? 'خطأ شبكة');
    } catch (e) {
      throw ParseException('خطأ في التحليل');
    }
  }
}
```

#### تسجيل الخدمة في الموفرين

```dart
// lib/presentation/providers/app_providers.dart

final customServiceProvider = Provider<CustomService>((ref) {
  final dio = Dio();
  return CustomService(dio);
});
```

---

## أفضل الممارسات

### 1. فصل المخاوف (Separation of Concerns)

```dart
// ✅ صحيح: كل طبقة لها مسؤولية واحدة

// Data Layer
class UserRepository {
  Future<User> fetchUser(String id) async {
    // جلب البيانات
  }
}

// Domain Layer
class GetUserUseCase {
  final UserRepository repository;
  
  Future<User> call(String id) async {
    // منطق الأعمال
    return repository.fetchUser(id);
  }
}

// Presentation Layer
class UserPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // عرض فقط
    final user = ref.watch(userProvider);
    return Text(user.name);
  }
}
```

### 2. معالجة الأخطاء بشكل صحيح

```dart
// ✅ صحيح: معالجة محددة لكل نوع خطأ

try {
  final data = await service.fetchData();
  // نجح
} on NetworkException catch (e) {
  // أخطاء الشبكة
  showErrorDialog(context, 'تحقق من الاتصال');
} on TimeoutException catch (e) {
  // انتهاء المهلة
  showErrorDialog(context, 'انتهت مهلة الانتظار');
} on ParseException catch (e) {
  // أخطاء التحليل
  showErrorDialog(context, 'بيانات غير صالحة');
}
```

### 3. استخدام const حيثما أمكن

```dart
// ✅ صحيح
class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 100,
      height: 100,
      child: Center(
        child: Text('محتوى'),
      ),
    );
  }
}
```

### 4. استخدام Null Safety

```dart
// ✅ صحيح
String? name;
int? age;

// استخدام آمن
final displayName = name ?? 'بدون اسم';
age?.toStringAsFixed(0);
```

---

## اختبار الميزات الجديدة

### اختبار وحدة (Unit Test)

```dart
// test/services/addon_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('AddonService', () {
    late AddonService service;
    late MockDio mockDio;
    
    setUp(() {
      mockDio = MockDio();
      service = AddonService(mockDio);
    });
    
    test('fetchManifest يعيد البيانات بنجاح', () async {
      // جهز
      when(mockDio.get(any)).thenAnswer(
        (_) async => Response(
          data: {'name': 'Test'},
          statusCode: 200,
          requestOptions: RequestOptions(path: 'test'),
        ),
      );
      
      // نفذ
      final result = await service.fetchManifest('test_url');
      
      // تحقق
      expect(result.name, 'Test');
    });
  });
}
```

### اختبار واجهة (Widget Test)

```dart
// test/pages/home_page_test.dart

void main() {
  testWidgets('الصفحة الرئيسية تعرض 4 تبويبات', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: EyadFlixApp(),
      ),
    );
    
    // تحقق من وجود 4 تبويبات
    expect(find.byType(Tab), findsWidgets);
  });
}
```

---

## تحسين الأداء

### 1. استخدام التخزين المؤقت

```dart
// ✅ جيد: تخزين النتائج مؤقتاً

final cachedAddonsProvider = FutureProvider<List<AddonManifest>>((ref) async {
  final service = ref.watch(addonServiceProvider);
  
  // الفحص الأول: Hive
  final cached = await ref.watch(localStorageProvider).getAllAddons();
  if (cached.isNotEmpty) {
    return cached;
  }
  
  // الفحص الثاني: API
  final fresh = await Future.wait([
    service.fetchManifest(url1),
    service.fetchManifest(url2),
  ]);
  
  // حفظ للمرة القادمة
  for (var addon in fresh) {
    await ref.watch(localStorageProvider).saveAddon(addon);
  }
  
  return fresh;
});
```

### 2. التحميل الكسول (Lazy Loading)

```dart
// ✅ جيد: تحميل البيانات حسب الحاجة

class CatalogPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        // تحميل عند الحاجة
        final mediaAsync = ref.watch(
          catalogItemProvider(index),
        );
        
        return mediaAsync.when(
          data: (media) => MediaCard(media: media),
          loading: () => const ShimmerCard(),
          error: (err, st) => const ErrorCard(),
        );
      },
    );
  }
}
```

---

## الأدوات المساعدة

### تنسيق الكود

```bash
# تنسيق جميع الملفات
dart format lib/

# التحقق من المشاكل
dart analyze
```

### إنشاء بناء الإصدار

```bash
# تنظيف وإعادة بناء
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# بناء APK للإصدار
flutter build apk --release

# بناء App Bundle
flutter build appbundle --release
```

---

## التصحيح

### استخدام Flutter DevTools

```bash
flutter pub global activate devtools
devtools
```

### الطباعة والتسجيل

```dart
// تسجيل معلومات للتصحيح
developer.log('رسالة تصحيح', name: 'MyApp');

// طباعة في وحدة التحكم
print('معلومات: $data');

// استخدام debugPrint
debugPrint('رسالة تصحيح');
```

---

## الخطوات التالية

1. ✅ افهم بنية المشروع
2. ✅ ادرس الكود الموجود
3. ✅ اختبر التغييرات محلياً
4. ✅ اتبع معايير الكود
5. ✅ وثق التغييرات

---

**تم التحديث**: 2024
**الإصدار**: 1.0.0
