import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:virga_shop/models/cart.dart';
import 'package:virga_shop/models/search_result.dart';
import 'package:virga_shop/globals.dart' as Globals;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virga_shop/models/user_address.dart';

class API {
  static const String tokenExpired = "Expired JWT Token";

  ///headers to post in every json http request.
  static const Map<String, String> jsonHeaders = {
    "Content-Type": "application/json",
    "Accept": "application/json"
  };

    
  ///
  /// Login to server with given username and password
  /// returns [http.Response]
  ///
  static Future<http.Response> login(String username, String password) async {
    var body = jsonEncode({"username": username, "password": password});

    return await http
        .post(Globals.Api.loginUrl, headers: jsonHeaders, body: body)
        .then((response) {
      return response;
    });
  }

  ///
  /// Register of the server with given credientials
  /// Email, phone, and password
  /// returns [http.response]
  static Future<http.Response> register(
      String email, String phone, String password) async {
    return await http.post(Globals.Api.registerUrl,
        headers: jsonHeaders,
        body:
            jsonEncode({'email': email, 'phone': phone, 'password': password}));
  }
  
  



  // -----------------------------------------------------------------------
  // all the functions down below here requires jwt authenctication
  // so becareful to pass the authentication everytime
  // a new [Request] is made. Other wise it throw a [401] [Bad Credentials]
  //========================================================================

  ///
  /// Reauthorize with the server with the credentials 
  /// provided by the user during first successful login
  /// by the user..
  ///
  static Future<bool> reAuth() async{

    String username;
    String password;

    print("ReAuth started....");

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    username = sharedPreferences.getString("_username");
    password = sharedPreferences.getString("_password");

    http.Response response = await login(username, password);

    if(response.statusCode == 200){
      dynamic jsonBody = jsonDecode(response?.body);
      if(jsonBody["token"]!=null){
        print("Reauth Successfully");
        await sharedPreferences.setString("token", jsonBody["token"]);
        return true;
      }
    }
    
    return false;

  }

  //Pass asll the get requests trough here to make sure
  //it doesn't fail after first authentication 

  static Future<http.Response> gatewayGet(String url) async {
    var token = await SharedPreferences
        .getInstance()
        .then((sharedPref) => sharedPref.get("token"));

    Map<String, String> headers = {"Authorization": "Bearer $token"};

    http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 401) {
      dynamic body = jsonDecode(response.body);
      if (body["message"] == tokenExpired) {        
        print("Token Expired");
        return reAuth().then((authenticated){
          if(authenticated){
            return gatewayGet(url);
          }
        });
      }
    }

    return response;
  }

  ///
  /// Load homepage
  /// returns [http.Response] contain encoded [Json] object
  ///
  static Future<http.Response> getHome() async {
    return gatewayGet(Globals.Api.homePageUrl);
  }

  ///
  /// Load Product from server
  /// returns [http.Response] contains encoded [Json] object
  ///
  static Future<http.Response> getProduct(String productID) async {
    return gatewayGet(Globals.Api.productsUrl + '/' + productID);
  }

  ///
  /// Get Category and its products
  ///
  static Future<http.Response> getCategory(String categoryID) async {
    return gatewayGet(Globals.Api.categoryUrl + '/' + categoryID);
  }

  ///
  ///
  /// Get User addresses
  ///
  ///
  static Future<http.Response> getCurrentUserAddresses() async{
    return gatewayGet(Globals.Api.currentUserAddressUrl);
  }


  ///
  /// Get user orders placed , including both normal and picture orders
  ///
  static Future<http.Response> getUserOrders() async{
    return gatewayGet(Globals.Api.currentUserOrdersUrl);
  } 



  ///Retreives search result for [String] query
  static Future<List<SearchResult>> search(String query) async {
    List<SearchResult> searchResults = new List();

    http.Response response =
        await gatewayGet(Globals.Api.searchUrl + "/" + query);

    try {
      Map<String, dynamic> items = jsonDecode(response.body);
      items.forEach((s, f) {
        searchResults.add(SearchResult.fromJson(f));
      });
    } catch (exception) {
      print(exception);
    }

    return searchResults;
  }




  ///method to post request, we pass them through this, 
  ///to make it possible to reauth and try again

  static Future<http.Response> postGateway(String url, dynamic body) async{
    var token = await SharedPreferences
        .getInstance()
        .then((sharedPref) => sharedPref.get("token"));

    Map<String, String> headers = {"Authorization": "Bearer $token"};

    http.Response response = await http.post(url, headers: headers,body: body);

    if (response.statusCode == 401) {
      dynamic body = jsonDecode(response.body);
      if (body["message"] == tokenExpired) {
        
        print("Token Expired");
        return await reAuth().then((authenticated){
          if(authenticated){
            return postGateway(url,body);
          }
        });
      }
    }

    return response;        
  }


  ///Method to place order from the cart items
  /// takes [API.url] string and [Cart] model 
  /// returns [http.Response
  static Future<http.Response> postOrder(Cart cart) async {
    return await postGateway(Globals.Api.placeOrderUrl, jsonEncode(cart));
  }


  ///Post a new User Address to current user profile
  /// Takes [models.UserAddress] and return [http.Response]
  static Future<http.Response> postAddress(UserAddress address) async{
    return await postGateway(Globals.Api.currentUserAddressUrl,jsonEncode(address));
  }


  ///
  /// Post picture order, 
  /// This is completely different from traditional request.
  ///
  static Future<bool> postPictureOrder(File image, String paymentMode, UserAddress shippingAddress) async{
    
    var url = Uri.parse(Globals.Api.pictureOrderUrl);

    http.MultipartRequest request = new http.MultipartRequest("POST", url);

    //get token
    var token = await SharedPreferences
        .getInstance()
        .then((sharedPref) => sharedPref.get("token"));


    //set headers
    Map<String, String> headers = {"Authorization": "Bearer $token"};
    request.headers.addAll(headers);

    //set fields
    Map<String,String> fields = {
      "paymentMode" : paymentMode,
      "shippingAddress" : jsonEncode(shippingAddress.toJson())
    };

    request.fields.addAll(fields);  

    request.files.add(new http.MultipartFile.fromBytes("image", image.readAsBytesSync(),filename: image.path));

    return await request.send().then((response){
      if(response.statusCode == 200){              
        return true;
      }else{
        return false;
      }
    });    
  }


}

