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
    apiKey: 'AIzaSyC5yQhgeGptbOhQPpDIBZ5KGjAtGHGL9YA',
    appId: '1:42740053504:android:34285c03eff859ffc4cae5',
    messagingSenderId: '42740053504',
    projectId: 'messengerclone-49f6b',
    storageBucket: 'messengerclone-49f6b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAwacrNIw8jLR4gfCct5t8klt-ZtcJFPjg',
    appId: '1:42740053504:ios:42f9843fcaf75e26c4cae5',
    messagingSenderId: '42740053504',
    projectId: 'messengerclone-49f6b',
    storageBucket: 'messengerclone-49f6b.appspot.com',
    androidClientId: '42740053504-bljdsn0q7opf4nnjlfovla2esc2slh3l.apps.googleusercontent.com',
    iosClientId: '42740053504-mn4gdp2qfpdejhelr5kvpuv4qpnpbbrk.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatApp',
  );
}