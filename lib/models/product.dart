import 'package:virga_shop/models/product_category.dart';

class Product{
  
  String id;
  String name;
  String description;
  String imageUrl;
  List<ProductCategory> categories;
  dynamic quantity;
  dynamic seller;
  dynamic keywords;
  DateTime addedTime;

  Product.fromJson(Map<String,Object> json):
    id = json["id"],
    name = json["name"],
    description = json["description"],
    imageUrl = json["imageUrl"],
    categories = (json["categories"] as List).map((category)=>ProductCategory.fromJson(category)).toList(),
    quantity = json["quantity"],
    seller = json["seller"],
    keywords = json["keywords"],
    addedTime = json ["addedTime"] ?? DateTime.now();

  Map<String,dynamic> toJson(){
    return {
      "id": id,
      "name" : name,
      "description" : description,
      "imageUrl" : imageUrl,
      "catergories": categories.map((item)=>item.toJson()).toList(),
      "quantity": quantity,
      "seller": seller,
      "keywords": keywords,
      "addedTime" :addedTime
    };
  }
}

class ProductQuantity{

  double maximum;
  double minimum;
  String type;

}