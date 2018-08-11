import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:virga_shop/models/cart_item.dart';
import 'package:virga_shop/network/api.dart';
import 'package:virga_shop/store/cart/cart_bloc.dart';
import 'package:virga_shop/store/cart/cart_provider.dart';
import '../globals.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Product extends StatefulWidget {
  final String productID;

  Product({this.productID});

  @override
  State<StatefulWidget> createState() {
    return _ProductState();
  }
}

class _ProductState extends State<Product> {

  final _totalAmountStream = new BehaviorSubject<double>(seedValue: null);

  final _quantityTEC = new TextEditingController();

  GlobalKey<FormState> _form = new GlobalKey();

  List<String> checked = new List();

  bool isDescriptionExpanded = false;

  String title = "";

  String imageUrl;

  String description;

  String quantityType;

  String productQuantityUnit;

  Map<String, dynamic> product;

  ///maximum quantity user can choose
  double maximum;

  ///minimum quantity user has to choose
  double minimum;

  //same old counter to keep it fresh
  int _count = 0;

  CartBloc cartBloc;

  ///calulated total amount for the product size
  double totalAmount = 0.0;


  /// Load the product info from the api
  /// returns a [http.Response] object containing
  /// [json] data
  Future<http.Response> _getProduct(String productID) async {
    return API.getProduct(productID);
  }

  @override
  void initState() {
    super.initState();
    _quantityTEC.addListener(handleQuantityChange);
  }

  @override
  void dispose(){
    _quantityTEC.dispose();
    _totalAmountStream.close();
    super.dispose();
  }

  void handleQuantityChange(){

    if(quantityType.isNotEmpty){

      if(this.quantityType == QuantityTypes.pieceQuantity){
        totalAmount = double.tryParse(_quantityTEC.text.trim()) * double.tryParse(product["quantity"]["price_per_unit"].toString());
        _totalAmountStream.add(totalAmount);
      }

      if(this.quantityType == QuantityTypes.looseQuantity){
        totalAmount = double.tryParse(_quantityTEC.text.trim()) * double.tryParse(product["quantity"]["values"][0]["price"].toString());
        _totalAmountStream.add(totalAmount);
      }

      if(this.quantityType == QuantityTypes.customQuantity){    
        List<dynamic> quantities = product["quantity"]["quantities"];
        totalAmount =  double.tryParse(_quantityTEC.text.trim()) *  (quantities.firstWhere((item)=>item["name"] == checked[0]))["price"].toDouble();        
        _totalAmountStream.add(totalAmount);
      }

    }
  
    
  }


