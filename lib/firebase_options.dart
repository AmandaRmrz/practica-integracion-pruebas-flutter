import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return android;
    }
    throw UnsupportedError('Plataforma no configurada');
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD1PPp9srB4N2BUwzz7IGKNoz9-QzA0iCs',
    appId: '1:917070625036:android:adcf79b00582d06cb93129',
    messagingSenderId: '917070625036',
    projectId: 'tareau-1058d',
    storageBucket: 'tareau-1058d.firebasestorage.app',
  );
}