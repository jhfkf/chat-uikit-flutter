
import 'dart:convert';

import '../generated/json/base/json_field.dart';
import '../generated/json/request_result_entity.g.dart';

@JsonSerializable()
class RequestResultEntity {

	String? msg;
	int? code;
  
  RequestResultEntity();

  factory RequestResultEntity.fromJson(Map<String, dynamic> json) => $RequestResultEntityFromJson(json);

  Map<String, dynamic> toJson() => $RequestResultEntityToJson(this);

  RequestResultEntity copyWith({String? msg, int? code}) {
      return RequestResultEntity()..msg= msg ?? this.msg
			..code= code ?? this.code;
  }
    
  @override
  String toString() {
    return jsonEncode(this);
  }
}