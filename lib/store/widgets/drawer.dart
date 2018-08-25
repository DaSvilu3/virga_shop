import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:virga_shop/store/home.dart';
import 'package:virga_shop/store/login.dart';
import 'package:virga_shop/store/picture_order.dart';
import 'package:virga_shop/store/user_account.dart';
import 'package:virga_shop/store/user_orders.dart';
import '../../globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart' as URLauncher;

class SideDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SideDrawerState();
  }
}

class _SideDrawerState extends State<SideDrawer> {
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
              child: Image.asset(
                'graphics/logo_trans.png'
              )
            ),
            decoration:
                new BoxDecoration(color: Colors.white,border: new Border(
                   bottom: new BorderSide(
                     color: Colors.grey.shade400,
                     width: 1.0
                   )
                ),
                )
              
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
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => new HomeScreen()),
                  (route) => false);
            },
          ),
          new ListTile(
            title: new Text("My Account"),
            leading: new Icon(FontAwesomeIcons.userCircle),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => UserAccountScreen()));
            },
          ),
          new ListTile(
            title: new Text("My Orders"),
            leading: new Icon(FontAwesomeIcons.truck),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => UserOrdersScreen()));
            },
          ),

          new Divider(),

          new ListTile(
            title: new Text("Picture Order"),
            leading: new Icon(FontAwesomeIcons.camera),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PictureOrderPage()));
            },
          ),
          new ListTile(
            title: new Text("Call"),
            leading: new Icon(Icons.phone),
            onTap: () async {
              const url = 'tel:+91 888877755';
              if (await URLauncher.canLaunch(url)) {
                await URLauncher.launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),

          new Divider(),
          new ListTile(
            title: new Text("Sign Out"),
            leading: new Icon(FontAwesomeIcons.signOutAlt),
            onTap: () {
              SharedPreferences.getInstance().then((sharedPref) {
                sharedPref.remove("token").then((sharedPref) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (bool) => false);
                });
              });
            },
          ),
        ],
      ),
    );
  }
}
