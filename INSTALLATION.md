# EyadFlix - متطلبات النظام والتثبيت

## متطلبات النظام

### للتطوير
- **Flutter SDK**: 3.0.0 أو أحدث
  ```bash
  flutter --version
  ```

- **Dart SDK**: 3.0.0 أو أحدث (يأتي مع Flutter)
  ```bash
  dart --version
  ```

- **Android SDK**: API 21 (أو أعلى)
  - استخدم Android Studio أو Command Line Tools

- **Java**: OpenJDK 11+
  ```bash
  java -version
  ```

- **Gradle**: 7.0+ (يُدار تلقائياً)

### للأجهزة المستهدفة
- **الحد الأدنى Android**: 5.0 (API 21)
- **Android المستهدف**: 13+ (API 33+)
- **الذاكرة**: 512MB على الأقل
- **التخزين**: 100MB مساحة حرة

## خطوات التثبيت

### 1. تثبيت Flutter (إذا لم يكن مثبتاً)

```bash
# Clone Flutter Repository
git clone https://github.com/flutter/flutter.git -b stable

# أضف إلى PATH
export PATH="$PATH:`pwd`/flutter/bin"

# التحقق من التثبيت
flutter doctor
```

### 2. إعداد بيئة Android

```bash
# افتح Android Studio وثبت:
# - Android SDK Platform 33
# - Android SDK Build-Tools 34.0.0
# - Android Emulator
# - Android SDK Command-line Tools
```

### 3. استنساخ المشروع

```bash
git clone <repository-url>
cd EyadFlix
```

### 4. تثبيت المكتبات

```bash
flutter pub get
```

### 5. إنشاء الأكواد المولدة

```bash
# JSON Serialization و Hive Adapters
flutter pub run build_runner build --delete-conflicting-outputs
```

## تشغيل التطبيق

### على محاكي أو جهاز حقيقي

```bash
# تشغيل Debug
flutter run

# تشغيل Release (على جهاز متصل فقط)
flutter run --release
```

## بناء APK

### APK Debug
```bash
flutter build apk --debug
```

الملف: `build/app/outputs/apk/debug/app-debug.apk`

### APK Release
```bash
flutter build apk --release
```

الملف: `build/app/outputs/apk/release/app-release.apk`

### Split APKs (حسب بنية المعالج)
```bash
flutter build apk --release --split-per-abi
```

الملفات:
- `app-armeabi-v7a-release.apk`
- `app-arm64-v8a-release.apk`
- `app-x86-release.apk`
- `app-x86_64-release.apk`

## إعداد الحقيقي والتوقيع

### 1. إنشاء مفتاح التوقيع

```bash
# إنشاء المفتاح
keytool -genkey -v -keystore ~/eyadflix-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias eyadflix

# سيُطلب منك:
# - كلمة مرور المستودع
# - كلمة المرور الشخصية
# - اسم المالك/الشركة
# - المدينة/الموقع
# - الولاية/المقاطعة
# - رمز الدولة
```

### 2. إعداد ملف المفاتيح

أنشئ `android/key.properties`:
```properties
storeFile=/path/to/eyadflix-key.jks
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=eyadflix
```

### 3. تحديث build.gradle

تم تعديل `android/app/build.gradle` بالفعل. تحقق من أنه يحتوي على:

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

signingConfigs {
    release {
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword']
        storeFile file(keystoreProperties['storeFile'])
        storePassword keystoreProperties['storePassword']
    }
}

buildTypes {
    release {
        signingConfig signingConfigs.release
        minifyEnabled true
        shrinkResources true
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
    }
}
```

## اختبار التطبيق

### على جهاز حقيقي
```bash
# توصيل الجهاز عبر USB
adb devices

# التشغيل
flutter run
```

### على محاكي
```bash
# بدء محاكي
flutter emulators --launch <emulator-name>

# أو من Android Studio

# التشغيل
flutter run
```

## الأوامر المهمة

```bash
# تحديث المكتبات
flutter pub upgrade

# تنظيف المشروع
flutter clean

# إعادة بناء المشروع
flutter pub run build_runner build --delete-conflicting-outputs

# فحص التحليل
flutter analyze

# تشغيل الاختبارات (عند توفرها)
flutter test

# حذف البيانات المخزنة محلياً
flutter run --dev-time-zone=UTC
```

## معالجة المشاكل

### المشكلة: SDK path not found
```bash
# الحل: إعداد ANDROID_HOME
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator
```

### المشكلة: Build fails with Gradle error
```bash
flutter clean
rm -rf build/
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter build apk --release
```

### المشكلة: Hive adapter not found
```bash
# تأكد من تشغيل build_runner:
flutter pub run build_runner build --delete-conflicting-outputs

# قد تحتاج إلى:
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### المشكلة: الإضافات لا تحمل
1. تحقق من الاتصال بالإنترنت
2. اختبر رابط البيان مباشرة في المتصفح
3. تحقق من سجلات Flutter:
   ```bash
   flutter run -v  # وضع تفصيلي
   ```

## الملفات المهمة

| الملف | الوصف |
|------|-------|
| `pubspec.yaml` | المكتبات والمواد |
| `android/app/build.gradle` | إعدادات Android |
| `android/app/AndroidManifest.xml` | البيانات الوصفية للتطبيق |
| `lib/main.dart` | نقطة الدخول |
| `lib/services/addon_service.dart` | معالج البروتوكول |
| `assets/translations/*.json` | الترجمات |

## الخطوات التالية

1. اختبر التطبيق على الأجهزة الحقيقية
2. اختبر الإضافات المختلفة
3. أضف صور وأيقونات التطبيق
4. جهز للنشر على Google Play

---

**مُنشأ بواسطة**: Eyad AI Juhani
