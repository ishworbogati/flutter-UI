import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodorderingsys/models/cart_item.dart';
import 'package:foodorderingsys/models/order.dart';
import 'package:foodorderingsys/notification/notificationhelper.dart';
import 'package:intl/intl.dart';

class OrderServices {
  String collection = "orders";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void createOrder(
      {String userId,
      String id,
      String description,
      String status,
      List<CartItemModel> cart,
      int paid,
      Timestamp time,
      GeoPoint location,
      String token,
      int totalquantity,
      int totaldiscount,
      String package,
      int show,
      int inittime,
      int totalPrice}) {
    List<Map> convertedCart = [];
    final f = new DateFormat('yyyy-MM-dd');
    var date = f.format(DateTime.now()).toString();
    for (CartItemModel item in cart) {
      convertedCart.add(item.toMap());
      _firestore
          .collection("fooditems")
          .doc(item.name)
          .update({"ORDEREDNO": item.orderedno + 1});
    }

    _firestore.collection("orders").doc(id).set({
      "userId": userId,
      "id": id,
      "cart": convertedCart,
      "total": totalPrice,
      "createdAt": DateTime.now().millisecondsSinceEpoch,
      "description": description,
      "status": status,
      "paid": paid,
      "time": time,
      "date": date,
      "location": location,
      "show": show,
      "totaldis": totaldiscount,
      "totalitems": totalquantity,
      "package": package,
      "inittime": inittime,
      "token": token
    }).then((value) => {
          _firestore
              .collection("admin")
              .where("admin", isEqualTo: true)
              .get()
              .then((value) {
            for (DocumentSnapshot order in value.docs) {
              sendNotification("Admin Home order", "Order", order["token"], 7);
              /*  flutterLocalNotificationsPlugin.show(
                  0,
                  id,
                  "Local message order",
                  NotificationDetails(
                    android: AndroidNotificationDetails(
                      channel.id,
                      channel.name,
                      channel.description,
                      color: AppTheme.notWhite,
                      playSound: true,
                      icon: '@drawable/hotel',
                    ),
                  ));*/ /*sendNotification("Order", id, token, 7)*/
            }
          })
        });
  }

  Future<List<OrderModel>> getUserOrders({String userId}) async => _firestore
          .collection("orders")
          .where("userId", isEqualTo: userId)
          .get()
          .then((result) {
        List<OrderModel> orders = [];
        for (DocumentSnapshot order in result.docs) {
          orders.add(OrderModel.fromSnapshot(order));
        }
        return orders;
      });
}
