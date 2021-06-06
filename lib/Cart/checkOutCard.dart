import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:foodorderingsys/Cart/checkOutPAge.dart';
import 'package:foodorderingsys/Cart/food%20tracker.dart';
import 'package:foodorderingsys/helpers/AppTheme.dart';
import 'package:foodorderingsys/helpers/order.dart';
import 'package:foodorderingsys/helpers/screen_navigation.dart';
import 'package:foodorderingsys/models/cart_item.dart';
import 'package:foodorderingsys/providers/user.dart';
import 'package:foodorderingsys/screens/popular_dishes.dart';
import 'package:foodorderingsys/widgets/custom_text.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CheckoutCard extends StatefulWidget {
  final int value;

  const CheckoutCard({Key key, this.value}) : super(key: key);

  @override
  _CheckoutCardState createState() => _CheckoutCardState();
}

class _CheckoutCardState extends State<CheckoutCard> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return InkWell(
      onTap: () async {
        if (widget.value == 0)
          changeScreen(context, CheckOutPage(umodel: user.userModel));
        if (widget.value == 1) {
          setState(() {
            isLoading = false;
          });

          var uuid = Uuid();
          String id = uuid.v4();
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.bestForNavigation);
          Timestamp timeKEy = Timestamp.now();
          FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
          OrderServices _orderServices = OrderServices();
          var token = await _firebaseMessaging.getToken();
          _orderServices.createOrder(
              location: GeoPoint(position.latitude, position.longitude),
              time: timeKEy,
              show: 1,
              paid: 0,
              token: token,
              userId: user.user.uid,
              id: id,
              inittime: 0,
              description: "Some random description",
              status: "pending",
              package: "delivery",
              totaldiscount: user.userModel.totaldis,
              totalquantity: user.userModel.totalCartNumber,
              totalPrice: user.userModel.totalCartPrice,
              cart: user.userModel.cart);
          for (CartItemModel cartItem in user.userModel.cart) {
            bool value = await user.removeFromCart(cartItem: cartItem);
            if (value) {
              user.reloadUserModel();
            } else {
              print("ITEM WAS NOT REMOVED");
            }
          }
          user.paid(user.user.uid, "In hand");
          setState(() {
            isLoading = true;
          });
          showToast(context, "Payment Sucessful",
              user.userModel.totalCartPrice.toString(), true);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => foodTracker()),
              (Route<dynamic> route) => route.isFirst);
        }
      },
      child: isLoading
          ? Container(
              height: 50,
              padding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 15,
              ),
              margin: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 15,
              ),
              // height: 174,
              decoration: BoxDecoration(
                color: AppTheme.darkText,
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
                    text: "Check out",
                    size: 16,
                    color: AppTheme.white,
                    weight: FontWeight.normal,
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: AppTheme.notWhite,
                    size: 15,
                  )
                ],
              )),
            )
          : Container(
              width: 50,
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              ))),
    );
  }
}
