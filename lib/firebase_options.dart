import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

/// Firebase options can be supplied in two ways:
/// 1. Replace the placeholder values below with generated FlutterFire values.
/// 2. Pass `--dart-define` values so the app can run without `flutterfire configure`.
class DefaultFirebaseOptions {
  static const _placeholder = 'REPLACE_WITH_FLUTTERFIRE';

  static const _androidApiKey = String.fromEnvironment(
    'FIREBASE_ANDROID_API_KEY',
    defaultValue: _placeholder,
  );
  static const _androidAppId = String.fromEnvironment(
    'FIREBASE_ANDROID_APP_ID',
    defaultValue: _placeholder,
  );
  static const _androidMessagingSenderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
    defaultValue: _placeholder,
  );
  static const _androidProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: _placeholder,
  );
  static const _androidStorageBucket = String.fromEnvironment(
    'FIREBASE_STORAGE_BUCKET',
    defaultValue: _placeholder,
  );

  static const _iosApiKey = String.fromEnvironment(
    'FIREBASE_IOS_API_KEY',
    defaultValue: _androidApiKey,
  );
  static const _iosAppId = String.fromEnvironment(
    'FIREBASE_IOS_APP_ID',
    defaultValue: _placeholder,
  );
  static const _iosMessagingSenderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
    defaultValue: _placeholder,
  );
  static const _iosProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: _placeholder,
  );
  static const _iosStorageBucket = String.fromEnvironment(
    'FIREBASE_STORAGE_BUCKET',
    defaultValue: _placeholder,
  );
  static const _iosBundleId = String.fromEnvironment(
    'FIREBASE_IOS_BUNDLE_ID',
    defaultValue: _placeholder,
  );

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Flutter Web не з\'яўляецца асноўнай мэтай.');
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _android;
      case TargetPlatform.iOS:
        return _ios;
      default:
        throw UnsupportedError('Платформа не падтрымліваецца.');
    }
  }

  static FirebaseOptions get _android {
    _assertConfigured(
      platformName: 'Android',
      values: {
        'FIREBASE_ANDROID_API_KEY': _androidApiKey,
        'FIREBASE_ANDROID_APP_ID': _androidAppId,
        'FIREBASE_MESSAGING_SENDER_ID': _androidMessagingSenderId,
        'FIREBASE_PROJECT_ID': _androidProjectId,
      },
    );

    return const FirebaseOptions(
      apiKey: _androidApiKey,
      appId: _androidAppId,
      messagingSenderId: _androidMessagingSenderId,
      projectId: _androidProjectId,
      storageBucket: _androidStorageBucket,
    );
  }

  static FirebaseOptions get _ios {
    _assertConfigured(
      platformName: 'iOS',
      values: {
        'FIREBASE_IOS_API_KEY': _iosApiKey,
        'FIREBASE_IOS_APP_ID': _iosAppId,
        'FIREBASE_MESSAGING_SENDER_ID': _iosMessagingSenderId,
        'FIREBASE_PROJECT_ID': _iosProjectId,
        'FIREBASE_IOS_BUNDLE_ID': _iosBundleId,
      },
    );

    return const FirebaseOptions(
      apiKey: _iosApiKey,
      appId: _iosAppId,
      messagingSenderId: _iosMessagingSenderId,
      projectId: _iosProjectId,
      storageBucket: _iosStorageBucket,
      iosBundleId: _iosBundleId,
    );
  }

  static void _assertConfigured({
    required String platformName,
    required Map<String, String> values,
  }) {
    final missingKeys = values.entries
        .where((entry) => entry.value == _placeholder || entry.value.isEmpty)
        .map((entry) => entry.key)
        .toList(growable: false);

    if (missingKeys.isNotEmpty) {
      throw UnsupportedError(
        '$platformName Firebase не наладжаны. '
        'Запусціце flutterfire configure або перадайце --dart-define для: '
        '${missingKeys.join(', ')}.',
      );
    }
  }
}
