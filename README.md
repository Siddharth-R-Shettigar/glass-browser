# Glass Browser - iOS-Style Browser with Liquid Glass UI

A beautiful, modern Android browser featuring iOS 16+ design language with liquid glass effects, smooth animations, and minimalist interface.

## ✨ Features

### 🎨 Design
- **Liquid Glass Effects** - Glassmorphism with blur, refraction, and edge reflections
- **iOS-Style UI** - Rounded corners, smooth animations, modern aesthetics
- **Pill-Shaped Search Bar** - Large, prominent search with AI mode and voice search
- **Gesture-Based Navigation** - Swipe down to dismiss panels, natural interactions
- **Bottom Navigation Bar** - Quick access to tabs, new tab, and menu

### 🚀 Functionality
- **WebView Integration** - Full browsing capability using Chromium engine
- **Recent Searches** - Quick access to search history in dropdown panel
- **Tab Management** - iOS-style card-based tab switcher
- **Incognito Mode** - Private browsing support
- **Smart Menu** - Comet-style button grid for common actions
- **Comprehensive Settings** - Featured quick settings + detailed options

## 📱 Screenshots

[Your screenshots will go here]

## 🛠️ Setup Instructions

### Prerequisites
- Android Studio (latest version)
- Flutter SDK 3.0.0 or higher
- Android SDK (API level 21+)
- A physical Android device or emulator

### Installation Steps

#### 1. Install Flutter
```bash
# Download Flutter from https://flutter.dev/docs/get-started/install
# Add Flutter to your PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor
```

#### 2. Set Up Android Studio
- Download and install Android Studio
- Install Android SDK and Android SDK Platform-Tools
- Set up an Android emulator or connect a physical device

#### 3. Clone/Download the Project
- Place the `browser_app` folder in your desired location

#### 4. Install Dependencies
```bash
cd browser_app
flutter pub get
```

#### 5. Configure Android Permissions
The app needs internet permission. This is already configured in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

#### 6. Run the App
```bash
# List available devices
flutter devices

# Run on connected device/emulator
flutter run

# Or run in release mode for better performance
flutter run --release
```

### Building APK
```bash
# Build release APK
flutter build apk --release

# APK will be located at: build/app/outputs/flutter-apk/app-release.apk
```

## 🎯 How to Use

### Main Interface
1. **Launch App** - Opens with search panel and keyboard automatically
2. **Search/Enter URL** - Type in the large search bar at top
3. **Voice Search** - Tap microphone icon
4. **AI Mode** - Tap the "AI" button for Google AI search
5. **Recent Searches** - Tap any recent search to reopen

### Navigation
- **Swipe Down** on search panel to dismiss and view current website
- **Tap + Button** in bottom bar to open new search
- **Tabs Button** - View and manage all open tabs (iOS-style cards)
- **Menu Button** - Access quick actions and settings

### Tabs
- View all tabs in grid layout (like iOS multitasking)
- Swipe to close individual tabs
- Switch between Regular and Incognito modes
- Tap + to create new tab

### Settings
- **Quick Access** cards for frequently used settings
- Organized sections: Privacy, Appearance, Advanced
- History and Bookmarks accessible from quick cards

## 🧩 Project Structure

```
browser_app/
├── lib/
│   ├── main.dart                 # App entry point, main browser logic
│   └── screens/
│       ├── search_panel.dart     # Liquid glass search panel
│       ├── tabs_view.dart        # iOS-style tab switcher
│       ├── settings_view.dart    # Settings with featured cards
│       └── browser_view.dart     # Browser view component
├── pubspec.yaml                  # Dependencies
└── README.md                     # This file
```

## 🎨 Customization

### Colors & Theme
Edit `main.dart` to change color scheme:
```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: Colors.blue,  // Change this to your preferred color
  brightness: Brightness.light,
)
```

### Search Engine
Currently uses Google. To change, modify `_openUrl()` in `main.dart`:
```dart
url = 'https://www.bing.com/search?q=${Uri.encodeComponent(query)}';
```

### Glass Effect Intensity
Adjust blur values in `search_panel.dart`:
```dart
BackdropFilter(
  filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),  // Adjust these values
  ...
)
```

## 🐛 Troubleshooting

### Common Issues

**Issue: "Flutter command not found"**
- Solution: Add Flutter to your PATH and restart terminal

**Issue: WebView not loading**
- Solution: Ensure internet permission is in AndroidManifest.xml
- Check device/emulator has internet connection

**Issue: UI looks different than expected**
- Solution: Run in release mode: `flutter run --release`
- Some effects perform better on physical devices

**Issue: Glassmorphism not showing**
- Solution: Update to latest Flutter version
- Ensure running on Android 10+ for best effects

## 📦 Dependencies

- `webview_flutter` - Web page rendering
- `glassmorphism` - Glass effects and blur
- `url_launcher` - Opening external links
- `shared_preferences` - Storing user preferences

## 🚧 Future Enhancements

- [ ] Download manager
- [ ] Bookmarks sync
- [ ] Reading mode
- [ ] Dark mode auto-switch
- [ ] Custom search engines
- [ ] Extensions support
- [ ] Tab groups
- [ ] Password manager integration

## 💡 Tips for Best Experience

1. **Use on Android 10+** for best visual effects
2. **Enable GPU acceleration** in developer options
3. **Test on real device** for accurate performance
4. **Close unused tabs** to improve performance on older devices

## 📄 License

This is a demonstration project. Modify and use as you see fit.

## 🤝 Contributing

Feel free to fork, improve, and share!

---

**Built with Flutter 💙 | Designed for Android 🤖**
