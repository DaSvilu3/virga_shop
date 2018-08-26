// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_quantity_unit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomQuantityUnit _$CustomQuantityUnitFromJson(Map<String, dynamic> json) {
  return CustomQuantityUnit(
      name: json['name'] as String,
      values: (json['values'] as List)
          ?.map((e) => e == null
              ? null
              : ProductQuantityValue.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$CustomQuantityUnitToJson(CustomQuantityUnit instance) =>
    <String, dynamic>{'name': instance.name, 'values': instance.values};
