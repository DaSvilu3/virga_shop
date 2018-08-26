import 'package:json_annotation/json_annotation.dart';
import 'package:virga_shop/models/product_quantity_value.dart';

part 'product_quantity.g.dart';

@JsonSerializable()

class ProductQuantity{
  int minimum;
  int maximum;  
  String type;
  String unitName;
  List<ProductQuantityValue> values;
  List<dynamic> quantities;

  ProductQuantity({this.minimum,this.maximum,this.type,this.unitName,this.values,this.quantities});

  factory ProductQuantity.fromJson(Map<String,dynamic> json)=> _$ProductQuantityFromJson(json);

  Map<String,dynamic> toJson() => _$ProductQuantityToJson(this);
}