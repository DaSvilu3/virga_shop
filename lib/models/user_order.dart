class OrderItem{
  double quantity;
  double amount;
  dynamic product;

  OrderItem.fromJson(Map<String,dynamic> json):
    quantity = json["quantity"].toDouble(),
    amount = json["amount"].toDouble(),
    product = json["product"];

  Map<String,dynamic> toJson(){
    return {
      "quantity" : quantity,
      "amount" :amount,
      "product" : product
    };
  }

}

class UserOrder{
  String id;
  DateTime createdTime;
  String status;
  String paymentMode;
  String imageUrl;
  String disc;
  List<OrderItem> orderItems;

  UserOrder.fromJson(Map<String,dynamic> json){
    id = json["id"];
    createdTime = DateTime.parse(json["created_time"]);
    status = json["status"];
    paymentMode = json["payment_mode"];
    disc = json["disc"];
    imageUrl = json["image_url"] ?? null;
    //orderItems =  json["order_items"]?.map((f)=>OrderItem.fromJson(f))?.toList();
    List<dynamic> c= json["order_items"] ?? null;
    orderItems = c?.map((f)=>OrderItem.fromJson(f))?.toList();
  }
  
  Map<String,dynamic> toJson(){
    return {
      "id": id,
      "createdTime" : createdTime.toString(),
      "status" : status,
      "paymentMode" : paymentMode,
      "imageUrl" : imageUrl,
      "disc" : disc,
      "orderItems" : orderItems?.map((f)=>f.toJson())?.toList()
    };
  }
}

