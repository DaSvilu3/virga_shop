class SearchResult {
  String id;
  String name;
  String description;
  String imageUrl;
  dynamic category;
  dynamic quantity;

  SearchResult(this.id, this.name, this.description, this.imageUrl,
      this.category, this.quantity);

  SearchResult.fromJson(Map<String, dynamic> result)
      : id = result["id"],
        name = result["name"],
        description = result["description"],
        imageUrl = result["image_url"],
        category = result["categories"],
        quantity = result["quantity"];

  Map<String,dynamic> toJson()
  {
    return {
      "id" : id,
      "name" : name,
      "description" : description,
      "image_url" : imageUrl,
      "categories" : category,
      "quantity" : quantity
    };
  }

  
}
