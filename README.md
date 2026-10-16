# scaffold_eng_mobile

A new Flutter project.

## Connecting to the Laravel learning API

Start Laravel from the repository root with `php artisan serve --host=0.0.0.0 --port=8000`.

- Flutter web and desktop: the app uses `http://localhost:8000/api/v1`.
- Android emulator: the app uses `http://10.0.2.2:8000/api/v1`, which maps to the computer's localhost.
- Physical phone: use your computer's LAN address with `API_BASE_URL`, for example `flutter run --dart-define=API_BASE_URL=http://192.168.0.10:8000/api/v1` (replace the IP with your computer's current address).

You can use `API_BASE_URL` to override the default for any target.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
