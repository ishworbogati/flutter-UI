class CartItemModel {
  static const ID = "id";
  static const NAME = "name";
  static const IMAGE = "image";
  static const PRODUCT_ID = "productId";
  static const QUANTITY = "quantity";
  static const PRICE = "price";
  static const INITTIME = "inittime";
  static const COOKTIME = "cooktime";
  static const TOTAL_RESTAURANT_SALES = "totalRestaurantSale";

  String _id;
  String _name;
  String _image;
  String _productId;
  int _inittime;
  int _cooktime;
  int _totalRestaurantSale;
  int _quantity;
  int _price;

  //  getters
  String get id => _id;

  String get name => _name;

  String get image => _image;

  String get productId => _productId;

  int get inittime => _inittime;

  int get cooktime => _cooktime;

  int get price => _price;

  int get totalRestaurantSale => _totalRestaurantSale;

  int get quantity => _quantity;

  CartItemModel.fromMap(Map data) {
    _id = data[ID];
    _name = data[NAME];
    _image = data[IMAGE];
    _productId = data[PRODUCT_ID];
    _price = data[PRICE];
    _quantity = data[QUANTITY];
    _totalRestaurantSale = data[TOTAL_RESTAURANT_SALES];
    _inittime = data[INITTIME];
    _cooktime = data[COOKTIME];
  }

  Map toMap() => {
        ID: _id,
        IMAGE: _image,
        NAME: _name,
        PRODUCT_ID: _productId,
        QUANTITY: _quantity,
        PRICE: _price,
        INITTIME: _inittime,
        COOKTIME: _cooktime,
        TOTAL_RESTAURANT_SALES: _totalRestaurantSale
      };
}
