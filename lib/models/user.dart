import 'package:json_annotation/json_annotation.dart';
import 'user_address.dart';

part 'user.g.dart';

@JsonSerializable()

class User{

  String id;
  String email;
  String phone;
  String password;
  bool isActive;
  int roles;
  DateTime registrationDate;
  List<UserAddress> addresses;
  
  User(this.id,this.phone,{this.email,this.password,this.isActive,this.roles,this.registrationDate,this.addresses});

  factory User.fromJson(Map<String,dynamic> json) => _$UserFromJson(json);

  Map<String,dynamic> toJson() => _$UserToJson(this);
}