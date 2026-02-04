//
//  Copyright (c) 2015年 Imou. All rights reserved.
//

#import "LCDevice.h"

#pragma mark - Device

@implementation LCDevice

- (instancetype)init
{
    if (self = [super init]) {
        self.apList = @[].mutableCopy;
        self.channelList = @[].mutableCopy;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    LCDevice *device =[LCDevice new];
    
    device.deviceID = self.deviceID;
    device.isOnline = self.isOnline;
    device.status = self.status;
    device.channelNum = self.channelNum;
    device.baseline = self.baseline;
    device.deviceModel = self.deviceModel;
    device.deviceCatalog = self.deviceCatalog;
    device.deviceBrand = self.deviceBrand;
    device.deviceVersion = self.deviceVersion;
    device.deviceName = self.deviceName;
    device.dmsIP = self.dmsIP;
    device.ability = self.ability;
    device.isNeedUpdate = self.isNeedUpdate;
    device.isSharedTo = self.isSharedTo;
    device.isSharedFrom = self.isSharedFrom;
    device.shareState = self.shareState;
    device.beShareToState = self.beShareToState;
    device.ownerUsername = self.ownerUsername;
    device.ownerNickname = self.ownerNickname;
    device.urlShareUser = self.urlShareUser;
    device.urlDeviceLogo = self.urlDeviceLogo;
    device.urlPano = self.urlPano;
    device.channelList = [self.channelList copy];
    device.apList = [self.apList copy];
    device.shareTime = self.shareTime;
    device.deviceCategory = self.deviceCategory;
    device.zbList = [self.zbList copy];
    device.encryptMode = self.encryptMode;
    device.agEnableState = self.agEnableState;
    device.paasFlag = self.paasFlag;
    device.deviceUsername = self.deviceUsername;
    device.devicePassword = self.devicePassword;
    device.airDetectionList = self.airDetectionList;

    return device;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.deviceID forKey:@"deviceID"];
    [aCoder encodeBool:self.isOnline forKey:@"isOnline"];
    [aCoder encodeInt:self.status forKey:@"status"];
    [aCoder encodeInt:self.channelNum forKey:@"channelNum"];
    [aCoder encodeObject:self.baseline forKey:@"baseline"];
    [aCoder encodeObject:self.deviceModel forKey:@"deviceModel"];
    [aCoder encodeObject:self.deviceCatalog forKey:@"deviceCatalog"];
    [aCoder encodeObject:self.deviceBrand forKey:@"deviceBrand"];
    [aCoder encodeObject:self.deviceVersion forKey:@"deviceVersion"];
    [aCoder encodeObject:self.deviceName forKey:@"deviceName"];
    [aCoder encodeObject:self.dmsIP forKey:@"dmsIP"];
    [aCoder encodeObject:self.ability forKey:@"ability"];
    [aCoder encodeBool:self.isNeedUpdate forKey:@"isNeedUpdate"];
    [aCoder encodeBool:self.isSharedTo forKey:@"isSharedTo"];
    [aCoder encodeBool:self.isSharedFrom forKey:@"isSharedFrom"];
    [aCoder encodeInt:self.shareState forKey:@"shareState"];
    [aCoder encodeInt:self.beShareToState forKey:@"beShareToState"];
    [aCoder encodeObject:self.ownerUsername forKey:@"ownerUsername"];
    [aCoder encodeObject:self.ownerNickname forKey:@"ownerNickname"];
    [aCoder encodeObject:self.urlShareUser forKey:@"urlShareUser"];
    [aCoder encodeObject:self.urlDeviceLogo forKey:@"urlDeviceLogo"];
    [aCoder encodeObject:self.urlPano forKey:@"urlPano"];
    [aCoder encodeObject:self.channelList forKey:@"channelList"];
    [aCoder encodeObject:self.apList forKey:@"apList"];
    [aCoder encodeInt64:self.shareTime forKey:@"shareTime"];
    [aCoder encodeObject:self.deviceCategory forKey:@"deviceCategory"];
    [aCoder encodeObject:self.zbList forKey:@"zbList"];
    [aCoder encodeInt:self.encryptMode forKey:@"encryptMode"];
    [aCoder encodeInt:self.agEnableState forKey:@"agEnableState"];
    [aCoder encodeInt:self.paasFlag forKey:@"passFlag"];
    [aCoder encodeObject:self.deviceUsername forKey:@"deviceUsername"];
    [aCoder encodeObject:self.devicePassword forKey:@"devicePassword"];
    [aCoder encodeObject:self.airDetectionList forKey:@"airDetectionList"];

}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self)
    {
        self.deviceID = [aDecoder decodeObjectForKey:@"deviceID"];
        self.isOnline = [aDecoder decodeBoolForKey:@"isOnline"];
        self.status = [aDecoder decodeIntForKey:@"status"];
        self.channelNum = [aDecoder decodeIntForKey:@"channelNum"];
        self.baseline = [aDecoder decodeObjectForKey:@"baseline"];
        self.deviceModel = [aDecoder decodeObjectForKey:@"deviceModel"];
        self.deviceCatalog = [aDecoder decodeObjectForKey:@"deviceCatalog"];
        self.deviceBrand = [aDecoder decodeObjectForKey:@"deviceBrand"];
        self.deviceVersion = [aDecoder decodeObjectForKey:@"deviceVersion"];
        self.deviceName = [aDecoder decodeObjectForKey:@"deviceName"];
        self.dmsIP = [aDecoder decodeObjectForKey:@"dmsIP"];
        self.ability = [aDecoder decodeObjectForKey:@"ability"];
        self.isNeedUpdate = [aDecoder decodeBoolForKey:@"isNeedUpdate"];
        self.isSharedTo = [aDecoder decodeBoolForKey:@"isSharedTo"];
        self.isSharedFrom = [aDecoder decodeBoolForKey:@"isSharedFrom"];
        self.shareState = [aDecoder decodeIntForKey:@"shareState"];
        self.beShareToState = [aDecoder decodeIntForKey:@"beShareToState"];
        self.ownerUsername = [aDecoder decodeObjectForKey:@"ownerUsername"];
        self.ownerNickname = [aDecoder decodeObjectForKey:@"ownerNickname"];
        self.urlShareUser = [aDecoder decodeObjectForKey:@"urlShareUser"];
        self.urlDeviceLogo = [aDecoder decodeObjectForKey:@"urlDeviceLogo"];
        self.urlPano = [aDecoder decodeObjectForKey:@"urlPano"];
        self.channelList = [aDecoder decodeObjectForKey:@"channelList"];
        self.apList = [aDecoder decodeObjectForKey:@"apList"];
        self.shareTime = [aDecoder decodeInt64ForKey:@"shareTime"];
        self.deviceCategory = [aDecoder decodeObjectForKey:@"deviceCategory"];
        self.zbList = [aDecoder decodeObjectForKey:@"zbList"];
        self.encryptMode = [aDecoder decodeIntForKey:@"encryptMode"];
        self.agEnableState = [aDecoder decodeIntForKey:@"agEnableState"];
        self.paasFlag = [aDecoder decodeIntForKey:@"passFlag"];
        self.deviceUsername = [aDecoder decodeObjectForKey:@"deviceUsername"];
        self.devicePassword = [aDecoder decodeObjectForKey:@"devicePassword"];
        self.airDetectionList = [aDecoder decodeObjectForKey:@"airDetectionList"];

    }
    return self;
}

