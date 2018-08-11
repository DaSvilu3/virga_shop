import 'dart:async';
import 'package:virga_shop/models/cart.dart';
import 'package:rxdart/subjects.dart';
import 'package:virga_shop/models/cart_item.dart';

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

      amount += addition.price;

      _totalAmount.add(amount);
    });
  }

  Sink<CartItem> get cartAddition => _cartAdditionController.sink;

  Stream<List<CartItem>> get items => _items.stream;

  Stream<int> get itemCount => _itemCount;

  Stream<double> get totalAmount => _totalAmount;


  bool placeOrder(){
    _cart.items.clear();
    _items.add(_cart.items);
    _totalAmount.add(0.0);
    return true;
  }

  void disponse(){
    _cartAdditionController.close();
  }

}


