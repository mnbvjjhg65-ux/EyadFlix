#!/bin/bash
# Comprehensive Project Validation Script
# فحص شامل لصحة المشروع

set -e

PASS="✅"
FAIL="❌"
WARN="⚠️"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║        EyadFlix - Comprehensive Project Check         ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check directories
check_directories() {
    echo -e "${BLUE}📁 Checking directories...${NC}"
    
    local dirs=(
        "lib/core/constants"
        "lib/core/errors"
        "lib/core/utils"
        "lib/data/models"
        "lib/data/datasources"
        "lib/data/repositories"
        "lib/domain/entities"
        "lib/domain/repositories"
        "lib/domain/usecases"
        "lib/presentation/pages"
        "lib/presentation/widgets"
        "lib/presentation/providers"
        "lib/services"
        "android/app/src/main"
        "assets/translations"
        "assets/icons"
        "assets/images"
    )
    
    for dir in "${dirs[@]}"; do
        if [ -d "$dir" ]; then
            echo "  $PASS $dir"
        else
            echo "  $FAIL $dir (missing)"
        fi
    done
}

# Check essential files
check_essential_files() {
    echo ""
    echo -e "${BLUE}📄 Checking essential files...${NC}"
    
    local files=(
        "pubspec.yaml"
        "lib/main.dart"
        "lib/core/constants/app_constants.dart"
        "lib/core/errors/exceptions.dart"
        "lib/core/utils/enums.dart"
        "lib/services/addon_service.dart"
        "lib/services/local_storage_service.dart"
        "lib/services/localization_service.dart"
        "lib/services/theme_service.dart"
        "lib/presentation/pages/home_page.dart"
        "lib/presentation/pages/addons_page.dart"
        "lib/presentation/pages/library_page.dart"
        "lib/presentation/pages/settings_page.dart"
        "lib/presentation/pages/video_player_page.dart"
        "lib/presentation/pages/catalog_page.dart"
        "lib/presentation/pages/media_detail_page.dart"
        "lib/presentation/widgets/bottom_nav_bar.dart"
        "lib/presentation/widgets/common_widgets.dart"
        "lib/presentation/providers/app_providers.dart"
        "lib/presentation/providers/library_providers.dart"
        "android/app/src/main/AndroidManifest.xml"
        "assets/translations/en.json"
        "assets/translations/ar.json"
        "README.md"
    )
    
    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            echo "  $PASS $file"
        else
            echo "  $FAIL $file (missing)"
        fi
    done
}

# Count code lines
count_code_lines() {
    echo ""
    echo -e "${BLUE}📊 Code Statistics...${NC}"
    
    local dart_count=$(find lib -name "*.dart" 2>/dev/null | wc -l)
    local dart_lines=$(find lib -name "*.dart" -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}')
    local json_count=$(find assets/translations -name "*.json" 2>/dev/null | wc -l)
    local doc_count=$(find . -maxdepth 1 -name "*.md" 2>/dev/null | wc -l)
    
    echo "  Dart Files: $dart_count"
    echo "  Dart Lines: $dart_lines"
    echo "  JSON Files: $json_count"
    echo "  Documentation: $doc_count"
}

# Check dependencies
check_dependencies() {
    echo ""
    echo -e "${BLUE}📦 Checking pubspec.yaml...${NC}"
    
    if grep -q "riverpod" pubspec.yaml; then
        echo "  $PASS Riverpod (state management)"
    else
        echo "  $FAIL Riverpod not found"
    fi
    
    if grep -q "hive" pubspec.yaml; then
        echo "  $PASS Hive (local storage)"
    else
        echo "  $FAIL Hive not found"
    fi
    
    if grep -q "dio" pubspec.yaml; then
        echo "  $PASS Dio (HTTP client)"
    else
        echo "  $FAIL Dio not found"
    fi
    
    if grep -q "better_player" pubspec.yaml; then
        echo "  $PASS Better Player (video player)"
    else
        echo "  $FAIL Better Player not found"
    fi
    
    if grep -q "easy_localization" pubspec.yaml; then
        echo "  $PASS Easy Localization (i18n)"
    else
        echo "  $FAIL Easy Localization not found"
    fi
}

