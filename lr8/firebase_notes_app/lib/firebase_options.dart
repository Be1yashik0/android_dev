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
    apiKey: 'AIzaSyC4Y8s5CoIaEDxqkPezNum94P9Iio_ina4',
    appId: '1:729221379184:web:bb8019f52465ca7c16f0b5',
    messagingSenderId: '729221379184',
    projectId: 'pksandroidlr8firebasenot-7f34f',
    authDomain: 'pksandroidlr8firebasenot-7f34f.firebaseapp.com',
    storageBucket: 'pksandroidlr8firebasenot-7f34f.firebasestorage.app',
    measurementId: 'G-L2ES0EBPF5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyALb12IQm0iLjDgu_odTYlgLo5723dUqK4',
    appId: '1:515489047798:android:f4447c77c292148fc738d7',
    messagingSenderId: '515489047798',
    projectId: 'belyashik-9e17f',
    storageBucket: 'belyashik-9e17f.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBZ_KdqltOtxUe6RW8Dwv-ujfR_ngDLWUc',
    appId: '1:729221379184:ios:cadd2440bbdc6ff516f0b5',
    messagingSenderId: '729221379184',
    projectId: 'pksandroidlr8firebasenot-7f34f',
    storageBucket: 'pksandroidlr8firebasenot-7f34f.firebasestorage.app',
    iosBundleId: 'com.example.firebaseNotesApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBZ_KdqltOtxUe6RW8Dwv-ujfR_ngDLWUc',
    appId: '1:729221379184:ios:cadd2440bbdc6ff516f0b5',
    messagingSenderId: '729221379184',
    projectId: 'pksandroidlr8firebasenot-7f34f',
    storageBucket: 'pksandroidlr8firebasenot-7f34f.firebasestorage.app',
    iosBundleId: 'com.example.firebaseNotesApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC4Y8s5CoIaEDxqkPezNum94P9Iio_ina4',
    appId: '1:729221379184:web:c889bf0662083b0316f0b5',
    messagingSenderId: '729221379184',
    projectId: 'pksandroidlr8firebasenot-7f34f',
    authDomain: 'pksandroidlr8firebasenot-7f34f.firebaseapp.com',
    storageBucket: 'pksandroidlr8firebasenot-7f34f.firebasestorage.app',
    measurementId: 'G-2EQRJLG94L',
  );
}
