import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodorderingsys/Cart/cartBody.dart';
import 'package:foodorderingsys/helpers/AppTheme.dart';
import 'package:foodorderingsys/helpers/customClipperWidget.dart';
import 'package:foodorderingsys/helpers/screen_navigation.dart';
import 'package:foodorderingsys/providers/user.dart';
import 'package:foodorderingsys/screens/popular_dishes.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class productDetail extends StatelessWidget {
  final document;
  final scaleAnimation;
  const productDetail(this.document, this.scaleAnimation);

  @override
  Widget build(BuildContext context) {
    return showItemDetails(context, document);
  }

  showItemDetails(context, document) {
    final user = Provider.of<UserProvider>(context);

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
                          image: NetworkImage(document.image),
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
                  margin: const EdgeInsets.only(top: 35),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.chevron_left,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Badge(
                            showBadge:
                                user.userModel.cart.length == 0 ? false : true,
                            position: BadgePosition(end: 8, top: 8),
                            toAnimate: true,
                            badgeContent: Text(
                              user.userModel.cart.length == 0
                                  ? ""
                                  : user.userModel.cart.length.toString(),
                              style: TextStyle(fontSize: 10),
                            ),
                            child: IconButton(
                              onPressed: () {
                                changeScreen(context, CartScreen());
                              },
                              icon: Icon(Icons.shopping_cart,
                                  size: 23, color: Colors.black87),
                            ),
                          )
                        ],
                      ),
                      Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(document.image),
                                fit: BoxFit.cover),
                            borderRadius:
                                BorderRadius.all(Radius.circular(75.0)),
                            //borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 7.0, color: AppTheme.dark_grey)
                            ]),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.camera, size: 20),
                            Container(
                                margin: EdgeInsets.only(left: 4, right: 4),
                                child: Text(
                                    document.name.toString().toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold))),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _buildInfoCard(context, document),
                      _buildDetailCard(context, document)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildDetailCard(context, document) {
    ScrollController scrollController;

    return Container(
      padding: EdgeInsets.only(top: 30, left: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.pin_drop,
                      color: Colors.grey[400],
                    ),
                    Text(
                      "3KM Until Arrival",
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                Text(
                  document.name.toString().toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  document.category.toString().toUpperCase(),
                  style: AppTheme.subtitle,
                ),
                Row(children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: AppTheme.dark_grey),
                    width: 15,
                    height: 15,
                  ),
                  SizedBox(
                    width: 11,
                  ),
                  Text(
                    "(5.0)",
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                  document.rating == null
                      ? Text("0")
                      : SmoothStarRating(
                          spacing: 1,
                          allowHalfRating: false,
                          starCount: 5,
                          isReadOnly: true,
                          rating: document.rating / document.rates,
                          size: 20.0,
                          color: AppTheme.dark_grey,
                          borderColor: AppTheme.dark_grey,
                        ),
                  Spacer(),
                  LikeButton(
                    size: 25,
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.comment)),
                  SizedBox(
                    width: 20,
                  )
                ]),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 100,
            child: GridView.count(
              primary: false,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(4),
              crossAxisSpacing: 4,
              mainAxisSpacing: 2,
              crossAxisCount: 1,
              shrinkWrap: true,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(document.calories.toString()),
                          Text(
                            "Calories",
                            style: AppTheme.title,
                          ),
                        ],
                      ),
                    ),
                    color: AppTheme.white,
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(document.time.toString() +
                              "-" +
                              (document.time + 10).toString()),
                          Text(
                            "Time",
                            style: AppTheme.title,
                          ),
                        ],
                      ),
                    ),
                    color: AppTheme.white,
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(document.category.toString()),
                          Text(
                            "Type",
                            style: AppTheme.title,
                          ),
                        ],
                      ),
                    ),
                    color: AppTheme.white,
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(document.price.toString()),
                          Text(
                            "Price",
                            style: AppTheme.title,
                          ),
                        ],
                      ),
                    ),
                    color: AppTheme.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Ingredients: ",
                style: AppTheme.title,
              ),
              Text(document.ingrediants.toString()),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            document.description,
            style: TextStyle(
              wordSpacing: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 30, top: 20),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: RaisedButton(
                elevation: 4,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                onPressed: () {
                  showpopUp(context, document);
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
            padding: const EdgeInsets.only(top: 30.0, left: 10, right: 20),
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
              stream: FirebaseFirestore.instance
                  .collection('fooditems')
                  .doc(document.name)
                  .collection("reviews")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');

                if ((snapshot.hasData)) {
                  return ListView.builder(
                    shrinkWrap: true,
                    controller: scrollController,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: snapshot.data.docs.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.only(bottom: 30),
                        elevation: 1,
                        child: _commentsUi(snapshot.data.docs[index]),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      );
                    },
                  );
                } else {
                  return Container(
                    child: Text("NO COMMENTS !!"),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _commentsUi(snapsort) {
    return ListTile(
      /*  leading: Container(
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
      ),*/
      title: Container(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ("#" + "${snapsort["title"]}"),
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

  Widget _buildInfoCard(context, document) {
    print(document.rates);
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
                          (document.rating / document.rates).toString(),
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
                          document.orderedno.toString(),
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
}
