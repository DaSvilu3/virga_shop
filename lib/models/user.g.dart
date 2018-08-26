// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(json['id'] as String, json['phone'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      isActive: json['isActive'] as bool,
      roles: json['roles'] as int,
      registrationDate: json['registrationDate'] == null
          ? null
          : DateTime.parse(json['registrationDate'] as String),
      addresses: (json['addresses'] as List)
          ?.map((e) => e == null
              ? null
              : UserAddress.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'phone': instance.phone,
      'password': instance.password,
      'isActive': instance.isActive,
      'roles': instance.roles,
      'registrationDate': instance.registrationDate?.toIso8601String(),
      'addresses': instance.addresses
    };
