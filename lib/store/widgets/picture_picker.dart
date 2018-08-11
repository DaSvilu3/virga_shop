import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';

class PicturePicker {
  /// Brings up [SimpleDialog] asking if you want to take a new picture
  /// or use the picture already take which is in gallery.
  Future<File> dialog(BuildContext context) async {
    return await showDialog<File>(
        context: context,
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
                  
                  var image = await ImagePicker.pickImage(
                      source: ImageSource.camera);
                  
                  Navigator.pop(context,image);
                  
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
                 var image = await ImagePicker.pickImage(
                      source: ImageSource.gallery);

                  Navigator.pop(context,image);
                },
              ),
            ],
          );
        });

  }
}