@end
#pragma mark - LCAirDetection

@implementation LCAirDetection

- (id)copyWithZone:(NSZone *)zone {
    LCAirDetection *airDetec = [LCAirDetection new];
    airDetec.type = self.type;
    airDetec.value = self.value;
    airDetec.qualityType = self.qualityType;
    airDetec.unit = self.unit;
    return airDetec;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.value forKey:@"value"];
    [aCoder encodeObject:self.qualityType forKey:@"qualityType"];
    [aCoder encodeObject:self.unit forKey:@"unit"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self)
    {
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.value = [aDecoder decodeObjectForKey:@"value"];
        self.qualityType = [aDecoder decodeObjectForKey:@"qualityType"];
        self.unit = [aDecoder decodeObjectForKey:@"unit"];
    }
    return self;
}

@end


@implementation LCAirDetectReportData
- (id)copyWithZone:(NSZone *)zone {
    LCAirDetectReportData *airDetec = [LCAirDetectReportData new];
    airDetec.utcTime = self.utcTime;
    airDetec.value = self.value;
    airDetec.minValue = self.minValue;
    airDetec.maxValue = self.maxValue;
    airDetec.qualityType = self.qualityType;
    airDetec.type = self.type;
    
    return airDetec;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.utcTime forKey:@"utcTime"];
    [aCoder encodeObject:self.value forKey:@"value"];
    [aCoder encodeObject:self.minValue forKey:@"minValue"];
    [aCoder encodeObject:self.maxValue forKey:@"maxValue"];
    [aCoder encodeObject:self.qualityType forKey:@"qualityType"];
    [aCoder encodeObject:self.type forKey:@"type"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self)
    {
        self.utcTime = [aDecoder decodeObjectForKey:@"utcTime"];
        self.value = [aDecoder decodeObjectForKey:@"value"];
        self.minValue = [aDecoder decodeObjectForKey:@"minValue"];
        self.maxValue = [aDecoder decodeObjectForKey:@"maxValue"];
        self.qualityType = [aDecoder decodeObjectForKey:@"qualityType"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
        
    }
    return self;
}
@end

