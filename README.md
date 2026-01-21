# 🎬 EyadFlix - Modern Stremio Addon-Based Streaming App

A professional Flutter-based Android application that implements the full Stremio Addon Protocol, allowing users to stream content seamlessly using existing Stremio ecosystem addons without any modifications.

---

## 🔗 Account & Links

### 👤 Developer Account
- **GitHub**: [@mnbvjjhg65-ux](https://github.com/mnbvjjhg65-ux)
- **Repository**: [EyadFlix](https://github.com/mnbvjjhg65-ux/EyadFlix)

### 📱 Download & Access
| Platform | Link |
|----------|------|
| **GitHub Releases** | [v1.0.0 Release](https://github.com/mnbvjjhg65-ux/EyadFlix/releases) |
| **GitHub Pages (AR)** | [Download Arabic](https://mnbvjjhg65-ux.github.io/EyadFlix/download.html) |
| **GitHub Pages (EN)** | [Download English](https://mnbvjjhg65-ux.github.io/EyadFlix/download-en.html) |
| **Direct APK** | [EyadFlix v1.0.0.apk](https://github.com/mnbvjjhg65-ux/EyadFlix/releases/download/v1.0.0/EyadFlix-v1.0.0.apk) |

### 📚 Documentation
| Document | Purpose |
|----------|---------|
| [START_HERE.md](START_HERE.md) | Quick start guide ⭐ |
| [QUICKSTART.md](QUICKSTART.md) | 5-minute setup |
| [INSTALLATION.md](INSTALLATION.md) | Detailed installation |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Technical architecture |
| [DEVELOPMENT.md](DEVELOPMENT.md) | Developer guide |
| [ADDON_API.md](ADDON_API.md) | API documentation |
| [PLAYSTORE_GUIDE.md](PLAYSTORE_GUIDE.md) | Google Play deployment |
| [GITHUB_PAGES_SETUP.md](GITHUB_PAGES_SETUP.md) | GitHub Pages setup |

---

## 📥 Download APK

**Latest Release: v1.0.0**

### 🚀 Quick Start

**Choose your path:**

1. **Just Want to Download?** ⬇️
   - Click one of the download links above
   - Install APK on your Android device
   - Done! Enjoy streaming 🎬

2. **Want to Develop?** 💻
   - Read [DEVELOPMENT.md](DEVELOPMENT.md)
   - Setup Flutter environment
   - Clone and run locally

3. **Want to Deploy?** 🌐
   - Read [GITHUB_PAGES_SETUP.md](GITHUB_PAGES_SETUP.md)
   - Enable GitHub Pages in your repository settings
   - Your download page goes live!

---

### Download Pages (GitHub Pages):
- **[🇦🇪 العربية - Download Page](https://mnbvjjhg65-ux.github.io/EyadFlix/download.html)**
- **[🇺🇸 English - Download Page](https://mnbvjjhg65-ux.github.io/EyadFlix/download-en.html)**

### Direct APK Download:
- **[APK File v1.0.0](https://github.com/mnbvjjhg65-ux/EyadFlix/releases/download/v1.0.0/EyadFlix-v1.0.0.apk)** - Optimized for production

**Requirements:** Android 5.0+ | **Size:** ~50 MB

### Installation Steps:
1. Click on download page above
2. Download the APK
3. Enable "Install from Unknown Sources" in your device settings
4. Open the downloaded APK and tap "Install"
5. Launch EyadFlix and enjoy!

---

## Features

### Core Streaming
- ✅ Full Stremio Addon Protocol Implementation (v1.0)
- ✅ Support for all handler types:
  - `defineCatalogHandler` - Browse media catalogs
  - `defineMetaHandler` - Fetch detailed metadata
  - `defineStreamHandler` - Get available streams
  - `defineSubtitlesHandler` - Fetch subtitles
  - `defineActionHandler` - Execute addon actions
- ✅ Direct integration with popular addons:
  - Torrentio
  - MediaFusion
  - Orion
  - Annatar
  - And any Stremio-compatible addon

### User Interface
- 🎨 Material Design 3 with dark/light theme support
- 🌍 Full internationalization (English & Arabic)
- 📱 RTL layout support for Arabic
- 🎬 Professional streaming app-inspired design
- 🔍 Searchable catalogs from installed addons
- 📚 Library section with favorites and watch history
- ⚙️ Settings with language and theme customization

### Video Player
- 🎥 High-quality video playback (up to 2K)
- 🔗 Support for HTTP direct links, magnet, and torrent streams
- ⏩ Long-press seek bar for continuous fast-forward/rewind
- 📺 Automatic intro skip detection
- 📝 Subtitle management with font and timing controls
- 🔊 Gesture controls for volume and brightness
- 🖼️ Picture-in-Picture (PiP) support
- 🔁 Background playback capability
- ⚠️ Proper error handling and fallback mechanisms

### Data Management
- 💾 Secure local storage using Hive
- 📜 Watch history tracking with progress
- ⭐ Favorites/Library section
- 🔐 User preferences and settings persistence

### Architecture
- 🏛️ Clean Architecture (Models, Services, Repositories, UI)
- 🎯 Riverpod for efficient state management
- 📦 Modular project structure
- 🔒 Type-safe data handling with JSON serialization

## Project Structure

```
lib/
├── core/
│   ├── constants/       # App constants and configuration
│   ├── errors/          # Custom exceptions
│   └── utils/           # Enums and utility functions
├── data/
│   ├── datasources/     # API calls and local storage
│   ├── models/          # JSON serializable models
│   └── repositories/    # Data layer abstractions
├── domain/
│   ├── entities/        # Business logic entities
│   ├── repositories/    # Repository interfaces
│   └── usecases/        # Use case implementations
├── services/
│   ├── addon_service.dart         # Stremio protocol handler
│   ├── local_storage_service.dart # Hive database wrapper
│   ├── localization_service.dart  # i18n management
│   └── theme_service.dart         # Theme definitions
├── presentation/
│   ├── pages/           # Screen implementations
│   ├── widgets/         # Reusable UI components
│   └── providers/       # Riverpod state providers
└── main.dart            # App entry point
```

## Getting Started

### Prerequisites
- Flutter SDK (3.0+)
- Android SDK (API 21+)
- Gradle 7.0+

### Installation

1. **Clone and Setup**
```bash
cd EyadFlix
flutter pub get
```

2. **Generate JSON Serialization Code**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. **Generate Hive Adapters**
```bash
flutter pub run build_runner build
```

4. **Run the App**
```bash
flutter run
```

## Building APK

### Debug APK
```bash
flutter build apk --debug
```

### Release APK (with code obfuscation)
```bash
flutter build apk --release
```

### Release APK (with Split APKs by architecture)
```bash
flutter build apk --release --split-per-abi
```

The APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`

## Signing Setup (for Play Store)

1. **Generate Signing Key**
```bash
keytool -genkey -v -keystore ~/eyadflix-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias eyadflix
```

2. **Create Signing Configuration** (`android/key.properties`):
```properties
storeFile=/path/to/eyadflix-key.jks
storePassword=your_password
keyPassword=your_password
keyAlias=eyadflix
```

## Using Stremio Addons

### How to Add Addons

1. Open the app and navigate to **Addons** tab
2. Paste the addon manifest URL (e.g., `https://example.com/manifest.json`)
3. Tap **Install**
4. The addon will be fetched and installed
5. Enable/disable addons as needed

### Popular Addons to Try

- **Torrentio**: `https://torrentio.strem.fun/manifest.json`
- **MediaFusion**: `https://mediafusion.strem.fun/manifest.json`
- **Orion**: `https://orion.strem.fun/manifest.json`
- **Annatar**: `https://annatar.strem.fun/manifest.json`

## Localization

The app supports **English (default)** and **Arabic** with automatic detection of device language.

## Developer Credits

**Developer**: Eyad AI Juhani

## Technical Stack

- Flutter 3.0+
- Riverpod for state management
- Hive for local storage
- Dio for HTTP requests
- Better Player for video playback
- Easy Localization for i18n

## License

Created for personal use and educational purposes.

---

**Made with ❤️ by Eyad AI Juhani**
