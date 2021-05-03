import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:foodorderingsys/helpers/AppTheme.dart';
import 'package:foodorderingsys/helpers/order.dart';
import 'package:foodorderingsys/helpers/screen_navigation.dart';
import 'package:foodorderingsys/helpers/style.dart';
import 'package:foodorderingsys/models/cart_item.dart';
import 'package:foodorderingsys/providers/app.dart';
import 'package:foodorderingsys/providers/product.dart';
import 'package:foodorderingsys/providers/user.dart';
import 'package:foodorderingsys/screens/details.dart';
import 'package:foodorderingsys/screens/login.dart';
import 'package:foodorderingsys/screens/popular_dishes.dart';
import 'package:foodorderingsys/screens/product_search.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';

class menu extends StatefulWidget {
  @override
  _menuState createState() => _menuState();
}

class _menuState extends State<menu> with SingleTickerProviderStateMixin {
  final f = new DateTime.now();
  ScrollController scrollController;
  bool isCircle = false;
  List queryResultSet = [];
  List tempSearchStore = [];
  bool viewmore = false;
  final _key = GlobalKey<ScaffoldState>();
  OrderServices _orderServices = OrderServices();
  var format = new DateFormat('HH:mm a');
  AnimationController controller;
  Animation<double> scaleAnimation;

