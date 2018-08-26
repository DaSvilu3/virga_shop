import 'package:json_annotation/json_annotation.dart';


part 'user_address.g.dart';

@JsonSerializable()


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

  factory UserAddress.fromJson(Map<String,dynamic> json)=> _$UserAddressFromJson(json);

  Map<String,dynamic> toJson() => _$UserAddressToJson(this);
}