import 'package:flutter_test/flutter_test.dart';
import 'package:meqawuel_front/src/core/config/api_config.dart';

void main() {
  group('ApiConfig.resolve', () {
    test('uses explicit configured URL in debug mode', () {
      const configuredUrl = 'https://example.com';

      final result = ApiConfig.resolve(
        configuredUrl: configuredUrl,
        isRelease: false,
      );

      expect(result, 'https://example.com/api/v1');
    });

    test('uses emulator fallback in debug mode when no explicit URL is provided', () {
      final result = ApiConfig.resolve(
        configuredUrl: '',
        isRelease: false,
      );

      expect(result, 'http://10.0.2.2:3000/api/v1');
    });

    test('uses explicit HTTPS URL in release mode', () {
      const configuredUrl = 'https://example.com/api/v1';

      final result = ApiConfig.resolve(
        configuredUrl: configuredUrl,
        isRelease: true,
      );

      expect(result, 'https://example.com/api/v1');
    });

    test('fails clearly in release mode when no explicit URL is provided', () {
      expect(
        () => ApiConfig.resolve(
          configuredUrl: '',
          isRelease: true,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws for malformed explicit URL', () {
      expect(
        () => ApiConfig.resolve(
          configuredUrl: 'not a valid url',
          isRelease: true,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws for empty explicit URL when passed as whitespace', () {
      expect(
        () => ApiConfig.resolve(
          configuredUrl: '   ',
          isRelease: true,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('rejects localhost in release mode', () {
      expect(
        () => ApiConfig.resolve(
          configuredUrl: 'http://localhost:3000',
          isRelease: true,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('normalizes API path without duplicating /api', () {
      final result = ApiConfig.resolve(
        configuredUrl: 'https://example.com/api',
        isRelease: false,
      );

      expect(result, 'https://example.com/api/v1');
    });
  });
}
