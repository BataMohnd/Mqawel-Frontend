import 'package:flutter/foundation.dart';

class ApiConfig {
  static const String _developmentBaseUrl = 'http://10.0.2.2:3000';

  static String get configuredUrl => const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: '',
      );

  static String get baseUrl {
    return resolve(
      configuredUrl: configuredUrl,
      isRelease: kReleaseMode,
    );
  }

  static String get socketBaseUrl {
    final parsed = Uri.parse(baseUrl);
    final socketUri = parsed.replace(
      path: '',
      query: null,
      fragment: null,
    );
    final url = socketUri.toString();
    return url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }

  static String resolve({
    required String configuredUrl,
    required bool isRelease,
  }) {
    final trimmed = configuredUrl.trim();

    if (trimmed.isNotEmpty) {
      return _normalizeBaseUrl(trimmed, isRelease);
    }

    if (!isRelease) {
      return '$_developmentBaseUrl/api/v1';
    }

    throw const FormatException(
      'Release builds require API_BASE_URL to be set to a valid HTTPS backend URL. '
      'Localhost, 127.0.0.1, and LAN IP fallbacks are not allowed in release.',
    );
  }

  static String _normalizeBaseUrl(
    String value,
    bool requireHttps,
  ) {
    if (value.trim().isEmpty) {
      throw const FormatException('API_BASE_URL cannot be empty.');
    }

    final uri = Uri.tryParse(value.trim());
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      throw const FormatException(
        'API_BASE_URL must be a valid absolute URL, for example https://your-backend.example.com',
      );
    }

    if (requireHttps && uri.scheme != 'https') {
      throw const FormatException(
        'Release builds require API_BASE_URL to use HTTPS.',
      );
    }

    final host = uri.host.toLowerCase();
    if (requireHttps &&
        (host == 'localhost' || host == '127.0.0.1' || host == '::1')) {
      throw const FormatException(
        'Release builds must not use localhost or loopback URLs.',
      );
    }

    final normalizedPath = _normalizedApiPath(uri.path);
    final normalizedUri = uri.replace(
      path: normalizedPath,
      query: null,
      fragment: null,
    );

    final normalized = normalizedUri.toString();
    return normalized.endsWith('/')
        ? normalized.substring(0, normalized.length - 1)
        : normalized;
  }

  static String _normalizedApiPath(String path) {
    final trimmedPath = path.trim();

    if (trimmedPath.isEmpty || trimmedPath == '/') {
      return '/api/v1';
    }

    final normalizedPath = trimmedPath.endsWith('/')
        ? trimmedPath.substring(0, trimmedPath.length - 1)
        : trimmedPath;

    if (normalizedPath.endsWith('/api/v1')) {
      return '/api/v1';
    }

    if (normalizedPath.endsWith('/api')) {
      return '/api/v1';
    }

    return '/api/v1';
  }
}
