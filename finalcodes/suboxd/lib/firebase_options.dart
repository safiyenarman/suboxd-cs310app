
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA3m2Mbgq6pQkSsbMKpx5zmIuWOIljMsjg',
    appId: '1:630220319538:web:5c25c169d645757c9bc52b',
    messagingSenderId: '630220319538',
    projectId: 'suboxd-cs310',
    authDomain: 'suboxd-cs310.firebaseapp.com',
    storageBucket: 'suboxd-cs310.firebasestorage.app',
    measurementId: 'G-HYTNGCC4MB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA_iUuxA3J1R5e017kQhiIofnEujqMx4FM',
    appId: '1:630220319538:android:55c86630f5ae76ad9bc52b',
    messagingSenderId: '630220319538',
    projectId: 'suboxd-cs310',
    storageBucket: 'suboxd-cs310.firebasestorage.app',
  );

}