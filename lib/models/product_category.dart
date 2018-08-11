class ProductCategory{  
  
  String id;
  int categoryID;
  String name;
  List<dynamic> products;

  ProductCategory({this.id,this.categoryID,this.name,this.products});

  ProductCategory.fromJson(Map<String,dynamic> category)
    :id  = category["id"],
    categoryID = category["category_id"],
    name = category["name"],
    products = category["products"];

  Map<String,dynamic> toJson(){
    return {
      "id" : id,
      "category_id" : categoryID,
      "name" : name,
      "products" :products
    };
  }
    
  
}