// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keyword.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Keyword _$KeywordFromJson(Map<String, dynamic> json) {
  return Keyword(json['keyword'] as String,
      weight: (json['weight'] as num)?.toDouble());
}

Map<String, dynamic> _$KeywordToJson(Keyword instance) =>
    <String, dynamic>{'keyword': instance.keyword, 'weight': instance.weight};