  //
  //
  // This return the form for piece quantity
  //
  Widget pieceQuantityForm() {
    return new Form(
      key: _form,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: new MaterialButton(
              color: Colors.white,
              child: Text(
                "-",
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed: () {
                _quantityTEC.text =
                    ((int.tryParse(_quantityTEC.text.trim()) ?? 0) - 1)
                        .toString();
              },
            ),
          ),
          new Container(
            padding: EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width * 0.3,
            child: TextFormField(
              controller: _quantityTEC,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(hintText: "Quantity"),
              validator: (value) {
                if (value.isEmpty) {
                  return "Cannot be empty";
                }
                if (double.tryParse(value.trim().replaceAll(" ", '')) < 1) {
                  return "Cannot be less than 0";
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: new MaterialButton(
              color: Colors.white,
              child: Text("+"),
              onPressed: () {
                _quantityTEC.text =
                    ((int.tryParse(_quantityTEC.text.trim()) ?? 0) + 1)
                        .toString();
                
              },
            ),
          ),
        ],
      ),
    );
  }

  //
  //
  /// This return the form for piece quantity
  //
  Widget looseQuantityForm({String unitName = "Kg"}) {
    return new Form(
      key: _form,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width * 0.5,
            child: TextFormField(
              textAlign: TextAlign.center,
              controller: _quantityTEC,
              keyboardType: TextInputType.number,
              decoration:
                  InputDecoration(hintText: "Quantity", suffixText: unitName),
              validator: (value) {
                if (value.isEmpty) {
                  return "Quantity cannot be empty";
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget customQuantityForm() {
    List<dynamic> quantity = product["quantity"]["quantities"];

    return new Column(
      children: <Widget>[
        new Column(
          children: quantity
              .map((item) => new CheckboxListTile(
                    value: _count++ == 0
                        ? !checked.contains(item["name"])
                        : checked.contains(item["name"]),
                    title: new Text(item["name"]),
                    onChanged: (ticked) {
                      if (ticked) {
                        setState(() {
                          checked.clear();
                          checked.add(item["name"]);
                        });
                      } else {
                        setState(() {
                          if (checked.length > 1) checked.remove(item["name"]);
                        });                        
                      }
                      handleQuantityChange();
                    },
                  ))
              .toList(),
        ),
        pieceQuantityForm()
      ],
    );
  }

  //this widget loads the quantity form depending upon the quantity chosen.
  Widget quantityForm() {
    if (quantityType.isNotEmpty && quantityType != null) {
      if (quantityType == QuantityTypes.pieceQuantity) {
       this._quantityTEC.text =
            double.tryParse(minimum.toString()).toInt().toString();
        
        return pieceQuantityForm();
      } else if (quantityType == QuantityTypes.looseQuantity) {
        this._quantityTEC.text = double.tryParse(minimum.toString()).toString();
        productQuantityUnit = product["quantity"]["unit_name"];
        return looseQuantityForm();
      } else if (quantityType == QuantityTypes.customQuantity) {
        this._quantityTEC.text =
            double.tryParse(minimum.toString()).toInt().toString();
        return customQuantityForm();
      }
    }

    return new Center(
      child: new Text("Not available"),
    );
  }

  //this is the complete page shown after loading, the body and info of the product
  Widget productPageBody() {
    return new SafeArea(
      child: new CustomScrollView(
        slivers: <Widget>[
          //////////////////////
          ///
          ///  App bar is to display quick and search probably
          ///
          //////////////////////

          new SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            primary: true,
            title: new Text(title),
            flexibleSpace: new FlexibleSpaceBar(
                background: new CachedNetworkImage(
              imageUrl: imageUrl,
            )),
          ),

          /////////////
          /////
          ////////
          //////////  Everything else is held in here as list of widgets
          ///........
          ///

          new SliverList(
              delegate: SliverChildListDelegate(<Widget>[
            //////////
            ///
            ///   Container to hold the title of the product page
            ///
            ///////
            new Container(
              child: Text(
                title,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              padding: new EdgeInsets.all(20.0),
            ),

            //
            //
            //container to hold the quanitity buttons
            //
            //
            quantityForm(),

            ////////////
            ///
            ///   Container to hold total amount and add to cart button
            ///
            ////////////
            new Container(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ///
                  /// This one displays the total amount
                  ///
                  new StreamBuilder<double>(
                    stream: _totalAmountStream,
                    builder: (context,snapshot){

                      if(snapshot.hasData){
                         return new Text("₹ : "+snapshot.data.toString());
                      }

                      return new Text("₹ : 0.0");
                    },
                  ),

                  ///
                  /// This one is the add to cart button
                  ///
                  new RaisedButton(
                    child: Text("Add to Cart"),
                    onPressed: () {
                      _clickAddToCart();
                    },
                  )
                ],
              ),
              padding: new EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
              margin: new EdgeInsets.fromLTRB(0.0, 10.0, .0, 10.0),
              decoration: new BoxDecoration(
                color: Colors.black12,
              ),
            ),

            /////////////
            ///
            /// Container to hold product description
            ///
            //////////
            new Container(
              child: new ExpansionPanelList(
                expansionCallback: (context, index) {
                  setState(() {
                    isDescriptionExpanded = !isDescriptionExpanded;
                  });
                },
                children: <ExpansionPanel>[
                  new ExpansionPanel(
                      headerBuilder: (context, index) {
                        return new Container(
                            padding:
                                new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                            child: new Row(
                              children: <Widget>[
                                new Text(
                                  "Description",
                                  style: new TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ));
                      },
                      body: new Container(
                        child: new Text(description),
                        padding: new EdgeInsets.all(100.0),
                      ),
                      isExpanded: isDescriptionExpanded),
                ],
              ),
            )
          ])),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //scaffold to display body of the product page

    cartBloc = CartProvider.of(context);

    return new Scaffold(
        body: new FutureBuilder<http.Response>(
      future: _getProduct(widget.productID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          dynamic response;
          try {
            response = json.decode(snapshot.data.body);

            title = response["name"];

            imageUrl = response["image_url"];
            description = response["description"];
            quantityType = response["quantity"]["type"];
            minimum =
                double.tryParse(response["quantity"]["minimum"].toString());
            maximum =
                double.tryParse(response["quantity"]["maximum"].toString());

            product = response;

            return productPageBody();
          } catch (exception) {
            print(exception);
            return new Center(
              child: CircularProgressIndicator(),
            );
          }
        }

        return SafeArea(child: new LinearProgressIndicator());
      },
    ));
  }

  void _clickAddToCart() {
    if (_form.currentState.validate()) {
      if (quantityType == QuantityTypes.customQuantity) {
        CartItem cartItem = new CartItem(
          product,
          quantityType,
          customQuantityName: checked[0],
          customQuantityUnits:
              double.tryParse(_quantityTEC.text.toString().trim()),
              price: totalAmount
        );

        cartBloc.cartAddition.add(cartItem);
      }
      if (quantityType == QuantityTypes.pieceQuantity) {
        CartItem cartItem = new CartItem(product, quantityType,
            pieceQuantity:
                double.tryParse(_quantityTEC.text.toString().trim()),
                price: totalAmount);

        cartBloc.cartAddition.add(cartItem);
      }
      if (quantityType == QuantityTypes.looseQuantity) {
        CartItem cartItem = new CartItem(product, quantityType,
            looseQuantity:
                double.tryParse(_quantityTEC.text.toString().trim()),
            looseQuantityUnitName: product["quantity"]["unit_name"],
                price: totalAmount);                        
        cartBloc.cartAddition.add(cartItem);
      }
    }
  }
}
