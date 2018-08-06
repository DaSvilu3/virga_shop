import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _formKey = GlobalKey<FormState>();
  
  //input controllers to retrieve the values
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();


  @override
  void dispose(){
    super.dispose();
  }
  
  ///function that returns input field text styles
  TextStyle _inputFontStyle() {
    return new TextStyle(      
      color: Colors.black87,
      fontSize: 16.0
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
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
                        ///First Name
                        ///
                        new Padding(
                          padding: new EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 10.0),
                          child: new TextFormField(
                            controller: _fullNameController,
                            style: _inputFontStyle(),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "Full Name",
                              prefixIcon: Icon(Icons.person),                              
                            ),
                            validator: (value){
                              if(value.isEmpty){
                                return "Full name cannot be empty";
                              }
                              if(value.length<3){
                                return "Invalid name";
                              }
                            },
                          ),
                        ),

                        ////
                        /////
                        /// Email
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
                                prefixIcon: Icon(FontAwesomeIcons.at)
                                ),
                            validator: (value){

                              ///make sure email contains @ and .
                              if(!value.contains("@") || !value.contains(".")){
                                return "Not a valid email address";
                              }
                            },
                                
                          ),
                          
                        ),

                        ////
                        /////
                        /// Mobile
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
                            validator: (value){
                              if(value.length<10 || value.length >10){
                                return "Invalid mobile number";
                              }
                            },
                          ),
                        ),

                        ///////
                        ////  Divider 
                        /// 
                        //////

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
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(FontAwesomeIcons.asterisk),
                              hintText: "Password",
                            ),
                            validator: (value){
                             if(value.length<6){
                               return "Password has to be at least 6 characters long.";
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
                            obscureText: true,
                            decoration: InputDecoration(
                               prefixIcon: Icon(FontAwesomeIcons.asterisk),
                              hintText: "Confirm Password",
                            ),
                            validator: (value){
                              if(value != _passwordController.text){
                                print(_passwordController.text);
                                return "Password confirmation doesn't match";
                              }
                            },
                          ),
                        ),

                        ///
                        //complete registration
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
                              if(_formKey.currentState.validate()){
                                
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
