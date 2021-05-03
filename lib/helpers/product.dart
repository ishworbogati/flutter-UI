import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/products.dart';

class ProductServices {
  String collection = "products";
  Firestore _firestore = Firestore.instance;

  Future<List<ProductModel>> getProducts() async =>
      _firestore.collection("fooditems").getDocuments().then((result) {
        List<ProductModel> products = [];
        for (DocumentSnapshot product in result.documents) {
          products.add(ProductModel.fromSnapshot(product));
        }
        return products;
      });
  Future<List<dynamic>> getListProducts() async =>
      _firestore.collection("fooditems").getDocuments().then((result) {
        List<dynamic> products = [];
        for (DocumentSnapshot product in result.documents) {
          products = product.data as List;
          print(products);
        }
        return products;
      });

  void likeOrDislikeProduct({String id, List<String> userLikes}) {
    _firestore
        .collection("fooditems")
        .document(id)
        .updateData({"userLikes": userLikes});
  }

  Future<List<ProductModel>> getAllProducts({String category}) async =>
      _firestore.collection("fooditems").getDocuments().then((result) {
        List<ProductModel> products = [];
        for (DocumentSnapshot product in result.documents) {
          products.add(ProductModel.fromSnapshot(product));
        }
        return products;
      });
  Future<List<ProductModel>> getProductsOfCategory({String category}) async =>
      _firestore
          .collection("fooditems")
          .where("category", isEqualTo: category)
          .getDocuments()
          .then((result) {
        List<ProductModel> products = [];
        for (DocumentSnapshot product in result.documents) {
          //   print(product.data);
          products.add(ProductModel.fromSnapshot(product));
        }
        return products;
      });

  Future<List<ProductModel>> searchProducts({String productName}) {
    // code to convert the first character to uppercase
    String searchKey = productName[0].toLowerCase() + productName.substring(1);
    return _firestore
        .collection("fooditems")
        .orderBy("FOODNAME")
        .startAt([searchKey])
        .endAt([searchKey + '\uf8ff'])
        .getDocuments()
        .then((result) {
          List<ProductModel> products = [];
          for (DocumentSnapshot product in result.documents) {
            print(product.data);
            products.add(ProductModel.fromSnapshot(product));
          }
          return products;
        });
  }
}
