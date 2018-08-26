import 'package:json_annotation/json_annotation.dart';

part 'keyword.g.dart';

@JsonSerializable()

class Keyword{
  String keyword;
  String weight;

  Keyword(this.keyword,{this.weight});

  factory Keyword.fromJson(Map<String,dynamic> json)=> _$KeywordFromJson(json);

  Map<String,dynamic> toJson() => _$KeywordToJson(this);
}