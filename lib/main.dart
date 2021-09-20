import "package:flutter/material.dart";
import 'package:firebase_core/firebase_core.dart';
import "package:firebase_auth/firebase_auth.dart";

import "./theme/custom_theme.dart";
import "./screens/chat_screen.dart";
import "./screens/splash_screen.dart";
import "./screens/auth_screen.dart";
import "./screens/home_screen_vi.dart";
import "./screens/home_screen_vo.dart";

void main() {
  //* Ensures Firebase initialized bef. running app
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //* Initialize Firebase
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Find My Path",
      theme: customTheme,
      //* FutureBuilder for Firebase init
      home: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              //TODO: Error handling
              print("Firebase init error");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              //* StreamBuilder listens to authStateChanges
              return StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (ctx, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const SplashScreen();
                    }
                    if (userSnapshot.hasData) {
                      return const HomeScreenVO();
                    }
                    return const AuthScreen();
                  });
            }
            return const SplashScreen();
          }),
    );
  }
}
