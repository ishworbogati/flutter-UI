import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodorderingsys/helpers/AppTheme.dart';
import 'package:foodorderingsys/helpers/beziercontainer.dart';
import 'package:foodorderingsys/helpers/info.dart';
import 'package:foodorderingsys/helpers/screen_navigation.dart';
import 'package:foodorderingsys/helpers/style.dart';
import 'package:foodorderingsys/providers/product.dart';
import 'package:foodorderingsys/providers/user.dart';
import 'package:foodorderingsys/screens/hotel_app.dart';
import 'package:foodorderingsys/widgets/loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _key = GlobalKey<ScaffoldState>();

  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;
  PageController _controller =
      new PageController(initialPage: 1, viewportFraction: 1.0);

  @override
  void initState() {
    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 500));
    _iconAnimation = new CurvedAnimation(
        parent: _iconAnimationController, curve: Curves.bounceOut);
    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final authProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      key: _key,
      backgroundColor: white,
      body: authProvider.status == Status.Authenticating
          ? Loading()
          : PageView(
              controller: _controller,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                LoginPage(context, 0),
                HomePage(context),
                LoginPage(context, 1)
              ],
              scrollDirection: Axis.horizontal,
            ),
    );
  }

  Widget LoginPage(context, int value) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .11),
                    _title(),
                    SizedBox(
                      height: 20,
                    ),
                    _emailPasswordWidget(value),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(value),
                    SizedBox(height: height * .02),
                    // _loginAccountLabel(),
                  ],
                ),
              ),
            ),
            value == 0
                ? Positioned(top: 40, right: 0, child: _backButton(value))
                : Positioned(top: 40, left: 0, child: _backButton(value)),
          ],
        ),
      ),
    );
  }

  Widget HomePage(context) {
    return new Container(
      decoration: BoxDecoration(
        color: AppTheme.nearlyWhite,
      ),
      child: SingleChildScrollView(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: SizeConfig.blockSizeVertical * 40,
              padding: EdgeInsets.only(top: 30.0),
              child: Center(
                child: Image.asset("assets/images/logo.png"),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Hotel",
                    style: TextStyle(
                      color: AppTheme.dark_grey,
                      fontSize: 20.0,
                    ),
                  ),
                  Text(
                    " App",
                    style: TextStyle(
                        color: AppTheme.dark_grey,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: AppTheme.dark_grey.withOpacity(0.8),
                    onPressed: () => gotoLogin(1),
                    child: new Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 80.0,
                      ),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Login with email".toUpperCase(),
                            textAlign: TextAlign.center,
                            style: AppTheme.caption,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      color: AppTheme.dark_grey.withOpacity(0.8),
                      onPressed: () => gotoLogin(0),
                      child: new Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 100.0,
                        ),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Signup".toUpperCase(),
                              textAlign: TextAlign.center,
                              style: AppTheme.caption,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  _buildSignInWithText(),
                  SizedBox(
                    height: 30,
                  ),
                  Align(
                      alignment: FractionalOffset(0.5, 0.95),
                      child: _googleSignInButton()),
                  SizedBox(
                    height: 20,
                  ),
                  _facebookButton(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            fontFamily: 'OpenSans',
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Sign in with',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ],
    );
  }

  Widget _googleSignInButton() {
    final authProvider = Provider.of<UserProvider>(context, listen: false);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    return ButtonTheme(
      minWidth: 175,
      child: FlatButton(
        color: AppTheme.notWhite,
        splashColor: Colors.white,
        onPressed: () async {
          if (!await authProvider.googleSignInButton()) {
            return;
          }
          productProvider.loadProducts();
          authProvider.clearController();
          changeScreenReplacement(context, hotel_home());
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                  image: AssetImage("assets/images/google_logo.png"),
                  height: 35.0),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Google',
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    color: AppTheme.dark_grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  var smsCode;

  TextEditingController _codeController = TextEditingController();
  Widget _facebookButton() {
    final authProvider = Provider.of<UserProvider>(context, listen: false);

    return ButtonTheme(
      minWidth: SizeConfig.blockSizeHorizontal * 2,
      child: FlatButton(
        color: AppTheme.notWhite,
        splashColor: Colors.white,
        onPressed: () async {
          await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: "+977 9840360131",
            verificationCompleted: (PhoneAuthCredential credential) {
              /*  _firestore.collection('users').doc(result.user.uid).set({
                'firstname': firstname.text,
                'lastname': lastname.text,
                'email': email.text,
                'phone': phone.text,
                'uid': result.user.uid,
                "likedFood": [],
                "cart": [],
                "photo": ""
              });*/
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
                              FirebaseAuth auth = FirebaseAuth.instance;

                              smsCode = _codeController.text.trim();

                              var credential = PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: smsCode);

                              print(credential.providerId);
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
          // authProvider.facebookSignInButton();
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                  image: AssetImage("assets/images/facebook_logo.png"),
                  height: 35.0),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Facebook',
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    color: AppTheme.dark_grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  gotoLogin(int data) {
    //controller_0To1.forward(from: 0.0);
    if ((data == 0)) {
      _controller.animateToPage(
        0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInExpo,
      );
    } else {
      _controller.animateToPage(
        2,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInExpo,
      );
    }
  }

  Widget _backButton(value) {
    return InkWell(
      onTap: () {
        gotoLoginOption();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
          child: value == 0
              ? Icon(Icons.keyboard_arrow_right, color: Colors.black)
              : Icon(Icons.keyboard_arrow_left, color: Colors.black),
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Hotel',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: AppTheme.dark_grey,
          ),
          children: [
            TextSpan(
              text: ' ',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
            TextSpan(
              text: 'App',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  gotoLoginOption() {
    _controller.animateToPage(
      1,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInExpo,
    );
  }

  Widget _emailPasswordWidget(value) {
    final authProvider = Provider.of<UserProvider>(context, listen: false);
    return value == 0
        ? Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
            child: new Form(
              child: new Theme(
                data: new ThemeData(
                  brightness: Brightness.light,
                  primarySwatch: Colors.grey,
                ),
                child: new Container(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new TextFormField(
                          controller: authProvider.email,
                          style: TextStyle(
                            color: AppTheme.dark_grey.withOpacity(0.5),
                          ),
                          decoration: new InputDecoration(hintText: "E-mail"),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your e-mail';
                            } else if (RegExp(
                                    r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                .hasMatch(value.trim())) {
                              return null;
                            }
                            return 'Please enter valid e-mail';
                          }),
                      new TextFormField(
                          controller: authProvider.firstname,
                          style: TextStyle(
                            color: AppTheme.dark_grey.withOpacity(0.5),
                          ),
                          decoration:
                              new InputDecoration(hintText: "First name"),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your firstname';
                            }
                            return null;
                          }),
                      new TextFormField(
                          controller: authProvider.lastname,
                          style: TextStyle(
                            color: AppTheme.dark_grey.withOpacity(0.5),
                          ),
                          decoration:
                              new InputDecoration(hintText: "Last name"),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your Lastname';
                            }
                            return null;
                          }),
                      new TextFormField(
                          controller: authProvider.password,
                          style: TextStyle(
                            color: AppTheme.dark_grey.withOpacity(0.5),
                          ),
                          obscureText: true,
                          decoration: new InputDecoration(hintText: "Password"),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          }),
                      new TextFormField(
                        controller: authProvider.phone,
                        style: TextStyle(
                          color: AppTheme.dark_grey.withOpacity(0.5),
                        ),
                        decoration: new InputDecoration(
                            hintText: "Phone number",
                            prefixText: "+977 ",
                            prefixStyle: TextStyle(color: AppTheme.dark_grey)),
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 80.0, bottom: 40.0),
            child: new Form(
              child: new Theme(
                data: new ThemeData(
                  brightness: Brightness.light,
                  primarySwatch: Colors.grey,
                ),
                child: new Container(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new TextFormField(
                          controller: authProvider.email,
                          style: TextStyle(
                            color: AppTheme.dark_grey.withOpacity(0.5),
                          ),
                          decoration: new InputDecoration(hintText: "E-mail"),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your e-mail';
                            } else if (RegExp(
                                    r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                .hasMatch(value.trim())) {
                              return null;
                            }
                            return 'Please enter valid e-mail';
                          }),
                      new TextFormField(
                          controller: authProvider.password,
                          style: TextStyle(
                            color: AppTheme.dark_grey.withOpacity(0.5),
                          ),
                          obscureText: true,
                          decoration: new InputDecoration(hintText: "Password"),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          }),
                      Container(
                        alignment: Alignment.centerRight,
                        child: FlatButton(
                          onPressed: () =>
                              print('Forgot Password Button Pressed'),
                          padding: EdgeInsets.only(right: 0.0),
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans',
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget _submitButton(value) {
    return RaisedButton(
      elevation: 5,
      onPressed: () async {
        value != 0 ? logindirect() : regdirect();
      },
      child: Text(
        value == 0 ? 'Register Now' : "Sign in",
        style: TextStyle(fontSize: 20, color: AppTheme.dark_grey),
      ),
    );
  }

  logindirect() async {
    final authProvider = Provider.of<UserProvider>(context, listen: false);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    if (!await authProvider.signIn()) {
      _key.currentState.showSnackBar(SnackBar(content: Text("Login failed!")));
      return;
    }
    productProvider.loadProducts();
    authProvider.clearController();
    changeScreenReplacement(context, hotel_home());
  }

  regdirect() async {
    final authProvider = Provider.of<UserProvider>(context, listen: false);

    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+977 9840360131",
        verificationCompleted: (PhoneAuthCredential credential) {},
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
                        onPressed: () async {
                          smsCode = _codeController.text.trim();
                          FirebaseAuth auth = FirebaseAuth.instance;

                          smsCode = _codeController.text.trim();

                          var credential = PhoneAuthProvider.credential(
                              verificationId: verificationId, smsCode: smsCode);
                          if (!await authProvider.signUp(context)) {
                            _key.currentState.showSnackBar(SnackBar(
                                content: Text("Registration failed!!")));
                            return;
                          } else {
                            productProvider.loadProducts();
                            authProvider.clearController();

                            changeScreenReplacement(context, hotel_home());
                          }
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
    }
  }
}
