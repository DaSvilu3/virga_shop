import 'package:flutter/material.dart';

class UserAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text(
          "Account",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey.shade200,
      ),
      body: UserAccountBody(),
    );
  }
}

class UserAccountBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserAccountBodyState();
  }
}

class UserAccountBodyState extends State<UserAccountBody> {
  Widget menuHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black38)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style:
                TextStyle(fontSize: 16.0, color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget menuItem(String text) {
    return MaterialButton(      
      onPressed: () {},
      padding: EdgeInsets.all(10.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Container(
            margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
            child: new Material(          
              elevation: 2.0,
              shape: BeveledRectangleBorder(),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  //title
                  menuHeader("Profile Settings"),

                  menuItem("My Profile"),

                  Divider(
                    color: Colors.black45,
                  ),

                  menuItem("My Addresses"),

                  Divider(
                    color: Colors.black45,
                  ),

                  menuItem("Change Password"),

                  Divider(
                    color: Colors.black45,
                  ),

                  menuItem("Logout"),

                  Container(padding: new EdgeInsets.all(4.0))
                ],
              ),
            ))
      ],
    );
  }
}
