# Flutter wrapper
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }

# Keep speech_to_text plugin
-keep class com.csdcorp.speech_to_text.** { *; }

# Keep url_launcher plugin
-keep class io.flutter.plugins.urllauncher.** { *; }

# Keep shared_preferences plugin
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# Keep http/network classes
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn okhttp3.**
-dontwarn okio.**

# Dart/Flutter obfuscation safe rules
-keep class com.google.** { *; }