@implementation LCAirDetectAllData

- (id)copyWithZone:(NSZone *)zone {
    LCAirDetectAllData *airDetec = [LCAirDetectAllData new];
    airDetec.type = self.type;
    airDetec.minRange = self.minRange;
    airDetec.maxRange = self.maxRange;
    airDetec.percision = self.percision;
    airDetec.unit = self.unit;
    airDetec.mode = self.mode;
    airDetec.space = [self.space copy];
    
    return airDetec;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.minRange forKey:@"minRange"];
    [aCoder encodeObject:self.maxRange forKey:@"maxRange"];
    [aCoder encodeObject:self.percision forKey:@"percision"];
    [aCoder encodeObject:self.unit forKey:@"unit"];
    [aCoder encodeObject:self.mode forKey:@"mode"];
    [aCoder encodeObject:self.space forKey:@"space"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self)
    {
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.minRange = [aDecoder decodeObjectForKey:@"minRange"];
        self.maxRange = [aDecoder decodeObjectForKey:@"maxRange"];
        self.percision = [aDecoder decodeObjectForKey:@"percision"];
        self.unit = [aDecoder decodeObjectForKey:@"unit"];
        self.mode = [aDecoder decodeObjectForKey:@"mode"];
        self.space = [aDecoder decodeObjectForKey:@"space"];
    }
    return self;
}
@end


#pragma mark - Channel

@implementation LCChannel

- (instancetype)init {
	
	if (self = [super init]) {
		self.lc_userInfo = [NSMutableDictionary new];
	}
	
	return self;
}

