import 'dart:async';
import 'package:virga_shop/models/cart.dart';
import 'package:rxdart/subjects.dart';
import 'package:virga_shop/models/cart_item.dart';
import 'package:virga_shop/models/user_address.dart';
import 'package:virga_shop/network/api.dart';

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
    _cartAdditionController.stream.listen(_cartItemAdditionHandler);
  }

  Sink<CartItem> get cartAddition => _cartAdditionController.sink;

  Stream<List<CartItem>> get items => _items.stream;

  Stream<int> get itemCount => _itemCount;

  Stream<double> get totalAmount => _totalAmount;

  void _cartItemAdditionHandler(CartItem addition) {
    ///add items to the cart
    _cart.items.add(addition);

    ///update items stream
    _items.add(_cart.items);

    ///total amount
    amount += addition.amount;

    ///update total amount stream
    _totalAmount.add(amount);

    //update total count
    count = _cart.items.length;

    //update total count stream
    _itemCount.add(count);
  }

  ///
  ///Post order request
  ///
  Future<bool> placeOrder(
      String paymentMode, UserAddress shippingAddress) async {
    _cart.shippingAddress = shippingAddress;

    _cart.paymentMode = paymentMode;

    await API.postOrder(_cart).then((response) {
      if (response.statusCode != 200) {
        return false;
      }
    });

    return true;
  }

  void clearCart() {
    _cart.items.clear();
    _items.add(_cart.items);
    count = _cart.items.length;
    _itemCount.add(count);
    amount = 0.0;
    _totalAmount.add(amount);
  }

  void disponse() {
    _cartAdditionController.close();
  }
}
