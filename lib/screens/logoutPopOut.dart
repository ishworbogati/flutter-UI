import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodorderingsys/helpers/AppTheme.dart';
import 'package:foodorderingsys/providers/user.dart';
import 'package:foodorderingsys/screens/login.dart';
import 'package:provider/provider.dart';

class FunkyOverlay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FunkyOverlayState();
}

class FunkyOverlayState extends State<FunkyOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {});

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.only(bottom: 5),
                      width: 50,
                      height: 86,
                      child: Column(
                        children: [
                          FloatingActionButton(
                            shape: CircleBorder(),
                            heroTag: "seissiom",
                            onPressed: () {
                              user.signOut();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  PageRouteBuilder(pageBuilder:
                                      (BuildContext context,
                                          Animation animation,
                                          Animation secondaryAnimation) {
                                    return LoginScreen();
                                  }, transitionsBuilder: (BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation,
                                      Widget child) {
                                    return new SlideTransition(
                                      position: new Tween<Offset>(
                                        begin: const Offset(1.0, 0.0),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: child,
                                    );
                                  }),
                                  (Route route) => false);
                              /*    widget.appstate.sessionLogout().then((value) {
                                if (value == "ok") {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              initialoptionchoose()));
                                }
                              });*/
                            },
                            backgroundColor: AppTheme.white,
                            child: Icon(Icons.power_settings_new,
                                size: 35, color: Colors.black87),
                          ),
                          Text("Session")
                        ],
                      )),
                  /*   Container(
                      margin: EdgeInsets.only(bottom: 5),
                      width: 50,
                      height: 86,
                      child: Column(
                        children: [
                          FloatingActionButton(
                            shape: CircleBorder(),
                            heroTag: "logout",
                            onPressed: () {
                              user.signOut();
                              changeScreenReplacement(context, LoginScreen());
                            },
                            backgroundColor: AppTheme.white,
                            child: Icon(Icons.power_settings_new,
                                size: 35, color: Colors.black87),
                          ),
                          Text("asda")
                        ],
                      )),*/
                  Container(
                      margin: EdgeInsets.only(bottom: 5),
                      width: 50,
                      height: 86,
                      child: Column(
                        children: [
                          FloatingActionButton(
                            shape: CircleBorder(),
                            heroTag: "logout",
                            onPressed: () async {
                              user.signOut();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  PageRouteBuilder(pageBuilder:
                                      (BuildContext context,
                                          Animation animation,
                                          Animation secondaryAnimation) {
                                    return LoginScreen();
                                  }, transitionsBuilder: (BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation,
                                      Widget child) {
                                    return new SlideTransition(
                                      position: new Tween<Offset>(
                                        begin: const Offset(1.0, 0.0),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: child,
                                    );
                                  }),
                                  (Route route) => false);
                            },
                            backgroundColor: AppTheme.white,
                            child: Icon(Icons.power_settings_new,
                                size: 35, color: Colors.black87),
                          ),
                          Text("Logout")
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
