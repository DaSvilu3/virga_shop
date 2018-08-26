// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
      json['id'] as String,
      json['name'] as String,
      json['description'] as String,
      json['imageUrl'] as String,
      (json['categories'] as List)
          ?.map((e) => e == null
              ? null
              : ProductCategory.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['quantity'] == null
          ? null
          : ProductQuantity.fromJson(json['quantity'] as Map<String, dynamic>),
      json['seller'] == null
          ? null
          : User.fromJson(json['seller'] as Map<String, dynamic>),
      (json['keywords'] as List)
          ?.map((e) =>
              e == null ? null : Keyword.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['addedTime'] == null
          ? null
          : DateTime.parse(json['addedTime'] as String))
    ..lastEdited = json['lastEdited'] == null
        ? null
        : DateTime.parse(json['lastEdited'] as String);
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'categories': instance.categories,
      'quantity': instance.quantity,
      'seller': instance.seller,
      'keywords': instance.keywords,
      'addedTime': instance.addedTime?.toIso8601String(),
      'lastEdited': instance.lastEdited?.toIso8601String()
    };
