import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:foodorderingsys/helpers/AppTheme.dart';
import 'package:foodorderingsys/models/order.dart';
import 'package:foodorderingsys/providers/product.dart';
import 'package:foodorderingsys/providers/user.dart';
import 'package:foodorderingsys/screens/logoutPopOut.dart';
import 'package:foodorderingsys/screens/popular_dishes.dart';
import 'package:foodorderingsys/screens/profile.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> with SingleTickerProviderStateMixin {
  BottomBarController controller;
  bool gridshow = false;

  @override
  void initState() {
    controller = BottomBarController(vsync: this, dragLength: 550, snap: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    user.getTotalAmount(user.user.uid);
    return Scaffold(
        backgroundColor: AppTheme.white,
        body: Container(
          height: MediaQuery.of(context).size.height - 20,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: IconButton(
                            icon: Icon(Icons.settings),
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (_) => profile(),
                              );
                            }),
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            "Paradox Restaurant",
                            style: TextStyle(
                                color: AppTheme.dark_grey,
                                fontSize: 25,
                                fontWeight: FontWeight.w800),
                          ),
                          Text(
                            "St-256, AU, Brasbain",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Container(
                            child: IconButton(
                                icon: Icon(Icons.power_settings_new),
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (_) => FunkyOverlay(),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ],
                  )),
                  decoration: BoxDecoration(
                      color: AppTheme.notWhite,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(50),
                          bottomLeft: Radius.circular(50)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[500],
                            offset: Offset(4.0, 4.0),
                            blurRadius: 15.0,
                            spreadRadius: 1.0),
                        BoxShadow(
                            color: Colors.white,
                            offset: Offset(-4.0, -4.0),
                            blurRadius: 15.0,
                            spreadRadius: 1.0),
                      ]),
                ),
                Container(
                  child: Row(children: [
                    Expanded(
                        child: Text('',
                            style: TextStyle(
                              height: 3.0,
                              fontSize: 15.2,
                              fontWeight: FontWeight.bold,
                            ))),
                    Expanded(
                        child: Text('Items',
                            style: TextStyle(
                              height: 3.0,
                              fontSize: 15.2,
                              fontWeight: FontWeight.bold,
                            ))),
                    Expanded(
                        child: Text('',
                            style: TextStyle(
                              height: 3.0,
                              fontSize: 15.2,
                              fontWeight: FontWeight.bold,
                            ))),
                    Expanded(
                        child: Text('Quantity',
                            style: TextStyle(
                              height: 3.0,
                              fontSize: 15.2,
                              fontWeight: FontWeight.bold,
                            ))),
                    Expanded(
                        child: Text('',
                            style: TextStyle(
                              height: 3.0,
                              fontSize: 15.2,
                              fontWeight: FontWeight.bold,
                            ))),
                    Expanded(
                        child: Text('Cost',
                            style: TextStyle(
                              height: 3.0,
                              fontSize: 15.2,
                              fontWeight: FontWeight.bold,
                            ))),
                  ]),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 1.8,
                  child: ListView.builder(
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
                    },
                  ),
                ),
                Consumer<ProductProvider>(builder: (context, provider, _) {
                  return user.Total > 0
                      ? InkWell(
                          onTap: () {
                            showItemspopUp(context, user.Total);
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                child: Center(
                                    child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      "To pay = ",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    Text(
                                      "\$ ${user.Total.toString()}",
                                      style: TextStyle(
                                        fontSize: 35,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                )),
                                decoration: BoxDecoration(
                                    color: AppTheme.notWhite,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[500],
                                          offset: Offset(4.0, 4.0),
                                          blurRadius: 15.0,
                                          spreadRadius: 1.0),
                                      BoxShadow(
                                          color: Colors.white,
                                          offset: Offset(-4.0, -4.0),
                                          blurRadius: 15.0,
                                          spreadRadius: 1.0),
                                    ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: user.Total > 0
                                    ? Text("Tap To Pay")
                                    : Text("paid"),
                              ),
                            ],
                          ),
                        )
                      : Container();
                })
              ],
            ),
          ),
        ));
  }

  showItemspopUp(context, amount) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => StatefulBuilder(
              builder: (context, setState) {
                return Material(
                  type: MaterialType.transparency,
                  child: Center(
                    child: Container(
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 500,
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 30.0),
                                    child: Text(
                                      "Payment Getways",
                                      style: AppTheme.title,
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      final user = Provider.of<UserProvider>(
                                          context,
                                          listen: false);
                                      user.paid(user.user.uid, "In hand");
                                      showToast(context, "Payment Sucessful",
                                          user.Total.toString(), true);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: AppTheme.notWhite,
                                          border: Border(
                                              bottom: BorderSide(
                                                color: AppTheme.dark_grey
                                                    .withOpacity(0.5),
                                                width: 0.5,
                                              ),
                                              right: BorderSide(
                                                color: AppTheme.dark_grey
                                                    .withOpacity(0.5),
                                                width: 0.5,
                                              )),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey[500],
                                                offset: Offset(4.0, 4.0),
                                                blurRadius: 15.0,
                                                spreadRadius: 1.0),
                                            BoxShadow(
                                                color: Colors.white,
                                                offset: Offset(-4.0, -4.0),
                                                blurRadius: 15.0,
                                                spreadRadius: 1.0),
                                          ]),
                                      height: 40,
                                      width: 200,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Icon(Icons.monetization_on),
                                          Text(
                                            "Cash in hand",
                                            style: AppTheme.title,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      _initpayment();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: AppTheme.white,
                                          border: Border(
                                              bottom: BorderSide(
                                                color: AppTheme.dark_grey
                                                    .withOpacity(0.5),
                                                width: 0.5,
                                              ),
                                              right: BorderSide(
                                                color: AppTheme.dark_grey
                                                    .withOpacity(0.5),
                                                width: 0.5,
                                              )),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey[500],
                                                offset: Offset(4.0, 4.0),
                                                blurRadius: 15.0,
                                                spreadRadius: 1.0),
                                            BoxShadow(
                                                color: Colors.white,
                                                offset: Offset(-4.0, -4.0),
                                                blurRadius: 15.0,
                                                spreadRadius: 1.0),
                                          ]),
                                      height: 80,
                                      width: 200,
                                      child: Image.asset(
                                        "assets/images/logo_dark.png",
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      _initpayment();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: AppTheme.notWhite,
                                          border: Border(
                                              bottom: BorderSide(
                                                color: AppTheme.dark_grey
                                                    .withOpacity(0.5),
                                                width: 0.5,
                                              ),
                                              right: BorderSide(
                                                color: AppTheme.dark_grey
                                                    .withOpacity(0.5),
                                                width: 0.5,
                                              )),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey[500],
                                                offset: Offset(4.0, 4.0),
                                                blurRadius: 15.0,
                                                spreadRadius: 1.0),
                                            BoxShadow(
                                                color: Colors.white,
                                                offset: Offset(-4.0, -4.0),
                                                blurRadius: 15.0,
                                                spreadRadius: 1.0),
                                          ]),
                                      height: 80,
                                      width: 200,
                                      child: Image.asset(
                                        "assets/images/khalti.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              decoration: BoxDecoration(
                                  color: AppTheme.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 15,
                                        spreadRadius: 5,
                                        color: Color.fromRGBO(0, 0, 0, .05))
                                  ]),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 10),
                              child: IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  "Payment".toString().toUpperCase(),
                                  style: AppTheme.title,
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ));
  }

  _initpayment() async {
    final user = Provider.of<UserProvider>(context, listen: false);
    /*ESewaConfiguration _configuration = ESewaConfiguration(
        clientID: "JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R",
        secretKey: "BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==",
        environment: ESewaConfiguration.ENVIRONMENT_TEST //ENVIRONMENT_LIVE
        );
    ESewaPayment _payment = ESewaPayment(
        amount: user.Total,
        productName: "food",
        productID: user.userModel.id,
        callBackURL: "http://www.example.com");
    ESewaPnp _eSewaPnp = ESewaPnp(configuration: _configuration);
    try {
      final _res = await _eSewaPnp.initPayment(payment: _payment);
      showToast(context, "Payment Sucessful", user.Total.toString(), true);
    } catch (e) {
      showToast(context, "Payment unSucessful", user.Total.toString(), true);
    }*/
    Navigator.pop(context);
  }
}

