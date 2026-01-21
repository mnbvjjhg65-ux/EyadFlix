# ProGuard/R8 configuration for EyadFlix

# Flutter app
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# Hive ORM
-keep class com.example.** { *; }
-keep class * extends com.example.hive.** { *; }
-keep @com.hive.annotations.HiveType class * { *; }
-keepclassmembers class * extends com.hive.** {
  *;
}

# JSON Serialization (json_serializable)
-keepclassmembers class ** {
  *** fromJson(Map);
}

# Dio HTTP Client
-dontwarn org.apache.http.**
-dontwarn android.net.http.**
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**

# Retrofit
-keepattributes Signature
-keepattributes *Annotation*
-keep class retrofit2.** { *; }
-dontwarn retrofit2.**

# Model classes
-keepclassmembers class com.eyadflix.** { *; }

# Keep all custom application classes
-keep class com.eyadflix.** { *; }

# Remove debug logs
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}
