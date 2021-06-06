import 'package:flutter/material.dart';
import 'package:foodorderingsys/helpers/AppTheme.dart';
import 'package:foodorderingsys/helpers/screen_navigation.dart';
import 'package:foodorderingsys/models/order.dart';
import 'package:foodorderingsys/providers/user.dart';
import 'package:foodorderingsys/screenOrder/MyOrders.dart';
import 'package:foodorderingsys/screens/hotel_app.dart';
import 'package:foodorderingsys/widgets/custom_text.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class foodTracker extends StatefulWidget {
  @override
  _foodTrackerState createState() => _foodTrackerState();
}

class _foodTrackerState extends State<foodTracker>
    with TickerProviderStateMixin {
  // final timerDuration = Duration(milliseconds: 2500);
  bool _show = true;
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _show = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    user.getOrders();

    return Scaffold(
      backgroundColor: AppTheme.notWhite,
      floatingActionButton: InkWell(
        onTap: () {
          changeScreenReplacement(context, hotel_home());
        },
        child: Container(
          height: 50,
          padding: EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 15,
          ),
          margin: EdgeInsets.symmetric(
            horizontal: 50,
          ),
          // height: 174,
          decoration: BoxDecoration(
            color: AppTheme.dark_grey,
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, -15),
                blurRadius: 20,
                color: Color(0xFFDADADA).withOpacity(0.15),
              )
            ],
          ),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                text: "Home",
                size: 20,
                color: AppTheme.white,
                weight: FontWeight.normal,
              ),
              SizedBox(width: 20,),
              Icon(
                Icons.fastfood,
                size: 16,
                color: AppTheme.white,
              )
            ],
          )),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            _show
                ? Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.green,
                    child: Column(
                      children: [
                        Icon(
                          Icons.done_all,
                          color: AppTheme.dark_grey,
                          size: 35,
                        ),
                        Text(
                          "Payment Completed !!",
                          style: TextStyle(
                              color: AppTheme.dark_grey, fontSize: 20),
                        ),
                        Text(
                          "Order Registered !!",
                          style: TextStyle(
                              color: AppTheme.dark_grey, fontSize: 30),
                        )
                      ],
                    ),
                  )
                : Container(),
            SizedBox(
              height: 10,
            ),
            Card(
              color: AppTheme.white,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.drag_handle_sharp),
                    title: Text(user.userModel.id),
                  ),
                  ListTile(
                    leading: Icon(Icons.alternate_email),
                    title: Text(user.userModel.email),
                  ),
                  ListTile(
                    leading: Icon(Icons.home_rounded),
                    title: Text(user.userModel.name),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text(user.userModel.phone),
                  ),
                  ListTile(
                    leading: Icon(Icons.monetization_on),
                    title: Text("Cash In Hand/E-sewa"),
                  ),
                  ListTile(
                    leading: Icon(Icons.timer),
                    title: Text("30 - 35 min"),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "All Orders",
                  style: AppTheme.title,
                ),
                LimitedBox(
                    child: ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: user.orders.length,
                        itemBuilder: (_, index) {
                          OrderModel _order = user.orders[index];
                          var date =
                              DateFormat('yyyy-MM-dd').format(DateTime.now());
                          if (DateTime.parse(_order.date)
                                  .compareTo(DateTime.parse(date)) ==
                              0) {
                            return MaterialTile(_order);
                          } else
                            return Container();
                        })),
              ],
            )
            /*  Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: OutlineButton(
                borderSide: BorderSide(width: 1.0, color: AppTheme.d,
                color: FoodColors.Blue,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 50),
                      Text(
                        'GO TO TRUCK',
                        style: TextStyle(fontSize: 15, color: FoodColors.Blue),
                      ),
                      SizedBox(width: 50),
                      Image.asset(
                        'assets/images/icon_direction.png',
                        scale: 2,
                      )
                    ],
                  ),
                ),
                onPressed: () {},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
