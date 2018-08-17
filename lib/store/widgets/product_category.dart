import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/zoomable_widget.dart';
import 'package:virga_shop/store/cart/cart_bloc.dart';
import 'package:virga_shop/store/cart/cart_provider.dart';
import 'package:virga_shop/store/category.dart';
import 'dart:async';
import '../product.dart';
import '../../globals.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:virga_shop/models/cart_item.dart';

class ProductCategory extends StatefulWidget {
  final String _categoryName;
  final String _categoryID;
  final Color color;
  final List<dynamic> products;

  ProductCategory(this._categoryName, this._categoryID,
      {this.color, this.products});

  @override
  State<StatefulWidget> createState() => new _ProductCategory();
}

class _ProductCategory extends State<ProductCategory> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      child: new Column(
        children: <Widget>[
          //this is holder for placing the title of the category

          //container to fold the list of images scrolled horizontally
          new Container(
            padding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
            height: (MediaQuery.of(context).size.width / 5) + 50,
            color: widget.color == null ? Colors.black87 : widget.color,
            child: new ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return GestureDetector(
                    child: new Card(
                        margin: new EdgeInsets.all(10.0),
                        child: new SizedBox(
                          child: new Center(
                            child: new Text(
                              "+ More \n" + widget._categoryName,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          width: MediaQuery.of(context).size.width / 5,
                          height: MediaQuery.of(context).size.width / 5,
                        )),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              new CategoryPage(widget._categoryID)));
                    },
                  );
                }
                if (index <= widget.products.length)
                  return new GestureDetector(
                    child: new Card(
                        margin: new EdgeInsets.all(10.0),
                        child: new SizedBox(
                          child: new CachedNetworkImage(
                            imageUrl: widget.products[index - 1]["image_url"],
                            fit: BoxFit.fill,
                          ),
                          width: MediaQuery.of(context).size.width / 5,
                          height: MediaQuery.of(context).size.width / 5,
                        )),
                    onTap: () {
                      _productDetails(widget.products[index - 1]);
                    },
                  );
              },
            ),
          ),
        ],
      ),
    );
  }

  /////////////////////////////////////////////
  ///
  ///   Products Details dialog shown after
  ///   touching those tiny icons
  ///   this show image of the product
  ///   name of the product
  ///   and price. also you be able to
  ///   browse more about the product by
  ///   redirecting to next product page
  ///   and add to cart option is available too
  ///
  /// //////////////////////////////////////////

  Future<Null> _productDetails(dynamic product) async {
    await showDialog<int>(
        context: this.context,
        builder: (BuildContext context) {
          dynamic width = MediaQuery.of(context).size.width / 100.0 * 50;

          return new SimpleDialog(
            ///
            ////
            ///   Title of the dialog to be shown
            ////
            title: new Text(product["name"]),

            //
            // Childerens in the dialog, those image of product, buttons
            //quanity selectio etc.
            //
            //
            children: <Widget>[
              new Container(
                child: new ZoomableWidget(
                  minScale: 0.5,
                  maxScale: 2.0,
                  child: new CachedNetworkImage(imageUrl: product["image_url"]),
                ),
                height: MediaQuery.of(context).size.height * 0.20,
                width: MediaQuery.of(context).size.width * 0.9,
              ),
              new Container(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    /////
                    ///
                    /// Row of buttons,
                    ///
                    /// either cancel or see more about product
                    ///
                    //////
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new OutlineButton(
                            borderSide: BorderSide(color: Colors.red),
                            child: new Text(
                              "Cancel",
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          new OutlineButton(
                            borderSide: BorderSide(color: Colors.green),
                            child: new Text(
                              "More",
                              style: TextStyle(color: Colors.green),
                            ),
                            onPressed: () {
                              //first close the dialog
                              Navigator.pop(context);

                              //then show the product page
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Product(
                                            productID: product["id"],
                                          )));
                            },
                          ),
                        ],
                      ),
                    ),

                    QuantityPrompt(product, this.context),
                  ],
                ),
                width: width,
              )
            ],
          );
        });
  }
}

///
///  Defining a type of void function to add a callback function
///
///
typedef void AddToCart(
    {double looseQuantity,
    String looseQuantityUnitName,
    double pieceQuantity,
    String customQuantityName,
    double customQuantityUnit,
    double amount});

