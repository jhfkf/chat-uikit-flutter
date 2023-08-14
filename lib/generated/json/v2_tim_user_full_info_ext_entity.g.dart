import 'package:tencent_cloud_chat_uikit/generated/json/base/json_convert_content.dart';
import 'package:tencent_cloud_chat_uikit/extension/v2_tim_user_full_info_ext_entity.dart';


V2TimUserFullInfoExtEntity $V2TimUserFullInfoExtEntityFromJson(Map<String, dynamic> json) {
	final V2TimUserFullInfoExtEntity v2TimUserFullInfoExtEntity = V2TimUserFullInfoExtEntity();
	final int? tagProfileCustomLock = jsonConvert.convert<int>(json['Tag_Profile_Custom_lock']);
	if (tagProfileCustomLock != null) {
		v2TimUserFullInfoExtEntity.tagProfileCustomLock = tagProfileCustomLock;
	}
	final int? tagProfileCustomSappid = jsonConvert.convert<int>(json['Tag_Profile_Custom_sappid']);
	if (tagProfileCustomSappid != null) {
		v2TimUserFullInfoExtEntity.tagProfileCustomSappid = tagProfileCustomSappid;
	}
	final int? tagProfileCustomSphone = jsonConvert.convert<int>(json['Tag_Profile_Custom_sphone']);
	if (tagProfileCustomSphone != null) {
		v2TimUserFullInfoExtEntity.tagProfileCustomSphone = tagProfileCustomSphone;
	}
	final String? tagProfileCustomUserid = jsonConvert.convert<String>(json['Tag_Profile_Custom_userid']);
	if (tagProfileCustomUserid != null) {
		v2TimUserFullInfoExtEntity.tagProfileCustomUserid = tagProfileCustomUserid;
	}
	final int? lock = jsonConvert.convert<int>(json['lock']);
	if (lock != null) {
		v2TimUserFullInfoExtEntity.lock = lock;
	}
	final int? sappid = jsonConvert.convert<int>(json['sappid']);
	if (sappid != null) {
		v2TimUserFullInfoExtEntity.sappid = sappid;
	}
	final int? sphone = jsonConvert.convert<int>(json['sphone']);
	if (sphone != null) {
		v2TimUserFullInfoExtEntity.sphone = sphone;
	}
	final String? userid = jsonConvert.convert<String>(json['userid']);
	if (userid != null) {
		v2TimUserFullInfoExtEntity.userid = userid;
	}
	final int? num = jsonConvert.convert<int>(json['num']);
	if (num != null) {
		v2TimUserFullInfoExtEntity.num = num;
	}
	final int? tagProfileCustomNum = jsonConvert.convert<int>(json['Tag_Profile_Custom_num']);
	if (tagProfileCustomNum != null) {
		v2TimUserFullInfoExtEntity.tagProfileCustomNum = tagProfileCustomNum;
	}
	return v2TimUserFullInfoExtEntity;
}

Map<String, dynamic> $V2TimUserFullInfoExtEntityToJson(V2TimUserFullInfoExtEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['Tag_Profile_Custom_lock'] = entity.tagProfileCustomLock;
	data['Tag_Profile_Custom_sappid'] = entity.tagProfileCustomSappid;
	data['Tag_Profile_Custom_sphone'] = entity.tagProfileCustomSphone;
	data['Tag_Profile_Custom_userid'] = entity.tagProfileCustomUserid;
	data['Tag_Profile_Custom_num'] = entity.tagProfileCustomNum;
	data['lock'] = entity.lock;
	data['sappid'] = entity.sappid;
	data['sphone'] = entity.sphone;
	data['userid'] = entity.userid;
	data['num'] = entity.num;
	return data;
}