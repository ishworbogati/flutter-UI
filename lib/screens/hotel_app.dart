import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:foodorderingsys/helpers/AppTheme.dart';
import 'package:foodorderingsys/main.dart';
import 'package:foodorderingsys/providers/user.dart';
import 'package:foodorderingsys/screenOrder/MyOrders.dart';
import 'package:foodorderingsys/screens/menu_page.dart';
import 'package:foodorderingsys/screens/profile.dart';
import 'package:provider/provider.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

class hotel_home extends StatefulWidget {
  @override
  _hotel_homeState createState() => _hotel_homeState();
}

class _hotel_homeState extends State<hotel_home> {
  int _selectedTab = 0;
  final _tabs = [
    menu(),
    menu(),
    Orders(),
    profile(),
  ];
  final List<TitledNavigationBarItem> items = [
    TitledNavigationBarItem(title: Text("Menu"), icon: Icons.menu),
    TitledNavigationBarItem(title: Text("Hot"), icon: Icons.local_post_office),
    TitledNavigationBarItem(title: Text("Order"), icon: Icons.fastfood),
    TitledNavigationBarItem(title: Text("Account"), icon: Icons.person),
  ];
  DateTime currentBackPressTime;

  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: AppTheme.notWhite,
                playSound: true,
                icon: '@drawable/hotel',
              ),
            ));
      }
      super.initState();
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body)],
                  ),
                ),
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context);
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: _tabs[_selectedTab],
        bottomNavigationBar: TitledBottomNavigationBar(
          indicatorColor: AppTheme.dark_grey,
          currentIndex: _selectedTab,
          enableShadow: true,
          onTap: (index) {
            setState(() {
              _selectedTab = index;
            });
          },
          reverse: true,
          curve: Curves.easeInOutQuart,
          items: items,
          activeColor: Colors.red,
          inactiveColor: Colors.blueGrey,
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Are you sure?'),
                content: Text('Do you want to exit an App'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  FlatButton(
                    child: Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  )
                ],
              );
            },
          ) ??
          false;
    }
    return Future.value(true);
  }
}
