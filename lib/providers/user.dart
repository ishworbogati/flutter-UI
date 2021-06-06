import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodorderingsys/helpers/order.dart';
import 'package:foodorderingsys/helpers/user.dart';
import 'package:foodorderingsys/models/cart_item.dart';
import 'package:foodorderingsys/models/order.dart';
import 'package:foodorderingsys/models/products.dart';
import 'package:foodorderingsys/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserProvider with ChangeNotifier {
  FirebaseAuth _auth;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  User _user;
  Status _status = Status.Uninitialized;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserServices _userServicse = UserServices();
  OrderServices _orderServices = OrderServices();
  UserModel _userModel;

//  getter
  UserModel get userModel => _userModel;

  OrderModel _ordercart;

//  getter
  OrderModel get ordercart => _ordercart;
  Status get status => _status;
  User get user => _user;

  // public variables
  List<OrderModel> orders = [];
  var smsCode;
  final formkey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController _codeController = TextEditingController();

  UserProvider.initialize() : _auth = FirebaseAuth.instance {
    Firebase.initializeApp();
    _auth.authStateChanges().listen(_onStateChanged);
  }

  Future<bool> signIn() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(
          email: email.text.trim(), password: password.text.trim());
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future<bool> signUp(BuildContext context) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth
          .createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((result) => {
                _firestore.collection('users').doc(result.user.uid).set({
                  'firstname': firstname.text,
                  'lastname': lastname.text,
                  'email': email.text,
                  'phone': phone.text,
                  'uid': result.user.uid,
                  "likedFood": [],
                  "cart": [],
                  "photo": ""
                })
              });

      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future<bool> verifyPhone(BuildContext context, User user) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+977+${phone.text}",
        verificationCompleted: (PhoneAuthCredential credential) {
          _firestore.collection('users').doc(user.uid).set({
            'firstname': firstname.text,
            'lastname': lastname.text,
            'email': email.text,
            'phone': phone.text,
            'uid': user.uid,
            "likedFood": [],
            "cart": [],
            "photo": ""
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e);
        },
        codeSent: (String verificationId, int resendToken) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                    title: Text("Enter SMS Code"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: _codeController,
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Done"),
                        textColor: Colors.white,
                        color: Colors.redAccent,
                        onPressed: () {
                          smsCode = _codeController.text.trim();
                          print(smsCode);
                          print(verificationId);
                        },
                      )
                    ],
                  ));
        },
        timeout: Duration(seconds: 60),
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          print(verificationId);
          print("Timout");
        },
      );
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future signOut() async {
    /*if (user.providerData[1].providerId == 'google.com') {
      await googleSignIn.disconnect();
    }*/
    print(user.providerData);
    googleSignIn.signOut();
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<bool> googleSignInButton() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      try {
        _status = Status.Authenticating;
        notifyListeners();
        await _auth.signInWithCredential(credential).then((value) => {
              _firestore.collection('users').doc(value.user.uid).set({
                'firstname': value.user.displayName,
                'lastname': "",
                'email': value.user.email,
                'phone': value.user.phoneNumber,
                'uid': value.user.uid,
                "likedFood": [],
                "cart": [],
                "photo": value.user.photoURL
              })
            });
        return true;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
          print(e.code);
        } else if (e.code == 'invalid-credential') {
          print(e.code);
          return false;
        }
      } catch (e) {
        _status = Status.Unauthenticated;
        notifyListeners();
        print(e.toString());
        return false;
      }
    }
  }

  Future<User> facebookSignInButton() async {
    /*  prefs = await SharedPreferences.getInstance();

    fblogin.logIn(['email']).then((result) async {
      if(result.status== FacebookLoginStatus.loggedIn){

        AuthResult authres = await FirebaseAuth.instance
            .signInWithCredential(FacebookAuthProvider.getCredential(accessToken: result.accessToken.token));
        FirebaseUser firebaseUser = authres.user;
        if (firebaseUser != null) {
          // Check is already sign up
          final QuerySnapshot result = await Firestore.instance
              .collection('users')
              .where('id', isEqualTo: firebaseUser.uid)
              .getDocuments();
          final List<DocumentSnapshot> documents = result.documents;
          if (documents.length == 0) {
            // Update data to server if new user
            Firestore.instance
                .collection('users')
                .document(firebaseUser.displayName)
                .setData({
              'userName': firebaseUser.displayName,
              'photoUrl': firebaseUser.photoUrl,
              'id': firebaseUser.uid,
              'email': firebaseUser.email,
              'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
              'chattingWith': null
            });

            // Write data to local
            currentUser = firebaseUser;
            await prefs.setString('id', currentUser.uid);
            await prefs.setString('userName', currentUser.displayName);
            await prefs.setString('photoUrl', currentUser.photoUrl);
            await prefs.setString('email', currentUser.email);

            // Write data to local
            await prefs.setString('id', documents[0]['id']);
            await prefs.setString('email', documents[0]['email']);
            await prefs.setString('userName', documents[0]['nickname']);
            await prefs.setString('photoUrl', documents[0]['photoUrl']);
            await prefs.setString('aboutMe', documents[0]['aboutMe']);

            Fluttertoast.showToast(msg: "Sign in success");
            this.setState(() {
              isLoading = false;
            });

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(currentUserId: firebaseUser.uid)));
          } else {
            Fluttertoast.showToast(msg: "Sign in fail");
            this.setState(() {
              isLoading = false;
            });
          }
        }
      }
    }).catchError((e){
      print(e);
    });
*/
  }
  void clearController() {
    name.text = "";
    password.text = "";
    email.text = "";
    firstname.text = "";
    lastname.text = "";
    phone.text = "";
    _codeController.text = "";
  }

  Future<void> reloadUserModel() async {
    _userModel = await _userServicse.getUserById(user.uid);
    notifyListeners();
  }

  Future<void> _onStateChanged(User firebaseUser) async {
    if (firebaseUser == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool _seen = (prefs.getBool('seen') ?? false);
      if (_seen) {
        _status = Status.Unauthenticated;
      } else {
        await prefs.setBool('seen', true);
        _status = Status.Uninitialized;
      }
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
      _userModel = await _userServicse.getUserById(user.uid);
      await _firestore
          .collection("users")
          .doc(user.uid)
          .update({"token": await FirebaseMessaging.instance.getToken()}).then(
              (value) {});
    }
    notifyListeners();
  }

  Future<bool> addToCard({ProductModel product, int quantity}) async {
    try {
      var uuid = Uuid();
      String cartItemId = uuid.v4();
      List cart = _userModel.cart;
//      bool itemExists = false;
      Map cartItem = {
        "id": cartItemId,
        "name": product.name,
        "image": product.image,
        "orderedno": product.orderedno,
        "productId": product.id,
        "price": product.price,
        "quantity": quantity,
        "discount": product.dis,
        "cooktime":
            quantity == 1 ? product.time : (product.time + quantity * 1),
        "inittime": 0,
        "url": product.image
      };

      CartItemModel item = CartItemModel.fromMap(cartItem);
//      if(!itemExists){
      _userServicse.addToCart(userId: _user.uid, cartItem: item);
//      }

      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  Future<bool> addLikedFood({product}) async {
    try {
//      if(!itemExists){

      _userServicse.addLikedFood(userId: _user.uid, likedItemid: product);
//      }

      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  getOrders() async {
    orders = await _orderServices.getUserOrders(userId: _user.uid);
    notifyListeners();
  }

  Future<bool> removeFromCart({CartItemModel cartItem}) async {
    try {
      _userServicse.removeFromCart(userId: _user.uid, cartItem: cartItem);
      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  Future<bool> removeAllFromCart() async {
    try {
      _userServicse.removeAllFromCart(userId: _user.uid);
      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  int total = 0;

  int get Total => total;

  getTotalAmount(id) {
    _firestore
        .collection("orders")
        .where("userId", isEqualTo: id)
        .get()
        .then((result) {
      total = 0;
      notifyListeners();
      for (var message in result.docs) {
        final getitem = message.data()["total"];
        if (message.data()["paid"] == 0) {
          total = total + getitem;
          notifyListeners();
        }
      }
    });
  }

  paid(id, method) {
    _firestore
        .collection("orders")
        .where("userId", isEqualTo: id)
        .get()
        .then((result) {
      for (var message in result.docs) {
        FirebaseFirestore.instance
            .collection("orders")
            .doc(message.id)
            .update({'paid': 1, 'gateway': method});
      }
    });
  }
}
