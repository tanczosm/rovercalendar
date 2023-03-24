import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyB738SpB1QYAXetrh3H2wTIIULcdGpN3YA",
            authDomain: "calendartest-aefe8.firebaseapp.com",
            projectId: "calendartest-aefe8",
            storageBucket: "calendartest-aefe8.appspot.com",
            messagingSenderId: "609304627305",
            appId: "1:609304627305:web:1657923df7d75b2a86faf8"));
  } else {
    await Firebase.initializeApp();
  }
}