- (id)copyWithZone:(NSZone *)zone {
    LCChannel *channel = [LCChannel new];
    
    channel.picurl = self.picurl;
    channel.channelID = self.channelID;
    channel.channelName = self.channelName;
    channel.deviceID = self.deviceID;
    channel.functions = self.functions;
    channel.channelAbility = self.channelAbility;
    channel.isSharedTo = self.isSharedTo;
    channel.beShareToState = self.beShareToState;
    channel.isOnline = self.isOnline;
    channel.sdCardStatus = self.sdCardStatus;
    channel.csStatus = self.csStatus;
    channel.csExpireTime = self.csExpireTime;
    channel.alarmStatus = self.alarmStatus;
    channel.remindStatus = self.remindStatus;
    channel.publicExpire = self.publicExpire;
    channel.publicToken = self.publicToken;
    channel.lastOffLineTime = self.lastOffLineTime;
    channel.csType = self.csType;
    channel.lc_shareState = self.lc_shareState;
    channel.encryptInfo = self.encryptInfo;
    channel.isCloseCamera = self.isCloseCamera;
	channel.lc_userInfo = self.lc_userInfo;
    return channel;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.picurl forKey:@"picurl"];
    [aCoder encodeInt:self.channelID forKey:@"channelID"];
    [aCoder encodeObject:self.channelName forKey:@"channelName"];
    [aCoder encodeObject:self.lastOffLineTime forKey:@"lastOffLineTime"];
    [aCoder encodeObject:self.csExpireTime forKey:@"csExpireTime"];
    [aCoder encodeObject:self.deviceID forKey:@"deviceID"];
    [aCoder encodeObject:self.functions forKey:@"functions"];
    [aCoder encodeObject:self.channelAbility forKey:@"channelAbility"];
    [aCoder encodeBool:self.isSharedTo forKey:@"isSharedTo"];
    [aCoder encodeInt:self.beShareToState forKey:@"beShareToState"];
    [aCoder encodeBool:self.isOnline forKey:@"isOnline"];
    [aCoder encodeInt:self.sdCardStatus forKey:@"sdCardStatus"];
    [aCoder encodeInt:self.csStatus forKey:@"csStatus"];
    [aCoder encodeInt:self.alarmStatus forKey:@"alarmStatus"];
    [aCoder encodeInt:self.remindStatus forKey:@"remindStatus"];
    [aCoder encodeInt64:self.publicExpire forKey:@"publicExpire"];
    [aCoder encodeObject:self.publicToken forKey:@"publicToken"];
    [aCoder encodeInt:self.csType forKey:@"csType"];
    [aCoder encodeInt:self.lc_shareState forKey:@"lc_shareState"];
    [aCoder encodeObject:self.encryptInfo forKey:@"encryptInfo"];
    [aCoder encodeInt:self.isCloseCamera forKey:@"isCloseCamera"];
	[aCoder encodeObject:self.lc_userInfo forKey:@"lc_userInfo"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self)
    {
        self.picurl = [aDecoder decodeObjectForKey:@"picurl"];
        self.channelID = [aDecoder decodeIntForKey:@"channelID"];
        self.channelName = [aDecoder decodeObjectForKey:@"channelName"];
        self.deviceID = [aDecoder decodeObjectForKey:@"deviceID"];
        self.functions = [aDecoder decodeObjectForKey:@"functions"];
        self.channelAbility = [aDecoder decodeObjectForKey:@"channelAbility"];
        self.isSharedTo = [aDecoder decodeBoolForKey:@"isSharedTo"];
        self.beShareToState = [aDecoder decodeIntForKey:@"beShareToState"];
        self.isOnline = [aDecoder decodeBoolForKey:@"isOnline"];
        self.sdCardStatus = [aDecoder decodeIntForKey:@"sdCardStatus"];
        self.csStatus = [aDecoder decodeIntForKey:@"csStatus"];
        self.csExpireTime = [aDecoder decodeObjectForKey:@"publicExpire"];
        self.alarmStatus = [aDecoder decodeIntForKey:@"alarmStatus"];
        self.remindStatus = [aDecoder decodeIntForKey:@"remindStatus"];
        self.publicExpire = [aDecoder decodeInt64ForKey:@"publicExpire"];
        self.publicToken = [aDecoder decodeObjectForKey:@"publicToken"];
        self.csType = [aDecoder decodeIntForKey:@"csType"];
        self.lc_shareState = [aDecoder decodeIntForKey:@"lc_shareState"];
        self.encryptInfo = [aDecoder decodeObjectForKey:@"encryptInfo"];
        self.isCloseCamera = [aDecoder decodeIntForKey:@"isCloseCamera"];
		self.lc_userInfo = [aDecoder decodeObjectForKey:@"lc_userInfo"];
        self.lastOffLineTime = [aDecoder decodeObjectForKey:@"lastOffLineTime"];
    }
    return self;
}

- (id)lc_generateLCChannel {
	//在上层扩展中实现功能
	return nil;
}

#pragma mark - KVC
- (id)valueForUndefinedKey:(NSString *)key {
	return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
	
}

@end

#pragma mark - Other

@implementation LCDeviceShareInfo

@end

@implementation LCDeviceUpdateVersionList

@synthesize description, deviceId, version, url;

@end

//@implementation LCDeviceUpgradeInfo
//
//@synthesize status, version, percent;
//
//@end

@implementation LCDeviceWifiInfo

@synthesize enabled, deviceID;

@end

@implementation LCDeviceWifiStatus

@synthesize auth, SSID, BSSID, linkStatus, intensity;

@end


@implementation LCZBDevicePowerConsumptionMessage
@end

@implementation LCDevicePowerConsumptionMessage
@end

@implementation LCUserPowerConsumptionMessage
@end

@implementation LCChannelAlarmPlan

@synthesize channelID;

