import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:foodorderingsys/helpers/AppTheme.dart';
import 'package:foodorderingsys/models/order.dart';
import 'package:foodorderingsys/providers/app.dart';
import 'package:foodorderingsys/providers/product.dart';
import 'package:foodorderingsys/providers/user.dart';
import 'package:foodorderingsys/screens/popular_dishes.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:toast/toast.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> with SingleTickerProviderStateMixin {
  bool loading = false;
  BottomBarController controller;
  final _key = GlobalKey<ScaffoldState>();
  ScrollController scrollController;

  bool gridshow = false;
  int sum = 0;

  @override
  void initState() {
    controller = BottomBarController(vsync: this, dragLength: 550, snap: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    return Scaffold(
      extendBody: true,
      floatingActionButton: GestureDetector(
        onVerticalDragUpdate: controller.onDrag,
        onVerticalDragEnd: controller.onDragEnd,
        child: FloatingActionButton.extended(
          label: Text("Pull menu"),
          elevation: 5,
          backgroundColor: AppTheme.dark_grey,
          foregroundColor: AppTheme.white,
          onPressed: () => controller.swap(),
        ),
      ),
      backgroundColor: AppTheme.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(controller.dragLength),
        child: Consumer<ProductProvider>(
          builder: (context, provider, _) {
            return BottomExpandableAppBar(
              controller: controller,
              expandedHeight: controller.dragLength,
              horizontalMargin: 15,
              attachSide: Side.Top,
              expandedBackColor: AppTheme.grey,
              expandedBody: _pull(),
              bottomAppBarBody: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(110),
                      child: Container(
                          width: 25,
                          height: 25,
                          child: CachedNetworkImage(
                            imageUrl: "profile_image_url",
                            fit: BoxFit.cover,
                            height: 30,
                            width: 30,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Orders",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Spacer(
                      flex: 5,
                    ),
                    Row(
                      children: [
                        Center(
                          child: IconButton(
                              icon: Icon(
                                Icons.collections_bookmark,
                                color: AppTheme.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  gridshow = !gridshow;
                                });
                              }),
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            AwesomeDialog(
                              context: context,
                              padding: EdgeInsets.only(top: 2),
                              headerAnimationLoop: false,
                              dialogType: DialogType.INFO,
                              animType: AnimType.BOTTOMSLIDE,
                              body: showpopUp(context, user.userModel.cart),
                              tittle: "Orders",
                              btnOk: FloatingActionButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                backgroundColor: AppTheme.dark_grey,
                                child: Text("Close"),
                              ),
                              btnCancel: FloatingActionButton(
                                onPressed: () {
                                  // uploadCarttoFirebase();
                                },
                                backgroundColor: AppTheme.dark_grey,
                                child: Text("Send"),
                              ),
                              desc: 'The operation was successfully completed.',
                            ).show();
                          },
                          backgroundColor: AppTheme.white,
                          child: Icon(Icons.shopping_cart,
                              size: 23, color: Colors.black87),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width - 20,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                !gridshow ? _listdata() : _griddata1(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _listdata() {
    final user = Provider.of<UserProvider>(context);
    user.getOrders();
    return Container(
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
            color: AppTheme.dark_grey.withOpacity(0.5),
            width: 0.5,
          )),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppTheme.dark_grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        height: MediaQuery.of(context).size.height - 20,
        child: ListView.builder(
            itemCount: user.orders.length,
            itemBuilder: (_, index) {
              OrderModel _order = user.orders[index];
              return MaterialTile(_order);
            }));
  }

  Widget _griddata1() {
    final user = Provider.of<UserProvider>(context);
    return Container(
        height: MediaQuery.of(context).size.height - 20,
        color: Colors.white30,
        child: ListView.builder(
            itemCount: user.orders.length,
            itemBuilder: (_, index) {
              OrderModel _order = user.orders[index];
              return LimitedBox(
                  maxHeight: 300.0,
                  child: GridView.builder(
                      itemCount: _order.cart.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4),
                      itemBuilder: (context, index) {
                        return Container(child: Gridcard(_order));
                      })
                  /* GridView.count(
                      crossAxisCount: 4,
                      childAspectRatio: 1.0,
                      padding: const EdgeInsets.all(4.0),
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        if ((document["user"] == user_email) &&
                            (document["show"] == 1)) {
                          return Gridcard(
                              document.documentID,
                              document['Table'],
                              document['user'],
                              document['food name'],
                              document['url'],
                              document['date'] as Timestamp,
                              document["Time"],
                              document["initialtime"]);
                        }
                      }).toList());
              }
            }));*/
                  );
            }));
  }

  Widget _pull() {
    final user = Provider.of<UserProvider>(context, listen: false);
    didChangeDependencies();

    return Container(
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.only(top: 55),
      child: Container(
        height: 430,
        child: Stack(
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('fooditems')
                  .orderBy("COST", descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Text('Loading...');
                  default:
                    return GroupedListView<dynamic, String>(
                      elements: snapshot.data.documents,
                      groupBy: (element) => element['CATEGORY'],
                      sort: true,
                      order: GroupedListOrder.ASC,
                      groupSeparatorBuilder: (String groupByValue) => Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, bottom: 2, top: 5),
                        child: Text(
                          groupByValue.toUpperCase(),
                          style: TextStyle(
                              color: AppTheme.nearlyWhite,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1),
                        ),
                      ),
                      itemBuilder: (context, dynamic element) {
                        return Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            height: 35,
                            alignment: Alignment.center,
                            child: Card(
                                elevation: 4,
                                color: AppTheme.notWhite.withOpacity(0.5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        element["FOODNAME"]
                                            .toString()
                                            .toUpperCase(),
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.add_box,
                                        color: AppTheme.darkerText,
                                        size: 14,
                                      ),
                                      onPressed: () {
                                        showpopOrderUp(context, element);
                                      },
                                    )
                                  ],
                                )));
                      },
                    );
                }
              },
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: ((user.userModel.cart.length > 0))
                  ? Container(
                      margin: EdgeInsets.only(right: 15, bottom: 15),
                      width: 40,
                      height: 46,
                      child: FloatingActionButton(
                        shape: CircleBorder(),
                        onPressed: () {
                          AwesomeDialog(
                            context: context,
                            padding: EdgeInsets.only(top: 2),
                            headerAnimationLoop: false,
                            dialogType: DialogType.INFO,
                            animType: AnimType.BOTTOMSLIDE,
                            body: showpopUp(context, user.userModel.cart),
                            tittle: "Orders",
                            btnOk: FloatingActionButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              backgroundColor: AppTheme.dark_grey,
                              child: Text("Close"),
                            ),
                            btnCancel: FloatingActionButton(
                              onPressed: () {
                                // uploadCarttoFirebase();
                              },
                              backgroundColor: AppTheme.dark_grey,
                              child: Text("Send"),
                            ),
                            desc: 'The operation was successfully completed.',
                          ).show();
                        },
                        backgroundColor: AppTheme.white,
                        child: Icon(Icons.shopping_cart,
                            size: 30, color: Colors.black87),
                      ))
                  : Container(),
            )
          ],
        ),
      ),
    );
  }

  cartBody() {
    final user = Provider.of<UserProvider>(context);
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Cart",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
              ),
              IconButton(
                  icon: Icon(Icons.clear_all),
                  onPressed: () {
                    /*clear.clearAllItem();
                    showToast(context, "Removed", "Food cart removed", true);
                    Navigator.of(context).pop();*/
                  })
            ],
          ),
        ),
        StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 270,
              child: ListView.builder(
                  itemCount: user.orders.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return Slidable(
                      key: UniqueKey(),
                      dismissal: SlidableDismissal(
                        onDismissed: (D) {
                          /* showToast(context, "Removed",
                              clear.foodCart[index].name, true);
                          clear.clearOneItem(index);*/
                        },
                        child: Container(
                          child: Icon(Icons.delete),
                        ),
                      ),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          foregroundColor: AppTheme.dark_grey,
                          caption: 'More',
                          color: Colors.transparent,
                          icon: Icons.more_horiz,
                          onTap: () => {},
                        ),
                        IconSlideAction(
                          foregroundColor: AppTheme.dark_grey,
                          caption: 'Cancel',
                          color: Colors.transparent,
                          icon: Icons.delete,
                          onTap: () =>
                              {Toast.show("Swip left to delete", context)},
                        ),
                      ],
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                            color: AppTheme.dark_grey,
                            width: 1.0,
                          )),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.dark_grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 10,
                              offset: Offset(0, 7),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(110),
                            child: Container(
                                width: 40,
                                height: 40,
                                child: CachedNetworkImage(
                                  imageUrl: "clear.foodCart[index].url",
                                  fit: BoxFit.cover,
                                  height: 20,
                                  width: 20,
                                )),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        "user.orders",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        "\$ " +
                                            " clear.foodCart[index].cost"
                                                .toString(),
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  /*   Column(
                                    children: <Widget>[
                                      clear.foodCart[index].takeaway != 0
                                          ? Icon(
                                              Icons.business_center,
                                              size: 15,
                                            )
                                          : Icon(
                                              Icons.room_service,
                                              size: 15,
                                            ),
                                      clear.foodCart[index].takeaway != 0
                                          ? Text(
                                              "Pack",
                                              style: AppTheme.subtitle,
                                            )
                                          : Text(
                                              "Eat",
                                              style: AppTheme.subtitle,
                                            )
                                    ],
                                  ),*/
                                  Column(
                                    children: <Widget>[
                                      Icon(
                                        Icons.local_dining,
                                        size: 15,
                                      ),
                                      Text(
                                        "clear.foodCart[index].quantity"
                                            .toString(),
                                        style: AppTheme.subtitle,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      actionPane: SlidableDrawerActionPane(),
                    );
                  }),
            );
          },
        )
      ],
    );
  }

  showpopOrderUp(context, product) {
    var _quantity = 1;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => StatefulBuilder(
        builder: (_, setState) {
          return Material(
            type: MaterialType.transparency,
            child: Center(
              child: Container(
                margin: EdgeInsets.only(top: 30),
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: EdgeInsets.only(top: 80, bottom: 110),
                          padding: EdgeInsets.only(top: 80),
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(product["FOODNAME"].toString().toUpperCase(),
                                  style: AppTheme.title),
                              Text("\$ " + product["COST"].toString(),
                                  style: AppTheme.subtitle),
                              Container(
                                margin: EdgeInsets.only(top: 5, bottom: 15),
                                child: SmoothStarRating(
                                  allowHalfRating: false,
                                  starCount: 5,
                                  rating: product["RATING"],
                                  size: 27.0,
                                  color: AppTheme.dark_grey,
                                  borderColor: AppTheme.dark_grey,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10, bottom: 15),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      child:
                                          Text('Time', style: AppTheme.title),
                                      margin: EdgeInsets.only(bottom: 10),
                                    ),
                                    Text((product["COST"] + (_quantity * 2))
                                            .toString() +
                                        " min")
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10, bottom: 15),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      child: Text('Quantity',
                                          style: AppTheme.title),
                                      margin: EdgeInsets.only(bottom: 10),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: 45,
                                          height: 45,
                                          child: OutlineButton(
                                            onPressed: () {
                                              setState(() {
                                                if (_quantity == 1) return;
                                                _quantity -= 1;
                                              });
                                            },
                                            child: Icon(Icons.remove),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: Text(_quantity.toString(),
                                              style: AppTheme.body2),
                                        ),
                                        Container(
                                          width: 45,
                                          height: 45,
                                          child: OutlineButton(
                                            onPressed: () {
                                              setState(() {
                                                _quantity += 1;
                                              });
                                            },
                                            child: Icon(Icons.add),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: FloatingActionButton(
                                        shape: CircleBorder(),
                                        heroTag: "buy",
                                        onPressed: () async {
                                          final app = Provider.of<AppProvider>(
                                              context,
                                              listen: false);
                                          final user =
                                              Provider.of<UserProvider>(context,
                                                  listen: false);
                                          app.changeLoading();
                                          bool value = await user.addToCard(
                                              product: product,
                                              quantity: _quantity);
                                          if (value) {
                                            showToast(context, "Food added",
                                                product.name, true);
                                            user.reloadUserModel();
                                            // Navigator.pop(context);
                                            Navigator.of(context).pop();
                                            app.changeLoading();
                                            return;
                                          } else {
                                            print("Item NOT added to cart");
                                          }
                                          print("lOADING SET TO FALSE");

                                          /*  isCircle = true;
                                              fooditemcart fc = fooditemcart(
                                                  itemid,
                                                  name,
                                                  type,
                                                  _quantity,
                                                  cost,
                                                  0,
                                                  ctime,
                                                  url);
                                              cart.addItem(fc);
                                              showToast(context, "Food added",
                                                  name, true);
                                              Navigator.of(context).pop();
                                              setState(() {
                                                _quantity = 1;
                                                _rating = _rating;
                                              });*/
                                        },
                                        backgroundColor: AppTheme.white,
                                        child: Icon(Icons.local_grocery_store,
                                            size: 35, color: Colors.black87),
                                      ),
                                    ),
                                  ]),
                              Spacer(),
                              Container(
                                alignment: Alignment.bottomRight,
                                decoration: BoxDecoration(
                                    color: AppTheme.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 15,
                                          spreadRadius: 5,
                                          color: Color.fromRGBO(0, 0, 0, .05)),
                                    ]),
                                child: IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        _quantity = 1;
                                      });
                                      Navigator.of(context).pop();
                                    }),
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
                        alignment: Alignment.topCenter,
                        child: Container(
                            width: 150,
                            height: 150,
                            child: CachedNetworkImage(
                              imageUrl: "url",
                              fit: BoxFit.fill,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Gridcard extends StatefulWidget {
  final OrderModel order;

  const Gridcard(this.order);

  @override
  _GridcardState createState() => _GridcardState();
}

class _GridcardState extends State<Gridcard> {
  int time = DateTime.now().millisecondsSinceEpoch;
  Timer t;

  @protected
  void initState() {
    t = Timer.periodic(new Duration(seconds: 1), (timer) {
      setState(() {
        time = DateTime.now().millisecondsSinceEpoch;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*var w = widget.time * 60000;*/
    bool
        completestat = /*((time - widget.initialtime) / w) < 0.99 ? true : */ false;
    return Badge(
      showBadge: /*widget.initialtime == 0 ? false : !completestat*/ true,
      badgeContent: Icon(
        Icons.check,
        size: 10,
        color: AppTheme.white,
      ),
      position: BadgePosition.topRight(top: 0, right: 8),
      animationDuration: Duration(milliseconds: 300),
      animationType: BadgeAnimationType.slide,
      badgeColor: AppTheme.dark_grey,
      child: Card(
        child: Container(
          height: 100,
          width: 40,
          child: completestat
              ? CircularPercentIndicator(
                  radius: 60.0,
                  lineWidth: 5.0,
                  addAutomaticKeepAlive: true,
                  curve: Curves.easeIn,
                  percent: 93 /*((time - widget.initialtime) / w)*/,
                  center: ClipRRect(
                    borderRadius: BorderRadius.circular(110),
                    child: Container(
                        child: CachedNetworkImage(
                      imageUrl: " widget.url",
                      fit: BoxFit.cover,
                      height: 30,
                      width: 30,
                    )),
                  ),
                  backgroundColor: Colors.grey,
                  progressColor: AppTheme.dark_grey,
                )
              : Container(
                  width: 100,
                  height: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(110),
                    child: Container(
                        child: CachedNetworkImage(
                      imageUrl: " widget.url",
                      fit: BoxFit.cover,
                      height: 30,
                      width: 30,
                    )),
                  )),
        ),
      ),
    );
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
  Timer t;
//  final NotificationManager notificationManager = NotificationManager();
  TextEditingController titlecomments = new TextEditingController();
  TextEditingController comments = new TextEditingController();
  ScrollController scrollController;

  @protected
  void initState() {
    t = Timer.periodic(new Duration(seconds: 1), (timer) {
      setState(() {
        time = DateTime.now().millisecondsSinceEpoch;
        // total = widget.sum;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
          child: Text(widget.order.url.toString()),
        ),
        LimitedBox(
          maxHeight: 300.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    itemCount: widget.order.cart.length,
                    itemBuilder: (context, index) {
                      var w = widget.order.cart[index].cooktime * 60000;

                      print(time);
                      bool completestat =
                          ((time - widget.order.cart[index].inittime) / w) <
                                  0.99
                              ? true
                              : false;
                      return Card(
                        child: Badge(
                          showBadge: true
                          /*widget.initialtime == 0 ? false : !completestat */,
                          badgeContent: Icon(
                            Icons.check,
                            size: 10,
                            color: AppTheme.white,
                          ),
                          position: BadgePosition.topRight(top: 0, right: 8),
                          animationDuration: Duration(milliseconds: 300),
                          animationType: BadgeAnimationType.slide,
                          badgeColor: AppTheme.dark_grey,
                          child: InkWell(
                            onTap: () {
                              ratingPopUp();
                            },
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                  color: AppTheme.dark_grey.withOpacity(0.5),
                                  width: 0.5,
                                )),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.dark_grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              margin: EdgeInsets.only(top: 8, bottom: 2),
                              padding: EdgeInsets.only(
                                  right: 10, left: 10, top: 5, bottom: 10),
                              child: ListTile(
                                  title: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      /*  Center(
                                        child: Text(
                                          (format.format(date)).toString(),
                                          style: TextStyle(fontSize: 9),
                                        ),
                                      ),*/
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "${widget.order.cart[index].name.toUpperCase()}",
                                            style: TextStyle(
                                                letterSpacing: 1,
                                                fontWeight: FontWeight.w700,
                                                color: AppTheme.dark_grey),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                " \$" +
                                                    widget
                                                        .order.cart[index].price
                                                        .toString(),
                                                style: AppTheme.subtitle,
                                              ),
                                              Text(
                                                widget.order.paid != 0
                                                    ? " (paid)"
                                                    : " (not paid)",
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 10,
                                                    color: AppTheme.dark_grey),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Icon(
                                                Icons.fastfood,
                                                size: 15,
                                              ),
                                              Text(
                                                widget.order.cart[index]
                                                    .productId,
                                                style: AppTheme.subtitle,
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Icon(
                                                Icons.local_dining,
                                                size: 15,
                                              ),
                                              Text(
                                                widget
                                                    .order.cart[index].quantity
                                                    .toString(),
                                                style: AppTheme.subtitle,
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Icon(
                                                Icons.business_center,
                                                size: 15,
                                              ),
                                              Text(
                                                "Pack",
                                                style: AppTheme.subtitle,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  leading: Container(
                                    padding: EdgeInsets.only(right: 20),
                                    decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                        color: AppTheme.dark_grey,
                                        width: 1.0,
                                      )),
                                    ),
                                    height: 100,
                                    width: 50,
                                    child: completestat
                                        ? CircularPercentIndicator(
                                            radius: 50.0,
                                            lineWidth: 5.0,
                                            addAutomaticKeepAlive: true,
                                            curve: Curves.easeIn,
                                            percent: ((time -
                                                            (widget
                                                                .order
                                                                .cart[index]
                                                                .inittime)) /
                                                        w) <
                                                    0
                                                ? 0.0
                                                : ((time -
                                                        widget.order.cart[index]
                                                            .inittime) /
                                                    w),
                                            center: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(110),
                                              child: Container(
                                                  child: CachedNetworkImage(
                                                imageUrl: "widget.url",
                                                fit: BoxFit.cover,
                                                height: 40,
                                                width: 40,
                                              )),
                                            ),
                                            backgroundColor: Colors.grey,
                                            progressColor: AppTheme.dark_grey,
                                          )
                                        : Container(
                                            width: 80,
                                            height: 80,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(110),
                                              child: Container(
                                                  child: CachedNetworkImage(
                                                imageUrl: "widget.url",
                                                fit: BoxFit.cover,
                                                height: 40,
                                                width: 40,
                                              )),
                                            )),
                                  ),
                                  trailing: Container(
                                      padding: EdgeInsets.only(top: 10),
                                      child: widget
                                                  .order.cart[index].inittime ==
                                              0
                                          ? Text("${"Queuing"}")
                                          : ((time -
                                                          widget
                                                              .order
                                                              .cart[index]
                                                              .inittime) /
                                                      w) <
                                                  0.1
                                              ? Column(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.local_dining,
                                                      color: AppTheme.dark_grey,
                                                      size: 11,
                                                    ),
                                                    Text(
                                                      "Preparing",
                                                    ),
                                                  ],
                                                )
                                              : ((time -
                                                              widget
                                                                  .order
                                                                  .cart[index]
                                                                  .inittime) /
                                                          w) <
                                                      0.9
                                                  ? Column(
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.hot_tub,
                                                          color: AppTheme
                                                              .dark_grey,
                                                          size: 11,
                                                        ),
                                                        Text(
                                                          "Cooking",
                                                        ),
                                                      ],
                                                    )
                                                  : completestat
                                                      ? Column(
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons.hot_tub,
                                                              color: AppTheme
                                                                  .dark_grey,
                                                              size: 11,
                                                            ),
                                                            Text(
                                                              "Almost",
                                                            ),
                                                          ],
                                                        )
                                                      : Column(
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons
                                                                  .brightness_1,
                                                              color: Colors
                                                                  .green[800],
                                                              size: 9,
                                                            ),
                                                            Text("On its way")
                                                          ],
                                                        ))),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        )
      ],
    );

    ;
  }

  ratingPopUp() {
    final cart = Provider.of<ProductProvider>(context, listen: false);
    double _rating = 4.0;
    var isCircle = false;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Material(
              type: MaterialType.transparency,
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.only(top: 100, bottom: 200),
                            padding: EdgeInsets.only(top: 20),
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text("Review".toString().toUpperCase(),
                                    style: AppTheme.title),
                                Container(
                                  margin: EdgeInsets.only(top: 5, bottom: 15),
                                  child: SmoothStarRating(
                                    allowHalfRating: false,
                                    starCount: 5,
                                    rating: _rating,
                                    onRated: (rate) {
                                      _rating = rate;
                                    },
                                    size: 27.0,
                                    color: AppTheme.dark_grey,
                                    borderColor: AppTheme.dark_grey,
                                  ),
                                ),
                                Spacer(),
                                Text("Comments".toString().toUpperCase(),
                                    style: AppTheme.title),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        right: 20.0, left: 20.0),
                                    child: TextFormField(
                                      controller: titlecomments,
                                      style: TextStyle(
                                        color:
                                            AppTheme.dark_grey.withOpacity(0.5),
                                      ),
                                      decoration: new InputDecoration(
                                          hintText: "Title"),
                                      keyboardType: TextInputType.text,
                                    )),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        right: 20.0, left: 20.0),
                                    child: TextFormField(
                                      controller: comments,
                                      maxLines: 3,
                                      style: TextStyle(
                                        color:
                                            AppTheme.dark_grey.withOpacity(0.5),
                                      ),
                                      decoration: new InputDecoration(
                                          hintText: "Type your comment."),
                                      keyboardType: TextInputType.text,
                                    )),
                                Spacer(),
                                Container(
                                  padding: EdgeInsets.only(bottom: 20),
                                  child: FloatingActionButton(
                                    shape: CircleBorder(),
                                    heroTag: "cart",
                                    onPressed: () {
                                      /* saveRating(
                                          widget.id,
                                          _rating,
                                          widget.food,
                                          titlecomments.text,
                                          comments.text,
                                          widget.user);
                                      Navigator.pop(context);*/
                                    },
                                    backgroundColor: AppTheme.white,
                                    child: Icon(Icons.email,
                                        size: 35, color: Colors.black87),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.bottomRight,
                                  decoration: BoxDecoration(
                                      color: AppTheme.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 15,
                                            spreadRadius: 5,
                                            color:
                                                Color.fromRGBO(0, 0, 0, .05)),
                                      ]),
                                  child: IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      }),
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
