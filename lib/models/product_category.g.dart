// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductCategory _$ProductCategoryFromJson(Map<String, dynamic> json) {
  return ProductCategory(
      id: json['id'] as String,
      categoryID: json['categoryID'] as int,
      name: json['name'] as String,
      products: (json['products'] as List)
          ?.map((e) =>
              e == null ? null : Product.fromJson(e as Map<String, dynamic>))
          ?.toList())
    ..parent = json['parent'] == null
        ? null
        : ProductCategory.fromJson(json['parent'] as Map<String, dynamic>)
    ..children = (json['children'] as List)
        ?.map((e) => e == null
            ? null
            : ProductCategory.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$ProductCategoryToJson(ProductCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categoryID': instance.categoryID,
      'name': instance.name,
      'parent': instance.parent,
      'children': instance.children,
      'products': instance.products
    };
