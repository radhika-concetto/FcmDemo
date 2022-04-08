import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:fcm_demo/ui/NotificationBadge.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:overlay_support/overlay_support.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
  _notificationInfo = message;
  AwesomeNotifications().createNotificationFromJsonData(message.data);
}

RemoteMessage? _notificationInfo = null;
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterAppBadger.removeBadge();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  FirebaseMessaging.onMessage.listen((message) {
    print("app in forground");

    _notificationInfo = message;
    AwesomeNotifications().createNotificationFromJsonData(message.data);
  });

  // FirebaseMessaging.onMessageOpenedApp.listen((message) {
  //   print("app is in Open mode");
  //   _notificationInfo = message;
  //   AwesomeNotifications().createNotificationFromJsonData(message.data);
  // });
  AwesomeNotifications().initialize(
    null,
    [
      // notification icon
      NotificationChannel(
          channelGroupKey: 'basic_test',
          channelKey: 'FCM',
          channelName: 'fcm notifications',
          channelDescription: 'Notification channel for basic tests',
          // channelShowBadge: true,
          importance: NotificationImportance.High,
          enableVibration: true,
          onlyAlertOnce: true),
    ],
  );
  AwesomeNotifications().actionStream.listen((action) {
    if (action.buttonKeyPressed == "open") {
      print("Open button is pressed");
    } else if (action.buttonKeyPressed == "delete") {
      print("Delete button is pressed.");
    } else {
      print(action.payload); //notification was pressed
    }
  });
  // Create the initialization for your desired push service here

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.getToken().then((value) {
      String? token = value;
      print(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        brightness: Brightness.dark,
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _notificationInfo != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TITLE: ${_notificationInfo?.data[NOTIFICATION_CONTENT]?[NOTIFICATION_TITLE] ?? _notificationInfo?.notification?.title}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'BODY: ${_notificationInfo?.data[NOTIFICATION_CONTENT]?[NOTIFICATION_BODY] ?? _notificationInfo?.notification?.body}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  )
                : Container(),
            // TODO: add the notification text here

            const Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool isallowed = await AwesomeNotifications().isNotificationAllowed();
          if (!isallowed) {
            //no permission of local notification
            AwesomeNotifications().requestPermissionToSendNotifications();
          } else {
            //show notification
            AwesomeNotifications().createNotification(
                content: NotificationContent(
                  //simgple notification
                  id: 123,
                  channelKey: 'FCM',
                  //set configuration wuth key "basic"
                  title: 'Welcome to FlutterCampus.com',
                  body:
                      'This simple notification with action buttons in Flutter App',
                  payload: {"name": "FlutterCampus"},
                  autoDismissible: false,
                ),
                actionButtons: [
                  NotificationActionButton(
                    key: "open",
                    label: "Open File",
                  ),
                  NotificationActionButton(
                    key: "delete",
                    label: "Delete File",
                  )
                ]);
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
