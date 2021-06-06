import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodorderingsys/models/cart_item.dart';
import 'package:foodorderingsys/models/user.dart';

class UserServices {
  String collection = "users";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void createUser(Map<String, dynamic> values) {
    String id = values["id"];
    _firestore.collection(collection).doc(id).set(values);
  }

  void updateUserData(Map<String, dynamic> values) {
    _firestore.collection(collection).doc(values['id']).update(values);
  }

  void addToCart({String userId, CartItemModel cartItem}) {
    _firestore.collection(collection).doc(userId).update({
      "cart": FieldValue.arrayUnion([cartItem.toMap()])
    });
  }

  void addLikedFood({String userId, likedItemid}) {
    Map<String, dynamic> likedItem = {
      "id": likedItemid,
    };

    _firestore.collection(collection).doc(userId).update({
      "likedFood": FieldValue.arrayUnion([
        {"id": likedItemid}
      ])
    });
  }

  void removeFromCart({String userId, CartItemModel cartItem}) {
    _firestore.collection(collection).doc(userId).update({
      "cart": FieldValue.arrayRemove([cartItem.toMap()])
    });
  }

  void removeAllFromCart({String userId}) {
    _firestore.collection(collection).doc(userId).update({"cart": []});
  }

  Future<UserModel> getUserById(String id) =>
      _firestore.collection(collection).doc(id).get().then((doc) {
        return UserModel.fromSnapshot(doc);
      });
}
