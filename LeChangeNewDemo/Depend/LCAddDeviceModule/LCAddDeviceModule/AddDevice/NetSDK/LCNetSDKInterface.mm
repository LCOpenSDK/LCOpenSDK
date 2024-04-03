//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

#import "LCNetSDKInterface.h"
#import <LCBaseModule/LCClientEventLogHelper.h>
#import <LCBaseModule/LCFileManager.h>
#import <LCBaseModule/NSString+Imou.h>
#import <LCBaseModule/NSObject+JSON.h>

///// 网卡类型

@interface LCNetSDKInterface()
@property (nonatomic, copy) LCNetSDKSearchDeviceCallback searchCallback;
@property (nonatomic, copy) LCNetSDKDisconnetCallback disconnectCallback;
@end

@implementation LCNetSDKInterface

+ (instancetype)sharedInstance {
	static dispatch_once_t onceToken;
	static LCNetSDKInterface *instance = nil;
	dispatch_once(&onceToken, ^{
		instance = [[self alloc] init];
	});
	return instance;
}

+ (void)initSDK {
//    [LCOpenSDK_Netsdk initSDKWithCallback:^(long loginHandle, NSString *ip, NSInteger port) {
//        if ([LCNetSDKInterface sharedInstance].disconnectCallback) {
//            [LCNetSDKInterface sharedInstance].disconnectCallback(loginHandle, ip, port);
//            // 发送断开连接通知
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"LCNotificationLocalNetworkDisconnect" object:nil userInfo:@{@"IP":ip}];
//        }
//    }];
}

+ (void)startNetSDKReportByRequestId:(NSString *)requestId{
    
    LCNetSDKInterface.sharedInstance.requestId = requestId;
    
    NSString *path = [[LCFileManager supportFolder] stringByAppendingPathComponent:@"cache"];
    [LCNetSDKInterface logOpen: path];
}

+ (void)logOpen:(NSString *)path {
    [LCOpenSDK_Netsdk logOpen:path callback:^(const char *szLogBuffer, unsigned int nLogSize, long dwUser) {
        NSString *content = [NSString stringWithUTF8String:szLogBuffer];
        NSDictionary *jsonDic = [content lc_jsonDictionary];
        NSString *type = jsonDic[@"type"];
        NSDictionary *contentDic = jsonDic[@"log"];
        NSMutableDictionary *contentMutableDic = contentDic.mutableCopy;
        NSString *requestId = [LCNetSDKInterface sharedInstance].requestId;
        if(requestId){
            contentMutableDic[@"requestId"] = requestId;
        }
        
        [[LCClientEventLogHelper shareInstance] addClientEventLog:type conent:contentMutableDic];
    }];
}

+ (void)stopNetSDKReport {
    [LCOpenSDK_Netsdk logClose];
}

- (void)setDisconnectCallback:(LCNetSDKDisconnetCallback)callback {
	_disconnectCallback = nil;
	_disconnectCallback = callback;
}

+ (LCDeviceInfoLogModel *)initDevAccount:(NSString *)password device:(LCOpenSDK_SearchDeviceInfo *)deviceNetInfo useIp:(BOOL)useIp {
	if(useIp) {
		return [self private_initDevAccountUseIp:password device:deviceNetInfo];
	}
	
	return [self private_initDevAccount:password device:deviceNetInfo];
}

+ (LCDeviceInfoLogModel *)private_initDevAccount:(NSString *)password device:(LCOpenSDK_SearchDeviceInfo *)deviceNetInfo {
	if(password.length == 0) {
		return nil;
	}
    BOOL ret = [LCOpenSDK_DeviceInit initDev:deviceNetInfo.mac byPwdResetWay:deviceNetInfo.byPWDResetWay initStatus:deviceNetInfo.initStatus passWord:password ip:nil];

	return [self setupModelData:deviceNetInfo isSuccess:ret];
}

+ (LCNetsdkDevInfo *)convertDeviceInfoWithPassword:(NSString *)password devNetInfo:(LCDeviceNetInfo *)devInfo {
    LCNetsdkDevInfo *netsdkDevInfo = [[LCNetsdkDevInfo alloc] init];
    netsdkDevInfo.passWord = password;
    netsdkDevInfo.deviceMac = devInfo.deviceMac;
    netsdkDevInfo.initStatus = devInfo.initStatus;
    netsdkDevInfo.byPWDResetWay = devInfo.byPWDResetWay;
    netsdkDevInfo.deviceIP = devInfo.deviceIP;
    return netsdkDevInfo;
}

