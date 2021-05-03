import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodorderingsys/helpers/AppTheme.dart';
import 'package:foodorderingsys/screenOrder/MyOrders.dart';
import 'package:foodorderingsys/screens/Accountpage.dart';
import 'package:foodorderingsys/screens/menu_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

class hotel_home extends StatefulWidget {
  @override
  _hotel_homeState createState() => _hotel_homeState();
}

class _hotel_homeState extends State<hotel_home> {
  Timer t;
  int _selectedTab = 0;
  final _tabs = [
    menu(),
    menu(),
    Orders(),
    Account(),
  ];
  final List<TitledNavigationBarItem> items = [
    TitledNavigationBarItem(title: Text("Menu"), icon: Icons.menu),
    TitledNavigationBarItem(title: Text("Hot"), icon: Icons.local_post_office),
    TitledNavigationBarItem(title: Text("Order"), icon: Icons.fastfood),
    TitledNavigationBarItem(title: Text("Account"), icon: Icons.person),
  ];

  @override
  void initState() {
    t = Timer.periodic(new Duration(seconds: 1), (timer) {});
    Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
