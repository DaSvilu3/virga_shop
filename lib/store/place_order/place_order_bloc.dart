import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:virga_shop/models/user_address.dart';
import 'package:virga_shop/network/api.dart';
import 'dart:convert';
import 'package:virga_shop/globals.dart';

class PlaceOrderBloc {

  BehaviorSubject<Status> _status = new BehaviorSubject(seedValue: Status.loading);

  Stream get status => _status.stream;

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

  //get selected address
  UserAddress getSelectedAddress() => _selectedAddress;

  PlaceOrderBloc() {
    initAddresses();
    _addressChangeController.stream.listen(addressChangeHandler);
  } 

  void setStatus(Status status){
    _status.add(status);
  }
  

  void initAddresses() {
    API.getCurrentUserAddresses().then((response) {
      if (response.statusCode == 200) {

        ///if status was successful, hide loading, and show screen
        _status.add(Status.ready);

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
      } else {

      }
    });
  }

  void addressChangeHandler(UserAddress change) {
    _selectedAddress = change;
    selectedAddress.add(_selectedAddress);
  }


  ///
  /// When disposing off the data
  /// close all the connections to the stream
  /// 
  void dispose() {
    _status.close();
    _addressChangeController.close();
    selectedAddress.close();
    addresses.close();
  }
}
