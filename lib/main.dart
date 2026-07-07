import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {

      if (kIsWeb) {
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyCy5Txrz85aRaxGE4eEKjenDbO_-TW3Tds",
            authDomain:
                "blood-connect-app-ed4fd.firebaseapp.com",
            projectId:
                "blood-connect-app-ed4fd",
            storageBucket:
                "blood-connect-app-ed4fd.firebasestorage.app",
            messagingSenderId:
                "917164716301",
            appId:
                "1:917164716301:web:b41cd8b34d6674d50a4044",
          ),
        );
      } else {
        // ANDROID
        await Firebase.initializeApp();
      }
    }
  } catch (_) {}

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Blood Connect",
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const SplashScreen(),
    );
  }
}