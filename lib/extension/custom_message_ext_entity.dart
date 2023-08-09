
import 'dart:convert';

import '../generated/json/base/json_field.dart';
import '../generated/json/custom_message_ext_entity.g.dart';

@JsonSerializable()
class CustomMessageExtEntity {
	String? headUrl;
	String? name;
	String? userId;
	String? type;

	CustomMessageExtEntity();

	factory CustomMessageExtEntity.fromJson(Map<String, dynamic> json) => $CustomMessageExtEntityFromJson(json);

	Map<String, dynamic> toJson() => $CustomMessageExtEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}