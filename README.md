# Master Calculator

Master Calculator is a Flutter app that bundles multiple calculators and converters in one cross-platform application.

## Features

- Standard calculator with expression evaluation and local history
- Voice input for calculator expressions (microphone + speech recognition)
- Date tools:
  - AD <-> BS (Bikram Sambat) conversion
  - Age calculator
  - Date math (add/subtract days)
  - Week number and days-between utilities
- Currency converter:
  - Live rates from `https://api.exchangerate-api.com/v4`
  - Fallback rates when API/network fails
  - Multi-currency comparison
  - Simulated historical trend chart data
- More tools:
  - Scientific calculator
  - Loan/EMI calculator
  - Percentage/discount/profit tools
  - Unit converter
  - Number system converter
  - Temperature converter
  - OCR calculator UI flow
- Light/dark theming with Riverpod state management
- AdMob integration (currently configured with Google test ad IDs)
- Local premium toggle (ads on/off) persisted with `SharedPreferences`

## Tech Stack

- Flutter (Dart 3)
- State management: `flutter_riverpod`
- Networking: `http`
- Storage: `shared_preferences` (premium flag), `hive` packages present
- Speech input: `speech_to_text`
- Image picking (OCR flow): `image_picker`
- Ads: `google_mobile_ads`

## Project Structure

```text
lib/
  app.dart                     # App shell, navigation, theme, ad banner behavior
  main.dart                    # App entrypoint, MobileAds init, premium load
  config/                      # constants + env values
  core/                        # shared providers, widgets, utilities
  features/
    calculator/
    scientific_calculator/
    date_converter/
    currency_converter/
    loan_calculator/
    percentage_calculator/
    unit_converter/
    number_system_converter/
    temperature_converter/
    ocr_calculator/
    more/
  services/                    # ads, premium, OCR, voice, storage, analytics
test/
  unit/
  widget/
integration_test/
```

## Getting Started

### 1. Prerequisites

- Flutter SDK (compatible with `>=3.0.0 <4.0.0`)
- Android Studio / VS Code + Flutter extensions
- Device/emulator for Android, iOS, desktop, or web

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run the app

```bash
flutter run
```

### 4. Optional: pass compile-time env values

```bash
flutter run --dart-define=CURRENCY_API_KEY=your_key
```

Note: current currency service uses a free endpoint and does not require this key in runtime code.

## Testing

Run all tests:

```bash
flutter test
```

Current test suite includes:

- Basic unit tests for expression evaluation
- Placeholder widget/integration/date tests (minimal coverage)

## Platform/Permissions Notes

- Android manifest includes `RECORD_AUDIO` for voice calculator input
- iOS `Info.plist` includes microphone and speech recognition usage descriptions
- AdMob app IDs are configured with Google test IDs in Android/iOS project files

## Known Limitations (Current Codebase)

- OCR service is currently scaffolded: image capture/pick works, but real text recognition is not yet integrated (ML Kit/Firebase OCR not wired)
- Some project docs (for example monetization notes) describe planned/older architecture that is not fully present in current source
- Localization assets exist, but app locale is currently fixed to English in `app.dart`

## Useful Commands

```bash
flutter analyze
flutter test
flutter run -d chrome
```

## License

This project is licensed under the terms in [LICENSE](LICENSE).
