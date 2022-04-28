import 'dart:async';

import 'package:fcm_demo/model/PushNotificationNew.dart';
import 'package:fcm_demo/ui/Accept_call_screen.dart';
import 'package:fcm_demo/ui/Reject_call_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:connectycube_flutter_call_kit/connectycube_flutter_call_kit.dart';
import 'package:flutter_ios_voip_kit/flutter_ios_voip_kit.dart';

import 'package:overlay_support/overlay_support.dart';

const String sessionId = "6A967474-8672-4ABC-A57B-52EA809C5E6D";

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");

  print("Notification ${message.data["caller_name"]}");
  CallEvent callEvent = CallEvent(
      sessionId: sessionId,
      callType: 1,
      callerId: 4,
      callerName: message.data["caller_name"],
      opponentsIds: {5},
      userInfo: {'customParameter1': 'value1'});
  ConnectycubeFlutterCallKit.showCallNotification(callEvent);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // ConnectycubeFlutterCallKit.instance.updateConfig(
  //     ringtone: 'custom_ringtone', icon: 'app_icon', color: '#07711e');
  runZonedGuarded(() {
    FlutterIOSVoIPKit.instance.onDidUpdatePushToken = (token) {
      print('🎈 example: onDidUpdatePushToken token = $token');
    };
    runApp(MyApp());
  }, (object, stackTrace) {
    print('stacktrace $stackTrace');
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        title: 'Notify',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BuildContext? mContext;
  late final FirebaseMessaging _messaging;
  late int _totalNotifications;
  PushNotificationNew? _notificationInfo;

  void registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    print("Token ${await _messaging.getToken()}");

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print(
            'Message1111 title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');
        showNotification(message);
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void showNotification(RemoteMessage message) {
    print("Notification ${message.data["caller_name"]}");
    print("Time ${message.data["session_id"]}");
    CallEvent callEvent = CallEvent(
        sessionId: sessionId,
        callType: 1,
        callerId: 4,
        callerName: message.data["caller_name"],
        opponentsIds: {5},
        userInfo: {'customParameter1': 'value1'});
    ConnectycubeFlutterCallKit.showCallNotification(callEvent);
    // ConnectycubeFlutterCallKit.re(
    //     sessionId: DateTime.now().millisecondsSinceEpoch.toString(),
    //     callType: 1);
    // ConnectycubeFlutterCallKit.reportCallEnded(sessionId: sessionId);
  }

  @override
  void initState() {
    super.initState();
    _totalNotifications = 0;

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Future<void> _onCallAccepted(CallEvent callEvent) async {
        Navigator.push(
          mContext!,
          MaterialPageRoute(
            builder: (mContext) => const AcceptCallScreen(),
          ),
        );
      }

      Future<void> _onCallRejected(CallEvent callEvent) async {
        Navigator.push(
          mContext!,
          MaterialPageRoute(
            builder: (mContext) => const RejectCallScreen(),
          ),
        );
      }

      ConnectycubeFlutterCallKit.instance.init(
          onCallAccepted: _onCallAccepted,
          onCallRejected: _onCallRejected,
          ringtone: "",
          icon: "",
          color: "");
    });
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Sending Message"),
        ));
        print(
            'Message Initaltitle: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');

        showNotification(message);
      }
    });
    registerNotification();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          'Message Opentitle: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');
      showNotification(message);
    });

    ConnectycubeFlutterCallKit.getToken().then((token) {
      print("Fcm Token $token");
    });

    ConnectycubeFlutterCallKit.onTokenRefreshed = (token) {
      // use refreshed token for resubscription on your server
      print("Refresh Token $token");
    };

    ConnectycubeFlutterCallKit.setOnLockScreenVisibility(isVisible: true);
  }

  @override
  Widget build(BuildContext context) {
    mContext = context;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notify'),
        brightness: Brightness.dark,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'App for capturing Firebase Push Notifications',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16.0),
          // NotificationBadge(totalNotifications: _totalNotifications),
          const SizedBox(height: 16.0),
          _notificationInfo != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TITLE: ${_notificationInfo!.dataTitle ?? _notificationInfo!.title}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'BODY: ${_notificationInfo!.dataBody ?? _notificationInfo!.body}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}

class NotificationBadge extends StatelessWidget {
  final int totalNotifications;

  const NotificationBadge({required this.totalNotifications});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$totalNotifications',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
