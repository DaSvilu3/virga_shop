class SearchResult {
  String _id;
  String _name;
  String _description;
  String _imageUrl;
  dynamic _category;
  dynamic _quantity;

  SearchResult(this._id, this._name, this._description, this._imageUrl,
      this._category, this._quantity);

  SearchResult.fromJson(Map<String, dynamic> result)
      : _id = result["id"],
        _name = result["name"],
        _description = result["description"],
        _imageUrl = result["image_url"],
        _category = result["categories"],
        _quantity = result["quantity"];

  Map<String,dynamic> toJson()
  {
    return {
      "id" : _id,
      "name" : _name,
      "description" : _description,
      "image_url" : _imageUrl,
      "categories" : _category,
      "quantity" : _quantity
    };
  }

  String get id => _id;
  set id(String id) => _id = id;

  String get name => _name;
  set name(String name) => _name = name;

  String get description => _description;
  set description(String description) => _description = description;

  String get imageUrl => _imageUrl;
  set imageUrl(String imageUrl) => _imageUrl = imageUrl;

  dynamic get category => _category;
  set category(dynamic category) => _category = category;

  dynamic get quantity => _quantity;
  set quantity(dynamic quantity) => _quantity = quantity;
}
