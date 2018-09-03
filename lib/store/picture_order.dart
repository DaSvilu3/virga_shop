import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/subjects.dart';
import 'package:virga_shop/store/dialogs/picture_picker.dart';
import 'package:virga_shop/store/place_order.dart';

class PictureOrderPage extends StatefulWidget { 

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PictureOrderPageState();
  }
}

class _PictureOrderPageState extends State<PictureOrderPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Place Order"),
      ),
      body: PictureOrderBody(),
    );
  }
}

class PictureOrderBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PictureOrderBodyState();
  }
}

class _PictureOrderBodyState extends State<PictureOrderBody> {
  final imageFileStream = new BehaviorSubject<File>(seedValue: null);
  File _imageFile;

  @override
  void initState() {
    super.initState();    
  }

  @override
  Widget build(BuildContext context) {
  
    return new Column(
      children: <Widget>[
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: new RaisedButton.icon(
                icon: Icon(Icons.camera_alt),
                label: new Text("Take a Picture"),
                onPressed: () async {
                  _imageFile =
                      await ImagePicker.pickImage(source: ImageSource.camera);
                  if (_imageFile != null) {
                    imageFileStream.add(_imageFile);
                  }
                },
              ),
            ),
            Expanded(
              child: new RaisedButton.icon(
                icon: Icon(Icons.photo_library),
                label: new Text("Choose from gallery"),
                onPressed: () async {
                  _imageFile =
                      await ImagePicker.pickImage(source: ImageSource.gallery);
                  if (_imageFile != null) {
                    imageFileStream.add(_imageFile);
                  }
                },
              ),
            )
          ],
        ),
        Expanded(
          child: new Container(
              padding: new EdgeInsets.all(5.0),
              child: new StreamBuilder(
                stream: imageFileStream,
                builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
                  if (snapshot.hasData) {
                    return new Image.file(snapshot.data);
                  }
                  return new Center(
                    child: Text("Please Select a Picture"),
                  );
                },
              )),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 56.0,
          child: new RaisedButton.icon(
            elevation: 30.0,
            color: Colors.red,
            icon: Icon(Icons.done),
            label: new Text(
              "Place Order",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              if (_imageFile == null) {
                Scaffold.of(context).showSnackBar(new SnackBar(
                      content: new Text("No image is selected to place order."),
                    ));
              } else {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => PlaceOrderScreen(
                          imageOrderFile: _imageFile,
                        )));
              }
            },
          ),
        )
      ],
    );
  }
}
