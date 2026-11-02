# M&F — Sexual & Mental Wellness

Existing Flutter project, implemented with native Flutter Material 3 widgets.
Hindi is the default; the top language selector switches the interface to English.
No login, phone number, OTP, WebView, backend or provider keys are required.

## Implemented demo

Home, four-step concern selection, text chat with fixed explicitly labeled demo replies,
Android system photo selection, Android voice-to-text with privacy notice, deletion
confirmation, doctor/date/time selection, sharing previews at both ends of chat,
local appointment drafts, store, removable kit, order preview, care status, ratings,
FAQ and video-topic text previews. Video streaming is not integrated.

Doctor identities, qualifications, fees and schedules are fictional samples. Bundled
photographs are AI-generated fictional demo assets. Product prices are examples.
No prescriptions are issued; no orders, appointments, payments or shared messages
are submitted. The interface explicitly states these limits.

## Architecture and privacy

- `lib/data/demo_repository.dart`: models, repository contract and sample catalog.
- `lib/services/chat_service.dart`: injectable backend-ready contract and fixed demo.
- `lib/services/device_service.dart`: native Android channel for photo/speech intents.
- `android/app/src/main/kotlin/com/yankeessoftware/mf_customer/MainActivity.kt`:
  Android picker/speech bridge, cancellation and errors, bounded 8 MB photo reads.
- `lib/main.dart`: bilingual presentation and session-only state.

All app data lives in memory and is discarded when the app process ends. Backgrounding
alone does not erase it. Delete conversation clears session chat/photos/topics, not
original photos in the device library. There is no app file persistence or upload.
Android speech recognition requests offline mode, but the device provider can still
process audio remotely; availability and behavior depend on the device. Recognition
fills the editable composer and never automatically sends the transcript.

Real mobile API/auth, secure backend chat, booking, prescriptions, order tracking,
payments and video streaming remain pending. Existing Sites ChatGPT browser sign-in
is not native mobile authentication and is not connected here. Future provider keys
must remain on the backend, never in the app, assets or local storage.

## Verification

Run `flutter analyze`, `flutter test`, then `flutter build apk --debug`.
Expected APK output after a successful build:
`build/app/outputs/flutter-apk/app-debug.apk`.

The replacement smoke test covers language switching, taxonomy, demo messages,
delete confirmation and local kit/order previews. Native photo/speech requires
an Android device or emulator with an installed recognition service.

Earlier note: a debug APK was later built successfully on the developer Mac.

## Changes (2026-10-18 review)

- Tele-MANAS 14416 / emergency 112 helpline card on Home and Chat.
- Doctor date picker starts today; past time slots are hidden.
- My Kit keeps quantities (+/−) and the order preview totals them.
- Bottom bar highlights the related tab on My Kit / Rating / Videos / FAQ.
- `allowBackup="false"`; Android 11+ `<queries>` for speech and photo intents.
- Release signing reads `android/key.properties`; without it release falls back
  to debug keys (do not upload that build to Play Store).
