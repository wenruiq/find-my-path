import "package:flutter/material.dart";
import 'package:firebase_core/firebase_core.dart';
import "package:firebase_auth/firebase_auth.dart";

import "./screens/chat_screen.dart";
import "./screens/splash_screen.dart";
import "./screens/auth_screen.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Find My Path",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              //TODO: handle error
              print("Firebase init error");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (ctx, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return SplashScreen();
                    }
                    if (userSnapshot.hasData) {
                      return ChatScreen();
                    }
                    return AuthScreen();
                  });
            }
            return SplashScreen();
          }),
    );
  }
}