@end

@implementation LCAlarmRule

@synthesize period, beginTime, endTime, enable, bPlus;

- (id)copyWithZone:(NSZone *)zone {
    LCAlarmRule *rule = [[self class] allocWithZone:zone];
    rule.period = self.period;
    rule.beginTime = self.beginTime;
    rule.endTime = self.endTime;
    rule.enable = self.enable;
    rule.bPlus = self.bPlus;
    return rule;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    LCAlarmRule *rule = [[self class] allocWithZone:zone];
    rule.period = self.period;
    rule.beginTime = self.beginTime;
    rule.endTime = self.endTime;
    rule.enable = self.enable;
    rule.bPlus = self.bPlus;
    return rule;
}

@end

@implementation LCAlarmMode

@end

@implementation DeviceModelInfo

@end
@implementation PublicLiveInfo

@end
@implementation PublicLiveStream

@end

@implementation VideoParameter

@end

@implementation LCPermission

@end

@implementation LCWifiAutoPairInfo

@end

@implementation LCDeviceSharer

@end

@implementation LCWeatherInfo

@end

@implementation LCMotionDetectRulesInfo

@end

@implementation LCUnbindDeviceApplyListInfo

- (id)copyWithZone:(NSZone *)zone {
    LCUnbindDeviceApplyListInfo *applyInfo =[LCUnbindDeviceApplyListInfo new];
    
    applyInfo.deviceCode = self.deviceCode;
    applyInfo.applyID = self.applyID;
    applyInfo.status = self.status;
    applyInfo.startTime = self.startTime;
    applyInfo.updateTime = self.updateTime;
    
    return applyInfo;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.deviceCode forKey:@"deviceCode"];
    [aCoder encodeInt64:self.applyID forKey:@"applyID"];
    [aCoder encodeInt:self.status forKey:@"status"];
    [aCoder encodeInt64:self.startTime forKey:@"startTime"];
    [aCoder encodeInt64:self.updateTime forKey:@"updateTime"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self)
    {
        self.deviceCode = [aDecoder decodeObjectForKey:@"deviceCode"];
        self.applyID = [aDecoder decodeInt64ForKey:@"applyID"];
        self.status = [aDecoder decodeIntForKey:@"status"];
        self.startTime = [aDecoder decodeInt64ForKey:@"startTime"];
        self.updateTime = [aDecoder decodeInt64ForKey:@"updateTime"];
    }
    return self;
}


@end

@implementation LCUnbindDeviceApplyInfo


@end

@implementation LCUnbindDeviceApplicationInfo


@end

@implementation LCGetDevModelInfo

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt64:self.modelId forKey:@"modelId"];
    [aCoder encodeObject:self.modelName forKey:@"modelName"];
    [aCoder encodeObject:self.deviceModel forKey:@"deviceModel"];
    [aCoder encodeObject:self.logoUrl forKey:@"logoUrl"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self)
    {
        self.modelId = [aDecoder decodeInt64ForKey:@"modelId"];
        self.modelName = [aDecoder decodeObjectForKey:@"modelName"];
        self.deviceModel = [aDecoder decodeObjectForKey:@"deviceModel"];
        self.logoUrl = [aDecoder decodeObjectForKey:@"logoUrl"];
    }
    return self;
}

@end

@implementation LCGetDevModelInfoList
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt64:self.timeStamp forKey:@"timeStamp"];
    [aCoder encodeObject:self.modelsArray forKey:@"modelsArray"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self)
    {
        self.timeStamp = [aDecoder decodeInt64ForKey:@"timeStamp"];
        self.modelsArray = [aDecoder decodeObjectForKey:@"modelsArray"];
    }
    return self;
}

@end


@implementation LCPanoUrlInfo

@end

@implementation LCDeviceCuriseInfo: NSObject

@end

@implementation LCDeviceCollectionInfo: NSObject

@end

@implementation LCDeviceCuriseConfig: NSObject
@end

@implementation LCShareStrategy: NSObject
@end

@implementation LCDevShareStrategy: NSObject
@end

@implementation LCReportStatisticData: NSObject
@end

@implementation LCReportStatisticNode :NSObject
@end

@implementation LCReportStrategy:NSObject
@end

@implementation LCStrategyDetail:NSObject
@end