+ (LCDeviceInfoLogModel *)private_initDevAccountUseIp:(NSString *)password device:(LCOpenSDK_SearchDeviceInfo *)deviceNetInfo {
	if(deviceNetInfo.ip.length == 0 || password.length == 0) {
		return nil;
	}

    BOOL ret = [LCOpenSDK_DeviceInit initDev:deviceNetInfo.mac byPwdResetWay:deviceNetInfo.byPWDResetWay initStatus:deviceNetInfo.initStatus passWord:password ip:deviceNetInfo.ip];
    return [self setupModelData:deviceNetInfo isSuccess:ret];
}

//上报设备初始化log需要
+ (LCDeviceInfoLogModel *)setupModelData:(LCOpenSDK_SearchDeviceInfo *)deviceNetInfo isSuccess:(BOOL)isSuccess
{
    LCDeviceInfoLogModel *model = [[LCDeviceInfoLogModel alloc]init];
    model.isSuccess         = isSuccess;
    model.mac               = deviceNetInfo.mac;
    model.pwdResetWay       = deviceNetInfo.byPWDResetWay;
    model.isNewDeviceVersion = !(deviceNetInfo.deviceInitType == LCDeviceInitTypeOldDevice);
    model.isEffectiveIP     = deviceNetInfo.deviceInitType == LCDeviceInitTypeIPEnable;
    model.ip                = deviceNetInfo.ip;
    return model;
}

- (void)startSearchDevices:(LCNetSDKSearchDeviceCallback)callback {
	if (self.searchCallback == nil) {
		self.searchCallback = callback;
	}
	
    [[LCOpenSDK_SearchDevices shareSearchDevices] startSearchDevicesWithDeviceId:nil timeOut:-1 callback:^(LCOpenSDK_SearchDeviceInfo *deviceInfo) {
        LCDeviceNetInfo *netInfo = [[LCDeviceNetInfo alloc] initWithNetInfo: deviceInfo];
        netInfo.isVaild = YES;
        self.searchCallback(netInfo);
    }];
}

- (void)stopSearchDevices {
	self.searchCallback = nil;
    [[LCOpenSDK_SearchDevices shareSearchDevices] stopSearchDevices];
}

+ (void)logout:(long)loginHandle {
    [LCOpenSDK_Netsdk logout:loginHandle];
	NSLog(@" %@:: Logout by login handle %ld", NSStringFromClass([self class]), loginHandle);
}

#pragma mark - Query WifiInfo

+ (LCOpenSDK_WifiInfo*)queryWifiByLoginHandle:(long)loginHandle mssId:(NSString *)mssid errorCode:(unsigned int *)errorCode {
    return [LCOpenSDK_SoftApConfig queryWifiByLoginHandle:loginHandle mssId:mssid errorCode:errorCode];
}


#pragma mark - Encryption Convert

+ (unsigned int)getLastError {
    return [LCOpenSDK_SearchDevices getLastError];
}

#pragma mark - Production
+ (LCDeviceProductDefinition *)queryProductDefinitionInfo:(long)loginHandle {

	
	LCDeviceProductDefinition *definition = nil;
    LCNetsdkProductDefinition *netsdkDefinition = nil;
    
    netsdkDefinition = [LCOpenSDK_Netsdk queryProductDefinitionInfo:loginHandle];
	
	if (netsdkDefinition) {
		definition = [LCDeviceProductDefinition new];
		definition.wlanScanConfigType = netsdkDefinition.wlanScanConfigType;
		definition.hasPtz = netsdkDefinition.hasPtz;
	}
	
	return definition;
}

+ (LCDeviceUserInfoDefinition *)queryDeviceUserInfo:(long)loginHandle {
    
    LCDeviceUserInfoDefinition *definition = [LCDeviceUserInfoDefinition new];
    definition.hasPtzAuth = [LCOpenSDK_Netsdk queryDevicePtzAuth:loginHandle];
    
    return definition;
}

