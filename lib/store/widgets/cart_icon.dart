import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CartIcon extends StatefulWidget {
  final int count;
  final VoidCallback onPressed;
  CartIcon({@required this.count, @required this.onPressed});

  @override
  State<StatefulWidget> createState() {
    return _CartIconState();
  }
}

class _CartIconState extends State<CartIcon> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        widget.onPressed();
      },
      icon: Stack(overflow: Overflow.visible, children: [
        Icon(FontAwesomeIcons.shoppingCart),
        Positioned(
            top: -10.0,
            right: -5.0,
            child: Material(
                type: MaterialType.circle,
                elevation: 2.0,
                color: Colors.white,
                child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(widget.count.toString()))))
      ]),
    );
  }
}
