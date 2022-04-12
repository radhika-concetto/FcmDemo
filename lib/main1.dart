import 'dart:math';

// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:fcm_demo/ui/incoming_call_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:connectycube_flutter_call_kit/connectycube_flutter_call_kit.dart';
// import 'package:connectycube_sdk/connectycube_sdk.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //
  print("Handling a background message: ${message.messageId}");
  // _notificationInfo = message;
  // ConnectycubeFlutterCallKit.showCallNotification(message.data);

  print("Notification ${message.data["caller_name"]}");
  CallEvent callEvent = CallEvent(
      sessionId: DateTime.now().millisecondsSinceEpoch.toString(),
      callType: 1,
      callerId: 4,
      callerName: message.data["caller_name"],
      opponentsIds: {5},
      userInfo: {'customParameter1': 'value1'});
  ConnectycubeFlutterCallKit.showCallNotification(callEvent);
  // AwesomeNotifications().createNotificationFromJsonData(message.data);
}

void main() async {
  // AwesomeNotifications().initialize(
  //   null,
  //   [
  //     // notification icon
  //     NotificationChannel(
  //         channelGroupKey: 'basic_test',
  //         channelKey: 'FCM',
  //         channelName: 'fcm notifications',
  //         channelDescription: 'Notification channel for basic tests',
  //         // channelShowBadge: true,
  //         importance: NotificationImportance.High,
  //         enableVibration: true,
  //         onlyAlertOnce: true),
  //   ],
  // );
  // AwesomeNotifications().actionStream.listen((action) {
  //   if (action.buttonKeyPressed == "open") {
  //     print("Open button is pressed");
  //   } else if (action.buttonKeyPressed == "delete") {
  //     print("Delete button is pressed.");
  //   } else {
  //     print(action.payload); //notification was pressed
  //   }
  // });
  // Create the initialization for your desired push service here

  // ConnectycubeFlutterCallKit.getToken().then((token) {
  //   print("Fcm Token $token");
  //   // use received token for subscription on push notifications on your server
  // });
  //
  // ConnectycubeFlutterCallKit.onTokenRefreshed = (token) {
  //   // use refreshed token for resubscription on your server
  //   print("Refresh Token $token");
  // };

  // var callState = await ConnectycubeFlutterCallKit.getCallState(sessionId: sessionId);
  // P2PCallSession incomingCall = P2PCallSession();

  // var sessionId = await ConnectycubeFlutterCallKit.getLastCallId();
  //
  // var callData =
  //     await ConnectycubeFlutterCallKit.getCallData(sessionId: sessionId);

  // var callData =
  //     await ConnectycubeFlutterCallKit.getCallState(sessionId: sessionId);

  // val callType = callData["call_type"]?.toInt();
  // val callInitiatorId = data["caller_id"]?.toInt()
  // val callInitiatorName = data["caller_name"]
  // val callOpponentsString = data["call_opponents"]
  // var callOpponents = ArrayList<Int>()
  // if (callOpponentsString != null) {
  //   callOpponents = ArrayList(callOpponentsString.split(',').map { it.toInt() })
  // }

  // CallEvent callEvent = CallEvent(
  //     sessionId: sessionId!!,
  //     callType: callData?["call_type"],
  //     callerId: callData?["caller_id"],
  //     callerName: 'Caller Name',
  //     opponentsIds: callData?["call_opponents"],
  //     userInfo: {'customParameter1': 'value1'});
  // ConnectycubeFlutterCallKit.showCallNotification(callEvent);

  // Future<void> _onCallAccepted(CallEvent callEvent) async {
  //   // the call was accepted
  // }
  //
  // Future<void> _onCallRejected(CallEvent callEvent) async {
  //   // the call was rejected
  // }
  //
  // ConnectycubeFlutterCallKit.instance.init(
  //   onCallAccepted: _onCallAccepted,
  //   onCallRejected: _onCallRejected,
  // );
  //
  // ConnectycubeFlutterCallKit.setOnLockScreenVisibility(isVisible: true);

  // ConnectycubeFlutterCallKit.onCallRejectedWhenTerminated =
  //     onCallRejectedWhenTerminated;
  // ConnectycubeFlutterCallKit.onCallAcceptedWhenTerminated =
  //     onCallAcceptedWhenTerminated;

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
  late final FirebaseMessaging _messaging;
  void initState() {
    registerNotification();
    checkForInitialMessage();

    ConnectycubeFlutterCallKit.getToken().then((token) {
      print("Fcm Token $token");
      // use received token for subscription on push notifications on your server
    });

    ConnectycubeFlutterCallKit.onTokenRefreshed = (token) {
      // use refreshed token for resubscription on your server
      print("Refresh Token $token");
    };

    Future<void> _onCallAccepted(CallEvent callEvent) async {
      // the call was accepted
    }

    Future<void> _onCallRejected(CallEvent callEvent) async {
      // the call was rejected
    }

    ConnectycubeFlutterCallKit.instance.init(
      onCallAccepted: _onCallAccepted,
      onCallRejected: _onCallRejected,
    );

    ConnectycubeFlutterCallKit.setOnLockScreenVisibility(isVisible: true);

    // FlutterAppBadger.removeBadge();
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("app is in Background mode");
      print("Notification BG ${message.data["caller_name"]}");

      CallEvent callEvent = CallEvent(
          sessionId: DateTime.now().millisecondsSinceEpoch.toString(),
          callType: 1,
          callerId: 4,
          callerName: message.data["caller_name"],
          opponentsIds: {5},
          userInfo: {'customParameter1': 'value1'});
      ConnectycubeFlutterCallKit.showCallNotification(callEvent);
    });

    FirebaseMessaging.instance.getToken().then((value) {
      String? token = value;
      print(token);
    });
    super.initState();
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
            // _notificationInfo != null
            //     ? Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             'TITLE: ${_notificationInfo?.data[NOTIFICATION_CONTENT]?[NOTIFICATION_TITLE] ?? _notificationInfo?.notification?.title}',
            //             style: TextStyle(
            //               fontWeight: FontWeight.bold,
            //               fontSize: 16.0,
            //             ),
            //           ),
            //           SizedBox(height: 8.0),
            //           Text(
            //             'BODY: ${_notificationInfo?.data[NOTIFICATION_CONTENT]?[NOTIFICATION_BODY] ?? _notificationInfo?.notification?.body}',
            //             style: TextStyle(
            //               fontWeight: FontWeight.bold,
            //               fontSize: 16.0,
            //             ),
            //           ),
            //         ],
            //       )
            //     : Container(),
            // TODO: add the notification text here

            const Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          CallEvent callEvent = CallEvent(
              sessionId: DateTime.now().millisecondsSinceEpoch.toString(),
              callType: 1,
              callerId: 4,
              callerName: 'Caller Name',
              opponentsIds: {5},
              userInfo: {'customParameter1': 'value1'});
          ConnectycubeFlutterCallKit.showCallNotification(callEvent);

          Navigator.push(
            context!,
            MaterialPageRoute(
              builder: (context) => IncomingCallScreen(),
            ),
          );

          // bool isallowed = await AwesomeNotifications().isNotificationAllowed();
          // CreateEventParams params = CreateEventParams();
          // params.parameters = {
          //   'message':
          //       "Incoming ${currentCall.callType == CallType.VIDEO_CALL ? "Video" : "Audio"} call",
          //   'call_type': currentCall.callType,
          //   'session_id': currentCall.sessionId,
          //   'caller_id': currentCall.callerId,
          //   'caller_name': callerName,
          //   'call_opponents': currentCall.opponentsIds.join(','),
          //   'signal_type': 'startCall',
          //   'ios_voip': 1,
          // };
          //
          // params.notificationType = NotificationType.PUSH;
          // params.environment = CubeEnvironment.DEVELOPMENT; // not important
          // params.usersIds = currentCall.opponentsIds.toList();
          //
          // createEvent(params.getEventForRequest()).then((cubeEvent) {
          //   // event was created
          // }).catchError((error) {
          //   // something went wrong during event creation
          // });
          // if (!isallowed) {
          //   //no permission of local notification
          //   AwesomeNotifications().requestPermissionToSendNotifications();
          // } else {
          //   //show notification
          //   AwesomeNotifications().createNotification(
          //       content: NotificationContent(
          //         //simgple notification
          //         id: 123,
          //         channelKey: 'FCM',
          //         //set configuration wuth key "basic"
          //         title: 'Welcome to FlutterCampus.com',
          //         body:
          //             'This simple notification with action buttons in Flutter App',
          //         payload: {"name": "FlutterCampus"},
          //         autoDismissible: false,
          //       ),
          //       actionButtons: [
          //         NotificationActionButton(
          //           key: "open",
          //           label: "Open File",
          //         ),
          //         NotificationActionButton(
          //           key: "delete",
          //           label: "Delete File",
          //         )
          //       ]);
          // }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

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

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      FirebaseMessaging.onMessage.listen((message) {
        print("app in forground");

        print("Notification ${message.data["caller_name"]}");
        CallEvent callEvent = CallEvent(
            sessionId: DateTime.now().millisecondsSinceEpoch.toString(),
            callType: 1,
            callerId: 4,
            callerName: message.data["caller_name"],
            opponentsIds: {5},
            userInfo: {'customParameter1': 'value1'});
        ConnectycubeFlutterCallKit.showCallNotification(callEvent);

        // AwesomeNotifications().createNotificationFromJsonData(message.data);
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // if (initialMessage != null) {
    //   print("app in forground");
    //
    //   print("Notification ${initialMessage.data["caller_name"]}");
    //   // CallEvent callEvent = CallEvent(
    //   //     sessionId: DateTime.now().millisecondsSinceEpoch.toString(),
    //   //     callType: 1,
    //   //     callerId: 4,
    //   //     callerName: initialMessage.data["caller_name"],
    //   //     opponentsIds: {5},
    //   //     userInfo: {'customParameter1': 'value1'});
    //   // ConnectycubeFlutterCallKit.showCallNotification(callEvent);
    // }
  }
}
// import 'package:connectycube_flutter_call_kit/connectycube_flutter_call_kit.dart';
// import 'package:fcm_demo/model/PushNotificationNew.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:overlay_support/overlay_support.dart';
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Handling a background message: ${message.messageId}");
// }
//
// void main() async {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return OverlaySupport(
//       child: MaterialApp(
//         title: 'Notify',
//         theme: ThemeData(
//           primarySwatch: Colors.deepPurple,
//         ),
//         debugShowCheckedModeBanner: false,
//         home: HomePage(),
//       ),
//     );
//   }
// }
//
// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   late final FirebaseMessaging _messaging;
//   late int _totalNotifications;
//   PushNotificationNew? _notificationInfo;
//
//   void registerNotification() async {
//     await Firebase.initializeApp();
//     _messaging = FirebaseMessaging.instance;
//
//     FirebaseMessaging.instance.getToken().then((value) {
//       String? token = value;
//       print(token);
//     });
//
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//     NotificationSettings settings = await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       provisional: false,
//       sound: true,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission');
//
//       FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//         print(
//             'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');
//
//         // Parse the message received
//         PushNotificationNew notification = PushNotificationNew(
//           title: message.notification?.title,
//           body: message.notification?.body,
//           dataTitle: message.data['title'],
//           dataBody: message.data['body'],
//         );
//
//         setState(() {
//           _notificationInfo = notification;
//           _totalNotifications++;
//         });
//
//         if (_notificationInfo != null) {
//           // For displaying the notification as an overlay
//           CallEvent callEvent = CallEvent(
//               sessionId: DateTime.now().millisecondsSinceEpoch.toString(),
//               callType: 1,
//               callerId: 4,
//               callerName: message.data["caller_name"],
//               opponentsIds: {5},
//               userInfo: {'customParameter1': 'value1'});
//           ConnectycubeFlutterCallKit.showCallNotification(callEvent);
//         }
//       });
//     } else {
//       print('User declined or has not accepted permission');
//     }
//   }
//
//   // For handling notification when the app is in terminated state
//   checkForInitialMessage() async {
//     await Firebase.initializeApp();
//     RemoteMessage? initialMessage =
//         await FirebaseMessaging.instance.getInitialMessage();
//
//     if (initialMessage != null) {
//       PushNotificationNew notification = PushNotificationNew(
//         title: initialMessage.notification?.title,
//         body: initialMessage.notification?.body,
//         dataTitle: initialMessage.data['title'],
//         dataBody: initialMessage.data['body'],
//       );
//
//       setState(() {
//         _notificationInfo = notification;
//         _totalNotifications++;
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     _totalNotifications = 0;
//     registerNotification();
//     checkForInitialMessage();
//
//     // For handling notification when the app is in background
//     // but not terminated
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       PushNotificationNew notification = PushNotificationNew(
//         title: message.notification?.title,
//         body: message.notification?.body,
//         dataTitle: message.data['title'],
//         dataBody: message.data['body'],
//       );
//
//       setState(() {
//         _notificationInfo = notification;
//         _totalNotifications++;
//       });
//     });
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notify'),
//         brightness: Brightness.dark,
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             'App for capturing Firebase Push Notifications',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 20,
//             ),
//           ),
//           SizedBox(height: 16.0),
//           NotificationBadge(totalNotifications: _totalNotifications),
//           SizedBox(height: 16.0),
//           _notificationInfo != null
//               ? Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'TITLE: ${_notificationInfo!.dataTitle ?? _notificationInfo!.title}',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16.0,
//                       ),
//                     ),
//                     SizedBox(height: 8.0),
//                     Text(
//                       'BODY: ${_notificationInfo!.dataBody ?? _notificationInfo!.body}',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16.0,
//                       ),
//                     ),
//                   ],
//                 )
//               : Container(),
//         ],
//       ),
//     );
//   }
// }
//
// class NotificationBadge extends StatelessWidget {
//   final int totalNotifications;
//
//   const NotificationBadge({required this.totalNotifications});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 40.0,
//       height: 40.0,
//       decoration: new BoxDecoration(
//         color: Colors.red,
//         shape: BoxShape.circle,
//       ),
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             '$totalNotifications',
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//         ),
//       ),
//     );
//   }
// }
