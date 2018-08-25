import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:virga_shop/models/user_order.dart';
import 'package:virga_shop/network/api.dart';
import 'dart:convert';

class UserOrdersBloc {
  static int loading = 101;
  static int done = 102;
  static int error = 103;

  List<UserOrder> _userOrders = new List();

  ///for status of the screen

  BehaviorSubject<int> _status = new BehaviorSubject(seedValue: loading);

  Stream<int> get status => _status.stream;

  BehaviorSubject<List<UserOrder>> userOrders =
      new BehaviorSubject(seedValue: null);

  UserOrdersBloc() {
    load();
  }

  void load() {
    _status.add(loading);

    ///make a request to server asking for list of orders
    API.getUserOrders().then((response) {
      //after the request has completed,
      //if the status code is 200, then success
      if (response.statusCode == 200) {
        try {
          //now convert all the data to native models
          Map<String, dynamic> va = jsonDecode(response.body);

          //response is always list of [UserOrder]
          va.forEach((f, v) {
            _userOrders.add(UserOrder.fromJson(v));
          });

          //after we have completed the conversion
          //now get ready to display list
          _status.add(done);

          /// now we wanna put out some show
          userOrders.add(_userOrders);
        } catch (exception) {
          _status.add(done);
        }
      } else if (response.statusCode == 500) {
        _status.add(error);
      }
    });
  }

  void dispose() {
    userOrders.close();
    _status.close();
  }
}
