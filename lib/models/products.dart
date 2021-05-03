import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  static const FOODID = "FOODID";
  static const FOODNAME = "FOODNAME";
  static const RATING = "RATING";
  static const IMAGE = "image";
  static const COST = "COST";
  static const discount = "DISCOUNT";
  static const TIME = "TIME";
  static const DESCRIPTION = "DESCRIPTION";
  static const CATEGORY = "CATEGORY";
  static const FEATURED = "FEATURED";
  static const RATES = "RATES";
  static const USER_LIKES = "userLikes";

  String _id;
  String _name;
  String _category;
  String _image;
  String _description;

  double _rating;
  int _price;
  int _rates;
  int _discount;
  int _time;

  bool _featured;

  String get id => _id;

  String get name => _name;

  String get category => _category;

  String get description => _description;

  String get image => _image;

  double get rating => _rating;

  int get price => _price;

  bool get featured => _featured;

  int get rates => _rates;
  int get dis => _discount;
  int get time => _time;

  // public variable
  bool liked = false;

  ProductModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.data[FOODID];
    _image = snapshot.data[IMAGE];
    _description = snapshot.data[DESCRIPTION];
    _featured = snapshot.data[FEATURED];
    _price = snapshot.data[COST].floor();
    _category = snapshot.data[CATEGORY];
    _rating = snapshot.data[RATING];
    _rates = snapshot.data[RATES];
    _discount = snapshot.data[discount];
    _time = snapshot.data[TIME];
    _name = snapshot.data[FOODNAME];
  }
}
