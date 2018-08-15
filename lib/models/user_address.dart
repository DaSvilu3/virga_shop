class UserAddress{
  
  ///Fullname of the user
  String fullname;
  String addressLine1;
  String addressLine2;
  String phoneNumber;
  String city;
  String landmark;
  String pincode;

  UserAddress({this.fullname,this.addressLine1,this.addressLine2,this.phoneNumber,this.city,this.landmark,this.pincode});

  UserAddress.fromJson(Map<String,dynamic> json):
    fullname = json["fullname"],
    addressLine1 = json["address_line1"],
    addressLine2 = json["address_line2"] ?? null,
    phoneNumber = json["phone_number"],
    city = json["city"],
    landmark = json["landmark"] ?? null,
    pincode = json["pincode"];
  
  Map<String,dynamic> toJson() {
    return {
      "fullname" : fullname,
      "addressLine1" : addressLine1,
      "addressLine2" :addressLine2,
      "phoneNumber" : phoneNumber,
      "city" : city,
      "landmark" : landmark,
      "pincode" : pincode      
    };
    }

}