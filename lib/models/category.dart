import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  static const FOODID = "id";
  static const FOODNAME = "name";
  static const IMAGE = "image";

  int _id;
  String _name;
  String _image;

  //  getters
  int get id => _id;

  String get name => _name;

  String get image => _image;

  CategoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.data[FOODID];
    _name = snapshot.data[FOODNAME];
    _image = snapshot.data[IMAGE];
  }
}
