class App{
  static const String TITLE = "MGM Mart";
}

class QuantityTypes{
  
  static const String looseQuantity = 'loose_quantity';

  static const String pieceQuantity = 'piece_quantity';

  static const String customQuantity = 'custom_quantity';

}

class Api{
  static const String URL = "http://10.0.2.2/VirgaMongo/public";
  static const String homePageUrl = URL+'/api/home';
  static const String searchUrl = URL+'/api/search';
}