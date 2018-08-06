import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_pro/carousel_pro.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as URLauncher;
import './widgets/drawer.dart';
import 'search.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:virga_shop/globals.dart';
import 'cart.dart';
import 'widgets/product_category.dart';
import 'login.dart';
import 'package:virga_shop/store/cart/cart_provider.dart';


class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _HomeState();
  }
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    //return app scaffold for material design
    //

    return new Scaffold(
      //this is drawer for the application
      //
      //
      // holding all the navigation items
      //
      // also the logo from drawer.dart
      drawer: new SideDrawer(),
     
      ////////////////////////////////////////////////////
      ///////////////
      //////////////
      ///
      /// Here fits the body of the app,
      /// home page is loaded here
      ///
      /// /////////////
      /// ////////////////////
      body: new CustomScrollView(
        slivers: <Widget>[
          ////////
          //app bar is necessary to show all the quick actions
          ///
          //// also
          ///
          /// also the search bar
          new SliverAppBar(
            elevation: 10.0,
            actions: <Widget>[
              new IconButton(
                icon: new Icon(Icons.camera_alt),
                onPressed: () async {
                  ///
                  ///
                  ///
                  ///   A dialogue asking if they want to take picture or pick a picture from gallery
                  ///
                  ///
                  ///
                  await showDialog(
                      context: this.context,
                      builder: (BuildContext context) {
                        return new SimpleDialog(
                          title: new Text("Send List"),
                          children: <Widget>[
                            new SimpleDialogOption(
                              child: new Row(
                                children: <Widget>[
                                  new Icon(Icons.camera),
                                  Container(
                                    padding: new EdgeInsets.all(10.0),
                                    child: new Text("Camera"),
                                  ),
                                ],
                              ),
                              onPressed: () async {
                                File _image = await ImagePicker.pickImage(
                                    source: ImageSource.camera);

                                if (_image == null) {
                                  print("photo not choose");
                                }
                              },
                            ),
                            new SimpleDialogOption(
                              child: new Row(
                                children: <Widget>[
                                  new Icon(Icons.photo_library),
                                  Container(
                                    padding: new EdgeInsets.all(10.0),
                                    child: new Text("Gallery"),
                                  ),
                                ],
                              ),
                              onPressed: () async {
                                File _image = await ImagePicker.pickImage(
                                    source: ImageSource.gallery);
                              },
                            ),
                          ],
                        );
                      });
                },
              ),
              new IconButton(
                icon: new Icon(Icons.phone),
                onPressed: () async {
                  const url = 'tel:+91 888877755';
                  if (await URLauncher.canLaunch(url)) {
                    await URLauncher.launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
              new IconButton(
                icon: new Icon(FontAwesomeIcons.shoppingBag),              
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => new Cart()),
                  );
                },
              ),
             
            ],

            //
            // title of the app show in the appbar at the top
            title: new Text(App.TITLE),

            /////
            /// this is where the search input is put
            /// style accordingly and pin it if necessary
            /// //
            bottom: new PreferredSize(
              child: new Container(
                child: new TextField(
                  decoration: new InputDecoration(
                    hintText: "Search...",
                    suffixIcon: new IconButton(
                      icon: new Icon(FontAwesomeIcons.search),
                      onPressed: () {
                        print("Pressed Search");
                        openSearch("query");
                      },
                    ),
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20.0),
                    border: InputBorder.none,
                  ),
                  onChanged: (string) {
                    if (string.length > 2) print(string);
                  },
                  onSubmitted: (query) {
                    openSearch(query);
                  },
                ),
                margin: new EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade400)),
              ),
              preferredSize: new Size.fromHeight(56.0),
            ),
          ),

          //this is end of appbar

          ///////////////
          ///Here is where the flow of body starts
          ///Put everything is a list
          ///All the widgets will get added to list view
          ///no need to add scroll view, as we already are in CustomScrollView
          ///Everything will be handled by it already!!!
          ///////////////

          new SliverList(
              delegate: new SliverChildListDelegate(<Widget>[
            //category and their items
            new FutureBuilder<http.Response>(

              future: loadHome(),
              
              builder: (context, snapshot) {
              
                if (snapshot.hasData && snapshot.data.headers["content-type"] == 'application/json' ) {
               

                  //list of product categories
                  List<ProductCategory> productCategories = new List();

                  //decode response to json object
                  Map<String,dynamic> data = jsonDecode(snapshot.data.body);

                  //get banner image urls
                  List<dynamic> bannerUrls = data["banners"];

                  //look for product category
                  if (data["category"] != null) {
                    List<dynamic> categories = new List();
                    categories = data["category"];
                    int oe = 0;
                    categories.forEach((c) {
                    
                      productCategories.add(new ProductCategory(
                        "Grocery",
                        products: c["products"],
                        color: oe % 2 != 0 ? Colors.white : Colors.black,
                      ));

                      oe++;
                    });
                  }

                  

                  return new Column(children: <Widget>[
                    //////////
                    ///
                    ///    This is where the Banner which is a carausel fits
                    ///    Pictures will always be in motion,
                    ///    When user touches any of them
                    ///    He will be redirected to that particular.
                    /// ...

                    new SizedBox(
                      height: MediaQuery.of(context).size.height * 0.40,
                      child: new Carousel(                        
                        dotBgColor: Colors.black12,
                        autoplay: true,
                        autoplayDuration: new Duration(seconds: 5),
                        images: bannerUrls.map((f)=>new NetworkImage(f["name"])).toList(),
                        dotSize: 4.0,                        
                      ),
                    ),

                    //here are where the category slider fit in
                    new Column(
                      children: productCategories,
                    ),

                    //simple holder for icons
                    new Container(
                      child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            new Container(
                              padding: new EdgeInsets.all(10.0),
                              child: new Text(
                                "Categories",
                                textAlign: TextAlign.left,
                                style: new TextStyle(
                                  fontSize: 24.0,
                                ),
                              ),
                            ),

                            ////
                            /////
                            /////   Hold the icons in grid
                            //////
                            /////////////
                            ///
                            new SizedBox(
                              height: MediaQuery.of(context).size.height * 0.30,
                              child: GridView.count(
                                  padding: new EdgeInsets.all(10.0),
                                  crossAxisSpacing: 20.0,
                                  mainAxisSpacing: 20.0,
                                  // Create a grid with 2 columns. If you change the scrollDirection to
                                  // horizontal, this would produce 2 rows.
                                  crossAxisCount: 4,
                                  // Generate Widgets that display their index in the List
                                  children: <Widget>[
                                    new SizedBox.expand(
                                      child: new Column(
                                        children: <Widget>[
                                          new Expanded(
                                            child: new Image.asset(
                                                "graphics/groceries.png",
                                                fit: BoxFit.fitHeight),
                                          ),
                                          new Expanded(
                                            child: new Text(
                                              "Groceries",
                                              style: new TextStyle(
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    new SizedBox.expand(
                                      child: new Column(
                                        children: <Widget>[
                                          new Expanded(
                                            child: new Image.asset(
                                                "graphics/vegetables.png",
                                                fit: BoxFit.fitHeight),
                                          ),
                                          new Expanded(
                                            child: new Text(
                                              "Vegetables",
                                              style: new TextStyle(
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    new SizedBox.expand(
                                      child: new Column(
                                        children: <Widget>[
                                          new Expanded(
                                            child: new Image.asset(
                                                "graphics/brush.png",
                                                fit: BoxFit.fitHeight),
                                          ),
                                          new Expanded(
                                            child: new Text(
                                              "Home Care",
                                              style: new TextStyle(
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    new SizedBox.expand(
                                      child: new Column(
                                        children: <Widget>[
                                          new Expanded(
                                            child: new Image.asset(
                                                "graphics/toothbrush.png",
                                                fit: BoxFit.fitHeight),
                                          ),
                                          new Expanded(
                                            child: new Text(
                                              "Personal Care",
                                              style: new TextStyle(
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    
                                  ]),
                            )
                          ]),
                    ),
                  ]);
                }
                return new Center(
                  child: new CircularProgressIndicator(),
                );
              },
            )
          ]))
        ],
      ),
    );
  }

/////
  ///
  /// Load Home page from the below url
  ///
/////
  Future<http.Response> loadHome() async {
    http.Response data = await http.get(Api.homePageUrl);
    return data;
  }

  //////////
  ///
  /// Function Called everytime a search query is made.
  ////
  void openSearch(String query) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => new SearchPage()));
  }
}




class Store extends StatefulWidget {
  final String title = App.TITLE;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _StoreState();
  }
}

class _StoreState extends State<Store> {

   Future<bool> loadHome() async{

     return true;

    // SharedPreferences prefs = await SharedPreferences.getInstance();

    // String apiKey = prefs.getString("apiKey");

    // if(apiKey == null){
    //   print("not logged in");
    //   return false;
    // } 
    // else return true;
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CartProvider(
      child: new MaterialApp(
      theme: new ThemeData(primaryColor: Color(0XFFE2E4E6)),
      title: widget.title,      
      home: new FutureBuilder<bool>(
        future: loadHome(),
        builder: (context,snapshot){

          if(snapshot.hasData){
            if(snapshot.data == true){
              return new Home();
            }else{
              return LoginScreen();
            }
          }
        return new Scaffold(
          body: new Center(
            child: new CircularProgressIndicator(),
          ),
        );
      },
      ),
    ),
    );
  }
 
}
