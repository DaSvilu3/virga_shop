import 'package:virga_shop/models/keyword.dart';
import 'package:virga_shop/models/product_category.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:virga_shop/models/product_quantity.dart';
import 'user.dart';

part 'product.g.dart';

@JsonSerializable()

class Product{
  
  String id;
  String name;
  String description;
  String imageUrl;
  List<ProductCategory> categories;
  ProductQuantity quantity;
  User seller;
  List<Keyword> keywords;
  DateTime addedTime;
  DateTime lastEdited;

  Product(this.id,this.name,this.description,this.imageUrl,this.categories,this.quantity,this.seller,this.keywords,this.addedTime);

  factory Product.fromJson(Map<String,dynamic> json)=> _$ProductFromJson(json);

  Map<String,dynamic> toJson() => _$ProductToJson(this);
}
