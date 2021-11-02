import 'package:find_my_path/screens/query_loading_screen.dart';
import "package:flutter/material.dart";
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
import 'widgets/home/vo_assignment_dialog.dart';

//* To be called to handle messages when app is in background/terminated
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //* Initialize Firebase services
  await Firebase.initializeApp();
}

//* Create an [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

//* Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  //* Initialize Firebase services
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //* Bind the background message handler function defined at the top-level
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //* If not web (we are on mobile so always true)
  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    ///* Create an Android Notification Channel.
    ///
    ///* We use this channel in the `AndroidManifest.xml` file to override the
    ///* default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    ///* Update the iOS foreground notification presentation options to allow
    ///* heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  runApp(
    MaterialApp(
      title: "FindMyPath",
      home: const MyApp(),
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
            builder: (BuildContext context) => const ChatScreen());
      },
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static const routeName = '/base';

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    
    //* Initialize FBM Instance to use service
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    
    //TODO: Check user role & isNotiEnabled before subscribing
    messaging.subscribeToTopic("assignments");

    //* Listens to foreground notifications & perform actions after
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      //* Dialog Box for user to accept/deny assignments
      ///TODO: Dialog should only show when clicked on the notifcation bar 
      Future.delayed(Duration.zero, () {
        showDialog(
          context: context,
          builder: (BuildContext context) => const AssignmentDialog(),
        );
      });

      //* Styling & Text for android noti bar
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
        // //* HOTFIX
        // onUnknownRoute: (settings) {
        //   return MaterialPageRoute(
        //       builder: (BuildContext context) => ChatScreen());
        // },
        theme: customTheme,
        //* Listens to authStateChanges to know whether to log the user in/out
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
                    //TODO: Better error handling
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
          //* ALSO HOTFIX
          '/base/chat': (context) => const ChatScreen(),
        });
  }
}
