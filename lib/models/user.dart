import 'package:foodorderingsys/models/cart_item.dart';

class UserModel {
  static const ID = "uid";
  static const NAME = "firstname";
  static const LNAME = "lastname";
  static const PHONE = "phone";
  static const URL = "photo";
  static const EMAIL = "email";
  static const STRIPE_ID = "stripeId";
  static const CART = "cart";

  String _name;
  String _lastname;
  String _phone;
  String _url;
  String _email;
  String _id;
  String _stripeId;
  int _priceSum = 0;
  int _priceItem = 0;
  int _priceDis = 0;

//  getters
  String get name => _name;
  String get lname => _lastname;
  String get email => _email;
  String get url => _url;

  String get id => _id;
  String get stripeId => _stripeId;
  String get phone => _phone;
//  public variable
  List<CartItemModel> cart = [];
  int totalCartPrice;
  int totalCartNumber;
  int totaldis;

  UserModel.fromSnapshot(snapshot) {
    _name = snapshot.data()[NAME] ?? "";
    _lastname = snapshot.data()[LNAME] ?? "";
    _phone = snapshot.data()[PHONE] ?? "";
    _url = snapshot.data()[URL] ??
        "https://www.pixsy.com/wp-content/uploads/2021/04/ben-sweet-2LowviVHZ-E-unsplash-1.jpeg";
    _email = snapshot.data()[EMAIL] ?? "";
    _id = snapshot.data()[ID] ?? "";
    _stripeId = snapshot.data()[STRIPE_ID] ?? "";
    cart = _convertCartItems(snapshot.data()[CART]) ?? [];
    totalCartPrice = snapshot.data()[CART] == null
        ? 0
        : getTotalPrice(cart: snapshot.data()[CART]);
    totalCartNumber = snapshot.data()[CART] == null
        ? 0
        : getCartItemNumber(cart: snapshot.data()[CART]);
    totaldis = snapshot.data()[CART] == null
        ? 0
        : getCartItemDiscount(cart: snapshot.data()[CART]);
  }

  int getCartItemNumber({List cart}) {
    if (cart == null) {
      return 0;
    }
    for (Map cartItem in cart) {
      _priceItem += cartItem["quantity"];
    }

    int total = _priceItem;

    return total;
  }

  int getCartItemDiscount({List cart}) {
    if (cart == null) {
      return 0;
    }
    for (Map cartItem in cart) {
      _priceDis += cartItem["discount"];
    }

    int total = _priceDis;

    return total;
  }

  int getTotalPrice({List cart}) {
    if (cart == null) {
      return 0;
    }
    for (Map cartItem in cart) {
      _priceSum += ((cartItem["price"] * cartItem["quantity"]) -
              ((cartItem["price"] * cartItem["quantity"]) *
                  (cartItem["discount"] / 100)))
          .round();
    }

    int total = _priceSum.round();

    return total;
  }

  List<CartItemModel> _convertCartItems(List cart) {
    List<CartItemModel> convertedCart = [];
    for (Map cartItem in cart) {
      convertedCart.add(CartItemModel.fromMap(cartItem));
    }
    return convertedCart;
  }
}
