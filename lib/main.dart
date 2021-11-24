import 'package:find_my_path/screens/query_loading_screen.dart';
import "package:flutter/material.dart";
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import "./theme/custom_theme.dart";
import "./screens/chat_screen.dart";
import "./screens/query_screen.dart";
import "./screens/query_loading_screen.dart";
import "./screens/loading_screen.dart";
import "./screens/auth_screen.dart";
import './screens/vi_home_screen.dart';
import './screens/vo_home_screen.dart';
import './screens/requests_screen.dart';
import './screens/ratings_screen.dart';
import './screens/hero_image_screen.dart';
import 'package:find_my_path/providers/user_model.dart';
import 'package:find_my_path/providers/location_model.dart';
import 'package:find_my_path/providers/request_model.dart';

//* Background Notification Handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //* Bind Background Notification Handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    //* Android Notification Channel Config
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
    //* Initialize FlutterNotificationsPlugin Package
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    //* Create Android Notification Channel based on config above
    //* Use it to override the default FCM channel to enable heads up notifications
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    ///* Update the iOS foreground notification presentation options to allow
    ///* heads up notifications.
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  //* MultiProvider here
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserModel()),
    ChangeNotifierProvider(create: (context) => LocationModel()),
    ChangeNotifierProvider(create: (context) => RequestModel())
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    //* Listens to foreground notifications & perform actions here
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      //* Dialog Box for user to accept/deny requests
      ///TODO: Connect interaction from notification click to display dialog box

      //* Styling & Text for Android notification bar
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                //* Using default icon from example app
                icon: 'launch_background',
              ),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Find My Path",
        theme: customTheme,
        //* Listens to authStateChanges to know whether to log the user in/out
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const AuthScreen();
              }
              if (userSnapshot.hasData) {
                String uid = FirebaseAuth.instance.currentUser!.uid;
                CollectionReference users = FirebaseFirestore.instance.collection('users');
                return FutureBuilder<DocumentSnapshot>(
                  future: users.doc(uid).get(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    //? Use snackbar to handle these errors?
                    if (snapshot.hasError) {
                      return const AuthScreen();
                    }
                    if (snapshot.hasData && !snapshot.data!.exists) {
                      return const AuthScreen();
                    }
                    //* If everything's good, user logs in
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                      if (data['isVolunteer'] == true) {
                        return const HomeScreenVO();
                      }
                      return const HomeScreenVI();
                    }

                    return const LoadingScreen();
                  },
                );
              }
              FirebaseMessaging firebaseMessagingInstance = FirebaseMessaging.instance;
              firebaseMessagingInstance.unsubscribeFromTopic('requests');
              return const AuthScreen();
            }),
        routes: {
          HomeScreenVI.routeName: (context) => const HomeScreenVI(),
          HomeScreenVO.routeName: (context) => const HomeScreenVO(),
          QueryScreen.routeName: (context) => const QueryScreen(),
          QueryLoadingScreen.routeName: (context) => const QueryLoadingScreen(),
          ChatScreen.routeName: (context) => const ChatScreen(),
          RequestsScreen.routeName: (context) => const RequestsScreen(),
          RatingScreen.routeName: (context) => const RatingScreen(),
          HeroImageScreen.routeName: (context) => const HeroImageScreen(),
        });
  }
}
