
import 'package:virga_shop/models/cart_item.dart';


class Cart{
  List<CartItem> items = new List();

  Map<String,Object> toJson(){
    return {
      "items" : items.map((f)=>f.toJson()).toList()
    };
  }
}