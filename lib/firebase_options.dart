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
    apiKey: 'AIzaSyCI5nXaVmwF6fViy57qg08ePILRNLFSGCw',
    appId: '1:486182441965:web:7f5e5b7422d62c5bd0cde4',
    messagingSenderId: '486182441965',
    projectId: 'pharmacy-in-pocket2',
    authDomain: 'pharmacy-in-pocket2.firebaseapp.com',
    storageBucket: 'pharmacy-in-pocket2.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCFxswWHcjX9q7hEZezZOAH_NtSXULUcv4',
    appId: '1:486182441965:android:c92318514457a8bcd0cde4',
    messagingSenderId: '486182441965',
    projectId: 'pharmacy-in-pocket2',
    storageBucket: 'pharmacy-in-pocket2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAz9dsjuAhwHy16Q0InkRkzuLJE_NE18Wc',
    appId: '1:486182441965:ios:e1b437aea706eac9d0cde4',
    messagingSenderId: '486182441965',
    projectId: 'pharmacy-in-pocket2',
    storageBucket: 'pharmacy-in-pocket2.appspot.com',
    iosClientId: '486182441965-ovlckegqj9p55ui107ohq7j6j0pumkc3.apps.googleusercontent.com',
    iosBundleId: 'com.example.admin',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAz9dsjuAhwHy16Q0InkRkzuLJE_NE18Wc',
    appId: '1:486182441965:ios:e1b437aea706eac9d0cde4',
    messagingSenderId: '486182441965',
    projectId: 'pharmacy-in-pocket2',
    storageBucket: 'pharmacy-in-pocket2.appspot.com',
    iosClientId: '486182441965-ovlckegqj9p55ui107ohq7j6j0pumkc3.apps.googleusercontent.com',
    iosBundleId: 'com.example.admin',
  );
}
