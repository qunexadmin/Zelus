# 📱 ZELUS App Icon Setup Guide

## Quick Start

The app name has been changed from "zelux" to **ZELUS** (all caps). Now you need to generate the custom app icon.

### Option 1: Use the HTML Generator (Easiest) ✨

1. **Open the generator in your browser:**
   ```bash
   # From mobile directory
   open assets/icons/generate_icon.html
   # Or on Linux
   xdg-open assets/icons/generate_icon.html
   ```

2. **Download the icon:**
   - Click the "Download Icon" button
   - Save the file as `app_icon.png`
   - Move it to: `mobile/assets/icons/app_icon.png`

3. **Generate all icon sizes:**
   ```bash
   cd mobile
   flutter pub get
   flutter pub run flutter_launcher_icons
   ```

4. **Rebuild your app:**
   ```bash
   flutter run
   ```

---

### Option 2: Use an Online Tool

If you prefer using an online tool:

1. **Go to:** https://www.canva.com or https://www.figma.com

2. **Create a 1024x1024px square with:**
   - Background: White (#FFFFFF)
   - Text: "ZELUS"
   - Font: Helvetica Neue (or Arial)
   - Font Weight: 200 (Ultra Light)
   - Font Size: ~280px
   - Letter Spacing: 60px
   - Color: Charcoal (#1F2937)
   - Alignment: Center

3. **Export as PNG:**
   - Size: 1024x1024px
   - Format: PNG
   - Background: White

4. **Save to:** `mobile/assets/icons/app_icon.png`

5. **Generate icons:**
   ```bash
   cd mobile
   flutter pub get
   flutter pub run flutter_launcher_icons
   ```

---

### Option 3: Screenshot the HTML Page

1. Open `assets/icons/generate_icon.html` in Chrome
2. Right-click on the white square → "Save image as..."
3. Save as `app_icon.png` to `mobile/assets/icons/`
4. Run the commands above

---

## What Changed

### 1. App Name ✅
- **Android:** Updated `AndroidManifest.xml`
  - Changed from `"zelux"` → `"ZELUS"`

### 2. Icon Configuration ✅
- **Added:** `flutter_launcher_icons` package
- **Configured:** Auto-generation for Android icons
- **Background:** White (#FFFFFF)
- **Design:** Minimal ZELUS typography

---

## Icon Specifications

| Property | Value |
|----------|-------|
| Size | 1024x1024px |
| Format | PNG with transparency |
| Background | White (#FFFFFF) |
| Text | ZELUS |
| Font | Helvetica Neue Light (200) |
| Text Color | Charcoal (#1F2937) |
| Letter Spacing | 60px |
| Style | Ultra minimal, elegant |

---

## Verify Installation

After running the commands, your app should show:
- ✅ App name: **ZELUS** (all caps)
- ✅ App icon: White square with black "ZELUS" text
- ✅ Consistent with login screen branding

---

## Troubleshooting

**Problem:** Icon not updating
- **Solution:** Uninstall the app and reinstall
  ```bash
  flutter clean
  flutter pub get
  flutter pub run flutter_launcher_icons
  flutter run
  ```

**Problem:** HTML file won't open
- **Solution:** Open it manually in Chrome/Firefox, or use Option 2 (online tool)

**Problem:** Download button doesn't work
- **Solution:** Right-click on the icon → Save image as → save as `app_icon.png`

---

## Next Steps

Once your icon is generated:
1. The app will display "ZELUS" on your phone
2. The icon will match your login screen aesthetic
3. Professional, minimal branding across the app

**Need help?** Check the HTML generator at `assets/icons/generate_icon.html`

