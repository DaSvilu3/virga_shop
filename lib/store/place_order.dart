import 'package:flutter/material.dart';
import 'package:virga_shop/models/user_address.dart';
import 'package:virga_shop/network/api.dart';
import 'package:virga_shop/store/add_address.dart';
import 'package:virga_shop/store/cart/cart_provider.dart';
import 'package:virga_shop/store/place_order/place_order_bloc.dart';
import 'package:virga_shop/store/place_order/place_order_provider.dart';
import 'dart:io';
import 'package:virga_shop/globals.dart' as Globals;

class PlaceOrderScreen extends StatefulWidget {
  final File imageOrderFile;

  PlaceOrderScreen({this.imageOrderFile});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PlaceOrderScreenState();
  }
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return new PlaceOrderProvider(
      providerBloc: new PlaceOrderBloc(),
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("Place Order"),
        ),
        body: PlaceOrderBody(
          imageOrderFile: widget.imageOrderFile,
        ),
      ),
    );
  }
}

class PlaceOrderBody extends StatefulWidget {
  final File imageOrderFile;

  PlaceOrderBody({this.imageOrderFile});

  @override
  State<StatefulWidget> createState() {
    return _PlaceOrderBodyState();
  }
}

class _PlaceOrderBodyState extends State<PlaceOrderBody> {
  List<String> _checkedPaymentMethod = [Globals.PaymentModes.cashOnDelivery];

  _navigateToAddAddressScreen() async {
    await Navigator
        .of(context)
        .push(MaterialPageRoute(builder: (context) => AddAddressScreen()))
        .then((onValue) {
      PlaceOrderProvider.of(context).initAddresses();
      _chooseAddressDialog();
    });
  }

  _chooseAddressDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: new Text("Choose Shipping Address"),
            children: <Widget>[
              StreamBuilder<List<UserAddress>>(
                  stream: PlaceOrderProvider.of(this.context).addresses,
                  builder:
                      (context, AsyncSnapshot<List<UserAddress>> snapshot) {
                    if (snapshot.data != null && snapshot.data.length > 0) {
                      return Column(
                        children: <Widget>[
                          new Column(
                              children: snapshot.data
                                  .map((address) => Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.90,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        decoration: new BoxDecoration(
                                            border: BorderDirectional(
                                                bottom: BorderSide(
                                                    color: Colors.grey.shade400,
                                                    width: 1.0))),
                                        child: new ListTile(
                                          isThreeLine: true,
                                          onTap: () {
                                            //on selection change to this address
                                            PlaceOrderProvider
                                                .of(this.context)
                                                .addressChangeHandler(address);
                                            Navigator.of(context).pop();
                                          },
                                          title: Text(address.fullname),
                                          subtitle: new Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(address.addressLine1),
                                              Text(address.city),
                                              Text(address.pincode),
                                              Text(
                                                  "Phone: ${address.phoneNumber ?? ""} \nLandmark: ${address.landmark ?? "None"}"),
                                            ],
                                          ),
                                        ),
                                      ))
                                  .toList()),
                          new Divider(
                            height: 2.0,
                          ),
                          new MaterialButton(
                            color: Colors.white,
                            child: new Text("Add new address"),
                            onPressed: () {
                              Navigator.of(context).pop();
                              _navigateToAddAddressScreen();
                            },
                          )
                        ],
                      );
                    }

                    //if there are no address in users
                    return new Column(
                      children: <Widget>[
                        new Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: <Widget>[
                              new Icon(Icons.error_outline, size: 100.0),
                              new Text(
                                  "There are no address in your profile currently"),
                              new MaterialButton(
                                padding: EdgeInsets.all(10.0),
                                color: Colors.white,
                                child: new Text("Add new address"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _navigateToAddAddressScreen();
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  })
            ],
          );
        });
  }

  Widget _addressesSelection() {
    return StreamBuilder<UserAddress>(
        stream: PlaceOrderProvider.of(context).selectedAddress,
        builder: (context, AsyncSnapshot<UserAddress> snapshot) {
          if (snapshot.hasData) {
            return new MaterialButton(
              padding: new EdgeInsets.all(20.0),
              color: Colors.blue.shade100,
              minWidth: MediaQuery.of(context).size.width,
              onPressed: () {
                _chooseAddressDialog();
              },
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(snapshot.data.fullname),
                  Text(snapshot.data.addressLine1),
                  Text(snapshot.data.city),
                  Text(snapshot.data.pincode)
                ],
              ),
            );
          }
          return new MaterialButton(
            color: Colors.white70,
            height: MediaQuery.of(context).size.height * 0.30,
            child: new Text("No address select, please select a address"),
            onPressed: () {
              _chooseAddressDialog();
            },
          );
        });
  }

  Widget _paymentModeSelection() {
    return new Column(
      children: <Widget>[
        Padding(
          child: new Divider(),
          padding: new EdgeInsets.symmetric(vertical: 20.0),
        ),
        Padding(
          padding: new EdgeInsets.all(5.0),
          child: Text("Payment Mode"),
        ),
        CheckboxListTile(
          title: new Text("Cash-on-Delivery"),
          value: _checkedPaymentMethod
              .contains(Globals.PaymentModes.cashOnDelivery),
          onChanged: (checked) {
            if (checked) {
              setState(() {
                _checkedPaymentMethod.clear();
                _checkedPaymentMethod.add(Globals.PaymentModes.cashOnDelivery);
              });
            }
          },
        ),
        CheckboxListTile(
          title: new Text("Pick-up from Mart"),
          value:
              _checkedPaymentMethod.contains(Globals.PaymentModes.pickBySelf),
          onChanged: (checked) {
            if (checked) {
              setState(() {
                _checkedPaymentMethod.clear();
                _checkedPaymentMethod.add(Globals.PaymentModes.pickBySelf);
              });
            }
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        Expanded(
            child: ListView(
          children: <Widget>[
            Container(
              padding: new EdgeInsets.all(20.0),
              child: new Text(
                "Select shipping address:",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            _addressesSelection(),
            _paymentModeSelection()
          ],
        )),
        Container(
          padding: new EdgeInsets.fromLTRB(.0, .0, .0, .0),
          width: MediaQuery.of(context).size.width,
          child: new RaisedButton(
            elevation: 40.0,
            color: Colors.grey.shade300,
            padding: new EdgeInsets.all(15.0),
            child: Text(
              "Place Order",
              style: TextStyle(color: Colors.blue),
            ),
            onPressed: () async {
              UserAddress selectedAddress =
                  PlaceOrderProvider.of(context).getSelectedAddress();

              if (widget.imageOrderFile != null) {
                print("Place picture order");
                Scaffold.of(context).showSnackBar(new SnackBar(
                      content: new Text("Placing order..."),
                    ));

                API.postPictureOrder(widget.imageOrderFile,
                    _checkedPaymentMethod.first, selectedAddress)
                    .then((response){
                     
                    });
              } else {
                await CartProvider
                    .of(context)
                    .placeOrder(_checkedPaymentMethod.first, selectedAddress)
                    .then((success){
                      if(success){
                        Scaffold.of(context).showSnackBar(new SnackBar(
                          content: Text("Successfully placed order."),
                        ));
                        CartProvider.of(context).clearCart();
                      }
                    });
              }
            },
          ),
        )
      ],
    );
  }
}
