class App{
  static const String TITLE = "MGM Mart";
}

enum Status{
  loading,
  ready,
  error,
  retry,
  wait,
}

class QuantityTypes{
  
  static const String looseQuantity = 'loose_quantity';

  static const String pieceQuantity = 'piece_quantity';

  static const String customQuantity = 'custom_quantity';

}

class Api{
  static const String URL = "http://10.0.2.2/VirgaMongo/public";
  static const String productImageAssetUrl = URL + '/product/images';
  static const String pictureOrderAssetUrl = URL + '/picture_order/images';
  static const String loginUrl = URL+'/api/login_check';
  static const String homePageUrl = URL+'/api/home';
  static const String searchUrl = URL+'/api/search';
  static const String pictureOrderUrl = URL+'/api/picture_order/upload';
  static const String registerUrl = URL+'/api/register';
  static const String productsUrl = URL+'/api/products';
  static const String categoryUrl = URL+'/api/product_categories';
  static const String placeOrderUrl = URL + '/api/orders';
  static const String currentUserAddressUrl = URL + '/api/user/addresses';
  static const String currentUserOrdersUrl = URL + '/api/user/orders';
  
}

class PaymentModes{
  static const String cashOnDelivery = "cash_on_delivery";
  static const String pickBySelf = "pick_by_self";
}