import 'package:json_annotation/json_annotation.dart';
import 'package:virga_shop/models/product_quantity_value.dart';

part 'custom_quantity_unit.g.dart';

@JsonSerializable()

class CustomQuantityUnit{
  String name;
  List<ProductQuantityValue> values;

  CustomQuantityUnit({this.name,this.values});

  factory CustomQuantityUnit.fromJson(Map<String,dynamic> json)=> _$CustomQuantityUnitFromJson(json);

  Map<String,dynamic> toJson() => _$CustomQuantityUnitToJson(this);
}