import 'dart:async';

import 'package:flutter/material.dart';
import 'package:virga_shop/models/user_address.dart';
import 'package:virga_shop/network/api.dart';
import 'package:http/http.dart' as http;

class AddAddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: new Text("Add Address")),
      body: AddAddressBody(),
    );
  }
}

class AddAddressBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddAddressBodyState();
  }
}

class _AddAddressBodyState extends State<AddAddressBody> {
  GlobalKey<FormState> _form = GlobalKey();

  final _fullnameTEC = TextEditingController();
  final _addressTEC = TextEditingController();
  final _cityTEC = TextEditingController();
  final _pincodeTEC = TextEditingController();
  final _landmarkTEC = TextEditingController();
  final _phoneTEC = TextEditingController();

  Future<http.Response> _saveAddress(UserAddress address) async {
    return await API.postAddress(address);
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        new Padding(
          padding: new EdgeInsets.all(20.0),
          child: Text("Add new address to your profile.",
              style: Theme.of(context).textTheme.body1),
        ),
        Form(
          key: _form,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _fullnameTEC,
                  decoration: InputDecoration(
                      hintText: "Fullname",
                      fillColor: Colors.white,
                      filled: true),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Fullname cannot be empty";
                    }
                  },
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _addressTEC,
                    maxLines: 4,
                    decoration: InputDecoration(
                        hintText: "Address",
                        fillColor: Colors.white,
                        filled: true),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Address cannot be empty";
                      }
                    },
                  )),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _phoneTEC,
                    decoration: InputDecoration(
                        hintText: "Phone number",
                        fillColor: Colors.white,
                        filled: true),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Phone number cannot be empty";
                      }
                    },
                  )),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _cityTEC,
                    decoration: InputDecoration(
                        hintText: "City",
                        fillColor: Colors.white,
                        filled: true),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "City cannot be empty";
                      }
                    },
                  )),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _pincodeTEC,
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: false, signed: false),
                    decoration: InputDecoration(
                        hintText: "Pincode",
                        fillColor: Colors.white,
                        filled: true),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Pincode cannot be empty";
                      }
                    },
                  )),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _landmarkTEC,
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: false, signed: false),
                    decoration: InputDecoration(
                        hintText: "Landmark  ex: Near Govt Hospital",
                        fillColor: Colors.white,
                        filled: true),
                    validator: (value) {},
                  )),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: RaisedButton(
                    elevation: 10.0,
                    color: Colors.blueAccent.shade400,
                    child: new Text(
                      "Save Address",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (_form.currentState.validate()) {
                        //show a snack bar saying, we are posting address
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content:
                                new Text("Saving new address, please wait.")));
                        var address = new UserAddress();
                        address.fullname = _fullnameTEC.text.trim();
                        address.addressLine1 = _addressTEC.text.trim();
                        address.city = _cityTEC.text.trim();
                        address.landmark = _landmarkTEC.text.trim();
                        address.pincode = _pincodeTEC.text.trim();
                        address.phoneNumber = _phoneTEC.text.trim();
                        _saveAddress(address).then((response) {
                          if (response.statusCode == 200) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                                content: new Text("Saved new address.")));
                          }
                        });
                      }
                    },
                  )),
            ],
          ),
        )
      ],
    );
  }
}
