// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAQJGcK-CDgc-WJEgJXX1LPPAavSZvdGfQ',
    appId: '1:662313365055:android:acb96fa014037c16ec928a',
    messagingSenderId: '662313365055',
    projectId: 'schoolsmk-97cb6',
    databaseURL: 'https://schoolsmk-97cb6-default-rtdb.firebaseio.com',
    storageBucket: 'schoolsmk-97cb6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB5iGCzx0ARhR-LvOFg4C_r39DYV3UobvY',
    appId: '1:662313365055:ios:934ca92cdcf776daec928a',
    messagingSenderId: '662313365055',
    projectId: 'schoolsmk-97cb6',
    databaseURL: 'https://schoolsmk-97cb6-default-rtdb.firebaseio.com',
    storageBucket: 'schoolsmk-97cb6.appspot.com',
    iosClientId: '662313365055-p92jmujct958p7j8s3pq93fvhq756nbm.apps.googleusercontent.com',
    iosBundleId: 'com.example.smk',
  );
}