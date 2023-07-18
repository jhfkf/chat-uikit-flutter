import 'package:tencent_cloud_chat_uikit/generated/json/base/json_convert_content.dart';
import 'package:tencent_cloud_chat_uikit/extension/request_result_entity.dart';

RequestResultEntity $RequestResultEntityFromJson(Map<String, dynamic> json) {
	final RequestResultEntity requestResultEntity = RequestResultEntity();
	final String? msg = jsonConvert.convert<String>(json['msg']);
	if (msg != null) {
		requestResultEntity.msg = msg;
	}
	final int? code = jsonConvert.convert<int>(json['code']);
	if (code != null) {
		requestResultEntity.code = code;
	}
	return requestResultEntity;
}

Map<String, dynamic> $RequestResultEntityToJson(RequestResultEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['msg'] = entity.msg;
	data['code'] = entity.code;
	return data;
}