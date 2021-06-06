import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:foodorderingsys/Cart/cartBody.dart';
import 'package:foodorderingsys/helpers/AppTheme.dart';
import 'package:foodorderingsys/helpers/ad.dart';
import 'package:foodorderingsys/helpers/screen_navigation.dart';
import 'package:foodorderingsys/helpers/style.dart';
import 'package:foodorderingsys/providers/app.dart';
import 'package:foodorderingsys/providers/product.dart';
import 'package:foodorderingsys/providers/user.dart';
import 'package:foodorderingsys/screens/menuTab.dart';
import 'package:foodorderingsys/screens/popular_dishes.dart';
import 'package:foodorderingsys/screens/product_search.dart';
import 'package:foodorderingsys/screens/profile.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class menu extends StatefulWidget {
  @override
  _menuState createState() => _menuState();
}

class _menuState extends State<menu> with TickerProviderStateMixin {
  final f = new DateTime.now();
  ScrollController scrollController;

  bool isCircle = false;
  List queryResultSet = [];
  List tempSearchStore = [];
  bool viewmore = false;
  final _key = GlobalKey<ScaffoldState>();
  var format = new DateFormat('HH:mm a');
  AnimationController controller;
  Animation<double> scaleAnimation;
  var searchcontroller = new TextEditingController();
  bool isSwitched = false;
  bool isliked;
  AppProvider themeChangeProvider = new AppProvider();

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
    controller.addListener(() {});
    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      key: _key,
      floatingActionButton:
          Consumer<UserProvider>(builder: (context, provider, _) {
        final cart = Provider.of<UserProvider>(context, listen: false);
        return cartFunctionMethod(cart, context);
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Container(
        //padding: EdgeInsets.only(left: 5, right: 5),
        color: AppTheme.notWhite,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                elevation: 1,
                child: Container(
                  color: AppTheme.notWhite.withOpacity(0.1),
                  height: MediaQuery.of(context).size.height * 0.24,
                  padding: EdgeInsets.only(right: 15, left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            format.format(DateTime.now()).toString(),
                            style: AppTheme.subtitle,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(110),
                            child: InkWell(
                              onTap: () {
                                changeScreenReplacement(context, profile());
                              },
                              child: Container(
                                  width: 30,
                                  height: 30,
                                  child: CachedNetworkImage(
                                    imageUrl: user.userModel.url,
                                    fit: BoxFit.cover,
                                    height: 30,
                                    width: 30,
                                  )),
                            ),
                          ),
                        ],
                      ), //First Row
                      Container(
                        height: 30,
                        child: Text(
                          "What would you like to have?",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w800),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 50,
                          width: MediaQuery.of(context).size.width - 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius:
                                new BorderRadius.all(Radius.circular(25)),
                            border: Border.all(
                                width: 1,
                                color: AppTheme.nearlyBlack.withOpacity(0.2)),
                          ),
                          child: TextField(
                            textInputAction: TextInputAction.search,
                            style: new TextStyle(
                              color: Colors.black,
                            ),
                            readOnly: true,
                            onTap: () {
                              changeScreen(context, ProductSearchScreen());
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                suffixIcon: Icon(Icons.fastfood_rounded,
                                    color: Colors.black26),
                                prefixIcon:
                                    Icon(Icons.search, color: Colors.black38),
                                hintText: "Search food items",
                                hintStyle: new TextStyle(
                                    fontSize: 16, color: Colors.black38),
                                contentPadding: EdgeInsets.only(top: 17)),
                          )), //Search
                    ],
                  ),
                ),
              ), //Top section
              headerTopCategories(productProvider),
              /*      AnimatedOpacity(
                    opacity: viewmore ? 1 : 0,
                    curve: Curves.easeInOut,
                    duration: Duration(milliseconds: 500),
                    child: viewmore
                        ? Container(
                            padding:
                                EdgeInsets.only(left: 15, right: 10, bottom: 25),
                            child: viewMoreCategories(productProvider))
                        : Container()),*/
              Container(
                padding: EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 0.5,
                      margin: EdgeInsets.symmetric(vertical: 4),
                      color: Colors.grey.shade400,
                    ),
                    adhelper(),
                    Container(
                      width: double.infinity,
                      height: 0.5,
                      margin: EdgeInsets.symmetric(vertical: 4),
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ), //ad

              Container(
                color: AppTheme.notWhite,
                height: 300,
                padding: EdgeInsets.only(left: 15, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Featured Items",
                      style: AppTheme.title,
                    ),
                    PopularDishes(),
                  ],
                ),
              ), // featured items
              Container(
                height: 400,
                child: buildDefaultTabController(productProvider),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: white,
    );
  }

  DefaultTabController buildDefaultTabController(
      ProductProvider productProvider) {
    return DefaultTabController(
        length: 7,
        child: Scaffold(
          appBar: AppBar(
            primary: false,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 0.0),
                  child: Text(
                    "Full Menu",
                    style: AppTheme.title,
                  ),
                ),
                Spacer(),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      isSwitched
                          ? Text(
                              "Veg",
                              style: AppTheme.subtitle,
                            )
                          : Text(
                              "Mix",
                              style: AppTheme.subtitle,
                            ),
                      Switch(
                        value: isSwitched,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                          });
                        },
                        activeTrackColor:
                            !isSwitched ? Colors.white60 : Colors.green,
                        activeColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.white,
            elevation: 1,
            bottom: PreferredSize(
                child: Container(
                  color: Colors.white,
                  height: 1.0,
                ),
                preferredSize: Size.fromHeight(20.0)),
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: TabBar(
                      isScrollable: true,
                      unselectedLabelColor: AppTheme.darkText,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: AppTheme.notWhite,
                      indicator: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [AppTheme.darkerText, AppTheme.grey]),
                          borderRadius: BorderRadius.circular(15),
                          color: AppTheme.darkText),
                      tabs: [
                        Tab(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Popular"),
                          ),
                        ),
                        Tab(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Salad"),
                          ),
                        ),
                        Tab(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Meal"),
                          ),
                        ),
                        Tab(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Desert"),
                          ),
                        ),
                        Tab(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Soup"),
                          ),
                        ),
                        Tab(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Chicken"),
                          ),
                        ),
                        Tab(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Vegetrian"),
                          ),
                        ),
                      ]),
                )
              ],
            ),
          ),
          body: TabBarView(children: [
            menuTab(scaleAnimation: scaleAnimation),
            menuTab(scaleAnimation: scaleAnimation, item: "salad"),
            menuTab(scaleAnimation: scaleAnimation, item: "meal"),
            menuTab(scaleAnimation: scaleAnimation, item: "desert"),
            menuTab(scaleAnimation: scaleAnimation, item: "soup"),
            menuTab(scaleAnimation: scaleAnimation, item: "chicken"),
            menuTab(scaleAnimation: scaleAnimation, item: "veg"),
          ]),
        ));
  }

  StatelessWidget cartFunctionMethod(user, BuildContext context) {
    if (user.userModel.cart.isNotEmpty) {
      return ((user.userModel.cart.length > 0))
          ? FloatingActionButton.extended(
              onPressed: () {
                changeScreen(context, CartScreen());
              },
              label:
                  Text("order (" + user.userModel.cart.length.toString() + ")"),
              icon: Icon(Icons.fastfood),
              elevation: 6,
              backgroundColor: AppTheme.dark_grey,
            )
          : new Container();
    } else {
      return Container();
    }
  }

  Widget headerTopCategories(productProvider) {
    return Container(
      height: 170,
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          sectionHeader('All Categories', onViewMore: () {
            setState(() {
              viewmore = !viewmore;
            });
          }),
          LimitedBox(
            maxHeight: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: <Widget>[
                headerCategoryItem('Frieds', FlutterIcons.food_fork_drink_mco,
                    onPressed: () async {
                  changeScreen(
                      context,
                      ProductSearchScreen(
                        text: "fried",
                      ));
                }),
                headerCategoryItem('Fast Food', Icons.local_dining,
                    onPressed: () async {
                  changeScreen(
                      context,
                      ProductSearchScreen(
                        text: "fried",
                      ));
                }),
                headerCategoryItem('Creamery', Icons.offline_bolt,
                    onPressed: () async {
                  changeScreen(
                      context,
                      ProductSearchScreen(
                        text: "fried",
                      ));
                }),
                headerCategoryItem('Hot Drinks', Icons.local_cafe,
                    onPressed: () async {
                  changeScreen(
                      context,
                      ProductSearchScreen(
                        text: "fried",
                      ));
                }),
                headerCategoryItem('Vegetables', Icons.local_florist,
                    onPressed: () async {
                  changeScreen(
                      context,
                      ProductSearchScreen(
                        text: "fried",
                      ));
                }),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget viewMoreCategories(productProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 90,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: <Widget>[
              headerCategoryItem('Chinese', Icons.people, onPressed: () async {
                changeScreen(context, ProductSearchScreen());
              }),
              headerCategoryItem('Mexican', Icons.local_dining,
                  onPressed: () async {
                changeScreen(context, ProductSearchScreen());
              }),
              headerCategoryItem('Spanish', Icons.offline_bolt,
                  onPressed: () async {
                changeScreen(context, ProductSearchScreen());
              }),
              headerCategoryItem('Japanese', Icons.local_grocery_store,
                  onPressed: () async {
                changeScreen(context, ProductSearchScreen());
              }),
              headerCategoryItem('American', Icons.local_drink,
                  onPressed: () async {
                changeScreen(context, ProductSearchScreen());
              }),
            ],
          ),
        )
      ],
    );
  }

  Widget sectionHeader(String headerTitle, {onViewMore}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 5, top: 10),
          child: Text(headerTitle, style: AppTheme.title),
        ),
        Container(
          margin: EdgeInsets.only(left: 15, top: 2),
          child: FlatButton(
            onPressed: onViewMore,
            child: viewmore
                ? Text('View less ^', style: AppTheme.subtitle)
                : Text('View all ›', style: AppTheme.subtitle),
          ),
        )
      ],
    );
  }

  Widget headerCategoryItem(String name, IconData icon, {onPressed}) {
    return Container(
      margin: EdgeInsets.only(right: 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(bottom: 5),
              width: 50,
              height: 56,
              child: FloatingActionButton(
                shape: CircleBorder(),
                heroTag: name,
                onPressed: onPressed,
                backgroundColor: AppTheme.white,
                child: Icon(icon, size: 20, color: Colors.black87),
              )),
          Text(name + ' ›', style: AppTheme.subtitle)
        ],
      ),
    );
  }

  cartBody(user) {
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
                  onPressed: () async {
                    bool value = await user.removeAllFromCart();
                    if (value) {
                      user.reloadUserModel();
                      showToast(context, "Removed", "Food cart removed", true);
                      Navigator.of(context).pop();
                      return;
                    } else {
                      print("ITEM WAS NOT REMOVED");
                    }
                  })
            ],
          ),
        ),
        StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                Container(
                  height: 400,
                  child: ListView.builder(
                      itemCount: user.userModel.cart.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Slidable(
                          key: UniqueKey(),
                          dismissal: SlidableDismissal(
                            onDismissed: (D) async {
                              bool value = await user.removeFromCart(
                                  cartItem: user.userModel.cart[index]);
                              if (value) {
                                user.reloadUserModel();
                                showToast(context, "Removed",
                                    user.userModel.cart[index].name, true);
                                return;
                              } else {
                                print("ITEM WAS NOT REMOVED");
                              }
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
                                      imageUrl:
                                          user.userModel.cart[index].image,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            user.userModel.cart[index].name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            "\$ " +
                                                user.userModel.cart[index].price
                                                    .toString() +
                                                " x " +
                                                user.userModel.cart[index]
                                                    .quantity
                                                    .toString(),
                                            style: TextStyle(fontSize: 12),
                                          ),
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
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Icon(
                                            Icons.local_dining,
                                            size: 15,
                                          ),
                                          Text(
                                            user.userModel.cart[index].quantity
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
                ),
                Container(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Total = ",
                      style: AppTheme.title,
                    ),
                    Consumer<UserProvider>(
                      builder: (context, provider, _) {
                        return Text(
                          "\$ " + user.userModel.totalCartPrice.toString(),
                          style: TextStyle(fontStyle: FontStyle.italic),
                        );
                      },
                    ),
                  ],
                ))
              ],
            );
          },
        )
      ],
    );
  }
}

Future<bool> onLikeButtonTapped(bool isLiked) async {
  /// send your request here
  // final bool success= await sendRequest();

  /// if failed, you can do nothing
  // return success? !isLiked:isLiked;

  return !isLiked;
}
