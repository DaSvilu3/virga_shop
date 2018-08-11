import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:virga_shop/store/home.dart';
import '../../globals.dart';

class SideDrawer extends StatefulWidget{

@override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SideDrawerState();
  }
}


class _SideDrawerState extends State<SideDrawer>{
  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Drawer(
        child: new ListView(
          children: <Widget>[
            /////
            ///
            // //  Drawer header
            ////
            ///
            new DrawerHeader(
              child: new Center(
                child: const Text(
                  App.TITLE,
                  style: TextStyle(
                    fontSize: 35.0,
                  ),
                ),
              ),
              decoration:
                  new BoxDecoration(color: Theme.of(context).primaryColor),
            ),

            /////////////////////////
            ///
            ///   List Items
            ///
            /// /////////////////////

            new ListTile(
              title: new Text("Home"),
              leading: new Icon(FontAwesomeIcons.home),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>new Home()), (route)=>false);
              },
            ),
            new ListTile(
              title: new Text("My Account"),
              leading: new Icon(FontAwesomeIcons.userCircle),
              onTap: () {},
            ),
            new ListTile(
              title: new Text("My Orders"),
              leading: new Icon(FontAwesomeIcons.truck),
              onTap: () {},
            ),
          ],
        ),
      );
    }
}