import 'package:find_my_path/screens/query_loading_screen.dart';
import "package:flutter/material.dart";
import 'package:firebase_core/firebase_core.dart';
import "package:firebase_auth/firebase_auth.dart";

import "./theme/custom_theme.dart";
import "./screens/chat_screen.dart";
import "./screens/query_screen.dart";
import "./screens/query_loading_screen.dart";
import "./screens/splash_screen.dart";
import "./screens/auth_screen.dart";
import './screens/vi_home_screen.dart';
import './screens/vo_home_screen.dart';
import './screens/assignments_screen.dart';
import './screens/ratings_screen.dart';

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
                      return const HomeScreenVI();
                    }
                    return const AuthScreen();
                  });
            }
            return const SplashScreen();
          },
        ),
        routes: {
          HomeScreenVI.routeName: (context) => const HomeScreenVI(),
          HomeScreenVO.routeName: (context) => const HomeScreenVO(),
          QueryScreen.routeName: (context) => const QueryScreen(),
          QueryLoadingScreen.routeName: (context) => const QueryLoadingScreen(),
          ChatScreen.routeName: (context) => const ChatScreen(),
          AssignmentsScreen.routeName: (context) => const AssignmentsScreen(),
          RatingScreen.routeName: (context) => const RatingScreen(),
        });
  }
}
