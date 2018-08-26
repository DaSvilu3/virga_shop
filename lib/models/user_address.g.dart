// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAddress _$UserAddressFromJson(Map<String, dynamic> json) {
  return UserAddress(
      fullname: json['fullname'] as String,
      addressLine1: json['addressLine1'] as String,
      addressLine2: json['addressLine2'] as String,
      phoneNumber: json['phoneNumber'] as String,
      city: json['city'] as String,
      landmark: json['landmark'] as String,
      pincode: json['pincode'] as String);
}

Map<String, dynamic> _$UserAddressToJson(UserAddress instance) =>
    <String, dynamic>{
      'fullname': instance.fullname,
      'addressLine1': instance.addressLine1,
      'addressLine2': instance.addressLine2,
      'phoneNumber': instance.phoneNumber,
      'city': instance.city,
      'landmark': instance.landmark,
      'pincode': instance.pincode
    };