///
/// What is quantityPrompt?
/// this is widget that is embedded into the dialogue asking the user to enter
/// the quantity of the product they wish to add to cart
///
/// it mainly has three types
///
///
/// 1) Custom Quanity,
///
/// 2) Loose Quanity,
///
/// 3) Piece Quantity
///
///
class QuantityPrompt extends StatefulWidget {
  final Map<String, dynamic> product;
  final BuildContext context;

  QuantityPrompt(this.product, this.context);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _QuantityPromptState();
  }
}

class _QuantityPromptState extends State<QuantityPrompt> {
  int val = 1;

  CartBloc cartBloc;

  void addToCart(
      {double looseQuantity,
      String looseQuantityUnitName,
      double pieceQuantity,
      String customQuantityName,
      double customQuantityUnit,
      double amount}) {
    CartItem item;
    String quantityType = widget.product["quantity"]["type"];

    if (quantityType == QuantityTypes.looseQuantity) {
      item = new CartItem(widget.product, quantityType,
          looseQuantity: looseQuantity,
          looseQuantityUnitName: looseQuantityUnitName);
    }
    if (quantityType == QuantityTypes.customQuantity) {
      item = new CartItem(widget.product, quantityType,
          customQuantityName: customQuantityName,
          customQuantity: customQuantityUnit);
    }
    if (quantityType == QuantityTypes.pieceQuantity) {
      item = new CartItem(widget.product, quantityType,
          pieceQuantity: pieceQuantity);
    }

    item.amount = amount;

    cartBloc.cartAddition.add(item);

    //close dialog after adding to cart
    Navigator.pop(context);
    Scaffold
        .of(widget.context)
        .showSnackBar(new SnackBar(content: new Text("Added to cart")));
  }

  @override
  Widget build(BuildContext context) {
    // we use product quantity type to decide which type of quantityPrompt to display
    dynamic productQuantityType = widget.product["quantity"]["type"];

    //CartBloc to enable addToCart function
    cartBloc = CartProvider.of(context);

    if (productQuantityType == QuantityTypes.customQuantity) {
      //
      // if the product is of custom quantity type
      //
      return new CustomQuantityPrompt(widget.product, this.addToCart);
    } else if (productQuantityType == QuantityTypes.looseQuantity) {
      //
      //  if the product is of loosequantity type
      //
      return new LooseQuantity(widget.product, this.addToCart);
    } else if (productQuantityType == QuantityTypes.pieceQuantity) {
      //
      //  if the product is of PieceQuantity type
      //
      return new PieceQuantity(widget.product, this.addToCart);
    }

    return new Column(
      children: <Widget>[
        new ListTile(
          title: new Text("data"),
        )
      ],
    );
  }
}

///   This is Custom quantity widget.
///

class CustomQuantityPrompt extends StatefulWidget {
  final dynamic product;
  final double minimum;
  final double maximum;
  final AddToCart addToCart;
  CustomQuantityPrompt(this.product, this.addToCart)
      : minimum =
            double.tryParse(product["quantity"]["minimum"].toString()) ?? 0.0,
        maximum =
            double.tryParse(product["quantity"]["maximum"].toString()) ?? 100;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _CustomQuantityPromptState();
  }
}

//
//  This is the state of the CustomQuantityPrompt
//
class _CustomQuantityPromptState extends State<CustomQuantityPrompt> {
  TextEditingController _quantityTEC = new TextEditingController();

  GlobalKey<FormState> _form = new GlobalKey();

  List<String> checked = new List();

  double _totalAmount = 0.0;

  int count = -1;

  @override
  void initState() {
    super.initState();
    _quantityTEC.text = widget.minimum.toInt().toString();
    _quantityTEC.addListener(_updatedQuantity);
    _totalAmount = double.tryParse(
        widget.product["quantity"]["quantities"][0]["price"].toString());
  }

  void _updatedQuantity() {
    if (_quantityTEC.text.isNotEmpty &&
        double.parse(_quantityTEC.text.trim().replaceAll(" ", '')) != null) {
      List<dynamic> quantities = widget.product["quantity"]["quantities"];

      int index = (quantities.indexWhere((b) => b["name"] == checked[0]));

      double amount = quantities[index]["price"] *
          double.tryParse(this._quantityTEC.text.trim().replaceAll(" ", ''));

      setState(() {
        _totalAmount = amount;
      });
    }
  }

