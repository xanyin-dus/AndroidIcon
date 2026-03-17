# Android Theme Studio

A beautiful Android 15 theme customization app built with Flutter.

## Features

- **Icon Beautification**: Customize app icons with various styles
- **Charging Animation**: Beautiful charging display animations
- **Dynamic Wallpaper**: Animated and interactive wallpapers
- **System Theming**: Customize colors, fonts, and shapes

## Getting Started

### Prerequisites

1. Install Flutter SDK: https://flutter.dev/docs/get-started/install
2. Install Android Studio
3. Set up Android SDK

### Installation

```bash
# Clone or download the project
cd android_theme_studio

# Get dependencies
flutter pub get

# Run the app
flutter run

# Build APK
flutter build apk --release
```

### Build Release APK

```bash
flutter build apk --release
```

The APK will be generated at: `build/app/outputs/flutter-apk/app-release.apk`

## Project Structure

```
android_theme_studio/
├── lib/
│   ├── main.dart
│   ├── models/
│   ├── providers/
│   ├── screens/
│   └── widgets/
├── android/
├── assets/
│   ├── images/
│   ├── animations/
│   └── icons/
└── pubspec.yaml
```

## Tech Stack

- Flutter 3.x
- Dart
- Provider for state management
- flutter_animate for animations
- Google Fonts

## License

MIT License
