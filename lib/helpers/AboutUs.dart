import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodorderingsys/helpers/AppTheme.dart';

class aboutUs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => aboutUsState();
}

class aboutUsState extends State<aboutUs> with SingleTickerProviderStateMixin {
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
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset("assets/images/delivery.png"),
                          Text(
                            "asdsad sdsd sad dsad asd asd sadas sad sds dasd ds ad asd sd"
                            " sdasd asd sad  dasdsdsd sd"
                            "sdsadsd sads dsad d asd",
                            maxLines: 5,
                          )
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

class editEmail extends StatefulWidget {
  final phone;

  const editEmail(this.phone);

  @override
  State<StatefulWidget> createState() => editEmailState();
}

class editEmailState extends State<editEmail>
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
    print(widget.phone);
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
                  SingleChildScrollView(
                    child: Container(
                        margin: EdgeInsets.only(bottom: 5),
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            widget.phone == ""
                                ? Text("No Phone Number"
                                    "")
                                : Text(widget.phone.toString()),
                            Row(
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: Form(
                                    child: TextFormField(
                                      style: TextStyle(
                                        color:
                                            AppTheme.dark_grey.withOpacity(0.5),
                                      ),
                                      decoration: new InputDecoration(
                                          hintText: "Phone number",
                                          prefixText: "+977 ",
                                          prefixStyle: TextStyle(
                                              color: AppTheme.dark_grey)),
                                      keyboardType: TextInputType.phone,
                                      maxLength: 10,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter your phone number';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text("Change"),
                                ),
                              ],
                            )
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
