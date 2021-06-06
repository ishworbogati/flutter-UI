import 'package:flutter/material.dart';
import 'package:foodorderingsys/Cart/checkOutCard.dart';
import 'package:foodorderingsys/Cart/timeSelector.dart';
import 'package:foodorderingsys/helpers/AppTheme.dart';
import 'package:foodorderingsys/models/user.dart';
import 'package:foodorderingsys/providers/user.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';
import 'package:provider/provider.dart';

class CheckOutPage extends StatefulWidget {
  final UserModel umodel;

  const CheckOutPage({this.umodel});

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  int choice = 0;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppTheme.notWhite,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          "Confirm Order",
          style: TextStyle(color: AppTheme.darkText, fontSize: 14),
        ),
      ),
      body: Builder(builder: (context) {
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              selectedAddressSection(),
              //  standardDelivery(),
              scheduleChoice(),
              checkoutItem(),
              priceSection(),
            ],
          ),
        );
      }),
      bottomNavigationBar: CheckoutCard(
        value: 1,
      ),
    );
  }

  selectedAddressSection() {
    final user = Provider.of<UserProvider>(context, listen: false);
    return Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Column(
          children: [
            Text(
              "Address",
              style: AppTheme.title,
            ),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    border: Border.all(color: Colors.grey.shade200)),
                padding: EdgeInsets.only(left: 12, top: 8, right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          user.userModel.name.toString(),
                          style: AppTheme.subtitle,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: 8, right: 8, top: 4, bottom: 4),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.grey.shade300,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                          child: FlatButton(
                              onPressed: () {
                                showPlacePicker();
                              },
                              child: Icon(Icons.edit)),
                        )
                      ],
                    ),
                    createAddressText(
                        "431, Commerce House, Nagindas Master, Fort", 16),
                    createAddressText("Mumbai - 400023", 6),
                    createAddressText("Nepal", 6),
                    SizedBox(
                      height: 6,
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(text: "Mobile : ", style: AppTheme.subtitle),
                        TextSpan(
                            text: user.userModel.phone.toString(),
                            style: AppTheme.subtitle),
                      ]),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      color: Colors.grey.shade300,
                      height: 1,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  void showPlacePicker() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            PlacePicker("YAIzaSyDXsiuF28WAi7shQZvWjR6OzuKPsXKksls")));

    // Handle the result in your way
    print(result.latLng);
  }

  createAddressText(String strAddress, double topMargin) {
    return Container(
      margin: EdgeInsets.only(top: topMargin),
      child: Text(
        strAddress,
        style: AppTheme.subtitle,
      ),
    );
  }

  checkoutItem() {
    return Column(
      children: [
        Text("Payment"),
        InkWell(
          onTap: () async {
            await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => StatefulBuilder(
                      builder: (context, setState) {
                        return Material(
                          type: MaterialType.transparency,
                          child: Center(
                            child: Container(
                              child: Stack(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: 500,
                                      width: MediaQuery.of(context).size.width *
                                          0.85,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 30.0),
                                            child: Text(
                                              "Payment Getways",
                                              style: AppTheme.title,
                                            ),
                                          ),
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context, 1);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: AppTheme.notWhite,
                                                  border: Border(
                                                      bottom: BorderSide(
                                                        color: AppTheme
                                                            .dark_grey
                                                            .withOpacity(0.5),
                                                        width: 0.5,
                                                      ),
                                                      right: BorderSide(
                                                        color: AppTheme
                                                            .dark_grey
                                                            .withOpacity(0.5),
                                                        width: 0.5,
                                                      )),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.grey[500],
                                                        offset:
                                                            Offset(4.0, 4.0),
                                                        blurRadius: 15.0,
                                                        spreadRadius: 1.0),
                                                    BoxShadow(
                                                        color: Colors.white,
                                                        offset:
                                                            Offset(-4.0, -4.0),
                                                        blurRadius: 15.0,
                                                        spreadRadius: 1.0),
                                                  ]),
                                              height: 40,
                                              width: 200,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Icon(Icons.monetization_on),
                                                  Text(
                                                    "Cash in hand",
                                                    style: AppTheme.title,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context, 2);
                                              // _initpayment();
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: AppTheme.white,
                                                  border: Border(
                                                      bottom: BorderSide(
                                                        color: AppTheme
                                                            .dark_grey
                                                            .withOpacity(0.5),
                                                        width: 0.5,
                                                      ),
                                                      right: BorderSide(
                                                        color: AppTheme
                                                            .dark_grey
                                                            .withOpacity(0.5),
                                                        width: 0.5,
                                                      )),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.grey[500],
                                                        offset:
                                                            Offset(4.0, 4.0),
                                                        blurRadius: 15.0,
                                                        spreadRadius: 1.0),
                                                    BoxShadow(
                                                        color: Colors.white,
                                                        offset:
                                                            Offset(-4.0, -4.0),
                                                        blurRadius: 15.0,
                                                        spreadRadius: 1.0),
                                                  ]),
                                              height: 80,
                                              width: 200,
                                              child: Image.asset(
                                                "assets/images/logo_dark.png",
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                          ),
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context, 3);
                                              // _initpayment();
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: AppTheme.notWhite,
                                                  border: Border(
                                                      bottom: BorderSide(
                                                        color: AppTheme
                                                            .dark_grey
                                                            .withOpacity(0.5),
                                                        width: 0.5,
                                                      ),
                                                      right: BorderSide(
                                                        color: AppTheme
                                                            .dark_grey
                                                            .withOpacity(0.5),
                                                        width: 0.5,
                                                      )),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.grey[500],
                                                        offset:
                                                            Offset(4.0, 4.0),
                                                        blurRadius: 15.0,
                                                        spreadRadius: 1.0),
                                                    BoxShadow(
                                                        color: Colors.white,
                                                        offset:
                                                            Offset(-4.0, -4.0),
                                                        blurRadius: 15.0,
                                                        spreadRadius: 1.0),
                                                  ]),
                                              height: 80,
                                              width: 200,
                                              child: Image.asset(
                                                "assets/images/khalti.jpg",
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                          color: AppTheme.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 15,
                                                spreadRadius: 5,
                                                color: Color.fromRGBO(
                                                    0, 0, 0, .05))
                                          ]),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, top: 10),
                                      child: IconButton(
                                        icon: Icon(Icons.clear),
                                        onPressed: () {
                                          Navigator.pop(context, 3);
                                        },
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Text(
                                          "Payment".toString().toUpperCase(),
                                          style: AppTheme.title,
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )).then((value) => {
                  print(value),
                  setState(() {
                    choice = value;
                  })
                });
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                border: Border.all(color: Colors.grey.shade200)),
            padding: EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 8),
            child: checkoutListItem(),
          ),
        ),
      ],
    );
  }

  checkoutListItem() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          choice == 0
              ? Card(
                  semanticContainer: true,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text("no payment selected"))
              : Container(),
          choice == 1
              ? Card(
                  color: AppTheme.white,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width - 50,
                    child: Row(children: [
                      Icon(
                        Icons.monetization_on,
                        size: 50,
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        "Cash In Hand",
                        style: AppTheme.tabtext,
                      ),
                    ]),
                  ))
              : Container(),
          choice == 2
              ? Card(
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/logo_dark.png",
                        fit: BoxFit.fitWidth,
                      ),
                      Text("Cash On hand"),
                    ],
                  ),
                )
              : Container(),
          choice == 3
              ? Row(
                  children: [
                    Image.asset(
                      "assets/images/khalti.jpg",
                      fit: BoxFit.cover,
                    ),
                    Card(
                      child: Text("Cash On hand"),
                    ),
                  ],
                )
              : Container()
        ],
      ),
    );
  }

  priceSection() {
    final user = Provider.of<UserProvider>(context);

    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              border: Border.all(color: Colors.grey.shade200)),
          padding: EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Total",
                    style: AppTheme.title,
                  ),
                  Text(
                    user.userModel.totalCartPrice.toString(),
                    style: AppTheme.subtitle,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  /*String getFormattedCurrency(double amount) {
    FlutterMoneyFormatter fmf = new FlutterMoneyFormatter(amount: amount);
    fmf.symbol = "₹";
    fmf.thousandSeparator = ",";
    fmf.decimalSeparator = ".";
    fmf.spaceBetweenSymbolAndNumber = true;
    return fmf.formattedLeftSymbol;
  }
*/
}
