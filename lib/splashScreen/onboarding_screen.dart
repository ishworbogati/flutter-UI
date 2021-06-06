import 'package:flutter/material.dart';
import 'package:foodorderingsys/helpers/AppTheme.dart';
import 'package:foodorderingsys/splashScreen/page_one.dart';
import 'package:foodorderingsys/splashScreen/page_three.dart';
import 'package:foodorderingsys/splashScreen/page_two.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final pages = [
    Container(child: PageOne()),
    Container(
      child: PageTwo(),
    ),
    Container(
      child: PageThree(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiquidSwipe(
        pages: pages,
        fullTransitionValue: 600,
        enableSideReveal: true,
        enableLoop: false,
        positionSlideIcon: 0.9,
        waveType: WaveType.circularReveal,
        slideIconWidget: Icon(
          Icons.arrow_back_ios,
          size: 18,
          color: AppTheme.dark_grey,
        ),
        initialPage: 0,
      ),
    );
  }
}
