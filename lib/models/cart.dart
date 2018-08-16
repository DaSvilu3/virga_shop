
import 'package:virga_shop/models/cart_item.dart';
import 'package:virga_shop/models/user_address.dart';


class Cart{

  List<CartItem> items = new List();

  String paymentMode;

  UserAddress shippingAddress;

  Map<String,Object> toJson(){
    return {
      "items" : items.map((f)=>f.toJson()).toList(),
      "paymentMode" : paymentMode,
      "shippingAddress" :shippingAddress.toJson(),
    };
  }
}