
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
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyAsL1bVe4c7Wub6uG6kp5A7PlhxLIahLis',
    appId: '1:1066925334822:web:d35c07d57dbadbb9f821e7',
    messagingSenderId: '1066925334822',
    projectId: 'insulin-pump-4dc28',
    authDomain: 'insulin-pump-4dc28.firebaseapp.com',
    databaseURL: 'https://insulin-pump-4dc28-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'insulin-pump-4dc28.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCJOpWllPbOZ1ZTuJGCVObiQeN1g5UyA4s',
    appId: '1:1066925334822:android:f7babc3d5a021465f821e7',
    messagingSenderId: '1066925334822',
    projectId: 'insulin-pump-4dc28',
    databaseURL: 'https://insulin-pump-4dc28-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'insulin-pump-4dc28.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBnc0xOb3H6JpvgyAXPa6UHCAu623APgIc',
    appId: '1:1066925334822:ios:8d85338a634c5187f821e7',
    messagingSenderId: '1066925334822',
    projectId: 'insulin-pump-4dc28',
    databaseURL: 'https://insulin-pump-4dc28-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'insulin-pump-4dc28.appspot.com',
    iosBundleId: 'com.example.insulin',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBnc0xOb3H6JpvgyAXPa6UHCAu623APgIc',
    appId: '1:1066925334822:ios:8d85338a634c5187f821e7',
    messagingSenderId: '1066925334822',
    projectId: 'insulin-pump-4dc28',
    databaseURL: 'https://insulin-pump-4dc28-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'insulin-pump-4dc28.appspot.com',
    iosBundleId: 'com.example.insulin',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAgHBi8kbpPWUdtn_WAb5J7LHBmnCoDuDg',
    appId: '1:1066925334822:web:e886c76d28089251f821e7',
    messagingSenderId: '1066925334822',
    projectId: 'insulin-pump-4dc28',
    authDomain: 'insulin-pump-4dc28.firebaseapp.com',
    databaseURL: 'https://insulin-pump-4dc28-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'insulin-pump-4dc28.appspot.com',
  );
}
