#!/bin/bash
# M&F: analyze, test, build debug APK, and install on a connected Android phone.
set -e
cd "$(dirname "$0")"
echo "== flutter pub get";        flutter pub get
echo "== flutter analyze";        flutter analyze
echo "== flutter test";           flutter test
echo "== flutter build apk";      flutter build apk --debug
APK=build/app/outputs/flutter-apk/app-debug.apk
echo "APK ready: $(pwd)/$APK"
if command -v adb >/dev/null && adb devices | grep -q "device$"; then
  echo "== installing on phone"; adb install -r "$APK"
  adb shell monkey -p com.yankeessoftware.mf_customer -c android.intent.category.LAUNCHER 1 >/dev/null
  echo "App phone par khul gaya."
else
  echo "Phone USB se nahi juda (ya USB debugging band). APK upar wale path se install karein."
fi
