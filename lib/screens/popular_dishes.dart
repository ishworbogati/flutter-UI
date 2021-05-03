import 'package:achievement_view/achievement_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodorderingsys/helpers/AppTheme.dart';
import 'package:foodorderingsys/models/products.dart';
import 'package:foodorderingsys/providers/app.dart';
import 'package:foodorderingsys/providers/product.dart';
import 'package:foodorderingsys/providers/user.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class PopularDishes extends StatefulWidget {
  @override
  _PopularDishesState createState() => _PopularDishesState();
}

class _PopularDishesState extends State<PopularDishes> {
  ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    productProvider.loadAllProducts();
    return Container(
      height: 220,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 15),
      child: ListView.builder(
        shrinkWrap: true,
        controller: scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: productProvider.allProducts.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if ((productProvider.allProducts[index].featured.toString()) ==
              "true") {
            return Card(
              child:
                  PopularFoodTile(product: productProvider.allProducts[index]),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class PopularFoodTile extends StatefulWidget {
  final ProductModel product;

  const PopularFoodTile({@required this.product});

  @override
  _PopularFoodTileState createState() => _PopularFoodTileState();
}

class _PopularFoodTileState extends State<PopularFoodTile>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  int _quantity = 1;

  @override
  void initState() {
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 300));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    buildImg(String path, double height) {
      return SizedBox(child: Container());
    }

    buildCollapsed1() {
      return Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      widget.product.name.toUpperCase(),
                      style: TextStyle(
                          color: AppTheme.darkText,
                          fontWeight: FontWeight.w600),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.add_box,
                        size: 20,
                        color: AppTheme.darkerText,
                      ),
                      onPressed: () {
                        showpopUp(context, widget.product);
                      },
                    )
                  ],
                ),
              ),
            ]),
      );
    }

    buildExpanded1() {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.product.name.toUpperCase(),
                        style: TextStyle(
                            color: AppTheme.darkText,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        widget.product.rates.toString() + " Tested",
                        style: TextStyle(
                            color: AppTheme.darkText.withOpacity(0.5),
                            fontSize: 11),
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.add_box,
                      size: 16,
                      color: AppTheme.darkerText,
                    ),
                    onPressed: () {
                      showpopUp(context, widget.product);
                    },
                  )
                ],
              ),
            ),
          ]);
    }

    buildCollapsed2() {
      return Banner(
        message: "10 %",
        location: BannerLocation.topEnd,
        child: Container(
          padding: EdgeInsets.only(left: 15),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: AppTheme.white, borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                      height: 130,
                      width: MediaQuery.of(context).size.width,
                      child: CachedNetworkImage(
                          imageUrl: "",
                          imageBuilder: (context, imageProvider) => Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              )))),
                  Padding(
                    padding: EdgeInsets.only(top: 110),
                    child: SmoothStarRating(
                      allowHalfRating: false,
                      isReadOnly: true,
                      starCount: 5,
                      rating: widget.product.rating,
                      size: 20.0,
                      color: AppTheme.nearlyBlack,
                      borderColor: AppTheme.nearlyBlack,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    buildExpanded2() {
      return Container(
        decoration: BoxDecoration(
            color: AppTheme.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "calories: ",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(widget.product.name.toString() + " kal"),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "Time: ",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(widget.product.time.toString() + " min"),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "Reviews: ",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      widget.product.rating == null
                          ? Text("0")
                          : SmoothStarRating(
                              allowHalfRating: false,
                              starCount: 5,
                              isReadOnly: true,
                              rating: widget.product.rating,
                              size: 20.0,
                              color: AppTheme.dark_grey,
                              borderColor: AppTheme.dark_grey,
                            ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(right: 15),
                    height: 80,
                    width: 150,
                    child: CachedNetworkImage(
                        imageUrl: "",
                        imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            )))),
              ],
            ),
          ],
        ),
      );
    }

    buildCollapsed3() {
      return Container(
        padding: EdgeInsets.only(right: 20, top: 6),
        height: 30,
        alignment: Alignment.topRight,
        child: Text(
          "\$ " + widget.product.price.toString(),
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic),
        ),
      );
    }

    buildExpanded3() {
      return Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 15, right: 10, top: 10),
            color: AppTheme.white,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      "Ingredients: ",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Flexible(
                      child: Text(widget.product.description,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left),
                    )
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      " \$ " + widget.product.price.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 30,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }

    var exp;
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: InkWell(
        onTap: () {
          exp.toggle();
        },
        onLongPress: () {
          /* showpopUp(context, widget.url, _quantity, widget.name, widget.type,
              widget.rating, widget.cost, widget.itemid, widget.duration);*/
        },
        child: Container(
            decoration: BoxDecoration(
              color: AppTheme.white,
            ),
            width: 300,
            child: ExpandableNotifier(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expandable(
                    collapsed: buildCollapsed1(),
                    expanded: buildExpanded1(),
                  ),
                  Expandable(
                    collapsed: buildCollapsed2(),
                    expanded: buildExpanded2(),
                  ),
                  Expandable(
                    collapsed: buildCollapsed3(),
                    expanded: buildExpanded3(),
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
    );
  }
}

showpopUp(context, product) {
  final app = Provider.of<AppProvider>(context, listen: false);
  final user = Provider.of<UserProvider>(context, listen: false);
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
                            Text(product.name.toString().toUpperCase(),
                                style: AppTheme.title),
                            Text("\$ " + product.price.toString(),
                                style: AppTheme.subtitle),
                            Container(
                              margin: EdgeInsets.only(top: 5, bottom: 15),
                              child: SmoothStarRating(
                                allowHalfRating: false,
                                starCount: 5,
                                rating: product.rating,
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
                                    child: Text('Time', style: AppTheme.title),
                                    margin: EdgeInsets.only(bottom: 10),
                                  ),
                                  Text((product.price + (_quantity * 2))
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
                                    child:
                                        Text('Quantity', style: AppTheme.title),
                                    margin: EdgeInsets.only(bottom: 10),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        app.changeLoading();
                                        bool value = await user.addToCard(
                                            product: product,
                                            quantity: _quantity);
                                        if (value) {
                                          showToast(context, "Food added",
                                              product.name, true);
                                          user.reloadUserModel();
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

showToast(BuildContext context, title, message, isCircle) {
  AchievementView(context,
      alignment: Alignment.topCenter,
      title: title,
      duration: Duration(seconds: 2),
      subTitle: message,
      textStyleSubTitle: TextStyle(fontSize: 12.0),
      isCircle: isCircle,
      listener: (status) {})
    ..show();
}
