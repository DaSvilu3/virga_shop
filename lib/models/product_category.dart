import 'package:virga_shop/models/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_category.g.dart';

@JsonSerializable()


class ProductCategory{  
  
  String id;
  int categoryID;
  String name;
  ProductCategory parent;
  List<ProductCategory> children;
  List<Product> products;

  ProductCategory({this.id,this.categoryID,this.name,this.products});

  factory ProductCategory.fromJson(Map<String,dynamic> json) => _$ProductCategoryFromJson(json);

  Map<String,dynamic> toJson() => _$ProductCategoryToJson(this);
    
  
}