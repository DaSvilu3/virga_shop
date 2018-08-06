import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'register.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //now we listen to the text input fields
  //they are username, password
  final _usernameTextEditingController = new TextEditingController();
  final _passwordTextEditingController = new TextEditingController();

  @override
  void dispose() {
    _usernameTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  Future<String> login(String username, String password) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json"
    };

    dynamic body = jsonEncode({"username": username, "password": password});

    await http
        .post('http://10.0.2.2/VirgaApi/public/api/login_check',
            body: body, headers: headers)
        .then((response) {
      dynamic responseBody = jsonDecode(response.body);

      if (responseBody["code"] != null) {
        if (responseBody["code"] == 401) {
          _scaffoldKey.currentState.showSnackBar(new SnackBar(
            content: new Text("Login failed, wrong username or password."),
            duration: Duration(seconds: 2),
          ));
        }
      }
      if (responseBody["token"] != null) {
        _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text("Login Successful."),
          duration: new Duration(seconds: 2),
        ));
      }
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        key: _scaffoldKey,
        body: new SafeArea(
            child: new Container(
          color: Colors.blueAccent,
          child: new Center(
            child: new Container(
              padding: EdgeInsets.all(10.0),
              color: Colors.white12,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Form(
                    key: _formKey,
                    child: new Column(
                      children: <Widget>[
                        //////
                        /////
                        ///   Mobile number input / username input
                        ///
                        //////
                        new Container(
                            color: Colors.white,
                            margin: new EdgeInsets.symmetric(vertical: 5.0),
                            child: new Row(
                              children: <Widget>[
                                new Flexible(
                                  child: new TextFormField(
                                    keyboardType: TextInputType.phone,
                                    controller: _usernameTextEditingController,
                                    validator: (value) {
                                      if (value.trim().isEmpty) {
                                        return "Please enter your mobile number.";
                                      } else if (value.trim().length < 10 ||
                                          value.trim().length > 10) {
                                        return "Invalid number of digits, check again.";
                                      }
                                    },
                                    decoration: new InputDecoration(
                                      prefixText: "+91",
                                      prefixIcon: new Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          new Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: new Icon(Icons.phone),
                                          ),
                                        ],
                                      ),
                                      hintText: "Mobile Number",
                                      border: InputBorder.none,
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.fromLTRB(
                                          0.0, 15.0, .0, 10.0),
                                    ),
                                  ),
                                )
                              ],
                            )),

                        ////
                        ////
                        ////  Password input
                        ////
                        new Container(
                          color: Colors.lightBlue,
                          margin: new EdgeInsets.symmetric(vertical: 2.0),
                          child: new TextFormField(
                            obscureText: true,
                            controller: _passwordTextEditingController,
                            decoration: new InputDecoration(
                              hintText: "Password",
                              prefixIcon: Icon(FontAwesomeIcons.key),
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                            ),

                            ////validation for password
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return "Password cannot be empty";
                              }
                              if (value.trim().length < 5) {
                                return "Invalid password, check again.";
                              }
                            },
                          ),
                        ),

                        /////
                        ///
                        ///   Login Button
                        /////
                        new Container(
                          margin: new EdgeInsets.all(20.0),
                          child: new RaisedButton.icon(
                            icon: new Icon(FontAwesomeIcons.lock),
                            label: new Text("Login"),
                            color: Colors.greenAccent,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _scaffoldKey.currentState
                                    .showSnackBar(new SnackBar(
                                  content:
                                      new Text("Logging in, please wait..."),
                                  duration: new Duration(seconds: 3),
                                ));
                              }
                              login(_usernameTextEditingController.text,
                                  _passwordTextEditingController.text);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  ////
                  ////
                  /// Not Registered yet ?
                  ///
                  new Container(
                    child: new Center(
                      child: new Text(
                        "Not registered yet? Register here",
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),

                  /////
                  ///   Register button
                  ///
                  ///..
                  new Container(
                    margin: new EdgeInsets.all(20.0),
                    child: new Center(
                      child: new RaisedButton(
                        color: Colors.amberAccent,
                        child: new Text("Register"),
                        onPressed: () {
                          //go to register screen
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => new RegisterScreen()));
                        },
                      ),
                    ),
                  )

                  ///////
                  ///
                  //////
                ],
              ),
            ),
          ),
        )));
  }
}
