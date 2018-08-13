import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'register.dart';
import 'dart:async';
import 'dart:convert';
import 'package:virga_shop/network/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

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

  /// Login into server using the username and password provided by the users
  Future<String> login(String username, String password) async {
    //try login to server
    API.login(username, password).then((reponse) {
      //if status code 401 is returened then
      // it  is bad crediantial error,
      if (reponse.statusCode == 401) {
        _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text("Login failed, try again."),
          duration: Duration(seconds: 1),
        ));
        return null;
      }
      return jsonDecode(reponse.body);
    }).then((responseBody) async {
      //if response is not null and has a token field then we have successfully logged in
      if (responseBody != null) {
        if (responseBody["token"] != null) {
          //create a snackbar to notify user that he/she has successfully logged in
          _scaffoldKey.currentState.showSnackBar(new SnackBar(
            content: new Text("Login Successful."),
            duration: new Duration(seconds: 1),
          ));

          //using shared preference we now store the token and credential in sharedprefs
          //for the future uses, we will need token in every request
          // and credential to [reAuth] in case the token expires.
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          await sharedPreferences.setString("token", responseBody["token"]);
          await sharedPreferences.setString("_username", username);
          await sharedPreferences.setString("_password", password);

          //now that we have done everything right we will now head to the home screen of the app

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => new HomeScreen()),
              (route) => false);
        }
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
              child: new ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  Container(
                    margin: new EdgeInsets.fromLTRB(.0, 40.0, .0, 40.0),
                    child: new Column(
                      children: <Widget>[
                        new SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: new Image.asset('graphics/logo.jpg'),
                        ),
                      ],
                    ),
                  ),
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
                                  duration: new Duration(seconds: 1),
                                ));
                              }
                              login(_usernameTextEditingController.text.trim(),
                                  _passwordTextEditingController.text.trim());
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
