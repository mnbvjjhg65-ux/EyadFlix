#!/bin/bash
# EyadFlix Quick Start Script
# هذا السكريبت يساعدك على البدء السريع مع EyadFlix

set -e

echo ""
echo "╔═══════════════════════════════════════════════════╗"
echo "║        EyadFlix - Quick Start Setup             ║"
echo "╚═══════════════════════════════════════════════════╝"
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed"
    echo "📥 Download from: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -1)"
echo ""

# Get dependencies
echo "📦 Installing dependencies..."
flutter pub get
echo "✅ Dependencies installed"
echo ""

# Generate code
echo "🔨 Generating code (JSON serialization & Hive)..."
flutter pub run build_runner build --delete-conflicting-outputs
echo "✅ Code generated"
echo ""

# Check for devices
echo "📱 Available devices:"
flutter devices
echo ""

# Options
echo "🚀 What would you like to do?"
echo ""
echo "1) Run the app (flutter run)"
echo "2) Build debug APK (flutter build apk --debug)"
echo "3) Build release APK (flutter build apk --release)"
echo "4) Open documentation (README.md)"
echo "5) Exit"
echo ""
read -p "Choose (1-5): " choice

case $choice in
    1)
        echo ""
        echo "🎬 Launching EyadFlix..."
        flutter run
        ;;
    2)
        echo ""
        echo "🔨 Building debug APK..."
        flutter build apk --debug
        echo "✅ APK built: build/app/outputs/flutter-apk/app-debug.apk"
        ;;
    3)
        echo ""
        echo "🔨 Building release APK..."
        flutter build apk --release
        echo "✅ APK built: build/app/outputs/flutter-apk/app-release.apk"
        ;;
    4)
        echo ""
        if command -v cat &> /dev/null; then
            cat README.md | head -50
        else
            echo "📖 Open README.md manually"
        fi
        ;;
    5)
        echo ""
        echo "👋 Goodbye!"
        ;;
    *)
        echo "❌ Invalid option"
        exit 1
        ;;
esac

echo ""
echo "✅ Done!"
echo ""
echo "💡 Next: Go to Addons tab and add a Stremio addon:"
echo "   https://torrentio.strem.fun/manifest.json"
echo ""