class MaterialTile extends StatefulWidget {
  final OrderModel order;

  const MaterialTile(this.order);

  @override
  _MaterialTileState createState() => _MaterialTileState();
}

class _MaterialTileState extends State<MaterialTile> {
  SlidableController slidableController;
  int time = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 43,
      padding: widget.order.paid == 0
          ? EdgeInsets.only(right: 10, left: 10)
          : EdgeInsets.only(right: 10, left: 25),
      child: Container(
        height: 20,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 20,
              blurRadius: 80,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Badge(
          showBadge: widget.order.paid == 0 ? false : true,
          alignment: Alignment.center,
          badgeColor: AppTheme.dark_grey,
          position: BadgePosition.topEnd(top: 10, end: 0),
          badgeContent: Text(
            "Paid",
            style: TextStyle(fontSize: 10, color: AppTheme.white),
          ),
          padding: EdgeInsets.all(10),
          child: ListTile(
            leading: Container(
              height: 15,
              width: 15,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(110),
                child: Container(
                    child: CachedNetworkImage(
                  imageUrl: widget.order.cart[0].image,
                  fit: BoxFit.cover,
                  height: 10,
                  width: 10,
                )),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.order.id.toUpperCase(),
                  //"${widget.food.toUpperCase()}",
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.dark_grey),
                ),
                Text(
                  (widget.order.status).toString(),
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 8),
                ),
                Text(
                  "\$ " + (widget.order.total).toString(),
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 8),
                ),
              ],
            ),
            /* trailing: Text(
              "\$ " + (widget.quantity * widget.cost).toString(),
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 10,
                  fontWeight: FontWeight.w400),
            ),*/
          ),
        ),
      ),
    );
  }
}

//9806800001
//Nepal@123
