import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodorderingsys/models/cart_item.dart';

class OrderModel {
  static const ID = "id";
  static const DESCRIPTION = "description";
  static const CART = "cart";
  static const USER_ID = "userId";
  static const TOTAL = "total";
  static const STATUS = "status";
  static const CREATED_AT = "createdAt";
  static const PAID = "paid";
  static const LOCATION = "location";
  static const URL = "url";
  static const SHOW = "show";
  static const TIME = "time";
  static const DATE = "date";
  static const INITTIME = "inittime";

  String _id;
  String _restaurantId;
  String _description;
  String _userId;
  String _status;
  int _createdAt;
  int _total;
  int _paid;
  String _url;
  String _date;
  int _show;
  int _init;
  Timestamp _time;
  GeoPoint _location;
//  getters
  String get id => _id;
  String get restaurantId => _restaurantId;
  String get description => _description;
  String get userId => _userId;
  String get status => _status;
  int get total => _total;
  int get createdAt => _createdAt;
  int get paid => _paid;
  int get inittime => _init;
  String get url => _url;
  String get date => _date;
  int get show => _show;
  Timestamp get time => _time;
  GeoPoint get location => _location;

  // public variable
  List<CartItemModel> cart;

  OrderModel.fromSnapshot(snapshot) {
    _id = snapshot.data()[ID];
    _description = snapshot.data()[DESCRIPTION];
    _total = snapshot.data()[TOTAL];
    _paid = snapshot.data()[PAID];
    _status = snapshot.data()[STATUS];
    _userId = snapshot.data()[USER_ID];
    _createdAt = snapshot.data()[CREATED_AT];
    _url = snapshot.data()[URL];
    _show = snapshot.data()[SHOW];
    _init = snapshot.data()[INITTIME];
    _time = snapshot.data()[TIME];
    _date = snapshot.data()[DATE];
    _location = snapshot.data()[LOCATION];
    cart = _convertOrderedItems(snapshot.data()[CART]) ?? [];
  }

  List<CartItemModel> _convertOrderedItems(List cart) {
    List<CartItemModel> convertedCart = [];
    for (Map cartItem in cart) {
      convertedCart.add(CartItemModel.fromMap(cartItem));
    }
    return convertedCart;
  }
}
