---
name: Production Configuration
description: Production-ready config details for Kisaan Saathi Flutter app
type: project
---

App is "किसान साथी" (Kisaan Saathi) - Flutter agricultural app for Indian farmers.

**Production changes made (2026-04-23):**
- Android app label: "किसान साथी"
- Android applicationId: "com.kisansaathi.app" (namespace still com.example.indian_farmer)
- Android release keystore: android/upload-keystore.jks (PKCS12, alias: kisansaathi)
- Android key.properties: android/key.properties (gitignored)
- Android ProGuard: android/app/proguard-rules.pro (minify + shrink enabled for release)
- iOS CFBundleDisplayName: "किसान साथी"
- iOS CFBundleName: "kisansaathi"
- iOS NSAllowsArbitraryLoads: false (wttr.in exception added)
- iOS camera/mic usage descriptions in Hindi
- Google Fonts allowRuntimeFetching: false
- pubspec description: proper Hindi description

**Why:** User requested 100% production readiness.
**How to apply:** When suggesting build commands, use `flutter build appbundle --release` for Play Store or `flutter build apk --release` for direct APK.
