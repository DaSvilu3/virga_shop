import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:virga_shop/network/api.dart';
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _passwordObscure = true;
  bool _confirmPasswordObscure = true;

  //input controllers to retrieve the values
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  ///function that returns input field text styles
  TextStyle _inputFontStyle() {
    return new TextStyle(color: Colors.black87, fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      key: _scaffoldKey,
      body: new SafeArea(
        child: new SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 10.0),
                child: new Center(
                  child: Text(
                    "Register",
                    style: new TextStyle(
                      fontSize: 24.0,
                      fontFamily: "Comfortaa",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              new Form(
                  key: _formKey,
                  child: new Container(
                    child: new Column(
                      children: <Widget>[
                        ///
                        ///
                        /// Mobile Number input : used as login for the user account
                        ///
                        ///
                        new Padding(
                          padding: new EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 10.0),
                          child: new TextFormField(
                            controller: _mobileController,
                            style: _inputFontStyle(),
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                hintText: "Mobile Number",
                                prefixText: "+91",
                                prefixIcon: Icon(FontAwesomeIcons.mobileAlt)),
                            validator: (value) {
                              if (value.trim().length < 10 || value.trim().length > 10) {
                                return "Invalid mobile number";
                              }
                            },
                          ),
                        ),

                        ///
                        ///
                        /// Email : Necessary to communicate, at least for now
                        ///
                        new Padding(
                          padding: new EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 10.0),
                          child: new TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: _inputFontStyle(),
                            decoration: InputDecoration(
                                hintText: "Email",
                                prefixIcon: Icon(FontAwesomeIcons.at)),
                            validator: (value) {
                              ///make sure email contains @ and .
                              if (!value.contains("@") ||
                                  !value.contains(".")) {
                                return "Not a valid email address";
                              }
                            },
                          ),
                        ),

                        ///
                        ///
                        ///  Divider
                        ///
                        ///

                        new Padding(
                          padding: new EdgeInsets.symmetric(
                              vertical: 30.0, horizontal: 100.0),
                          child: new Divider(
                            height: 3.0,
                            color: Colors.brown,
                          ),
                        ),

                        /////
                        //////
                        ///   Input Password
                        ////

                        new Padding(
                          padding: new EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 30.0),
                          child: new TextFormField(
                            controller: _passwordController,
                            style: _inputFontStyle(),
                            obscureText: _passwordObscure,
                            decoration: InputDecoration(
                              prefixIcon: Icon(FontAwesomeIcons.asterisk),
                              hintText: "Password",
                              suffixIcon: GestureDetector(
                                child: Icon(FontAwesomeIcons.eye),
                                onTapDown: (details) {
                                  setState(() {
                                    this._passwordObscure =
                                        !this._passwordObscure;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value.length < 6) {
                                return "Password has to be at least 6 characters long.";
                              }
                              if (value.contains(' ')) {
                                return "Password cannot contain space.";
                              }
                            },
                          ),
                        ),

                        /////
                        //////
                        ///  Confirm Password
                        ////

                        new Padding(
                          padding: new EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 30.0),
                          child: new TextFormField(
                            controller: _confirmPasswordController,
                            style: _inputFontStyle(),
                            obscureText: _confirmPasswordObscure,
                            decoration: InputDecoration(
                              prefixIcon: Icon(FontAwesomeIcons.asterisk),
                              hintText: "Confirm Password",
                              suffixIcon: GestureDetector(
                                child: Icon(FontAwesomeIcons.eye),
                                onTapDown: (details) {
                                  setState(() {
                                    this._confirmPasswordObscure =
                                        !this._confirmPasswordObscure;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value != _passwordController.text) {
                                print(_passwordController.text);
                                return "Password confirmation doesn't match";
                              }
                            },
                          ),
                        ),

                        ///
                        ///complete registration
                        ///
                        new Padding(
                          padding: new EdgeInsets.all(10.0),
                          child: new RaisedButton(
                            child: new Text(
                              "Register",
                              style: new TextStyle(color: Colors.white),
                            ),
                            color: Colors.green,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                print("Register started");
                                API
                                    .register(
                                        _emailController.text.trim(),
                                        _mobileController.text.trim(),
                                        _passwordController.text.trim())
                                    .then((response) {                                     
                                  if (response.statusCode == 500) {
                                    dynamic body = jsonDecode(response.body);
                                    _scaffoldKey.currentState
                                        .showSnackBar(new SnackBar(
                                      content: new Text(body["message"]),
                                      duration: new Duration(seconds: 5),
                                    ));
                                  }else if(response.statusCode==200){
                                    _scaffoldKey.currentState
                                        .showSnackBar(new SnackBar(
                                      content: new Text("Registered Successfully"),
                                      duration: new Duration(seconds: 5),
                                    ));
                                    Future.delayed(Duration(seconds: 2),()async{
                                      Navigator.pop(context,true);
                                    });
                                  }
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
