import 'package:json_annotation/json_annotation.dart';

part 'product_quantity_value.g.dart';

@JsonSerializable()

class ProductQuantityValue{
  
  double quantity;
  double price;
  double offerPrice;

  ProductQuantityValue({this.quantity,this.price,this.offerPrice});
  
  factory ProductQuantityValue.fromJson(Map<String,dynamic> json) => _$ProductQuantityValueFromJson(json);

  Map<String,dynamic> toJson() => _$ProductQuantityValueToJson(this);
}