  Widget _quantityRow(dynamic quantity) {
    //useful to select the first checkbox
    //very smart

    if (++count == 0) checked.add(quantity["name"]);

    return new CheckboxListTile(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(quantity["name"]),
              new Text(
                "₹ " + quantity["price"].toString(),
                style: new TextStyle(color: Colors.green),
              )
            ]),
        value: checked.contains(quantity["name"]),
        onChanged: (b) {
          setState(() {
            if (b) {
              checked.clear();
              checked.add(quantity["name"]);
            } else {
              if (checked.length > 1) checked.remove(quantity["name"]);
            }
          });

          this._updatedQuantity();
        });
  }

  Widget quantityForm() {
    return new Form(
      key: _form,
      child: new Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: new TextFormField(
              controller: this._quantityTEC,
              keyboardType: TextInputType.numberWithOptions(
                  decimal: false, signed: false),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "Quantity",
              ),
              validator: (v) {
                if (v.isEmpty) {
                  return "Quantity cannot be empty.";
                }
                if (v.contains(r'.')) {
                  return "Quantity can only be numbers";
                }
              },
            ),
          ),
          new Padding(
            padding: new EdgeInsets.all(5.0),
            child: new Text(
              "Payable ₹: $_totalAmount",
              style: TextStyle(fontSize: 16.0, color: Colors.red),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: new MaterialButton(
              color: Colors.indigoAccent,
              elevation: 10.0,
              child: new Text(
                "Add to cart",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                if (_form.currentState.validate()) {
                  //if quantity and choice is valid,
                  //enable to add to cart.
                  widget.addToCart(
                      customQuantityName: this.checked[0],
                      customQuantityUnit:
                          double.tryParse(_quantityTEC.text.trim()),
                      amount: _totalAmount);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> quantities = widget.product["quantity"]["quantities"];

    return Column(
      children: <Widget>[
        new Column(
            children: quantities.map((f) => this._quantityRow(f)).toList()),
        new Container(
          width: MediaQuery.of(context).size.width * 0.4,
          child: quantityForm(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    this._quantityTEC.dispose();
    super.dispose();
  }
}

///
///  This is Loose Quantity Widget
///
///

class LooseQuantity extends StatefulWidget {
  final dynamic product;
  final double minimum;
  final double maximum;
  final AddToCart addToCart;

  LooseQuantity(this.product, this.addToCart)
      : minimum = double.tryParse(product["quantity"]["minimum"].toString()),
        maximum = double.tryParse(product["quantity"]["maximum"].toString());

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LooseQuantityState();
  }
}

class _LooseQuantityState extends State<LooseQuantity> {
  final _formKey = GlobalKey<FormState>();
  final _quantityValueTEC = new TextEditingController();
  double _totalAmount = 0.0;

  void onQuantityChanged() {
    double pricePerUnit = double
        .parse(widget.product["quantity"]["values"][0]["price"].toString());
    if (this._quantityValueTEC.text.isNotEmpty) {
      setState(() {
        this._totalAmount = (pricePerUnit *
                double.tryParse(
                    _quantityValueTEC.text.trim().replaceAll(" ", '')) ??
            0);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _quantityValueTEC.addListener(this.onQuantityChanged);
    _quantityValueTEC.text = widget.minimum.toString();
  }

  @override
  void dispose() {
    _quantityValueTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minimum = widget.product["quantity"]["minimum"];
    final maximum = widget.product["quantity"]["maximum"];

    return new Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Text(
            "Quantity",
          ),
        ),
        new SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: new Form(
            key: _formKey,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                /////
                ////  This is where user will input quantity
                ///
                new Container(
                  margin: new EdgeInsets.all(10.0),
                  child: new TextFormField(
                    controller: _quantityValueTEC,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        suffixText: widget.product["quantity"]["unit_name"],
                        hintText: "Quantity"),
                    validator: (value) {
                      double parsedValue = double.tryParse(value);

                      if (value.length < 1) {
                        return "Please enter a quantity";
                      }

                      if (parsedValue == null) {
                        return "An invalid value given";
                      }

                      if (double.parse(value) > maximum) {
                        return "Quantity cannot be more than " +
                            maximum.toString();
                      }

                      if (minimum != null && double.parse(value) < minimum) {
                        return "Quantity cannot be less than " +
                            minimum.toString();
                      }
                    },
                  ),
                ),

                /**
                 * This shows the total amount that is to be charged to 
                 * the user based upon price and chosen quantity
                 */
                Container(
                  margin: new EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 20.0),
                  child: new Column(
                    children: <Widget>[
                      new Text(
                        "Total ₹: $_totalAmount",
                        style: TextStyle(fontSize: 20.0, color: Colors.red),
                      )
                    ],
                  ),
                ),

                //////
                ///
                /// This is add to cart button,
                ///
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  child: new MaterialButton(
                    color: Colors.indigoAccent,
                    elevation: 10.0,
                    child: const Text(
                      "Add to Cart",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        //iff loose quantity is set and is valid
                        //then add to cart

                        widget.addToCart(
                            looseQuantity:
                                double.tryParse(_quantityValueTEC.text.trim()),
                            amount: _totalAmount,
                            looseQuantityUnitName: widget.product["quantity"]
                                ["unit_name"]);
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

/////
///// This Piece Quantity Widget
/////
/////
///
class PieceQuantity extends StatefulWidget {
  final dynamic product;
  final double minimum;
  final double maximum;
  final double pricePerUnit;
  final AddToCart addToCart;

  PieceQuantity(this.product, this.addToCart)
      : maximum =
            double.tryParse((product["quantity"]["maximum"]).toString()) ?? 0,
        minimum =
            double.tryParse((product["quantity"]["minimum"]).toString()) ?? 199,
        pricePerUnit =
            double.tryParse(product["quantity"]["price_per_unit"].toString());

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PieceQuantityState();
  }
}

class _PieceQuantityState extends State<PieceQuantity> {
  final _quantityTEC = new TextEditingController();
  double _totalAmount = 0.0;
  GlobalKey<FormState> _form = new GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _quantityTEC.text = widget.minimum.toInt().toString();
    _quantityTEC.addListener(this._updatedQuantity);
    this._updatedQuantity();
  }

  @override
  void dispose() {
    _quantityTEC.dispose();
    super.dispose();
  }

  void _updatedQuantity() {
    this._totalAmount = widget.pricePerUnit;

    if (_quantityTEC.text.isNotEmpty) {
      if (double.tryParse(_quantityTEC.text.trim()) != null) {
        dynamic quantity =
            double.tryParse(_quantityTEC.text.trim()) * widget.pricePerUnit;
        setState(() {
          this._totalAmount = quantity;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: new Column(
      children: <Widget>[
        new Text("Number Of Items"),
        new Container(
          child: new Form(
            key: _form,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //// decrease button
                new MaterialButton(
                  child: new Text(
                    "-",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  elevation: 10.0,
                  onPressed: () {
                    this._quantityTEC.text =
                        this._quantityTEC.text.trim().replaceAll(" ", '');
                    if (this._quantityTEC.text.isNotEmpty)
                      this._quantityTEC.text =
                          (int.parse(_quantityTEC.text) - 1) >= widget.minimum
                              ? (int.parse(_quantityTEC.text) - 1).toString()
                              : this._quantityTEC.text;
                  },
                ),
                new Container(
                  margin: new EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 20.0),
                  child: new SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: new TextFormField(
                      controller: this._quantityTEC,
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: false, signed: false),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(hintText: "Quantity"),
                      validator: (value) {
                        //this is a validator for form field that takes
                        //the quantity
                        if (value.isEmpty) {
                          return "Please choose a quantity";
                        }
                        if (int.tryParse(value.trim()) == null) {
                          return "Invalid Value";
                        }
                      },
                    ),
                  ),
                ),
                new MaterialButton(
                  child: new Text(
                    "+",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  onPressed: () {
                    this._quantityTEC.text =
                        this._quantityTEC.text.trim().replaceAll(" ", '');
                    if (this._quantityTEC.text.isNotEmpty) {
                      this._quantityTEC.text =
                          (int.parse(_quantityTEC.text) + 1).toString();
                    } else if (this._quantityTEC.text.isEmpty) {
                      this._quantityTEC.text = 1.toString();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        new Container(
          margin: new EdgeInsets.all(10.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                "Total : ₹: $_totalAmount",
                style: TextStyle(fontSize: 18.0, color: Colors.red),
              )
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: new MaterialButton(
            color: Colors.indigoAccent,
            elevation: 10.0,
            child: Text(
              "Add to Cart",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              if (_form.currentState.validate()) {
                widget.addToCart(
                    pieceQuantity: double.tryParse(_quantityTEC.text.trim()),
                    amount: _totalAmount);
              }
            },
          ),
        )
      ],
    ));
  }
}
