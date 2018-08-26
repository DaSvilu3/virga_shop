// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_quantity_value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductQuantityValue _$ProductQuantityValueFromJson(Map<String, dynamic> json) {
  return ProductQuantityValue(
      quantity: (json['quantity'] as num)?.toDouble(),
      price: (json['price'] as num)?.toDouble(),
      offerPrice: (json['offerPrice'] as num)?.toDouble());
}

Map<String, dynamic> _$ProductQuantityValueToJson(
        ProductQuantityValue instance) =>
    <String, dynamic>{
      'quantity': instance.quantity,
      'price': instance.price,
      'offerPrice': instance.offerPrice
    };
