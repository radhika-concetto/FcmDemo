# fcm_demo

A new Flutter project.

## Getting Started
Go to xcode and find below file and add one line in xcode otherwise this demo will not work.
[_channel invokeMethod:@"Messaging#onMessage" arguments:notificationDict];

- [Link](https://github.com/firebase/flutterfire/blob/master/packages/firebase_messaging/firebase_messaging/ios/Classes/FLTFirebaseMessagingPlugin.m#L488)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


curl -v --location --request POST 'https://api.sandbox.push.apple.com/3/device/AEE900394EE0D73B76C3EF7771E154223364289D218BCA7583B514F7673AE7A4' \
-H "apns-push-type: voip" \
-H "apns-expiration: 0" \
-H "apns-priority: 0" \
-H "apns-topic: com.concettolabs.testapp.voip" \
--http2 \
--cert ~/Desktop/voip_services_V1.pem \
--data-raw '{
"aps": {
"alert": {
"uuid": "982cf533-7b1b-4cf6-a6e0-004aab68c503",
"incoming_caller_id": "0123456789",
"incoming_caller_name": "Tester",
"message": "Incoming video call",
"call_type": 1,
"session_id": "6A967474-8672-4ABC-A57B-52EA809C5E6D",
"caller_id": 1,
"caller_name": "Radhika 121",
"call_opponents": "2",
"signal_type": "startCall",
"notificationType": "push",
"channelName": "Calls",
"body": "dasfafdsadf"
}
}
}'
