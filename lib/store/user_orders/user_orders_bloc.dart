import 'package:virga_shop/models/user_order.dart';
import 'package:virga_shop/network/api.dart';
import 'dart:convert';

class UserOrdersBloc{

  UserOrdersBloc(){
    API.getUserOrders().then((response){
      if(response.statusCode == 200){       

        Map<String,dynamic> va = jsonDecode(response.body);

        List<UserOrder> userOrders = new List();
         va.forEach((f,v){
         userOrders.add(UserOrder.fromJson(v));
        });
       
        
      }
    });
  }
}