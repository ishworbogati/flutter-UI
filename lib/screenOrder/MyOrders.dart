import 'dart:async';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:foodorderingsys/Cart/cartBody.dart';
import 'package:foodorderingsys/helpers/AppTheme.dart';
import 'package:foodorderingsys/helpers/ad.dart';
import 'package:foodorderingsys/helpers/order.dart';
import 'package:foodorderingsys/helpers/screen_navigation.dart';
import 'package:foodorderingsys/models/order.dart';
import 'package:foodorderingsys/models/products.dart';
import 'package:foodorderingsys/providers/product.dart';
import 'package:foodorderingsys/providers/user.dart';
import 'package:foodorderingsys/screenOrder/map.dart';
import 'package:foodorderingsys/screens/popular_dishes.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> with SingleTickerProviderStateMixin {
  bool loading = false;
  BottomBarController controller;
  final _key = GlobalKey<ScaffoldState>();
  ScrollController scrollController;
  OrderServices _orderServices = OrderServices();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  bool gridshow = false;
  int sum = 0;

  @override
  void initState() {
    controller = BottomBarController(vsync: this, dragLength: 550, snap: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      key: _key,
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
      backgroundColor: AppTheme.notWhite,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(controller.dragLength),
          child: BottomExpandableAppBar(
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
                          changeScreen(context, CartScreen());
                        },
                        backgroundColor: AppTheme.white,
                        child: Badge(
                          showBadge:
                              user.userModel.cart.length == 0 ? false : true,
                          position: BadgePosition(start: 20, bottom: 10),
                          toAnimate: true,
                          badgeContent:
                              Text(user.userModel.cart.length.toString()),
                          child: Icon(Icons.shopping_cart,
                              size: 23, color: Colors.black87),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )),
      body: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.symmetric(horizontal: 10),
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              !gridshow ? _listdata() : _griddata1(),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10, bottom: 30),
                    child: Text(
                      "You May Also Like",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  adhelper(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _listdata() {
    final user = Provider.of<UserProvider>(context);
    user.getOrders();
    return LimitedBox(
        child: ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: user.orders.length,
            itemBuilder: (_, index) {
              OrderModel _order = user.orders[index];
              var date = DateFormat('yyyy-MM-dd').format(DateTime.now());
              if (DateTime.parse(_order.date).compareTo(DateTime.parse(date)) ==
                  0) {
                return MaterialTile(_order);
              } else
                return Container();
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
              var date = DateFormat('yyyy-MM-dd').format(DateTime.now());
              if (DateTime.parse(_order.date).compareTo(DateTime.parse(date)) ==
                  0) {
                return LimitedBox(
                    maxHeight: 400.0,
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
              } else
                return Container();
            }));
  }

  Widget _pull() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 55),
      child: Container(
        height: 430,
        child: Stack(
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('fooditems')
                    .orderBy("COST", descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  return GroupedListView<dynamic, String>(
                    elements: snapshot.data.docs,
                    groupBy: (element) => element['CATEGORY'],
                    sort: true,
                    order: GroupedListOrder.ASC,
                    groupSeparatorBuilder: (String groupByValue) => Padding(
                      padding:
                          const EdgeInsets.only(left: 15.0, bottom: 2, top: 5),
                      child: Text(
                        groupByValue.toUpperCase(),
                        style: TextStyle(
                            color: AppTheme.nearlyWhite,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1),
                      ),
                    ),
                    itemBuilder: (context, dynamic element) {
                      final product = ProductModel.fromSnapshot(element);
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
                                      product.name.toString().toUpperCase(),
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
                                      showpopUp(context, product);
                                    },
                                  )
                                ],
                              )));
                    },
                  );
                }),
            /*   Align(
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
            )*/
          ],
        ),
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
      position: BadgePosition.topEnd(top: 0, end: 8),
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
                      imageUrl: widget.order.cart[0].image,
                      fit: BoxFit.cover,
                      height: 40,
                      width: 40,
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
                      imageUrl: widget.order.cart[0].image,
                      fit: BoxFit.cover,
                      height: 400,
                      width: 40,
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
  List<Marker> _markers = <Marker>[];
  bool _showbadge = true;
  BitmapDescriptor sourceIcon;
  Completer<GoogleMapController> _controller = Completer();

  @protected
  void initState() {
    t = Timer.periodic(new Duration(seconds: 1), (timer) {
      setState(() {
        time = DateTime.now().millisecondsSinceEpoch;
        // total = widget.sum;
      });
    });
    setCustomMapPin();

    super.initState();
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }

  void setCustomMapPin() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/food_marker.jpg');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 15.0),
      child: LimitedBox(
        maxWidth: MediaQuery.of(context).size.width - 10,
        child: Column(
          children: [
            Center(
              child: Container(
                child: Text("Order No: #" + widget.order.id.substring(0, 5)),
              ),
            ),
            Card(
              child: Column(children: [
                Container(
                  margin: const EdgeInsets.only(top: 8.0),
                  height: 100,
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          border: Border.all(
                            color: AppTheme.dark_grey.withOpacity(0.1),
                          )),
                      child: Center(
                          child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                              ),
                              child: GoogleMap(
                                  onTap: (value) {
                                    changeScreen(
                                        context,
                                        ordermap(
                                            LatLng(27.7172, 85.3240),
                                            LatLng(
                                                widget.order.location.latitude,
                                                widget.order.location
                                                    .longitude)));
                                  },
                                  scrollGesturesEnabled: false,
                                  zoomGesturesEnabled: false,
                                  myLocationEnabled: true,
                                  compassEnabled: false,
                                  mapToolbarEnabled: false,
                                  myLocationButtonEnabled: false,
                                  zoomControlsEnabled: false,
                                  tiltGesturesEnabled: false,
                                  markers: Set<Marker>.of(_markers),
                                  mapType: MapType.normal,
                                  initialCameraPosition: CameraPosition(
                                      target: LatLng(
                                          widget.order.location.latitude,
                                          widget.order.location.longitude),
                                      zoom: CAMERA_ZOOM,
                                      tilt: CAMERA_TILT,
                                      bearing: CAMERA_BEARING),
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    _controller.complete(controller);

                                    setState(() {
                                      _markers.add(Marker(
                                          markerId: MarkerId('SomeId'),
                                          position: LatLng(
                                              widget.order.location.latitude,
                                              widget.order.location.longitude),
                                          infoWindow: InfoWindow(
                                              title:
                                                  'The title of the marker')));
                                    });
                                  })))),
                ),
                header(widget.order),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  header(data) {
    var exp;
    var format = new DateFormat('HH:mm a');

    buildCollapsed1() {
      return Container(
        height: 90,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                  child: ListTile(
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Text(
                              (format.format(data.time.toDate())).toString(),
                              style: TextStyle(fontSize: 9),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "${data.cart.length}",
                                style: TextStyle(
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.dark_grey),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    " \$" + data.total.toString(),
                                    style: AppTheme.subtitle,
                                  ),
                                  Text(
                                    data.paid != 0 ? " (paid)" : " (not paid)",
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
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.fastfood,
                                    size: 15,
                                  ),
                                  Text(
                                    data.cart.length.toString(),
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
                                    data.total.toString(),
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
                        height: 60,
                        width: 60,
                        child: Icon(Icons.fastfood_sharp),
                      ),
                      trailing: Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Icon(Icons.keyboard_arrow_down_rounded))))
            ]),
      );
    }

    buildExpanded1() {
      return Container(
        height: 90,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                  shadowColor: AppTheme.dark_grey.withOpacity(0.3),
                  elevation: 5,
                  child: ListTile(
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Text(
                              (format.format(data.time.toDate())).toString(),
                              style: TextStyle(fontSize: 9),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "${data.cart.length}",
                                style: TextStyle(
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.dark_grey),
                              ),
                              Row(
                                children: [
                                  Text(
                                    " \$" + data.total.toString(),
                                    style: AppTheme.subtitle,
                                  ),
                                  Text(
                                    data.paid != 0 ? " (paid)" : " (not paid)",
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
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.fastfood,
                                    size: 15,
                                  ),
                                  Text(
                                    data.cart.length.toString(),
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
                                    data.total.toString(),
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
                        height: 60,
                        width: 60,
                        child: Icon(Icons.fastfood_sharp),
                      ),
                      trailing: Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Icon(Icons.keyboard_arrow_up_rounded)))),
            ]),
      );
    }

    buildExpanded2() {
      return LimitedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: data.cart.length,
                  itemBuilder: (context, index) {
                    var w = data.cart[index].cooktime * 60000;
                    bool completestat =
                        ((time - data.inittime) / w) < 0.99 ? true : false;

                    return Card(
                      child: Badge(
                        showBadge: data.inittime == 0 ? false : !completestat,
                        badgeContent: Icon(
                          Icons.check,
                          size: 10,
                          color: AppTheme.white,
                        ),
                        position: BadgePosition.topEnd(top: 0, end: 8),
                        animationDuration: Duration(milliseconds: 300),
                        animationType: BadgeAnimationType.slide,
                        badgeColor: AppTheme.dark_grey,
                        child: InkWell(
                          onLongPress: () {
                            ratingPopUp(data.cart[index]);
                          },
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: LimitedBox(
                              /*decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                  color: AppTheme.dark_grey.withOpacity(0.1),
                                  width: 0.5,
                                )),
                                color: Colors.white,
                              ),
                              margin: EdgeInsets.only(top: 8, bottom: 2),
                              padding: EdgeInsets.only(top: 5, bottom: 10),*/
                              child: ListTile(
                                  title: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            width: 100,
                                            child: Text(
                                              "${data.cart[index].name.toUpperCase()}",
                                              maxLines: 2,
                                              overflow: TextOverflow.fade,
                                              style: TextStyle(
                                                  letterSpacing: 1,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppTheme.dark_grey),
                                            ),
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
                                                data.paid != 0
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
                                                data.cart[index].name,
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
                                    padding: EdgeInsets.only(right: 15),
                                    decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                        color: AppTheme.dark_grey,
                                        width: 1.0,
                                      )),
                                    ),
                                    height: 60,
                                    width: 60,
                                    child: completestat
                                        ? CircularPercentIndicator(
                                            radius: 50.0,
                                            lineWidth: 5.0,
                                            addAutomaticKeepAlive: true,
                                            curve: Curves.easeIn,
                                            percent: ((time - (data.inittime)) /
                                                        w) <
                                                    0
                                                ? 0.0
                                                : ((time - data.inittime) / w),
                                            center: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(110),
                                              child: CachedNetworkImage(
                                                imageUrl: widget
                                                    .order.cart[index].image,
                                                fit: BoxFit.cover,
                                                height: 40,
                                                width: 40,
                                              ),
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
                                                imageUrl: widget
                                                    .order.cart[index].image,
                                                fit: BoxFit.cover,
                                                height: 40,
                                                width: 40,
                                              )),
                                            )),
                                  ),
                                  trailing: LimitedBox(
                                      child: data.inittime == 0
                                          ? Text("${"Queuing"}")
                                          : (((time - data.inittime) / w) < 0.3)
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
                                              : (((time -
                                                              widget
                                                                  .order
                                                                  .cart[index]
                                                                  .inittime) /
                                                          w) <
                                                      0.9)
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
                                                            InkWell(
                                                              onTap: () {},
                                                              child: Icon(
                                                                Icons
                                                                    .directions,
                                                                color: Colors
                                                                    .green[800],
                                                                size: 15,
                                                              ),
                                                            ),
                                                            Text("On its way")
                                                          ],
                                                        ))),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _showbadge = false;
          });
          exp.toggle();
        },
        child: Badge(
          showBadge: _showbadge,
          badgeColor: AppTheme.dark_grey,
          position: BadgePosition.topEnd(top: 15, end: 8),
          child: Container(
              decoration: BoxDecoration(
                color: AppTheme.white,
              ),
              width: MediaQuery.of(context).size.width,
              child: ExpandableNotifier(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expandable(
                      collapsed: buildCollapsed1(),
                      expanded: buildExpanded1(),
                    ),
                    Expandable(
                      expanded: buildExpanded2(),
                      collapsed: Container(),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Builder(
                          builder: (context) {
                            exp = ExpandableController.of(context);
                            return Container();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  ratingPopUp(data) {
    double _rating = 4.0;
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
                                      final product =
                                          Provider.of<ProductProvider>(context,
                                              listen: false);
                                      product.saveRating(
                                          data.id,
                                          _rating,
                                          data.name,
                                          titlecomments.text,
                                          comments.text,
                                          widget.order.userId);
                                      Navigator.pop(context);
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
