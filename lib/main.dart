import 'package:find_my_path/screens/query_loading_screen.dart';
import "package:flutter/material.dart";
import 'package:firebase_core/firebase_core.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

void main() async {
  //* Ensures Firebase initialized bef. running app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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

  void initState() {
    super.initState();
    // FirebaseMessaging messaging = FirebaseMessaging.instance;
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print('Got a message whilst in the foreground!');
    //   print('Message data: ${message.data}');

    //   if (message.notification != null) {
    //     print('Message also contained a notification: ${message.notification}');
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Find My Path",
        theme: customTheme,
        //* FutureBuilder for Firebase init
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              }
              if (userSnapshot.hasData) {
                String uid = FirebaseAuth.instance.currentUser!.uid;
                CollectionReference users =
                    FirebaseFirestore.instance.collection('users');
                return FutureBuilder<DocumentSnapshot>(
                  future: users.doc(uid).get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text("Something went wrong");
                    }

                    if (snapshot.hasData && !snapshot.data!.exists) {
                      return const Text("Document does not exist");
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      if (data['isVolunteer'] == true) {
                        return const HomeScreenVO();
                      }
                      return const HomeScreenVI();
                    }

                    return const SplashScreen();
                  },
                );
              }
              return const AuthScreen();
            }),
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
