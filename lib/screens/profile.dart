import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodorderingsys/helpers/AboutUs.dart';
import 'package:foodorderingsys/helpers/AppTheme.dart';
import 'package:foodorderingsys/models/order.dart';
import 'package:foodorderingsys/providers/app.dart';
import 'package:foodorderingsys/providers/user.dart';
import 'package:foodorderingsys/screens/logoutPopOut.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class profile extends StatefulWidget {
  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<profile> {
  bool isSwitched;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    user.reloadUserModel();
    return Scaffold(
      body: Container(
        child: new ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(bottom: 20),
              height: 65,
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: IconButton(
                        padding: EdgeInsets.all(20),
                        icon: Icon(Icons.settings),
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (_) => profile(),
                          );
                        }),
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "Paradox Restaurant",
                        style: TextStyle(
                            color: AppTheme.dark_grey,
                            fontSize: 25,
                            fontWeight: FontWeight.w800),
                      ),
                      Text(
                        "St-256, AU, Brasbain",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Container(
                        child: IconButton(
                            padding: EdgeInsets.all(20),
                            icon: Icon(Icons.power_settings_new),
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (_) => FunkyOverlay(),
                              );
                            }),
                      ),
                    ],
                  ),
                ],
              )),
              decoration: BoxDecoration(
                  color: AppTheme.notWhite,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(40),
                      bottomLeft: Radius.circular(40)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[400],
                        offset: Offset(4.0, 4.0),
                        blurRadius: 15.0,
                        spreadRadius: 1),
                    BoxShadow(
                        color: Colors.white,
                        offset: Offset(-4.0, -4.0),
                        blurRadius: 15.0,
                        spreadRadius: 1.0),
                  ]),
            ),
            Column(
              children: <Widget>[
                Container(
                  color: AppTheme.notWhite.withOpacity(0.5),
                  height: 240.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Stack(
                            fit: StackFit.loose,
                            alignment: AlignmentDirectional.center,
                            children: <Widget>[
                              _buildProfileImage(user),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 100.0, right: 90.0),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      InkWell(
                                        child: new CircleAvatar(
                                          backgroundColor: AppTheme.dark_grey,
                                          radius: 20.0,
                                          child: new Icon(
                                            Icons.add_a_photo,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                        onTap: () {
                                          uploadImg(context);
                                        },
                                      )
                                    ],
                                  )),
                            ]),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Text(
                            ("${user.userModel.name}" +
                                    " ${user.userModel.lname}")
                                .toUpperCase(),
                            style: TextStyle(
                                color: AppTheme.nearlyBlack.withOpacity(0.5),
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  color: AppTheme.grey.withOpacity(0.8),
                ),
                LimitedBox(
                  child: SettingsList(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    contentPadding: EdgeInsets.only(top: 20),
                    sections: [
                      SettingsSection(
                        title: 'Profile',
                        titleTextStyle: TextStyle(
                            color: AppTheme.dark_grey,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                        tiles: [
                          SettingsTile(
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                            ),
                            title: 'E-Mail',
                            subtitle: '${user.userModel.email}',
                            leading: Icon(Icons.alternate_email),
                            onPressed: (BuildContext context) {},
                          ),
                          SettingsTile(
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                            ),
                            title: 'Phone Number',
                            subtitle: '${user.userModel.phone}',
                            leading: Icon(Icons.phone),
                            onPressed: (BuildContext context) {
                              showDialog(
                                  context: context,
                                  builder: (_) =>
                                      editEmail(user.userModel.phone));
                            },
                          ),
                          SettingsTile(
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                            ),
                            title: 'Address',
                            subtitle: 'Nepal',
                            leading: Icon(Icons.home),
                            onPressed: (BuildContext context) {},
                          ),
                        ],
                      ),
                      SettingsSection(
                        title: 'View',
                        titleTextStyle: TextStyle(
                            color: AppTheme.dark_grey,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                        tiles: [
                          SettingsTile(
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                            ),
                            title: 'History',
                            subtitle: 'orders',
                            leading: Icon(Icons.history),
                            onPressed: (BuildContext context) {
                              showDialog(
                                  context: context, builder: (_) => About());
                            },
                          ),
                          SettingsTile(
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                            ),
                            title: 'Wishlist',
                            leading: Icon(Icons.fact_check_outlined),
                            onPressed: (BuildContext context) {
                              showDialog(
                                  context: context, builder: (_) => aboutUs());
                            },
                          ),
                        ],
                      ),
                      SettingsSection(
                        title: 'App',
                        titleTextStyle: TextStyle(
                            color: AppTheme.dark_grey,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                        tiles: [
                          SettingsTile(
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                            ),
                            title: 'Notification',
                            subtitle: '',
                            leading: Icon(Icons.notifications),
                            onPressed: (BuildContext context) {},
                          ),
                          /* SettingsTile(
                            trailing: Switch(
                              value: isSwitched,
                              onChanged: (value) {
                                app.darkTheme = value;
                                setState(() {
                                  isSwitched = value;
                                });
                              },
                              activeColor: AppTheme.dark_grey,
                            ),
                            title: 'Dark Mode',
                            subtitle: '',
                            leading: Icon(Icons.remove_red_eye),
                            onPressed: (BuildContext context) {},
                          ),*/
                          SettingsTile(
                            title: 'About Us',
                            subtitle: '',
                            leading:
                                Icon(Icons.account_balance_wallet_outlined),
                            onPressed: (BuildContext context) {
                              showDialog(
                                  context: context, builder: (_) => aboutUs());
                            },
                          ),
                          SettingsTile(
                            title: 'Version',
                            subtitle: '1.0.0',
                            leading: Icon(Icons.app_blocking_rounded),
                            onPressed: (BuildContext context) {},
                          ),
                        ],
                      ),
                    ],
                  ),
                )
                /* BottomSection()*/
              ],
            ),
          ],
        ),
      ),
    );
  }

  aboutUsDialog(context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Scaffold(
            backgroundColor: AppTheme.notWhite,
            body: Container(
              child: Column(
                children: [
                  Image.asset("assets/images/delivery.jpg"),
                  Text(
                    "asdsad sdsd sad dsad asd asd sadas sad sds dasd ds ad asd sd"
                    " sdasd asd sad  dasdsdsd sd"
                    "sdsadsd sads dsad d asd",
                    maxLines: 5,
                  )
                ],
              ),
            )));
  }

  bool newimage = false;
  Future uploadImg(context) async {
    showModalBottomSheet(
        backgroundColor: AppTheme.dark_grey,
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Pick an image',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FlatButton(
                  textColor: AppTheme.notWhite,
                  child: Text('Use Camera'),
                  onPressed: () {
                    _getImage(context, ImageSource.camera);
                  },
                ),
                FlatButton(
                  textColor: AppTheme.notWhite,
                  child: Text('Use Gallery'),
                  onPressed: () {
                    _getImage(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        });
  }

  _buildProfileImage(user) {
    //  print(user.userModel.url);
    return Container(
        padding: EdgeInsets.all(2.0),
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 4, color: AppTheme.dark_grey),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(200),
          child:
              /*user.userModel.url == null
              ? Image.file(_imageFile)
              :*/
              CachedNetworkImage(
            imageUrl: user.userModel.url,
            fit: BoxFit.cover,
            height: 100,
            width: 100,
          ),
        ));
  }

  File _imageFile;

  void _getImage(BuildContext context, ImageSource source) async {
    final user = Provider.of<UserProvider>(context, listen: false);
    final app = Provider.of<AppProvider>(context, listen: false);
    app.changeLoading();
    PickedFile pickedFile = await ImagePicker().getImage(
      source: source,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    print(pickedFile); /*ImagePicker.pickImage(source: source);*/
    File image = File(pickedFile.path);
    setState(() {
      _imageFile = image;
      newimage = true;
    });
    uploadImageToFirebase(context, user);
    // Closes the bottom sheet
    Navigator.pop(context);
  }

  Future uploadImageToFirebase(BuildContext context, user) async {
    String fileName = basename(_imageFile.path);
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('uploads/$fileName');
    firebase_storage.UploadTask uploadTask =
        firebase_storage.FirebaseStorage.instance.ref().putFile(_imageFile);
    await uploadTask.whenComplete(() => {
          didChangeDependencies(),
          FirebaseFirestore.instance
              .collection("users")
              .doc(user.userModel.id)
              .update({
            "photo": uploadTask.snapshot.ref.getDownloadURL(),
          })
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class BottomSection extends StatefulWidget {
  @override
  _BottomSectionState createState() => new _BottomSectionState();
}

class _BottomSectionState extends State<BottomSection>
    with TickerProviderStateMixin {
  List<Tab> _tabs;
  List<Widget> _pages;
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _tabs = [
      new Tab(text: 'History'),
      new Tab(text: 'Liked Gallery'),
      //new Tab(text: 'Skills'),
    ];
    _pages = [
      About(),
      Gallery(),
      //Skills(),
    ];
    _controller = new TabController(
      length: _tabs.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.nearlyWhite,
      child: Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child: new Column(
          children: <Widget>[
            new TabBar(
              controller: _controller,
              tabs: _tabs,
              labelColor: AppTheme.nearlyBlack,
              indicatorColor: AppTheme.dark_grey,
              unselectedLabelColor: AppTheme.nearlyBlack.withOpacity(0.5),
              labelStyle: AppTheme.title,
            ),
            new SizedBox.fromSize(
              size: const Size.fromHeight(500.0),
              child: new TabBarView(
                controller: _controller,
                children: _pages,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Gallery extends StatelessWidget {
  List<Widget> _buildItems() {
    var items = <Widget>[];

    for (var i = 900; i <= 914; i++) {
      var image = new CachedNetworkImage(
        imageUrl: "profile_image_url",
      );

      items.add(image);
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    var delegate = new SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
    );

    return new GridView(
      padding: const EdgeInsets.only(top: 16.0),
      gridDelegate: delegate,
      children: _buildItems(),
    );
  }
}

class Skills extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            LinearPercentIndicator(
              width: 170.0,
              animation: true,
              animationDuration: 1000,
              lineHeight: 16.0,
              leading: Container(width: 60, child: Text("Flutter")),
              percent: 0.80,
              linearStrokeCap: LinearStrokeCap.butt,
              progressColor: AppTheme.dark_grey,
            ),
            LinearPercentIndicator(
              width: 170.0,
              animation: true,
              animationDuration: 1000,
              lineHeight: 16.0,
              leading: Container(width: 60, child: Text("Dart")),
              percent: 0.95,
              linearStrokeCap: LinearStrokeCap.butt,
              progressColor: AppTheme.dark_grey,
            ),
            LinearPercentIndicator(
              width: 170.0,
              animation: true,
              animationDuration: 1000,
              lineHeight: 16.0,
              leading: Container(width: 60, child: Text("Java")),
              percent: 0.75,
              linearStrokeCap: LinearStrokeCap.butt,
              progressColor: Colors.green,
            ),
            LinearPercentIndicator(
              width: 170.0,
              animation: true,
              animationDuration: 1000,
              lineHeight: 16.0,
              leading: Container(width: 60, child: Text("C++")),
              percent: 0.60,
              linearStrokeCap: LinearStrokeCap.butt,
              progressColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false);
    return new Center(
      child: Card(
        child: LimitedBox(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .where("userId", isEqualTo: user.user.uid)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Text('Loading...');
                default:
                  return GroupedListView<dynamic, String>(
                      elements: snapshot.data.docs,
                      groupBy: (element) => (element["date"]),
                      sort: true,
                      order: GroupedListOrder.DESC,
                      useStickyGroupSeparators: true,
                      addRepaintBoundaries: true,
                      groupSeparatorBuilder: (String groupByValue) => Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, bottom: 2, top: 5),
                            child: Text(
                              groupByValue.toUpperCase(),
                              style: TextStyle(
                                  color: AppTheme.nearlyBlack,
                                  fontWeight: FontWeight.w200,
                                  letterSpacing: 1),
                            ),
                          ),
                      itemBuilder: (context, dynamic element) {
                        final order = OrderModel.fromSnapshot(element);
                        print(order.cart);
                        return Padding(
                          padding:
                              const EdgeInsets.only(top: 5.0, bottom: 15.0),
                          child: LimitedBox(
                            maxWidth: MediaQuery.of(context).size.width - 10,
                            child: Column(
                              children: [
                                Center(
                                  child: Container(
                                    child: Text("Order No: #" +
                                        order.id.substring(0, 5)),
                                  ),
                                ),
                                Card(
                                  child: Column(children: [
                                    header(order, context),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        );
                        /*Card(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 12.0, bottom: 12.0, right: 10, left: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 10.0, bottom: 5),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                Colors.green.withOpacity(0.8)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Icon(
                                            Icons.check,
                                            size: 10.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 10.0, bottom: 5),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color:
                                                Colors.green.withOpacity(0.8)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text("Delivered"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(element["id"]),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ))),
                                      child: Text(
                                          "\$ " + element["total"].toString()),
                                    ),
                                    // Container(child: Text(sum.toString())),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )*/ /* Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              height: 20,
                              alignment: Alignment.center,
                              child: Card(
                                  elevation: 4,
                                  color: AppTheme.notWhite.withOpacity(0.5),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          element["foodname"]
                                              .toString()
                                              .toUpperCase(),
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.add_box,
                                          color: AppTheme.darkerText,
                                          size: 14,
                                        ),
                                        onPressed: () {},
                                      )
                                    ],
                                  )))*/
                        ;
                      });
              }
            },
          ),
        ),
      ),
    );
  }

  header(data, context) {
    var exp;
    var format = new DateFormat('HH:mm a');
    buildCollapsed1() {
      return Container(
        height: 90,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                  child: ListTile(
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Text(
                              (format.format(data.time.toDate())).toString(),
                              style: TextStyle(fontSize: 9),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "${data.cart.length}",
                                style: TextStyle(
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.dark_grey),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    " \$" + data.total.toString(),
                                    style: AppTheme.subtitle,
                                  ),
                                  Text(
                                    data.paid != 0 ? " (paid)" : " (not paid)",
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 10,
                                        color: AppTheme.dark_grey),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.fastfood,
                                    size: 15,
                                  ),
                                  Text(
                                    data.cart.length.toString(),
                                    style: AppTheme.subtitle,
                                  )
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.local_dining,
                                    size: 15,
                                  ),
                                  Text(
                                    data.total.toString(),
                                    style: AppTheme.subtitle,
                                  )
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.business_center,
                                    size: 15,
                                  ),
                                  Text(
                                    "Pack",
                                    style: AppTheme.subtitle,
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      leading: Container(
                        padding: EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(
                            color: AppTheme.dark_grey,
                            width: 1.0,
                          )),
                        ),
                        height: 60,
                        width: 60,
                        child: Icon(Icons.fastfood_sharp),
                      ),
                      trailing: Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Icon(Icons.keyboard_arrow_down_rounded))))
            ]),
      );
    }

    buildExpanded1() {
      return Container(
        height: 90,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                  shadowColor: AppTheme.dark_grey.withOpacity(0.3),
                  elevation: 5,
                  child: ListTile(
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Text(
                              (format.format(data.time.toDate())).toString(),
                              style: TextStyle(fontSize: 9),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "${data.cart.length}",
                                style: TextStyle(
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.dark_grey),
                              ),
                              Row(
                                children: [
                                  Text(
                                    " \$" + data.total.toString(),
                                    style: AppTheme.subtitle,
                                  ),
                                  Text(
                                    data.paid != 0 ? " (paid)" : " (not paid)",
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 10,
                                        color: AppTheme.dark_grey),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.fastfood,
                                    size: 15,
                                  ),
                                  Text(
                                    data.cart.length.toString(),
                                    style: AppTheme.subtitle,
                                  )
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.local_dining,
                                    size: 15,
                                  ),
                                  Text(
                                    data.total.toString(),
                                    style: AppTheme.subtitle,
                                  )
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.business_center,
                                    size: 15,
                                  ),
                                  Text(
                                    "Pack",
                                    style: AppTheme.subtitle,
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      leading: Container(
                        padding: EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(
                            color: AppTheme.dark_grey,
                            width: 1.0,
                          )),
                        ),
                        height: 60,
                        width: 60,
                        child: Icon(Icons.fastfood_sharp),
                      ),
                      trailing: Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Icon(Icons.keyboard_arrow_up_rounded)))),
            ]),
      );
    }

    buildExpanded2() {
      return LimitedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: data.cart.length,
                  itemBuilder: (context, index) {
                    return Card(
                        child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: LimitedBox(
                              /*decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                              color: AppTheme.dark_grey.withOpacity(0.1),
                              width: 0.5,
                            )),
                            color: Colors.white,
                          ),
                          margin: EdgeInsets.only(top: 8, bottom: 2),
                          padding: EdgeInsets.only(top: 5, bottom: 10),*/
                              child: ListTile(
                                title: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          width: 100,
                                          child: Text(
                                            "${data.cart[index].name.toUpperCase()}",
                                            maxLines: 2,
                                            overflow: TextOverflow.fade,
                                            style: TextStyle(
                                                letterSpacing: 1,
                                                fontWeight: FontWeight.w700,
                                                color: AppTheme.dark_grey),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              " \$" +
                                                  data.cart[index].price
                                                      .toString(),
                                              style: AppTheme.subtitle,
                                            ),
                                            Text(
                                              data.paid != 0
                                                  ? " (paid)"
                                                  : " (not paid)",
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 10,
                                                  color: AppTheme.dark_grey),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Icon(
                                              Icons.fastfood,
                                              size: 15,
                                            ),
                                            Text(
                                              data.cart[index].name,
                                              style: AppTheme.subtitle,
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Icon(
                                              Icons.local_dining,
                                              size: 15,
                                            ),
                                            Text(
                                              data.cart[index].quantity
                                                  .toString(),
                                              style: AppTheme.subtitle,
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Icon(
                                              Icons.business_center,
                                              size: 15,
                                            ),
                                            Text(
                                              "Pack",
                                              style: AppTheme.subtitle,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                leading: Container(
                                  padding: EdgeInsets.only(right: 15),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        right: BorderSide(
                                      color: AppTheme.dark_grey,
                                      width: 1.0,
                                    )),
                                  ),
                                  height: 60,
                                  width: 60,
                                  child: Container(
                                      width: 80,
                                      height: 80,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(110),
                                        child: Container(
                                            child: CachedNetworkImage(
                                          imageUrl: data.cart[index].image,
                                          fit: BoxFit.cover,
                                          height: 40,
                                          width: 40,
                                        )),
                                      )),
                                ),
                                trailing: Container(
                                  margin: const EdgeInsets.only(
                                      top: 10.0, bottom: 5),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: Colors.green.withOpacity(0.8)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text("Delivered"),
                                  ),
                                ),
                              ),
                            )));
                  }),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 8),
      child: InkWell(
        onTap: () {
          exp.toggle();
        },
        child: Container(
            decoration: BoxDecoration(
              color: AppTheme.white,
            ),
            width: MediaQuery.of(context).size.width,
            child: ExpandableNotifier(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expandable(
                    collapsed: buildCollapsed1(),
                    expanded: buildExpanded1(),
                  ),
                  Expandable(
                    expanded: buildExpanded2(),
                    collapsed: Container(),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Builder(
                        builder: (context) {
                          exp = ExpandableController.of(context);
                          return Container();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
