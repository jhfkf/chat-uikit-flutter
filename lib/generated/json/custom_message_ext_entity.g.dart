
import '../../extension/custom_message_ext_entity.dart';
import 'base/json_convert_content.dart';

CustomMessageExtEntity $CustomMessageExtEntityFromJson(Map<String, dynamic> json) {
	final CustomMessageExtEntity customMessageExtEntity = CustomMessageExtEntity();
	final String? headUrl = jsonConvert.convert<String>(json['headUrl']);
	if (headUrl != null) {
		customMessageExtEntity.headUrl = headUrl;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		customMessageExtEntity.name = name;
	}
	final String? userId = jsonConvert.convert<String>(json['userId']);
	if (userId != null) {
		customMessageExtEntity.userId = userId;
	}
	final String? type = jsonConvert.convert<String>(json['type']);
	if (type != null) {
		customMessageExtEntity.type = type;
	}
	return customMessageExtEntity;
}

Map<String, dynamic> $CustomMessageExtEntityToJson(CustomMessageExtEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['headUrl'] = entity.headUrl;
	data['name'] = entity.name;
	data['userId'] = entity.userId;
	data['type'] = entity.type;
	return data;
}