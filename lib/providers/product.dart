import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helpers/product.dart';
import '../models/products.dart';

class ProductProvider with ChangeNotifier {
  ProductServices _productServices = ProductServices();
  List<ProductModel> products = [];
  List<ProductModel> allProducts = [];
  List<ProductModel> productsByCategory = [];
  List<ProductModel> productsByRestaurant = [];
  List<ProductModel> productsSearched = [];

  ProductProvider.initialize() {
    loadProducts();
  }

  Future loadProducts() async {
    products = await _productServices.getProducts();
    notifyListeners();
  }

  Future loadAllProducts({String productName}) async {
    allProducts = await _productServices.getAllProducts(category: productName);
    //  notifyListeners();
  }

  Future loadProductsByCategory({String categoryName}) async {
    productsByCategory =
        await _productServices.getProductsOfCategory(category: categoryName);
    notifyListeners();
  }

  saveRating(id, rate, food, title, comments, user) async {
    final f = new DateFormat('yyyy-MM-dd');
    int ratingno;
    double rating;
    FirebaseFirestore.instance
        .collection('fooditems')
        .where("FOODNAME", isEqualTo: food)
        .get()
        .then((doc) {
      for (var u in doc.docs) {
        FirebaseFirestore.instance
            .collection('fooditems')
            .doc(food)
            .collection("reviews")
            .doc(user)
            .get()
            .then((value) {
          if (value.data() != null) {
            ratingno = u.data()["RATINGNO"] + 1;
            rating = double.parse(u.data()["RATING"].toString()) +
                double.parse(rate.toString());
          } else {
            ratingno = u.data()["RATINGNO"];
            rating = double.parse(u.data()["RATING"].toString());
          }
          FirebaseFirestore.instance
              .collection('fooditems')
              .doc(u.id)
              .update({'RATING': rating, "RATINGNO": ratingno});

          FirebaseFirestore.instance
              .collection('fooditems')
              .doc(food)
              .collection("reviews")
              .doc(user)
              .set({
            "title": title,
            "comments": comments,
            //"url": profile_image_url,
            "date": f.format(DateTime.now())
          });
        });
      }
    });
  }
//  likeDislikeProduct({String userId, ProductModel product, bool liked})async{
//    if(liked){
//      if(product.userLikes.remove(userId)){
//        _productServices.likeOrDislikeProduct(id: product.id, userLikes: product.userLikes);
//      }else{
//        print("THE USER WA NOT REMOVED");
//      }
//    }else{
//
//      product.userLikes.add(userId);
//        _productServices.likeOrDislikeProduct(id: product.id, userLikes: product.userLikes);
//
//
//      }
//  }

  Future search({String productName}) async {
    productsSearched =
        await _productServices.searchProducts(productName: productName);
    notifyListeners();
  }
}
