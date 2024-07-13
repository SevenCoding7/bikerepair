import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCveMYTKpdarw7UJt9Ry4DPScfUHMb0N7c',
    appId: '1:338018831074:android:a139fa2427a1524d3fecbb',
    messagingSenderId: '338018831074',
    projectId: 'bikerepair-b2a75',
    databaseURL: 'https://bikerepair-b2a75-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'bikerepair-b2a75.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDtS6G8dD8qtE5rMX_Wh8rKKg705UvDrk8',
    appId: '1:338018831074:web:1e37c313803994043fecbb',
    messagingSenderId: '338018831074',
    projectId: 'bikerepair-b2a75',
    authDomain: 'bikerepair-b2a75.firebaseapp.com',
    databaseURL: 'https://bikerepair-b2a75-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'bikerepair-b2a75.appspot.com',
    measurementId: 'G-J67LGG8ZTM',
  );

}