  Future<Position> locateUser() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  @override
  void initState() {
    FocusManager.instance.primaryFocus.unfocus();
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
    final user = Provider.of<UserProvider>(context, listen: false);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    return Scaffold(
      key: _key,
      floatingActionButton:
          Consumer<UserProvider>(builder: (context, provider, _) {
        final cart = Provider.of<UserProvider>(context, listen: false);
        return cartFunctionMethod(cart, context);
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        color: AppTheme.notWhite,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.050,
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
                        user.signOut();
                        changeScreenReplacement(context, LoginScreen());
                      },
                      child: Container(
                          width: 30,
                          height: 30,
                          child: CachedNetworkImage(
                            imageUrl: "",
                            fit: BoxFit.cover,
                            height: 30,
                            width: 30,
                          )),
                    ),
                  ),
                ],
              ),
              Container(
                child: Text(
                  "What would you like to have?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 45,
                  width: MediaQuery.of(context).size.width - 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: new BorderRadius.all(Radius.circular(25)),
                    border: Border.all(
                        width: 1, color: AppTheme.nearlyBlack.withOpacity(0.2)),
                  ),
                  child: TextField(
                    textInputAction: TextInputAction.search,
                    style: new TextStyle(
                      color: Colors.black,
                    ),
                    onSubmitted: (pattern) async {
                      final app =
                          Provider.of<AppProvider>(context, listen: false);
                      app.changeLoading();
                      await productProvider.search(productName: pattern);
                      changeScreen(context, ProductSearchScreen());

                      app.changeLoading();
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: Colors.black38),
                      hintText: "Search food items",
                      hintStyle: new TextStyle(color: Colors.black38),
                    ),
                  )),
              headerTopCategories(productProvider),
              AnimatedOpacity(
                  opacity: viewmore ? 1 : 0,
                  curve: Curves.easeInOut,
                  duration: Duration(milliseconds: 500),
                  child: viewmore
                      ? Container(child: viewMoreCategories())
                      : Container()),
              Container(
                padding: EdgeInsets.only(top: 12, bottom: 10),
                child: Text(
                  "Featured Items",
                  style: AppTheme.title,
                ),
              ),
              PopularDishes(),
              SizedBox(
                height: 500,
                child: DefaultTabController(
                    length: 7,
                    child: Scaffold(
                      appBar: AppBar(
                        primary: false,
                        automaticallyImplyLeading: false,
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 0.0),
                          child: Text(
                            "Full Menu",
                            style: AppTheme.title,
                          ),
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
                                  indicator: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        AppTheme.darkerText,
                                        AppTheme.grey
                                      ]),
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
                        popularfooditems("popular", productProvider),
                        fooditems("salad", productProvider),
                        fooditems("meal", productProvider),
                        fooditems("desert", productProvider),
                        fooditems("soup", productProvider),
                        fooditems("chicken", productProvider),
                        fooditems("veg", productProvider),
                      ]),
                    )),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: white,
    );
  }

  StatelessWidget cartFunctionMethod(user, BuildContext context) {
    return ((user.userModel.cart.length > 0))
        ? FloatingActionButton.extended(
            onPressed: () {
              AwesomeDialog(
                context: context,
                padding: EdgeInsets.only(top: 2),
                headerAnimationLoop: false,
                customHeader: Icon(
                  Icons.shopping_cart,
                  color: AppTheme.dark_grey,
                  size: 50,
                ),
                dialogType: DialogType.INFO,
                animType: AnimType.BOTTOMSLIDE,
                body: cartBody(user),
                tittle: "Orders",
                btnOk: FloatingActionButton(
                  onPressed: () async {
                    var uuid = Uuid();
                    String id = uuid.v4();
                    Position position = await Geolocator().getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    Timestamp timeKEy = Timestamp.now();
                    _orderServices.createOrder(
                        location:
                            GeoPoint(position.latitude, position.longitude),
                        time: timeKEy,
                        show: 1,
                        paid: 0,
                        userId: user.user.uid,
                        id: id,
                        description: "Some random description",
                        status: "pending",
                        totalPrice: user.userModel.totalCartPrice,
                        cart: user.userModel.cart);
                    for (CartItemModel cartItem in user.userModel.cart) {
                      bool value =
                          await user.removeFromCart(cartItem: cartItem);
                      if (value) {
                        user.reloadUserModel();
                        _key.currentState.showSnackBar(
                            SnackBar(content: Text("Clearing Cart!")));
                      } else {
                        print("ITEM WAS NOT REMOVED");
                      }
                    }
                    _key.currentState.showSnackBar(
                        SnackBar(content: Text("Order created!")));
                    Navigator.pop(context);
                  },
                  backgroundColor: AppTheme.dark_grey,
                  child: Text("Send"),
                ),
                btnCancel: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  backgroundColor: AppTheme.dark_grey,
                  child: Text("Close"),
                ),
                desc: 'The operation was successfully completed.',
              ).show();
            },
            label:
                Text("order (" + user.userModel.cart.length.toString() + ")"),
            icon: Icon(Icons.fastfood),
            elevation: 6,
            backgroundColor: AppTheme.dark_grey,
          )
        : new Container();
  }

  Widget buildReturn(data) {
    return Container(
        color: AppTheme.white,
        child: ListTile(
          onTap: () {
            FocusManager.instance.primaryFocus.unfocus();
            FocusScope.of(context).requestFocus(FocusNode());
            FocusScope.of(context).unfocus();

            //showItemDetails(context, data);
          },
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(110),
            child: Container(
                width: 20,
                height: 20,
                child: CachedNetworkImage(
                  imageUrl: data["url"],
                  fit: BoxFit.cover,
                  height: 20,
                  width: 20,
                )),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.add_box,
              color: AppTheme.darkerText,
            ),
            onPressed: () {
              /* showpopUp(
                  context,
                  data["url"],
                  _quantity,
                  data["foodname"],
                  data["foodtype"],
                  rating,
                  data["cost"],
                  data["foodname"],
                  data["duration"]);*/
            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                data["foodname"].toString(),
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                "\$ " + data["cost"].toString(),
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ));
  }

  Widget headerTopCategories(productProvider) {
    final app = Provider.of<AppProvider>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        sectionHeader('All Categories', onViewMore: () {
          setState(() {
            viewmore = !viewmore;
          });
        }),
        SizedBox(
          height: 90,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: <Widget>[
              headerCategoryItem('Frieds', FlutterIcons.food_fork_drink_mco,
                  onPressed: () async {
                app.changeLoading();
                await productProvider.search(productName: "salad");
                changeScreen(context, ProductSearchScreen());
                app.changeLoading();
              }),
              headerCategoryItem('Fast Food', Icons.local_dining,
                  onPressed: () async {
                app.changeLoading();
                await productProvider.search(productName: "salad");
                changeScreen(context, ProductSearchScreen());
                app.changeLoading();
              }),
              headerCategoryItem('Creamery', Icons.offline_bolt,
                  onPressed: () async {
                app.changeLoading();
                await productProvider.search(productName: "salad");
                changeScreen(context, ProductSearchScreen());
                app.changeLoading();
              }),
              headerCategoryItem('Hot Drinks', Icons.local_cafe,
                  onPressed: () async {
                app.changeLoading();
                await productProvider.search(productName: "salad");
                changeScreen(context, ProductSearchScreen());
                app.changeLoading();
              }),
              headerCategoryItem('Vegetables', Icons.local_florist,
                  onPressed: () async {
                app.changeLoading();
                await productProvider.search(productName: "salad");
                changeScreen(context, ProductSearchScreen());
                app.changeLoading();
              }),
            ],
          ),
        )
      ],
    );
  }

  Widget viewMoreCategories() {
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
              headerCategoryItem('Chinese', Icons.people, onPressed: () {
                showItemspopUp(context, "salad");
              }),
              headerCategoryItem('Mexican', Icons.local_dining, onPressed: () {
                showItemspopUp(context, "salad");
              }),
              headerCategoryItem('Spanish', Icons.offline_bolt, onPressed: () {
                showItemspopUp(context, "salad");
              }),
              headerCategoryItem('Japanese', Icons.local_grocery_store,
                  onPressed: () {
                showItemspopUp(context, "salad");
              }),
              headerCategoryItem('American', Icons.local_drink, onPressed: () {
                showItemspopUp(context, "salad");
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
      margin: EdgeInsets.only(right: 15),
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
                child: Icon(icon, size: 35, color: Colors.black87),
              )),
          Text(name + ' ›', style: AppTheme.subtitle)
        ],
      ),
    );
  }

  Widget fooditems(item, productProvider) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: Container(
        height: 130,
        child: Container(
          height: 100,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: productProvider.allProducts.length,
              itemBuilder: (context, index) {
                if ((productProvider.allProducts[index].name.toString()) ==
                    item) {
                  return Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: ListTile(
                      onTap: () {
                        //showItemDetails(context, document);
                      },
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(110),
                        child: Container(
                            width: 20,
                            height: 20,
                            child: CachedNetworkImage(
                              imageUrl: "",
                              fit: BoxFit.cover,
                              height: 20,
                              width: 20,
                            )),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.add_box,
                          size: 20,
                          color: AppTheme.darkerText,
                        ),
                        onPressed: () {
                          showpopUp(
                              context, productProvider.allProducts[index]);
                        },
                      ),
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            productProvider.allProducts[index].name.toString(),
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              "\$ " +
                                  productProvider.allProducts[index].price
                                      .toString(),
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else
                  return Container();
              }),
        ),
      ),
    );
  }

  Widget popularfooditems(item, productProvider) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: Container(
        height: 130,
        child: Container(
          height: 100,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: productProvider.allProducts.length,
              itemBuilder: (context, index) {
                if (productProvider.allProducts[index].rates >= 5) {
                  return Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: ListTile(
                      onTap: () async {
                        print(productProvider.allProducts[index]);
                        changeScreen(
                            context,
                            Details(
                                product: productProvider.allProducts[index]));

                        //showItemDetails(context, document);
                      },
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(110),
                        child: Container(
                            width: 20,
                            height: 20,
                            child: CachedNetworkImage(
                              imageUrl: "",
                              fit: BoxFit.cover,
                              height: 20,
                              width: 20,
                            )),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.add_box,
                          size: 20,
                          color: AppTheme.darkerText,
                        ),
                        onPressed: () {
                          showpopUp(
                              context, productProvider.allProducts[index]);
                        },
                      ),
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            productProvider.allProducts[index].name.toString(),
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              "\$ " +
                                  productProvider.allProducts[index].price
                                      .toString(),
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return new Container();
                }
              }),
        ),
      ),
    );
  }

  cartBody(user) {
    final app = Provider.of<AppProvider>(context, listen: false);
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
                    app.changeLoading();
                    bool value = await user.removeFromCart(
                        cartItem: user.userModel.cart);
                    if (value) {
                      user.reloadUserModel();
                      print("Item added to cart");
                      _key.currentState.showSnackBar(
                          SnackBar(content: Text("Removed from Cart!")));
                      app.changeLoading();
                      return;
                    } else {
                      print("ITEM WAS NOT REMOVED");
                      app.changeLoading();
                    }
                    showToast(context, "Removed", "Food cart removed", true);
                    Navigator.of(context).pop();
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
                              app.changeLoading();
                              bool value = await user.removeFromCart(
                                  cartItem: user.userModel.cart[index]);
                              if (value) {
                                user.reloadUserModel();
                                print("Item added to cart");
                                _key.currentState.showSnackBar(SnackBar(
                                    content: Text("Removed from Cart!")));
                                app.changeLoading();
                                return;
                              } else {
                                print("ITEM WAS NOT REMOVED");
                                app.changeLoading();
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
                                      imageUrl: "",
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
                    Text(
                      "\$ " + user.userModel.totalCartPrice.toString(),
                      style: TextStyle(fontStyle: FontStyle.italic),
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

  showItemspopUp(context, item) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => StatefulBuilder(
              builder: (context, setState) {
                return ScaleTransition(
                  scale: scaleAnimation,
                  child: Material(
                    type: MaterialType.card,
                    child: Center(
                      child: Container(
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: 500,
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: Firestore.instance
                                      .collection('foodItemslist')
                                      .orderBy("cost", descending: true)
                                      .snapshots(),
                                  builder: (_,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError)
                                      return new Text(
                                          'Error: ${snapshot.error}');
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        return Container(
                                            child: Center(
                                                child: new Text('Loading...')));
                                      default:
                                        return new ListView(
                                          scrollDirection: Axis.vertical,
                                          children: snapshot.data.documents
                                              .map((DocumentSnapshot document) {
                                            if (document["foodtype"] == item) {
                                              return ListTile(
                                                onTap: () {
                                                  /* showItemDetails(
                                                      context, document);*/
                                                },
                                                leading: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          110),
                                                  child: Container(
                                                      width: 20,
                                                      height: 20,
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            document["url"],
                                                        fit: BoxFit.cover,
                                                        height: 20,
                                                        width: 20,
                                                      )),
                                                ),
                                                trailing: IconButton(
                                                  icon: Icon(
                                                    Icons.add_box,
                                                    size: 20,
                                                    color: AppTheme.darkerText,
                                                  ),
                                                  onPressed: () {
                                                    /*   showpopUp1(
                                                        document["url"],
                                                        _quantity,
                                                        document["foodname"],
                                                        document["foodtype"],
                                                        _rating,
                                                        document["cost"],
                                                        document.documentID,
                                                        document["duration"]);*/
                                                  },
                                                ),
                                                title: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      document["foodname"]
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    Text(
                                                      "\$ " +
                                                          document["cost"]
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } else {
                                              return Container();
                                            }
                                          }).toList(),
                                        );
                                    }
                                  },
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
                                    item.toString().toUpperCase(),
                                    style: AppTheme.title,
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ));
  }

  /* showItemDetails(context, document) {
    FocusManager.instance.primaryFocus.unfocus();
    FocusScope.of(context).requestFocus(FocusNode());
    FocusScope.of(context).unfocus();
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => StatefulBuilder(
              builder: (context, setState) {
                return Scaffold(
                    backgroundColor: AppTheme.notWhite,
                    body: ScaleTransition(
                      scale: scaleAnimation,
                      child: Stack(
                        children: <Widget>[
                          ClipPath(
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(document["url"]),
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                          Colors.white.withOpacity(0.8),
                                          BlendMode.lighten))),
                            ),
                            clipper: CustomClipperWidget(),
                          ),
                          SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: Column(
                                children: <Widget>[
                                  Align(
                                    child: IconButton(
                                        icon: Icon(Icons.arrow_back),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        }),
                                    alignment: Alignment.topLeft,
                                  ),
                                  Container(
                                    width: 150.0,
                                    height: 150.0,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image:
                                                NetworkImage(document["url"]),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(75.0)),
                                        //borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 7.0,
                                              color: AppTheme.dark_grey)
                                        ]),
                                  ),
                                  SizedBox(height: 20),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.camera, size: 20),
                                        Container(
                                            margin: EdgeInsets.only(
                                                left: 4, right: 4),
                                            child: Text(
                                                document["foodname"]
                                                    .toString()
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  _buildInfoCard(context, document),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: _buildDetailCard(context, document),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ));
              },
            ));
  }*/

  /* Widget _buildDetailCard(context, document) {
    return Container(
      padding: EdgeInsets.only(top: 50, right: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            document["foodname"].toString().toUpperCase(),
            style: AppTheme.title,
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            document["foodtype"].toString().toUpperCase(),
            style: AppTheme.subtitle,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Calories:",
                style: AppTheme.title,
              ),
              Text(document["calories"].toString()),
              SizedBox(
                width: 20,
              ),
              Text(
                "Calories:",
                style: AppTheme.title,
              ),
              Text(document["calories"].toString()),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Time: ",
                style: AppTheme.title,
              ),
              Text(document["duration"].toString()),
              SizedBox(
                width: 10,
              ),
              Text(
                "(Extra time ",
                style: AppTheme.subtitle,
              ),
              Text(
                "Depends on Quantities).",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Ingredients: ",
                style: AppTheme.title,
              ),
              Text(document["Ingrediant"].toString()),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Reviews: ",
                  style: AppTheme.title,
                ),
              ),
              document["rating"] == null
                  ? Text("0")
                  : SmoothStarRating(
                      allowHalfRating: false,
                      starCount: 5,
                      isReadOnly: true,
                      rating: document["rating"] / document["ratingno"],
                      size: 20.0,
                      color: AppTheme.dark_grey,
                      borderColor: AppTheme.dark_grey,
                    ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              document["description"],
              style: TextStyle(
                wordSpacing: 1,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: SizedBox(
              width: double.infinity,
              child: RaisedButton(
                elevation: 5,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                onPressed: () {
                  showpopUp1(
                      document["url"],
                      1,
                      document["foodname"],
                      document["foodtype"],
                      document["rating"],
                      document["cost"],
                      document["foodname"],
                      document["duration"]);
                },
                color: AppTheme.dark_grey,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.fastfood,
                      color: AppTheme.white,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Order now".toUpperCase(),
                      style: TextStyle(color: AppTheme.notWhite),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Comments",
                  style: AppTheme.title,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('foodItemslist')
                  .document(document["foodname"])
                  .collection("reviews")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: new Text('Loading...'));
                  default:
                    if ((snapshot.hasData)) {
                      return ListView.builder(
                        shrinkWrap: true,
                        controller: scrollController,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: snapshot.data.documents.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, position) {
                          return Card(
                            margin: EdgeInsets.only(bottom: 30),
                            elevation: 1,
                            child:
                                _commentsUi(snapshot.data.documents[position]),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          );
                        },
                      );
                    } else {
                      return SizedBox();
                    }
                }
              },
            ),
          )
        ],
      ),
    );
  }*/

  Widget _buildInfoCard(context, document) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Card(
            elevation: 5.0,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 16.0, bottom: 16.0, right: 10.0, left: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        'Reviews',
                        style: new TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: new Text(
                          (document["rating"] / document["ratingno"])
                              .toString(),
                          style: new TextStyle(
                              fontSize: 18.0,
                              color: Color(0Xffde6262),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  new Column(
                    children: <Widget>[
                      new Text(
                        'Orders',
                        style: new TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: new Text(
                          document["orderedno"].toString(),
                          style: new TextStyle(
                              fontSize: 18.0,
                              color: Color(0Xffde6262),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  new Column(
                    children: <Widget>[
                      new Text(
                        'Following',
                        style: new TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: new Text(
                          '150',
                          style: new TextStyle(
                              fontSize: 18.0,
                              color: Color(0Xffde6262),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _commentsUi(snapsort) {
    return ListTile(
      leading: Container(
        height: 50,
        width: 50,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(110),
          child: Container(
              child: CachedNetworkImage(
            imageUrl: snapsort["url"],
            fit: BoxFit.cover,
            height: 10,
            width: 10,
          )),
        ),
      ),
      title: Container(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  snapsort.documentID,
                  style: AppTheme.subtitle,
                ),
                Text(
                  snapsort["date"],
                  style: AppTheme.subtitle,
                )
              ],
            ),
            Container(
              child: Column(
                children: [
                  Text(
                    snapsort["title"].toString().toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "\"" + snapsort["comments"] + "\"",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
