import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodorderingsys/models/cart_item.dart';
import 'package:foodorderingsys/models/order.dart';

class OrderServices {
  String collection = "orders";
  Firestore _firestore = Firestore.instance;

  void createOrder(
      {String userId,
      String id,
      String description,
      String status,
      List<CartItemModel> cart,
      int paid,
      Timestamp time,
      GeoPoint location,
      int show,
      int inittime,
      int totalPrice}) {
    List<Map> convertedCart = [];

    for (CartItemModel item in cart) {
      convertedCart.add(item.toMap());
    }

    _firestore.collection("orders").document(id).setData({
      "userId": userId,
      "id": id,
      "cart": convertedCart,
      "total": totalPrice,
      "createdAt": DateTime.now().millisecondsSinceEpoch,
      "description": description,
      "status": status,
      "paid": paid,
      "time": time,
      "location": location,
      "show": show,
      "inittime": inittime
    });
  }

  Future<List<OrderModel>> getUserOrders({String userId}) async => _firestore
          .collection("orders")
          .where("userId", isEqualTo: userId)
          .getDocuments()
          .then((result) {
        List<OrderModel> orders = [];
        for (DocumentSnapshot order in result.documents) {
          orders.add(OrderModel.fromSnapshot(order));
        }
        return orders;
      });
}
