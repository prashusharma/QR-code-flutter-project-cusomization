import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    if (kIsWeb) {
      return FirebaseOptions(
          apiKey: "AIzaSyAmcv2fvY_rmxhjcS4OO-xePBa3MhZSj5A",
          authDomain: "qr-menu-laravel.firebaseapp.com",
          projectId: "qr-menu-laravel",
          storageBucket: "qr-menu-laravel.appspot.com",
          messagingSenderId: "511821267483",
          appId: "1:511821267483:web:76d8018f8a64a7cb6f6ebe",
          measurementId: "G-DFB8W415BY",
          androidClientId: '511821267483-c25u0akg5ium8an55ddsbjdikjhqqu44.apps.googleusercontent.com');
    } else if (Platform.isIOS || Platform.isMacOS) {
      return FirebaseOptions(
          appId: '1:511821267483:ios:46a3733bff04ec0b6f6ebe',
          apiKey: 'AIzaSyAtZojQzf0sjzkCG9UmGm8xgE8YdB0fVk0',
          projectId: 'qr-menu-laravel',
          messagingSenderId: '511821267483',
          iosBundleId: 'com.iqonic.qrmenularavel',
          iosClientId: '511821267483-bmav6q72rahupgj78qgv92toin9c3atu.apps.googleusercontent.com');
    } else {
      // Android
      return FirebaseOptions(
        appId: "1:511821267483:android:6d8884661631f3956f6ebe",
        apiKey: "AIzaSyCWsdledgUlmDi5ECDX5dZWHGlLjYQ8oxU",
        projectId: "qr-menu-laravel",
        messagingSenderId: "511821267483",
      );
    }
  }
}
