# Mqawel Frontend

Mqawel Frontend is the Flutter application for the Mqawel marketplace platform. It supports both the customer flow and the contractor flow, integrates with the backend API, and provides a mobile UI for creating orders, discovering contractors, tracking order status, and managing worker availability.

## Features

- Customer order creation and tracking
- Contractor discovery and selection
- Worker availability updates
- Real-time updates via Socket.IO
- Image upload support for order photos
- API configuration through `API_BASE_URL`

## Tech Stack

- Flutter
- Dart
- Bloc state management
- Dio for HTTP requests
- Socket.IO client
- SharedPreferences for local storage

## Project Structure

- `lib/` — Flutter application source code
- `test/` — widget and unit tests
- `android/` — Android project files
- `ios/` — iOS project files
- `web/` — Web project files
- `windows/`, `linux/`, `macos/` — desktop support files

## API Configuration

The app reads its backend base URL from the `API_BASE_URL` compile-time variable. Local development defaults to:

- Android emulator: `http://10.0.2.2:3000/api/v1`
- Physical Android device: use `flutter run --dart-define=API_BASE_URL=http://<PC-LAN-IP>:3000/api/v1`

Do not commit a permanent LAN IP or any production endpoint into source control.

## Android Emulator

```bash
flutter run
```

The app will use the default emulator backend URL:

```text
http://10.0.2.2:3000/api/v1
```

## Physical Android Device

```bash
flutter run --dart-define=API_BASE_URL=http://<PC-LAN-IP>:3000/api/v1
```

## Development Setup

1. Install Flutter dependencies:

```bash
flutter pub get
```

2. Ensure the backend is running on the expected URL.

3. Run the app:

```bash
flutter run
```

## Running Tests

```bash
flutter test
```

## Building APK

```bash
flutter build apk --debug
```

## Notes

- The app expects the backend base URL to be configured with `API_BASE_URL` for non-debug builds.
- Release builds must use HTTPS and should not fall back to localhost, `127.0.0.1`, or LAN IP defaults.
- Keep secrets and environment-specific values out of Git history.
