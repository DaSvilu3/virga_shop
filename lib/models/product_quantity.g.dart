// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_quantity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductQuantity _$ProductQuantityFromJson(Map<String, dynamic> json) {
  return ProductQuantity(
      minimum: json['minimum'] as int,
      maximum: json['maximum'] as int,
      type: json['type'] as String,
      unitName: json['unitName'] as String,
      values: (json['values'] as List)
          ?.map((e) => e == null
              ? null
              : ProductQuantityValue.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      quantities: json['quantities'] as List);
}

Map<String, dynamic> _$ProductQuantityToJson(ProductQuantity instance) =>
    <String, dynamic>{
      'minimum': instance.minimum,
      'maximum': instance.maximum,
      'type': instance.type,
      'unitName': instance.unitName,
      'values': instance.values,
      'quantities': instance.quantities
    };
