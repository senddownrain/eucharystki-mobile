import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Replace this file with generated values by running `flutterfire configure`.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Flutter Web не з\'яўляецца асноўнай мэтай.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return const FirebaseOptions(
          apiKey: 'REPLACE_WITH_FLUTTERFIRE',
          appId: 'REPLACE_WITH_FLUTTERFIRE',
          messagingSenderId: 'REPLACE_WITH_FLUTTERFIRE',
          projectId: 'REPLACE_WITH_FLUTTERFIRE',
          storageBucket: 'REPLACE_WITH_FLUTTERFIRE',
        );
      default:
        throw UnsupportedError('Платформа не падтрымліваецца.');
    }
  }
}
