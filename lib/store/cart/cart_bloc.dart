import 'dart:async';
import 'package:virga_shop/models/cart.dart';
import 'package:rxdart/subjects.dart';
import 'package:virga_shop/models/cart_item.dart';
import 'package:virga_shop/network/api.dart';
import 'package:http/http.dart' as http;

class CartAddition {
  String productID;

  CartAddition(this.productID);
}

class CartBloc {
  int count = 0;

  double amount = 0.0;

  final _cart = Cart();

  final BehaviorSubject<List<CartItem>> _items =
      new BehaviorSubject<List<CartItem>>(seedValue: []);

  final BehaviorSubject<int> _itemCount = BehaviorSubject<int>(seedValue: 0);

  final BehaviorSubject<double> _totalAmount =
      BehaviorSubject<double>(seedValue: 0.0);

  final StreamController<CartItem> _cartAdditionController =
      StreamController<CartItem>();

  CartBloc() {
    _cartAdditionController.stream.listen((addition) {    

      int currentCount = _cart.items.length;

      _itemCount.add(currentCount);

      _cart.items.add(addition);

      _items.add(_cart.items);

      amount += addition.amount;

      _totalAmount.add(amount);
    });
  }

  Sink<CartItem> get cartAddition => _cartAdditionController.sink;

  Stream<List<CartItem>> get items => _items.stream;

  Stream<int> get itemCount => _itemCount;

  Stream<double> get totalAmount => _totalAmount;


  Future<bool> placeOrder() async {

    http.Response response = await API.postOrder(_cart);

    print(response.body);
   
    return true;
  }

  void disponse(){
    _cartAdditionController.close();
  }

}


