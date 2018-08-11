
class CartItem{
  
  dynamic product;

  String quantityType;

  /// loose quantity
  double looseQuantity;

  String looseQuantityUnitName;


  ///custom quantity name
  String customQuantityName;

  ///custom quantity units
  double customQuantityUnits;


  /// piece quantity;
  double pieceQuantity;

  /// price calculated
  double price;


  CartItem(this.product,this.quantityType,{this.looseQuantity,this.looseQuantityUnitName,this.customQuantityName,this.customQuantityUnits,this.pieceQuantity,this.price});

  Map<String,Object> toJson(){
    
    return {
      "productID" : product["id"],
      "quantityType" : quantityType,
      "looseQuantityValue" : looseQuantity,
      "looseQuantityUnitName" : looseQuantityUnitName,
      "customQuantityName" : customQuantityName,
      "customQuantityUnits" : customQuantityUnits,
      "pieceQuantity" : pieceQuantity,
      "price": price
    };
  }



}