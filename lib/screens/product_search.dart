import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodorderingsys/helpers/AppTheme.dart';
import 'package:foodorderingsys/helpers/screen_navigation.dart';
import 'package:foodorderingsys/helpers/style.dart';
import 'package:foodorderingsys/models/products.dart';
import 'package:foodorderingsys/providers/user.dart';
import 'package:foodorderingsys/screens/popular_dishes.dart';
import 'package:foodorderingsys/screens/productDetail.dart';
import 'package:foodorderingsys/widgets/custom_text.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ProductSearchScreen extends StatefulWidget {
  final String text;

  const ProductSearchScreen({this.text});

  @override
  _ProductSearchScreenState createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen>
    with TickerProviderStateMixin {
  Animation<double> scaleAnimation;
  AnimationController controller;

  @override
  void initState() {
    FocusManager.instance.primaryFocus.unfocus();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
    controller.addListener(() {});
    controller.forward();

    if (widget.text != null) {
      _searchController.text = widget.text;
    } else {
      _searchController.addListener(_onSearchChanged);
    }
    super.initState();
  }

  TextEditingController _searchController = TextEditingController();

  Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getUsersPastTripsStreamSnapshots();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    var showResults = [];
    if (_searchController.text != "") {
      for (var tripSnapshot in _allResults) {
        if (widget.text != null) {
          var title =
              ProductModel.fromSnapshot(tripSnapshot).category.toLowerCase();
          if (title.contains(_searchController.text.toLowerCase())) {
            showResults.add(tripSnapshot);
          }
        } else {
          var title =
              ProductModel.fromSnapshot(tripSnapshot).name.toLowerCase();
          if (title.contains(_searchController.text.toLowerCase())) {
            showResults.add(tripSnapshot);
          }
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  getUsersPastTripsStreamSnapshots() async {
    var data = await FirebaseFirestore.instance.collection('fooditems').get();
    setState(() {
      _allResults = data.docs;
    });
    searchResultsList();
    return "complete";
  }

  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        backgroundColor: white,
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: CustomText(
          text: "Search Food Products",
          size: 20,
        ),
        elevation: 0.0,
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Badge(
              position: BadgePosition(start: 10, bottom: 15),
              toAnimate: true,
              badgeContent: Text(user.userModel.cart.length.toString()),
              child: Icon(Icons.shopping_cart, size: 23, color: Colors.black87),
            ),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, right: 30.0, bottom: 20.0, top: 10),
              child: TextField(
                readOnly: widget.text != null ? true : false,
                controller: _searchController,
                decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
              ),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: _resultsList.length,
              itemBuilder: (BuildContext context, int index) =>
                  buildTripCard(context, _resultsList[index]),
            )),
          ],
        ),
      ),
    );
  }

  Widget buildTripCard(BuildContext context, DocumentSnapshot document) {
    final product = ProductModel.fromSnapshot(document);
    return new Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, top: 4, bottom: 10),
      child: InkWell(
        onTap: () {
          changeScreen(context, productDetail(product, scaleAnimation));
        },
        child: Container(
          height: 100,
          decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[300],
                    offset: Offset(-2, -1),
                    blurRadius: 5),
              ]),
//            height: 160,
          child: Row(
            children: <Widget>[
              Container(
                width: 120,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: product.image,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomText(
                            text: product.name.toString().toUpperCase(),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: InkWell(
                            onTap: () {
                              showpopUp(context, product);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[300],
                                        offset: Offset(1, 1),
                                        blurRadius: 4),
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Icon(
                                  Icons.add_box,
                                  color: AppTheme.darkerText,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Row(
                        children: <Widget>[
                          CustomText(
                            text: "",
                            color: grey,
                            weight: FontWeight.w300,
                            size: 14,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, bottom: 8),
                              child: CustomText(
                                text: product.rating.toString() +
                                    " (" +
                                    product.orderedno.toString() +
                                    ")",
                                color: grey,
                                size: 14.0,
                              ),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5, bottom: 15),
                              child: SmoothStarRating(
                                allowHalfRating: false,
                                starCount: 5,
                                rating: product.rating,
                                size: 16.0,
                                isReadOnly: true,
                                color: AppTheme.dark_grey,
                                borderColor: AppTheme.dark_grey,
                              ),
                            ),
                          ],
                        ),
                        LikeButton(
                          size: 18,
                          circleColor: CircleColor(
                              start: AppTheme.notWhite, end: AppTheme.darkText),
                          bubblesColor: BubblesColor(
                            dotPrimaryColor: AppTheme.notWhite,
                            dotSecondaryColor: AppTheme.darkText,
                          ),
                          likeBuilder: (bool isLiked) {
                            print(isLiked);
                            return Icon(
                              isLiked
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              color: isLiked ? AppTheme.dark_grey : Colors.grey,
                              size: 18,
                            );
                          },
                          countBuilder: (int count, bool isLiked, String text) {
                            var color =
                                isLiked ? Colors.deepPurpleAccent : Colors.red;
                            Widget result;
                            if (count == 0) {
                              result = Text(
                                "love",
                                style: TextStyle(color: color),
                              );
                            } else
                              result = Text(
                                text,
                                style: TextStyle(color: color),
                              );
                            return result;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: CustomText(
                            text: "\$${product.price}",
                            weight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
