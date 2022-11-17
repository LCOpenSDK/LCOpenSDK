//
//  Copyright © 2019 Imou. All rights reserved.
//

#ifndef TextDefine_h
#define TextDefine_h

/// 设置的时区对应索引值
static NSString * const KEY_AREAINDEX = @"areaIndex";
/// 设备所在时区
static NSString * const KEY_TIMEZONE = @"timeZone";
/// 夏令时开始时间
static NSString * const KEY_BEGIN_SUMMERTIME = @"beginSunTime";
/// 夏令时结束时间
static NSString * const KEY_END_SUMMERTIME = @"endSunTime";
/// 设备大类
static NSString * const KEY_DEVICE_TYPE = @"deviceType";
/// 设备市场型号
static NSString * const KEY_DEVICE_MODEL = @"deviceModel";
/// 扫描的设备市场型号
static NSString * const KEY_DT = @"deviceCodeModel";
/// 扫描的设备市场名称
static NSString * const KEY_DEVICE_MODEL_NAME = @"deviceModelName";
/// 扫描的设备市场名称
static NSString * const KEY_NC_CODE = @"ncCode";
/// 设备序列号
static NSString * const KEY_DEVICE_ID = @"deviceId";
/// 设备序列号
static NSString * const KEY_OPENID_ID = @"openid";
/// 验证码
static NSString * const KEY_CODE = @"code";
/// 通道号
static NSString * const KEY_CHANNEL_ID = @"channelId";
/// 是否有效
static NSString * const KEY_ENABLE = @"enable";
/// 状态
static NSString * const KEY_STATUS = @"status";
/// 设备翻转状态
static NSString * const KEY_DIRECTION = @"direction";
/// url地址
static NSString * const KEY_URL = @"url";
/// 结果
static NSString * const KEY_RESULT = @"result";
/// OSD
static NSString * const KEY_OSD = @"osd";
/// 图片数据
static NSString * const KEY_PICTURE_DATA = @"pictureData";
/// token
static NSString * const KEY_TOKEN = @"token";
/// 操作行为
static NSString * const KEY_OPERATION = @"operation";
/// 持续时间
static NSString * const KEY_DURATION = @"duration";
/// 上次查询最后一个ID
static NSString * const KEY_BINDID = @"bindId";
/// 取值范围
static NSString * const KEY_QUERYRANGE = @"queryRange";
/// 条数
static NSString * const KEY_LIMIT = @"limit";
/// 类型
static NSString * const KEY_TYPE = @"type";
/// 分页查询的数量
static NSString * const KEY_COUNT = @"count";
/// 需要配件列表
static NSString * const KEY_NEEDAPINFO = @"needApInfo";
/// oms更新时间
static NSString * const KEY_UPDATETIME = @"updateTime";
/// 名称
static NSString * const KEY_NAME = @"name";
/// 设备列表
static NSString * const KEY_DEVICES = @"deviceIds";
/// 通道列表
static NSString * const KEY_CHANNELS = @"channelList";
/// 配件ID列表
static NSString * const KEY_APLIST = @"apList";
/// 设备列表
static NSString * const KEY_DEVICE_LIST = @"deviceList";

/// 开始时间
static NSString * const KEY_BEGIN_TIME = @"beginTime";

/// 结束时间
static NSString * const KEY_END_TIME = @"endTime";

/// 产品唯一标识符
static NSString * const KEY_PRODUCT_ID = @"productId";

/// 语言类型
static NSString * const KEY_LANGUAGE = @"language";

/// 下一报警Id
static NSString * const KEY_NEXTALARMID = @"nextAlarmId";

/// 报警消息id
static NSString * const KEY_ALARMID = @"indexId";

/// 使能类型
static NSString * const KEY_ENABLETYPE = @"enableType";

#endif /* TextDefine_h */
