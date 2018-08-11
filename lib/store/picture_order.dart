import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:virga_shop/globals.dart' as Global;
import 'package:rxdart/subjects.dart';
import 'package:http/http.dart' as http;

import 'package:virga_shop/store/widgets/picture_picker.dart';

class PictureOrderPage extends StatefulWidget {
  PictureOrderPage();

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

  @override
  Widget build(BuildContext context) {
    PicturePicker().dialog(context).then((_image){      
      imageFileStream.add(_image);
      });
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
                  File _image =
                      await ImagePicker.pickImage(source: ImageSource.camera);
                  if (_image != null) {
                    imageFileStream.add(_image);
                  }
                },
              ),
            ),
            Expanded(
              child: new RaisedButton.icon(
                icon: Icon(Icons.photo_library),
                label: new Text("Choose from gallery"),
                onPressed: () async {
                  File _image =
                      await ImagePicker.pickImage(source: ImageSource.gallery);
                  if (_image != null) {
                    imageFileStream.add(_image);
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
            color: Colors.grey,
            icon: Icon(Icons.done),
            label: new Text("Place Order",
            style: TextStyle(
              color: Colors.pink
            ),),
            onPressed: () {
              print("Started upload");
              var url = Uri.parse(Global.Api.pictureOrderUrl);
              http.MultipartRequest request = new http.MultipartRequest("POST", url);
              imageFileStream.listen((onData){
                print("Reached stream for $url");
                request.files.add(new http.MultipartFile.fromBytes("image", onData.readAsBytesSync(),filename: onData.path));
                request.send().then((response){               
                  if(response.statusCode == 200){
                  
                  }
                });
              });
              

              //request.files.add()
            },
          ),
        )
      ],
    );
  }
}
