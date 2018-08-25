import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:virga_shop/globals.dart';
import 'package:virga_shop/models/cart_item.dart';
import 'package:virga_shop/store/place_order.dart';
import './widgets/drawer.dart';
import 'package:virga_shop/store/cart/cart_bloc.dart';
import 'package:virga_shop/store/cart/cart_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Cart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _CartState();
  }
}

class _CartState extends State<Cart> {
  final _scaffold = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffold,
      drawer: SideDrawer(),
      body: CustomScrollView(
        slivers: <Widget>[
          new SliverAppBar(
            elevation: 20.0,
            title: new Text("Shopping Cart"),
            snap: true,
            floating: true,
            pinned: true,
            bottom: new PreferredSize(
                preferredSize: Size.fromHeight(80.0),
                child: new Container(
                  child: new Column(
                    children: <Widget>[
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new StreamBuilder<double>(
                            stream: CartProvider.of(context).totalAmount,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return new Text(
                                  "Total: " + snapshot.data.toString(),
                                  style: new TextStyle(
                                      color: Colors.deepOrange,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 25.0),
                                );
                              }
                              return new Text(
                                "Total: ",
                                style: new TextStyle(
                                    color: Colors.deepOrange,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 25.0),
                              );
                            },
                          ),
                          new RaisedButton(
                            child: new Text(
                              "Checkout",
                            ),
                            onPressed: () {
                              if(CartProvider.of(context).count < 1){
                                _scaffold.currentState.showSnackBar(new SnackBar(content: new Text("No items in the cart."),));
                              }
                              else{
                                 Navigator.push(context, MaterialPageRoute(builder: (context)=>PlaceOrderScreen()));
                              }                             
                            },
                          )
                        ],
                      )
                    ],
                  ),
                  padding: new EdgeInsets.all(20.0),
                )),
            actions: <Widget>[
              new IconButton(
                onPressed: () {},
                icon: new Icon(Icons.check),
                tooltip: "Checkout",
              )
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              new Container(
                child: cartItems(),
              )
            ]),
          )
        ],
      ),
    );
  }

  Widget cartItems() {
    CartBloc cartBloc = CartProvider.of(context);

    return StreamBuilder<List<CartItem>>(
      stream: cartBloc.items,
      builder: (context, snapshot) {
        if (snapshot.data == null || snapshot.data.isEmpty) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: new Column(
              children: <Widget>[
                new Icon(
                  FontAwesomeIcons.cartArrowDown,
                  size: 50.0,
                ),
                Center(
                    child: Text('Your cart is empty.',
                        style: Theme.of(context).textTheme.display1))
              ],
            ),
          );
        }

        return Column(
            children: snapshot.data.map((item) => cartItem(item)).toList());
      },
    );
  }

  Widget cartItem(CartItem item) {
    if (item.quantityType == QuantityTypes.customQuantity) {
      return new Card(
        child: customQuantityItem(item),
      );
    }

    return new Card(
      child: quantityItem(item),
    );
  }

  Widget quantityItem(CartItem item) {
    return new Container(
      height: MediaQuery.of(context).size.height * 0.14,
      child: new Row(
        children: <Widget>[
          new SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: new CachedNetworkImage(
              imageUrl: item.product["imageUrl"],
            ),
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text(
                  item.product["name"],
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text(
                  item.quantityType == QuantityTypes.looseQuantity
                      ? (item.looseQuantity.toString() +
                          ' ' +
                          (item.looseQuantityUnitName ?? ''))
                      : item.pieceQuantity.toInt().toString(),
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text(
                  "₹ : " + item.amount.toString(),
                  style: TextStyle(fontSize: 12.0),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget customQuantityItem(CartItem item) {
    return new Container(
      height: MediaQuery.of(context).size.height * 0.14,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: new CachedNetworkImage(
              imageUrl: item.product["imageUrl"],
            ),
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text(
                  item.product["name"],
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text(
                  item.customQuantity.toInt().toString() +
                      ' - ' +
                      item.customQuantityName,
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text(
                  "₹ : " + item.amount.toString(),
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
