//
//  Copyright © 2017 dahua. All rights reserved.
//

#ifndef DHPubDeviceDefine_h
#define DHPubDeviceDefine_h

/**
 枚举：设备类型
 */
typedef NS_ENUM(NSInteger, DeviceType) {
    DeviceTypeUnknown,
    DeviceTypeMultichannel, //多通道
    DeviceTypeBox,          //乐盒
    DeviceTypeCamera,       //摄像头
    DeviceTypeSubchannel,   //子通道
    DeviceTypeAg,           //报警网关
    DeviceTypeAp,           //网关配件
    DeviceTypeZb,           //盒子配件
    DeviceTypeTP1,          //TP1
    DeviceTypeTP1S,         //TP1S
    DeviceTypeTC5S,         //TC5S
    DeviceTypeIS,           //插座
    DeviceTypePIR,          //固定感应器
    DeviceTypeMV,           //移动感应器
    DeviceTypeWP2,          //无线红外探测器
    DeviceTypeWP3,          //无线幕帘探测器
    DeviceTypeWM1,          //移动感应器
    DeviceTypeWM2,          //移动感应器
    DeviceTypeWD1,          //门磁报警器
    DeviceTypeWR1,          //声光报警器
    DeviceTypeWT1,          //网关中继器
    DeviceTypeWE1,          //配件
    DeviceTypeWL1,          //配件
    DeviceTypeWS1,          //配件
    DeviceTypeSmartLock,    //门锁🚪
    DeviceTypeK5,           //云锁 K5
    DeviceTypeSAM,          //消防主机，类网关
    DeviceTypeSAK923,       //消防配件
    DeviceTypeGASK9A,       //消防配件
    DeviceTypeED,           //空气探测器
    DeviceTypeK8,           //K8 锁
	DeviceTypeK6S,          //K6s 锁
    DeviceTypeVD2,          //VD2
    
};
/**
 枚举：设备策略
 */
typedef NS_ENUM(NSUInteger, DeviceStrategy) {
    DeviceStrategyCamera,       //摄像头
    DeviceStrategyCameraGuard,  //带摄像头的网关
    DeviceStrategyCameraLock,   //带摄像头的门锁
    DeviceStrategyBox,          //盒子
    DeviceStrategySubchannel,   //子通道
    DeviceStrategyMultichannel, //多通道设备
    DeviceStrategyAg,           //报警网关
    DeviceStrategyZb,           //盒子配件
    DeviceStrategyAp,           //网关配件
    DeviceStrategyAD2,          //空气探测器
};

/**
 枚举：设备持有类型
 */
typedef NS_ENUM(NSUInteger, DeviceOwnType) {
    DeviceOwnTypeMine,      //自己设备
    DeviceOwnTypeShare,     //共享设备
    DeviceOwnTypeAuthority, //授权设备
};

/**
 枚举：设备异常类型
 */
typedef NS_ENUM(NSUInteger, DeviceAbnormalType) {
    DeviceAbnormalTypeNone,
    DeviceAbnormalTypeShare,     //他人共享
    DeviceAbnormalTypeAuthority, //他人授权
    DeviceAbnormalTypeOffLine,   //设备离线
    DeviceAbnormalTypeVersion,   //版本可升级
    DeviceAbnormalTypeSdCard,    //SD卡异常
    DeviceAbnormalTypePower,     //低电量
};

/// 设备平台状态
typedef NS_ENUM(NSInteger,DHPlatformType) {
    DHPlatformTypeDefault,  //对应乐橙及PasS平台
    DHPlatformTypeP2P,      //旧的p2p设备
    DHPlatformTypeEasy4ip,  //Easy4ip平台设备
};

typedef NS_ENUM(NSInteger,DHCloudChargeStatus) {
    DHCloudChargeStatusNone,  //没有云存储
    DHCloudChargeStatusUsing, //套餐使用中
    DHCloudChargeStatusUnopen,//未开通云存储
    DHCloudChargeStatusWillExpire,//即将过期
};

/// 云存储状态
typedef NS_ENUM(NSInteger,DHCloudStatus) {
    DHCloudStatusUnknown = -2,  // 未知状态，需要API获取
    DHCloudStatusUnopen = -1,   // 未开通
    DHCloudStatusOverdue =  0,  // 过期
    DHCloudStatusUsing =  1,    // 使用中
    DHCloudStatusPause =  2,    // 暂停
    DHCloudStatusWillExpire =  3,    //即将过期
};

/// sd卡状态,0:异常  1 正常   2 无SD卡   3 格式化中
typedef NS_ENUM(NSInteger,DHSdCardStatus) {
	DHSdCardStatusError = 0,
	DHSdCardStatusNomal = 1,
	DHSdCardStatusAbsent = 2,
	DHSdCardStatusFormatting = 3,
};

/// 遮罩状态,0:关闭遮罩  1：打开遮罩   -1：正在打开遮罩   -2：正在关闭遮罩
typedef NS_ENUM(NSInteger,DHMaskStatus) {
	DHMaskStatusClose = 0,
	DHMaskStatusOpen = 1,
	DHMaskStatusOpening = -1,
	DHMaskStatusClosing = -2,
};

/// 白光灯状态,0:未知  1：白光灯关闭  2：白光灯打开
typedef NS_ENUM(NSInteger, DHWhiteLightStatus) {
	DHWhiteLightStatusUnknown = 0,
	DHWhiteLightStatusOff = 1,
	DHWhiteLightStatusOn = 2,
};

/// 探照灯状态,0:未知  1：探照灯关闭  2：探照灯打开
typedef NS_ENUM(NSInteger, DHSearchLightStatus) {
    DHSearchLightStatusUnknown = 0,
    DHSearchLightStatusOff = 1,
    DHSearchLightStatusOn = 2,
};

/// 警笛状态,0:未知  1：警笛关闭  2：警笛打开
typedef NS_ENUM(NSInteger, DHSirenStatus) {
	DHSirenStatusUnknown = 0,
	DHSirenStatusOff = 1,
	DHSirenStatusOn = 2
};

/// 加密模式
typedef NS_ENUM(NSInteger, LCDeviceEncryptMode) {
    LCDeviceEncryptModeDefault = 0, //默认
    LCDeviceEncryptModeCustom = 1,  //自定义
};

/// 通道类型
typedef NS_ENUM(NSInteger, DHChannelType) {
    DHChannelTypeDefault = 0,   //默认
    DHChannelTypeAP = 1,        //配件
    DHChannelTypeBLE = 2,       // 蓝牙
};

/// 设备状态  0-设备离线  1-设备在线  3-设备升级中  5-设备休眠中
typedef NS_ENUM(NSUInteger, DHDeviceStatusMask) {
    DHDeviceStatusMaskOffLine = 0,
    DHDeviceStatusMaskOnLine = 1,
    DHDeviceStatusMaskUpdating = 3,
    DHDeviceStatusMaskSleeping = 5,
};

#endif /* DHPubDeviceDefine_h */
