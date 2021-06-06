import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

Future<void> sendNotification(message, title, admintoken, id) async {
  var token = admintoken;
  print('token : $token');

  final data = {
    "notification": {"body": message, "title": title},
    "priority": "high",
    "data": {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": id,
      "status": "done"
    },
    "to": "$token"
  };

  final headers = {
    'content-type': 'application/json',
    'Authorization':
        'key=AAAAZiXhmTE:APA91bFG4LAtdjd-1F_SC0B4CAql39qWWEKycg7Ybs_r1vuJxE8ag8dEOxbScM6tk3G8spuKTjBrYxuWRJ33q9jdTDQ9wRoFZJgjDfmAamCHcuMMkGaM-0dzK5ak1JR8GTo0QjinxOQ2'
  };

  BaseOptions options = new BaseOptions(
    connectTimeout: 5000,
    receiveTimeout: 3000,
    headers: headers,
  );

  try {
    final response = await Dio(options)
        .post("https://fcm.googleapis.com/fcm/send", data: data);

    if (response.statusCode == 200) {
      print("this is notification");
    } else {
      print('notification sending failed');
    }
  } catch (e) {
    print('exception $e');
  }
}
