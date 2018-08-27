
import 'package:virga_shop/models/product.dart';

class CartItem{
  
  Product product;

  String quantityType;

  /// loose quantity
  double looseQuantity;

  String looseQuantityUnitName;


  ///custom quantity name
  String customQuantityName;

  ///custom quantity units
  double customQuantity;


  /// piece quantity;
  double pieceQuantity;

  /// price calculated
  double amount;


  CartItem(this.product,this.quantityType,{this.looseQuantity,this.looseQuantityUnitName,this.customQuantityName,this.customQuantity,this.pieceQuantity,this.amount});

  Map<String,Object> toJson(){
    
    return {
      "id" : product.id,
      "quantityType" : quantityType,
      "looseQuantity" : looseQuantity,
      "looseQuantityUnitName" : looseQuantityUnitName,
      "customQuantityName" : customQuantityName,
      "customQuantity" : customQuantity,
      "pieceQuantity" : pieceQuantity,
      "amount": amount
    };
  }



}