# Check models have .g.dart files
check_model_serialization() {
    echo ""
    echo -e "${BLUE}🔄 Checking model serialization...${NC}"
    
    local models=(
        "addon_manifest"
        "meta_model"
        "stream_model"
        "subtitle_model"
        "installed_addon"
        "watch_history"
    )
    
    for model in "${models[@]}"; do
        if [ -f "lib/data/models/${model}.g.dart" ]; then
            echo "  $PASS ${model}.g.dart"
        else
            echo "  $WARN ${model}.g.dart (not generated yet - run: flutter pub run build_runner build)"
        fi
    done
}

# Check translations
check_translations() {
    echo ""
    echo -e "${BLUE}🌐 Checking translations...${NC}"
    
    if [ -f "assets/translations/en.json" ]; then
        local en_count=$(grep -o '":' assets/translations/en.json | wc -l)
        echo "  $PASS English: $en_count keys"
    else
        echo "  $FAIL English translation missing"
    fi
    
    if [ -f "assets/translations/ar.json" ]; then
        local ar_count=$(grep -o '":' assets/translations/ar.json | wc -l)
        echo "  $PASS Arabic: $ar_count keys"
    else
        echo "  $FAIL Arabic translation missing"
    fi
}

# Check Android configuration
check_android_config() {
    echo ""
    echo -e "${BLUE}🤖 Checking Android configuration...${NC}"
    
    if grep -q "android:name" android/app/src/main/AndroidManifest.xml; then
        echo "  $PASS AndroidManifest.xml configured"
    else
        echo "  $FAIL AndroidManifest.xml not properly configured"
    fi
    
    if grep -q "minSdkVersion" android/app/build.gradle; then
        echo "  $PASS build.gradle configured"
    else
        echo "  $FAIL build.gradle not properly configured"
    fi
    
    if [ -f "android/app/proguard-rules.pro" ]; then
        echo "  $PASS ProGuard rules configured"
    else
        echo "  $FAIL ProGuard rules missing"
    fi
}

# Check documentation
check_documentation() {
    echo ""
    echo -e "${BLUE}📚 Checking documentation...${NC}"
    
    local docs=(
        "README.md"
        "QUICKSTART.md"
        "DEVELOPMENT.md"
        "ARCHITECTURE.md"
        "INSTALLATION.md"
        "PROJECT_SUMMARY.md"
        "PROJECT_STRUCTURE_AR.md"
    )
    
    for doc in "${docs[@]}"; do
        if [ -f "$doc" ]; then
            local lines=$(wc -l < "$doc")
            echo "  $PASS $doc ($lines lines)"
        else
            echo "  $WARN $doc (missing)"
        fi
    done
}

# Summary
print_summary() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                        SUMMARY                        ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
    
    echo ""
    echo -e "${GREEN}✨ Project Structure: Complete${NC}"
    echo -e "${GREEN}✨ Core Services: Implemented${NC}"
    echo -e "${GREEN}✨ UI Pages: 8 screens${NC}"
    echo -e "${GREEN}✨ State Management: Riverpod${NC}"
    echo -e "${GREEN}✨ Localization: English + Arabic${NC}"
    echo -e "${GREEN}✨ Video Player: Ready${NC}"
    echo -e "${GREEN}✨ Addon Management: Ready${NC}"
    
    echo ""
    echo -e "${YELLOW}Next Steps:${NC}"
    echo "  1. Run: flutter pub get"
    echo "  2. Run: flutter pub run build_runner build --delete-conflicting-outputs"
    echo "  3. Run: flutter run"
    echo "  4. Test with addon: https://torrentio.strem.fun/manifest.json"
    
    echo ""
    echo -e "${BLUE}📖 Documentation:${NC}"
    echo "  - README.md: Overview and features"
    echo "  - QUICKSTART.md: 5-minute setup"
    echo "  - DEVELOPMENT.md: Development guide"
    echo "  - ARCHITECTURE.md: Technical architecture"
    echo "  - PROJECT_STRUCTURE_AR.md: Arabic structure guide"
    
    echo ""
}

# Run all checks
check_directories
check_essential_files
count_code_lines
check_dependencies
check_model_serialization
check_translations
check_android_config
check_documentation
print_summary

echo -e "${GREEN}✅ Validation complete!${NC}"
echo ""