+ (BOOL)querySupportWlanConfigV3:(long)loginHandle {
    return [LCOpenSDK_SoftApConfig querySupportWlanConfigV3:loginHandle];
}

//MARK: Device Password Reset
+ (LCDeviceResetPWDInfo *)queryPasswordResetType:(LCDeviceNetInfo *)device byPhoneIp:(NSString *)phoneIp {
    LCNetsdkDevInfo *devInfo = [[LCNetsdkDevInfo alloc] init];
    devInfo.deviceMac = device.mac;
    devInfo.devicePwdResetWay = device.devicePwdResetWay;
    devInfo.byPWDResetWay = device.byPWDResetWay;
    devInfo.initStatus = device.initStatus;
    
    return [LCOpenSDK_Netsdk queryPasswordResetType:devInfo byPhoneIp:phoneIp];
}

+ (LCDevicePWDResetInfo *)resetPassword:(NSString *)password
			   device:(LCDeviceNetInfo *)device
		 securityCode:(NSString *)securityCode
			  contact:(NSString *)contact
		  useAsPreset:(BOOL)useAsPreset
			byPhoneIp:(NSString *)phoneIp {
    LCNetsdkDevInfo *devInfo = [[LCNetsdkDevInfo alloc] init];
    devInfo.deviceMac = device.mac;
    devInfo.initStatus = device.initStatus;
    devInfo.byPWDResetWay = device.byPWDResetWay;
    return [LCOpenSDK_Netsdk resetPassword:password device:devInfo securityCode:securityCode contact:contact useAsPreset:useAsPreset byPhoneIp:phoneIp];
}

//MARK:Private
+ (NSString *)private_stringWithUTF8:(char *)utf8 {
	if (utf8 == NULL) {
		return @"";
	}
	
	return [NSString stringWithUTF8String:utf8];
}

//MARK: Error
+ (NSString *)getErrorDescription:(unsigned int)erroCode
{
    NSString *strError = nil;
    switch (erroCode) {
        case LC_NET_USER_FLASEPWD:
        case LC_NET_LOGIN_ERROR_PASSWORD:
        case LC_NET_LOGIN_ERROR_USER_OR_PASSOWRD:
            strError = @"login_user_or_pwd_error";
            break;
        case LC_NET_LOGIN_ERROR_USER:
            strError = @"login_user_not_exist";
            break;
        case LC_NET_LOGIN_ERROR_TIMEOUT:
            strError = @"login_timeout";
            break;
        case LC_NET_LOGIN_ERROR_RELOGGIN:
            strError = @"login_user_logined";
            break;
        case LC_NET_LOGIN_ERROR_LOCKED:
            strError = @"login_user_locked";
            break;
        case LC_NET_LOGIN_ERROR_BLACKLIST:
            strError = @"login_user_in_black_list";
            break;
        case LC_NET_LOGIN_ERROR_BUSY:
            strError = @"login_system_busy";
            break;
        case LC_NET_LOGIN_ERROR_CONNECT:
            strError = @"login_timeout";
            break;
        case LC_NET_LOGIN_ERROR_MAXCONNECT:
            strError = @"login_out_of_max_con";
            break;
        case LC_NET_LOGIN_ERROR_NETWORK:
            strError = @"common_connect_failed";
            break;
        case LC_NET_ERROR_TALK_RIGHTLESS:
        case LC_NET_NOT_AUTHORIZED:
            strError = @"common_msg_no_permission";
            break;
        case LC_NET_ERROR_UNSUPPORTED:
            strError = @"device_settings_wifi_not_support";
            break;
        case LC_NET_RETURN_DATA_ERROR:
        case LC_NET_NO_RECORD_FOUND:
            strError = @"playback_no_record";
            break;
        case 0xff:
            strError = @"device_settings_wifi_not_support";
            break;
        default:
        {
            return [NSString stringWithFormat:@"%@",@"common_connect_failed"];
        }
            break;
    }
    
    return strError;
}

@end


//MARK: Safe String Copy
void safe_strcpy(char *__dst, const char *__src) {
	if (__src) {
		strcpy(__dst, __src);
	} else {
		NSLog(@" %s:: __src can't be nil...", __FUNCTION__ );
	}
}
