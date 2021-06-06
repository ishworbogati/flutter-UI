import 'package:flutter/material.dart';
import 'package:foodorderingsys/Cart/cartCard.dart';
import 'package:foodorderingsys/helpers/AppTheme.dart';
import 'package:foodorderingsys/providers/user.dart';
import 'package:foodorderingsys/screens/popular_dishes.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    var dcharge;
    final user = Provider.of<UserProvider>(context);
    user.userModel.totalCartPrice < 150 ? dcharge = 20 : dcharge = 10;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: MediaQuery.of(context).size.height / 1.8,
              child: ListView.builder(
                itemCount: user.userModel.cart.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Dismissible(
                    key: Key(user.userModel.cart[index].id.toString()),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) async {
                      bool value = await user.removeFromCart(
                          cartItem: user.userModel.cart[index]);
                      if (value) {
                        user.reloadUserModel();
                        showToast(context, "Removed",
                            user.userModel.cart[index].name, true);
                        return;
                      } else {
                        print("ITEM WAS NOT REMOVED");
                      }
                      //  demoCarts.removeAt(index);
                    },
                    background: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: AppTheme.darkText.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [Spacer(), Icon(Icons.delete)],
                      ),
                    ),
                    child: CartCard(cart: user.userModel.cart[index]),
                  ),
                ),
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.all(10),
            elevation: 2,
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 15,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Container(child: Text("Sub-Total:")),
                      Spacer(),
                      Text("\$ " +
                          "${user.userModel.totalCartPrice.toString()}"),
                      IconButton(
                        icon: Icon(
                          Icons.info_outline,
                          size: 15,
                          color: Colors.teal,
                        ),
                        tooltip: "Total",
                      )
                    ],
                  ),
                  Row(children: [
                    Container(child: Text("Discount:")),
                    Spacer(),
                    Text(user.userModel.totaldis.toString() + "%"),
                    IconButton(
                      icon: Icon(
                        Icons.info_outline,
                        size: 15,
                        color: Colors.teal,
                      ),
                      tooltip: "Total",
                    )
                  ]),
                  Row(
                    children: [
                      Container(child: Text("Delivery Charge:")),
                      Spacer(),
                      Text("\$ " + dcharge.toString()),
                      IconButton(
                        icon: Icon(
                          Icons.info_outline,
                          size: 15,
                          color: Colors.teal,
                        ),
                        tooltip: "Total",
                      )
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: 0.5,
                    margin: EdgeInsets.symmetric(vertical: 4),
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(child: Text("Total:")),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 45.0),
                          child: Text(
                            "\$ " +
                                (user.userModel.totalCartPrice + dcharge)
                                    .toString(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
