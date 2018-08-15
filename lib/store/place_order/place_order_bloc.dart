import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:virga_shop/models/user_address.dart';
import 'package:http/http.dart' as http;
import 'package:virga_shop/network/api.dart';
import 'dart:convert';

class PlaceOrderBloc {
  //list in which addresses are stored
  List<UserAddress> _addresses = new List();

  //current selected address
  UserAddress _selectedAddress = new UserAddress();

  //stream the list of user addresses
  BehaviorSubject<List<UserAddress>> addresses =
      new BehaviorSubject(seedValue: null);

  //stream current selected user address

  BehaviorSubject<UserAddress> selectedAddress =
      new BehaviorSubject(seedValue: null);

  //handle address selection changes
  StreamController<UserAddress> _addressChangeController =
      new StreamController<UserAddress>();

  //getter for [_addressChangeController]
  Sink<UserAddress> get addressChange => _addressChangeController.sink;

  PlaceOrderBloc() {
    initAddresses();
    _addressChangeController.stream.listen(addressChangeHandler);
  }

  void initAddresses() {
    API.getCurrentUserAddresses().then((response) {
      if (response.statusCode == 200) {
        try {
          //try to get list of user address
          List<dynamic> rawAddresses = jsonDecode(response.body)["addresses"];

          //if address are not empty
          if (rawAddresses != null) {
            //first clear prior data
            _addresses.clear();
            _selectedAddress = null;

            _addresses =
                rawAddresses.map((f) => UserAddress.fromJson(f)).toList();
            addresses.add(_addresses);

            //select first address as current selection
            _selectedAddress = _addresses.first;

            selectedAddress.add(_selectedAddress);
          }
        } catch (exception) {
          print(exception);
        }
      } else {}
    });
  }

  void addressChangeHandler(UserAddress change) {
    _selectedAddress = change;
    selectedAddress.add(_selectedAddress);
  }

  void dispose() {
    _addressChangeController.close();
    selectedAddress.close();
    addresses.close();
  }
}
