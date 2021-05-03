import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodorderingsys/helpers/AppTheme.dart';

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
                  Container(
                      margin: EdgeInsets.only(bottom: 5),
                      width: 50,
                      height: 86,
                      child: Column(
                        children: [
                          FloatingActionButton(
                            shape: CircleBorder(),
                            heroTag: "logout",
                            onPressed: () {},
                            backgroundColor: AppTheme.white,
                            child: Icon(Icons.power_settings_new,
                                size: 35, color: Colors.black87),
                          ),
                          Text("asda")
                        ],
                      )),
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
                              /* FirebaseAuth.instance.signOut().then((value) {
                                widget.appstate.logout().then((value) {
                                  if (value == "ok") {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginOption()));
                                  }
                                });
                              });*/
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
