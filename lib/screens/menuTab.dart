import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodorderingsys/helpers/AppTheme.dart';
import 'package:foodorderingsys/helpers/screen_navigation.dart';
import 'package:foodorderingsys/providers/product.dart';
import 'package:foodorderingsys/screens/popular_dishes.dart';
import 'package:foodorderingsys/screens/productDetail.dart';
import 'package:foodorderingsys/widgets/custom_text.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class menuTab extends StatefulWidget {
  final Animation scaleAnimation;
  final String item;

  const menuTab({this.scaleAnimation, this.item});
  @override
  _menuTabState createState() => _menuTabState();
}

class _menuTabState extends State<menuTab> with TickerProviderStateMixin {
  ScrollController scrollController;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<ProductProvider>(context).loadAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    final products =
        Provider.of<ProductProvider>(context, listen: false).products;
    return ScaleTransition(
      scale: widget.scaleAnimation,
      child: Container(
          child: ListView.builder(
              primary: false,
              scrollDirection: Axis.vertical,
              itemCount: products.length,
              itemBuilder: (context, index) {
                if (widget.item == null) {
                  if (products[index].orderedno >= 5) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 4, right: 4, top: 4, bottom: 10),
                      child: InkWell(
                        onTap: () {
                          changeScreen(
                              context,
                              productDetail(
                                  products[index], widget.scaleAnimation));
                        },
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                              color: AppTheme.white,
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
                                      imageUrl: products[index].image,
                                      fit: BoxFit.fill,
                                    ) /*  Image.network(
                                  products[index].image,

                                ),*/
                                    ),
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CustomText(
                                            text: products[index]
                                                .name
                                                .toString()
                                                .toUpperCase(),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8),
                                          child: InkWell(
                                            onTap: () {
                                              showpopUp(
                                                  context, products[index]);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: AppTheme.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.grey[300],
                                                        offset: Offset(1, 1),
                                                        blurRadius: 4),
                                                  ]),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(1.0),
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
                                            color: AppTheme.notWhite,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, bottom: 8),
                                              child: CustomText(
                                                text: products[index]
                                                        .rating
                                                        .toString() +
                                                    " (" +
                                                    products[index]
                                                        .orderedno
                                                        .toString() +
                                                    ")",
                                                color: AppTheme.notWhite,
                                                size: 14.0,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 2,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 5, bottom: 15),
                                              child: SmoothStarRating(
                                                allowHalfRating: false,
                                                starCount: 5,
                                                rating: products[index].rating,
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
                                              start: AppTheme.notWhite,
                                              end: AppTheme.darkText),
                                          bubblesColor: BubblesColor(
                                            dotPrimaryColor: AppTheme.notWhite,
                                            dotSecondaryColor:
                                                AppTheme.darkText,
                                          ),
                                          likeBuilder: (bool isLiked) {
                                            return Icon(
                                              isLiked
                                                  ? Icons.favorite
                                                  : Icons
                                                      .favorite_border_outlined,
                                              color: isLiked
                                                  ? AppTheme.dark_grey
                                                  : Colors.grey,
                                              size: 18,
                                            );
                                          },
                                          countBuilder: (int count,
                                              bool isLiked, String text) {
                                            var color = isLiked
                                                ? Colors.deepPurpleAccent
                                                : Colors.red;
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
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: CustomText(
                                            text: "\$${products[index].price}",
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
                  } else {
                    return new Container();
                  }
                } else {
                  if ((products[index].category.toString()) == widget.item) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 4, right: 4, top: 4, bottom: 10),
                      child: InkWell(
                        onTap: () {
                          changeScreen(
                              context,
                              productDetail(
                                  products[index], widget.scaleAnimation));
                        },
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                              color: AppTheme.white,
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
                                child: Hero(
                                  key: _key,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        topLeft: Radius.circular(20),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: products[index].image,
                                        fit: BoxFit.fill,
                                      ) /*  Image.network(
                                    products[index].image,

                                  ),*/
                                      ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CustomText(
                                            text: products[index]
                                                .name
                                                .toString()
                                                .toUpperCase(),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8),
                                          child: InkWell(
                                            onTap: () {
                                              showpopUp(
                                                  context, products[index]);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: AppTheme.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.grey[300],
                                                        offset: Offset(1, 1),
                                                        blurRadius: 4),
                                                  ]),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(1.0),
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
                                            color: AppTheme.notWhite,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, bottom: 8),
                                              child: CustomText(
                                                text: products[index]
                                                        .rating
                                                        .toString() +
                                                    " (" +
                                                    products[index]
                                                        .orderedno
                                                        .toString() +
                                                    ")",
                                                color: AppTheme.notWhite,
                                                size: 14.0,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 2,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 5, bottom: 15),
                                              child: SmoothStarRating(
                                                allowHalfRating: false,
                                                starCount: 5,
                                                rating: products[index].rating,
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
                                              start: AppTheme.notWhite,
                                              end: AppTheme.darkText),
                                          bubblesColor: BubblesColor(
                                            dotPrimaryColor: AppTheme.notWhite,
                                            dotSecondaryColor:
                                                AppTheme.darkText,
                                          ),
                                          likeBuilder: (bool isLiked) {
                                            return Icon(
                                              isLiked
                                                  ? Icons.favorite
                                                  : Icons
                                                      .favorite_border_outlined,
                                              color: isLiked
                                                  ? AppTheme.dark_grey
                                                  : Colors.grey,
                                              size: 18,
                                            );
                                          },
                                          countBuilder: (int count,
                                              bool isLiked, String text) {
                                            var color = isLiked
                                                ? Colors.deepPurpleAccent
                                                : Colors.red;
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
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: CustomText(
                                            text: "\$${products[index].price}",
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
                  } else {
                    return new Container();
                  }
                }
              })),
    );
  }
}
