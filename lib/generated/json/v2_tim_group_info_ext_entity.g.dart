

import '../../extension/v2_tim_group_info_ext_entity.dart';
import 'base/json_convert_content.dart';

V2TimGroupInfoExtEntity $V2TimGroupInfoExtEntityFromJson(Map<String, dynamic> json) {
	final V2TimGroupInfoExtEntity v2TimGroupInfoExtEntity = V2TimGroupInfoExtEntity();
	final String? expireDate = jsonConvert.convert<String>(json['expire_date']);
	if (expireDate != null) {
		v2TimGroupInfoExtEntity.expireDate = expireDate;
	}
	final String? nameColour = jsonConvert.convert<String>(json['name_colour']);
	if (nameColour != null) {
		v2TimGroupInfoExtEntity.nameColour = nameColour;
	}
	final String? iconUrl = jsonConvert.convert<String>(json['icon_url']);
	if (iconUrl != null) {
		v2TimGroupInfoExtEntity.iconUrl = iconUrl;
	}
	final int? forbidBack = jsonConvert.convert<int>(json['forbid_back']);
	if (forbidBack != null) {
		v2TimGroupInfoExtEntity.forbidBack = forbidBack;
	}
	final int? higherStatus = jsonConvert.convert<int>(json['higher_status']);
	if (higherStatus != null) {
		v2TimGroupInfoExtEntity.higherStatus = higherStatus;
	}
	final int? noticeMode = jsonConvert.convert<int>(json['notice_mode']);
	if (noticeMode != null) {
		v2TimGroupInfoExtEntity.noticeMode = noticeMode;
	}
	final int? privateMode = jsonConvert.convert<int>(json['private_mode']);
	if (privateMode != null) {
		v2TimGroupInfoExtEntity.privateMode = privateMode;
	}
	final int? goodNumber = jsonConvert.convert<int>(json['good_number']);
	if (goodNumber != null) {
		v2TimGroupInfoExtEntity.goodNumber = goodNumber;
	}
	return v2TimGroupInfoExtEntity;
}

Map<String, dynamic> $V2TimGroupInfoExtEntityToJson(V2TimGroupInfoExtEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['expire_date'] = entity.expireDate;
	data['forbid_back'] = entity.forbidBack;
	data['higher_status'] = entity.higherStatus;
	data['notice_mode'] = entity.noticeMode;
	data['private_mode'] = entity.privateMode;
	data['good_number'] = entity.goodNumber;
	data['name_colour'] = entity.nameColour;
	data['icon_url'] = entity.iconUrl;
	return data;
}