@implementation LCOneDayStrategy:NSObject
@end

@implementation LCDevCloudStrategy:NSObject
@end

@implementation LCSnapKeyInfo:NSObject
@end

@implementation LCKeyEffectPeriod:NSObject
@end

@implementation LCSecretKeyInfo:NSObject
@end

@implementation LCHoveringAlarmInfo:NSObject
@end

@implementation LCDevicePowerInfo:NSObject
@end

@implementation LCDeviceFlushCellInfo:NSObject
@end

@implementation LCDeviceFlushInfo:NSObject
@end

@implementation LCDeviceGearInfo
@end

@implementation LCDeviceMotionDetectInfo
@end

@implementation LCQuerySirenStateResultObject
@end

@implementation LCDeviceZoomFocusInfo
@end

@implementation LCDeviceWifiStateFromServer
@end

@implementation LCDeviceWifiForRemoteDevice
@end

@implementation LCDeviceBatteryElectric
@end

@implementation LCDeviceRemoteDeviceElectric
@end

@implementation LCMotionDetectParamInfo
@end

@implementation LCSirenTimeInfo
@end

//MARK: 设备添加融合

@implementation LCUserDeviceBindInfo

- (instancetype)init {
    if (self = [super init]) {
        self.deviceExist = @"";
        self.bindStatus = @"";
        self.userAccount = @"";
        self.wifiConfigMode = @"";
        self.wifiTransferMode = @"";
        self.status = @"";
        self.deviceModel = @"";
        self.ability = @"";
        self.bindStatus = @"";
        self.bindStatus = @"";
        self.catalog = @"";
//        self.accessType = @"";
        self.brand = @"";
        self.family = @"";
        self.modelName = @"";
        self.type = @"";
        self.deviceType = @"";
    }
    return self;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"deviceModel":@"deviceCodeModel",@"modelName":@"deviceModelName"};
}

/// iot设备
- (BOOL)isIotDevice {
    return self.productId != nil && self.productId.length > 0;
}

@end


@implementation LCBindDeviceSuccess

@end

@implementation LCDeviceTimeZone

- (NSInteger)areaIndex {
	return _area.integerValue;
}

- (NSInteger)timeZoneIndex {
	return _timeZone.integerValue;
}

+ (NSString *)dstTimeFormat {
	return @"MM-dd HH:mm:ss";
}

@end

@implementation LCDeviceTimeZoneQueryInfo

-(BOOL)isDayModel
{
    if ([self.mode isEqualToString:@"day"]) {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(BOOL)isWeekModel
{
    if ([self.mode isEqualToString:@"week"]) {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end

@implementation LCSearchLightWorkMode

@end

@implementation LCSearchLightModel

@end

@implementation LCLightTimeModel

@end

@implementation LCLightTimeWorkMode

@end

@implementation LCSirenContentModel

@end

@implementation LCSirenChannelModel
@end

@implementation LCSirenResponseModel
@end

@implementation LCBellContentModel
@end

@implementation LCIntelligentlockNotesInfo

- (NSString *)localKeyType {
    if ([self.keyType isEqualToString:@"card"]) {
        return @"card".lc_T;
    } else if ([self.keyType isEqualToString:@"fingerPrint"]) {
        return @"fingerprint".lc_T;
    } else if ([self.keyType isEqualToString:@"password"]) {
        return @"password".lc_T;
    } else if ([self.keyType isEqualToString:@"face"]) {
        return @"face".lc_T;
    }
    return self.keyType;
}

- (NSString *)localOperateType {
    if ([self.operateType isEqualToString:@"add"]) {
        return @"user_addition".lc_T;
    } else if ([self.operateType isEqualToString:@"delete"]) {
        return @"user_deletion".lc_T;
    } else if ([self.operateType isEqualToString:@"deleteAll"]) {
        return @"delete_all".lc_T;
    } else if ([self.operateType isEqualToString:@"modify"]) {
        return @"user_modification".lc_T;
    } else if ([self.operateType isEqualToString:@"login"]) {
        return @"User_Mode_Login_Title".lc_T;
    } else {
        return @"user_addition".lc_T;
    }
}

@end

@implementation NVMMode
@end

@implementation NVMChannelMode
@end

@implementation LCIntroductionContentItem
@end
