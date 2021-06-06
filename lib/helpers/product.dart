import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/products.dart';

class ProductServices {
  String collection = "products";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ProductModel>> getProducts() async =>
      _firestore.collection("fooditems").get().then((result) {
        List<ProductModel> products = [];
        result.docs.forEach((element) {
          products.add(ProductModel.fromSnapshot(element));
        });
        return products;
      });
/*  void likeOrDislikeProduct({String id, List<String> userLikes}) {
    _firestore.collection("fooditems").doc(id).update({"userLikes": userLikes});
  }*/

  Future<List<ProductModel>> getAllProducts({String category}) async =>
      _firestore.collection("fooditems").get().then((result) {
        List<ProductModel> products = [];
        result.docs.forEach((element) {
          products.add(ProductModel.fromSnapshot(element));
        });
        return products;
      });
  Future<List<ProductModel>> getProductsOfCategory({String category}) async =>
      _firestore
          .collection("fooditems")
          .where("category", isEqualTo: category)
          .get()
          .then((result) {
        List<ProductModel> products = [];
        for (DocumentSnapshot product in result.docs) {
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
        .get()
        .then((result) {
          List<ProductModel> products = [];
          for (DocumentSnapshot product in result.docs) {
            products.add(ProductModel.fromSnapshot(product));
          }
          return products;
        });
  }
}
