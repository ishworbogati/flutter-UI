import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodorderingsys/helpers/AppTheme.dart';
import 'package:foodorderingsys/models/cart_item.dart';
import 'package:foodorderingsys/providers/user.dart';
import 'package:foodorderingsys/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class CartCard extends StatefulWidget {
  const CartCard({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final CartItemModel cart;

  @override
  _CartCardState createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 88,
              child: AspectRatio(
                aspectRatio: 0.88,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F6F9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: widget.cart.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.cart.name.toString().toUpperCase(),
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      maxLines: 2,
                    ),
                    SizedBox(height: 10),
                    Text.rich(
                      TextSpan(
                        text: "\$${widget.cart.price}",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.flatPurple),
                        children: [
                          TextSpan(
                              text: " x${widget.cart.quantity}",
                              style: Theme.of(context).textTheme.bodyText1),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: IconButton(
                        icon: Icon(
                          Icons.remove,
                          size: 15,
                        ),
                        onPressed: () async {
                          final user = Provider.of<UserProvider>(context);
                        })),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CustomText(
                    text: "${widget.cart.quantity}",
                    color: AppTheme.dark_grey,
                    size: 15,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: IconButton(
                      icon: Icon(
                        Icons.add,
                        size: 15,
                        color: AppTheme.dark_grey,
                      ),
                      onPressed: () {
                        /*  setState(() {
                          quantity += 1;
                        });*/
                      }),
                ),
              ],
            ),
            Spacer(),
            Row(
              children: [
                Column(
                  children: [
                    Container(
                      child: Center(
                        child: Text.rich(
                          TextSpan(
                              text:
                                  "\$${widget.cart.price * widget.cart.quantity}",
                              style: AppTheme.title),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
