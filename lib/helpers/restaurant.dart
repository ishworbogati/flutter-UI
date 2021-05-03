import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodorderingsys/models/products.dart';

class RestaurantServices {
  String collection = "restaurants";
  Firestore _firestore = Firestore.instance;

  Future<List<ProductModel>> getRestaurants() async =>
      _firestore.collection(collection).getDocuments().then((result) {
        List<ProductModel> restaurants = [];
        for (DocumentSnapshot restaurant in result.documents) {
          restaurants.add(ProductModel.fromSnapshot(restaurant));
        }
        return restaurants;
      });

  Future<ProductModel> getRestaurantById({String id}) => _firestore
          .collection(collection)
          .document(id.toString())
          .get()
          .then((doc) {
        return ProductModel.fromSnapshot(doc);
      });

  Future<List<ProductModel>> searchRestaurant({String restaurantName}) {
    // code to convert the first character to uppercase
    String searchKey =
        restaurantName[0].toUpperCase() + restaurantName.substring(1);
    return _firestore
        .collection(collection)
        .orderBy("name")
        .startAt([searchKey])
        .endAt([searchKey + '\uf8ff'])
        .getDocuments()
        .then((result) {
          List<ProductModel> restaurants = [];
          for (DocumentSnapshot product in result.documents) {
            restaurants.add(ProductModel.fromSnapshot(product));
          }
          return restaurants;
        });
  }
}
