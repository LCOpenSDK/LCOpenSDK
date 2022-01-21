//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//

#import "DHNetSDKInterface.h"
#import <LCOpenSDKDynamic/LCOpenNetSDK/netsdk.h>
#import <LCBaseModule/DHClientEventLogHelper.h>
#import <LCBaseModule/DHFileManager.h>
#import <LCBaseModule/NSString+Dahua.h>
#import <LCBaseModule/NSObject+JSON.h>
#import <LCOpenSDKDynamic/LCOpenNetSDK/configsdk.h>
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_SearchDevices.h>

/// 网卡类型
typedef enum : NSUInteger {
	DHNetworkCardTypeUnknown, ///获取失败
	DHNetworkCardTypeWlan0,
	DHNetworkCardTypeEth2,
} DHNetworkCardType;

@interface DHNetSDKInterface()
@property (nonatomic, copy) DHNetSDKSearchDeviceCallback searchCallback;
@property (nonatomic, copy) DHNetSDKDisconnetCallback disconnectCallback;
@end

@implementation DHNetSDKInterface

+ (instancetype)sharedInstance {
	static dispatch_once_t onceToken;
	static DHNetSDKInterface *instance = nil;
	dispatch_once(&onceToken, ^{
		instance = [[self alloc] init];
	});
	return instance;
}

+ (void)initSDK {
	CLIENT_Init(fDisconnect, NULL);
}

+ (void)startNetSDKReportByRequestId:(NSString *)requestId{
    
    DHNetSDKInterface.sharedInstance.requestId = requestId;
    
    NSString *path = [[DHFileManager supportFolder] stringByAppendingPathComponent:@"cache"];
    [DHNetSDKInterface logOpen: path];
}

+ (void)stopNetSDKReport {
    CLIENT_LogClose();
}

- (void)setDisconnectCallback:(DHNetSDKDisconnetCallback)callback {
	_disconnectCallback = nil;
	_disconnectCallback = callback;
}

+ (void)logOpen:(NSString *)path {
	if (path == nil) {
		NSLog(@" 日志打开失败：路径为空");
		return;
	}
	
	LOG_SET_PRINT_INFO *logopen = (LOG_SET_PRINT_INFO *)malloc(sizeof(LOG_SET_PRINT_INFO));
	memset(logopen, 0, sizeof(LOG_SET_PRINT_INFO));
	logopen->dwSize = sizeof(LOG_SET_PRINT_INFO);
	logopen->bSetFilePath = YES;
	logopen->nPrintStrategy = 1;
	logopen->bSetPrintStrategy = YES;
    logopen->cbSDKLogCallBack = netSDKLogCallBack;
	safe_strcpy(logopen->szLogFilePath, [path UTF8String]);
	
	BOOL ret = CLIENT_LogOpen(logopen);
	NSLog(@" 日志打开: %d",ret);
}


int netSDKLogCallBack(const char* szLogBuffer, unsigned int nLogSize, LDWORD dwUser){
    
    NSString *content = [NSString stringWithUTF8String:szLogBuffer];
    NSDictionary *jsonDic = [content dh_jsonDictionary];
    NSString *type = jsonDic[@"type"];
    NSDictionary *contentDic = jsonDic[@"log"];
    NSMutableDictionary *contentMutableDic = contentDic.mutableCopy;
    NSString *requestId = [DHNetSDKInterface sharedInstance].requestId;
    if(requestId){
        contentMutableDic[@"requestId"] = requestId;
    }
    
    [[DHClientEventLogHelper shareInstance] addClientEventLog:type conent:contentMutableDic];
    
    //    NSLog(@"28614---%@", content);
    return 0;
}


+ (DHDeviceInfoLogModel *)initDevAccount:(NSString *)password device:(DHDeviceNetInfo *)deviceNetInfo useIp:(BOOL)useIp {
	if(useIp) {
		return [self private_initDevAccountUseIp:password device:deviceNetInfo];
	}
	
	return [self private_initDevAccount:password device:deviceNetInfo];
}

+ (DHDeviceInfoLogModel *)private_initDevAccount:(NSString *)password device:(DHDeviceNetInfo *)deviceNetInfo {
	if(password.length == 0) {
		return nil;
	}
	
	NET_IN_INIT_DEVICE_ACCOUNT *pInitAccountIn = (NET_IN_INIT_DEVICE_ACCOUNT *)malloc(sizeof(NET_IN_INIT_DEVICE_ACCOUNT));
	safe_strcpy(pInitAccountIn->szMac, [deviceNetInfo.deviceMac UTF8String]);
	safe_strcpy(pInitAccountIn->szUserName, [@"admin" UTF8String]);
	pInitAccountIn->dwSize = sizeof(NET_IN_INIT_DEVICE_ACCOUNT);
	
	//只需要改变bit3位为1，其他位不用处理
	pInitAccountIn->byInitStatus = (deviceNetInfo.initStatus | 0x08);
	safe_strcpy(pInitAccountIn->szPwd, [password UTF8String]);
	pInitAccountIn->byPwdResetWay = deviceNetInfo.byPWDResetWay;
	safe_strcpy(pInitAccountIn->szCellPhone,"");
	safe_strcpy(pInitAccountIn->szMail,"");
	pInitAccountIn->byReserved[0] = 0;
	pInitAccountIn->byReserved[1] = 0;
	
	NET_OUT_INIT_DEVICE_ACCOUNT* pInitAccountOut = (NET_OUT_INIT_DEVICE_ACCOUNT *)malloc(sizeof(NET_OUT_INIT_DEVICE_ACCOUNT));
	pInitAccountOut->dwSize = sizeof(NET_OUT_INIT_DEVICE_ACCOUNT);
	
	NSLog(@"DHNetSDKInterface::Init by multi with mac:%@, password:%@", deviceNetInfo.deviceMac, password);
	BOOL ret = NO;
	
	for (int i = 0; i < 3; i++)
	{
		ret = CLIENT_InitDevAccount(pInitAccountIn, pInitAccountOut,5 * 1000,NULL);
		NSLog(@"DHNetSDKInterface::Init by multi with result:%d", ret);
		if(ret) {
			break;
		} else {
			long lastError = CLIENT_GetLastError();
			NSLog(@"NetSDKInteface:: Init by multi failed with lastError:...0x%lx", lastError);
		}
	}
	
	free(pInitAccountIn);
	free(pInitAccountOut);

	return [self setupModelData:deviceNetInfo isSuccess:ret];
}

+ (DHDeviceInfoLogModel *)private_initDevAccountUseIp:(NSString *)password device:(DHDeviceNetInfo *)deviceNetInfo {
	if(deviceNetInfo.deviceIP.length == 0 || password.length == 0) {
		return nil;
	}
	
	NET_IN_INIT_DEVICE_ACCOUNT stIn = {0};
	stIn.dwSize = sizeof(stIn);

	safe_strcpy(stIn.szMac, [deviceNetInfo.deviceMac UTF8String]);
	stIn.byPwdResetWay = deviceNetInfo.byPWDResetWay;//需要确认
	safe_strcpy(stIn.szUserName,"admin");
	safe_strcpy(stIn.szPwd,[password UTF8String]);
	safe_strcpy(stIn.szCellPhone,"");
	safe_strcpy(stIn.szMail,"");
	
	NET_OUT_INIT_DEVICE_ACCOUNT stOut = {0};
	stOut.dwSize = sizeof(stOut);
	NSLog(@"28614 -----");
	char *deviceIp = (char *)[deviceNetInfo.deviceIP UTF8String];
	
	NSLog(@"DHNetSDKInterface::Init by ip with mac:%@, ip:%@, password:%@", deviceNetInfo.deviceMac, deviceNetInfo.deviceIP, password);
	
	BOOL ret = CLIENT_InitDevAccountByIP(&stIn, &stOut, 5000, NULL, deviceIp);
	NSLog(@"DHNetSDKInterface::Init by ip with result 1:%d", ret);
	if (!ret) {
		long lastError = CLIENT_GetLastError();
		NSLog(@"NetSDKInteface:: Init by ip failed with lastError:...0x%lx", lastError);
		ret = CLIENT_InitDevAccountByIP(&stIn, &stOut, 5000, NULL, deviceIp);
		NSLog(@"DHNetSDKInterface::Init by ip with result 2:%d", ret);
	}
	
    return [self setupModelData:deviceNetInfo isSuccess:ret];
}

//上报设备初始化log需要
+ (DHDeviceInfoLogModel *)setupModelData:(DHDeviceNetInfo *)deviceNetInfo isSuccess:(BOOL)isSuccess
{
    DHDeviceInfoLogModel *model = [[DHDeviceInfoLogModel alloc]init];
    model.isSuccess         = isSuccess;
    model.mac               = deviceNetInfo.deviceMac;
    model.pwdResetWay       = deviceNetInfo.byPWDResetWay;
    model.isNewDeviceVersion = !(deviceNetInfo.deviceInitType == DHDeviceInitTypeOldDevice);
    model.isEffectiveIP     = deviceNetInfo.deviceInitType == DHDeviceInitTypeIPEnable;
    model.ip                = deviceNetInfo.ip;
    return model;
}

- (long)startSearchDevices:(DHNetSDKSearchDeviceCallback)callback byLocalIp:(NSString *)localIp {
	if (self.searchCallback == nil) {
		self.searchCallback = callback;
	}
    
    LCOpenSDK_SearchDevices *searchDevice = [LCOpenSDK_SearchDevices shareSearchDevices];
    long result = [searchDevice startSearchDevices:^(DEVICE_NET_INFO_EX *deviceInfo) {

        DHDeviceNetInfo *netInfo = [[DHDeviceNetInfo alloc] initWithNetInfo: deviceInfo];
        netInfo.isVaild = YES;
        self.searchCallback(netInfo);
    } byLocalIp:localIp];
	
	return result;
}

- (long)startSearchDevices:(DHNetSDKSearchDeviceCallback)callback {
	if (self.searchCallback == nil) {
		self.searchCallback = callback;
	}
	
    LCOpenSDK_SearchDevices *searchDevice = [LCOpenSDK_SearchDevices shareSearchDevices];
    long result = [searchDevice startSearchDevices:^(DEVICE_NET_INFO_EX *deviceInfo) {

        DHDeviceNetInfo *netInfo = [[DHDeviceNetInfo alloc] initWithNetInfo: deviceInfo];
        netInfo.isVaild = YES;
        self.searchCallback(netInfo);
    } byLocalIp:@""];
    
    return result;
}

- (void)stopSearchDevices:(long)handle {
	self.searchCallback = nil;
    LCOpenSDK_SearchDevices *searchDevice = [LCOpenSDK_SearchDevices shareSearchDevices];
    [searchDevice stopSearchDevices:handle];
}

+ (DHNetLoginDeviceInfo *)loginWithHighLevelSecurityByIP:(NSString *)devIP port:(NSInteger)port username:(NSString *)username password:(NSString *)password errorCode:(unsigned int *)errorCode {
    DHNetLoginDeviceInfo *deviceInfo = [DHNetLoginDeviceInfo new];
    
    tagNET_IN_LOGIN_WITH_HIGHLEVEL_SECURITY inLoginInfo;
    memset(&inLoginInfo, 0, sizeof(tagNET_IN_LOGIN_WITH_HIGHLEVEL_SECURITY));
    inLoginInfo.dwSize = sizeof(tagNET_IN_LOGIN_WITH_HIGHLEVEL_SECURITY);
    safe_strcpy(inLoginInfo.szIP, [devIP UTF8String]);
    inLoginInfo.nPort = (unsigned int)port;
    safe_strcpy(inLoginInfo.szUserName, [username UTF8String]);
    safe_strcpy(inLoginInfo.szPassword, [password UTF8String]);
    
    tagNET_OUT_LOGIN_WITH_HIGHLEVEL_SECURITY outLoginInfo;
    memset(&outLoginInfo, 0, sizeof(tagNET_OUT_LOGIN_WITH_HIGHLEVEL_SECURITY));
    outLoginInfo.dwSize = sizeof(tagNET_OUT_LOGIN_WITH_HIGHLEVEL_SECURITY);
    
    long loginHandle = CLIENT_LoginWithHighLevelSecurity(&inLoginInfo, &outLoginInfo);
    NET_DEVICEINFO_Ex m_deviceInfo = outLoginInfo.stuDeviceInfo;
    deviceInfo.loginHandle = loginHandle;
    deviceInfo.deviceId = [[NSString alloc] initWithFormat:@"%s", m_deviceInfo.sSerialNumber];
    deviceInfo.alarmInPortNum = m_deviceInfo.nAlarmInPortNum;
    deviceInfo.alarmOutPortNum = m_deviceInfo.nAlarmOutPortNum;
    deviceInfo.DVRType = m_deviceInfo.nDVRType;
    deviceInfo.diskNum = m_deviceInfo.nDiskNum;
    deviceInfo.channelNum = m_deviceInfo.nChanNum;
    
    switch(outLoginInfo.nError)
    {
        case 1:
            *errorCode = NET_LOGIN_ERROR_PASSWORD;
            break;
        case 2:
            *errorCode = NET_LOGIN_ERROR_USER;
            break;
        case 3:
            *errorCode = NET_LOGIN_ERROR_TIMEOUT;
            break;
        case 4:
            *errorCode = NET_LOGIN_ERROR_RELOGGIN;
            break;
        case 5:
            *errorCode = NET_LOGIN_ERROR_LOCKED;
            break;
        case 6:
            *errorCode = NET_LOGIN_ERROR_BLACKLIST;
            break;
        case 7:
            *errorCode = NET_LOGIN_ERROR_BUSY;
            break;
        case 10:
            *errorCode = NET_LOGIN_ERROR_MAXCONNECT;
            break;
        case 17:
            *errorCode = NET_LOGIN_ERROR_USER_OR_PASSOWRD;
            break;
        default:
            *errorCode = outLoginInfo.nError;
    }
    
    NSLog(@"❗️DHNetSDKInterface:: loginWithHighLevelSecurity by ip:%@, result:%ld, error:0x%x", devIP, loginHandle, *errorCode);
    return deviceInfo;
}

+ (DHNetLoginDeviceInfo *)loginDeviceByIP:(NSString *)devIP port:(NSInteger)port username:(NSString *)username password:(NSString *)password errorCode:(unsigned int *)errorCode {
    DHNetLoginDeviceInfo *deviceInfo = [DHNetLoginDeviceInfo new];
    NET_DEVICEINFO_Ex m_deviceInfo = {0};
    int error;
	EM_LOGIN_SPAC_CAP_TYPE type = EM_LOGIN_SPEC_CAP_TCP;
	
	long loginHandle = CLIENT_LoginEx2([devIP UTF8String], port > 0 ? port : 37777, [username UTF8String], [password UTF8String], type, NULL, &m_deviceInfo, &error);
    deviceInfo.loginHandle = loginHandle;
    deviceInfo.deviceId = [[NSString alloc] initWithFormat:@"%s", m_deviceInfo.sSerialNumber];
    deviceInfo.alarmInPortNum = m_deviceInfo.nAlarmInPortNum;
    deviceInfo.alarmOutPortNum = m_deviceInfo.nAlarmOutPortNum;
    deviceInfo.DVRType = m_deviceInfo.nDVRType;
    deviceInfo.diskNum = m_deviceInfo.nDiskNum;
    deviceInfo.channelNum = m_deviceInfo.nChanNum;
	
    switch(error)
    {
        case 1:
            *errorCode = NET_LOGIN_ERROR_PASSWORD;
            break;
        case 2:
            *errorCode = NET_LOGIN_ERROR_USER;
            break;
        case 3:
            *errorCode = NET_LOGIN_ERROR_TIMEOUT;
            break;
        case 4:
            *errorCode = NET_LOGIN_ERROR_RELOGGIN;
            break;
        case 5:
            *errorCode = NET_LOGIN_ERROR_LOCKED;
            break;
        case 6:
            *errorCode = NET_LOGIN_ERROR_BLACKLIST;
            break;
        case 7:
            *errorCode = NET_LOGIN_ERROR_BUSY;
            break;
		case 10:
			*errorCode = NET_LOGIN_ERROR_MAXCONNECT;
			break;
        case 17:
            *errorCode = NET_LOGIN_ERROR_USER_OR_PASSOWRD;
            break;
    }
	
	NSLog(@"❗️DHNetSDKInterface:: Login by ip:%@, result:%ld, error:0x%x", devIP, loginHandle, *errorCode);
	return deviceInfo;
}

+ (void)logout:(long)loginHandle {
	CLIENT_Logout(loginHandle);
	NSLog(@"🍎🍎🍎 %@:: Logout by login handle %ld", NSStringFromClass([self class]), loginHandle);
}

#pragma mark - Query WifiInfo

+ (DHApWifiInfo*)queryWifiByLoginHandle:(long)loginHandle mssId:(NSString *)mssid errorCode:(unsigned int *)errorCode {
    DHNetworkCardType cardType = [self getNetworkCardType:loginHandle];
    if (loginHandle == 0 ) {
        return nil;
    }
    
    DHApWifiInfo *wifiInfo = nil;
    
    NET_IN_WLAN_ACCESSPOINT accessPointIn;
    memset(&accessPointIn, 0, sizeof(NET_IN_WLAN_ACCESSPOINT));
    accessPointIn.dwSize = sizeof(NET_IN_WLAN_ACCESSPOINT);
    
    strcpy(accessPointIn.szSSID, [mssid UTF8String]);
    
    NET_OUT_WLAN_ACCESSPOINT accessPointOut;
    memset(&accessPointOut, 0, sizeof(NET_IN_WLAN_ACCESSPOINT));
    accessPointOut.dwSize = sizeof(NET_OUT_WLAN_ACCESSPOINT);
    
    NSLog(@"v3_loadWifiListByLoginHandle");
    BOOL isSucceed = CLIENT_QueryDevInfo(loginHandle, NET_QUERY_WLAN_ACCESSPOINT, &accessPointIn, &accessPointOut, NULL, 5000 * 4);
    if (isSucceed) {
        NSLog(@"🍎🍎🍎 %@:: Get wifi list count:%d", NSStringFromClass([self class]), accessPointOut.nCount);
        if(accessPointOut.nCount > 0) {
            
            NET_WLAN_ACCESSPOINT_INFO accessPointInfo = accessPointOut.stuInfo[0];
            
            int encrAlgr = accessPointInfo.nEncrAlgr;
            int authorityMode = accessPointInfo.nAuthMode;
            int encryptionAuthority = [self v3_convertToEncryptionAuthorityMode:authorityMode withEncryption:encrAlgr];
            wifiInfo = [DHApWifiInfo new];
            wifiInfo.selected = NO;

            wifiInfo.name = [NSString stringWithUTF8String: accessPointInfo.szSSID];
            wifiInfo.encryptionAuthority = encryptionAuthority;
            wifiInfo.linkQuality = accessPointInfo.nStrength;
            wifiInfo.autoConnect = (authorityMode == 0 && encrAlgr == 0);
            wifiInfo.netcardName = cardType == DHNetworkCardTypeWlan0 ? @"wlan0" : @"";
            
            NSLog(@"🍎🍎🍎 %@:: Get wifi:%@, authorityMode:%d, encrAlgr:%d, encryptionAuthority: %d, quality:%ld", NSStringFromClass([self class]), wifiInfo.name, authorityMode, encrAlgr, encryptionAuthority, (long)wifiInfo.linkQuality);
        }
    } else {
        NSLog(@"NetSDKInteface:: Load wifilist failed with errorCode:...0x%x", CLIENT_GetLastError());
    }
    
    return wifiInfo;
}

#pragma mark - Wifi

+ (NSArray<DHApWifiInfo*> *)loadWifiListByLoginHandle:(long)loginHandle errorCode:(unsigned int *)errorCode {
    
    NET_PARAM param = {0};
    param.nConnectTime = 5000;
    CLIENT_SetNetworkParam(&param);
    
	BOOL isSupportWlanV3 = [self querySupportWlanConfigV3:loginHandle];
	if (isSupportWlanV3) {
		return [self v3_loadWifiListByLoginHandle:loginHandle errorCode:errorCode];
	}
	
	return [self v2_loadWifiListByLoginHandle:loginHandle errorCode:errorCode];
}

+ (BOOL)scDeviceApConnectWifi:(NSString *)mSSID
                         password:(NSString *)password
                           ip:(NSString *)deviceIP port:(NSInteger)port encryptionAuthority:(int)encryptionAuthority{
    int errorCode = 0;
    
    NET_IN_SET_DEV_WIFI inDevWifi;
    memset(&inDevWifi, 0, sizeof(NET_IN_SET_DEV_WIFI));
    NET_OUT_SET_DEV_WIFI outDevWifi;
    memset(&outDevWifi, 0, sizeof(NET_OUT_SET_DEV_WIFI));
    
    inDevWifi.nEnable = 0; //0:使能 1:关闭
    safe_strcpy(inDevWifi.szSSID, [mSSID UTF8String]);
    inDevWifi.nKeyFlag = 0;
    inDevWifi.nConnectedFlag = 1;// 0: 无连接, 1: 连接 
    inDevWifi.nEncryption = encryptionAuthority;//加密；0：off,2：WEP64bit,3：WEP128bit, 4:WPA-PSK-TKIP, 5: WPA-PSK-CCMP
//    strcpy(inDevWifi.szWPAKeys, [password UTF8String]);
    
    if (encryptionAuthority>=4 && encryptionAuthority<=12) {
        safe_strcpy(inDevWifi.szWPAKeys, [password UTF8String]);
    } else {
        safe_strcpy(inDevWifi.szKeys[0], [password UTF8String]);
    }
    
    inDevWifi.nLinkMode = 0;//连接模式；0：auto,1：adhoc,2：Infrastructure
    inDevWifi.nKeyID = 0;
    inDevWifi.nPort = (unsigned int)port;
    safe_strcpy(inDevWifi.szDevIP, [deviceIP UTF8String]);
    inDevWifi.dwSize = sizeof(NET_IN_SET_DEV_WIFI);
    
    outDevWifi.dwSize = sizeof(NET_OUT_SET_DEV_WIFI);
    
    BOOL success = CLIENT_SetDevWifiInfo(&inDevWifi, &outDevWifi, 5000 * 2);

    if (success)
    {
        NSLog(@"CLIENT_ParseData 28614 ");
    } else {
        errorCode = CLIENT_GetLastError();
        NSLog(@"%s with errorCode:0x%x", __FUNCTION__, errorCode);
    }

    return success;
}

+ (NSArray <DHApWifiInfo *>*)scDeviceApLoadWifiList:(NSString *)deviceIP port:(NSInteger)port error:(unsigned int *)errorCode {
    
    NSMutableArray<DHApWifiInfo *> * wifiList = [NSMutableArray new];
    
    NET_IN_GET_DEV_WIFI_LIST wifiListIn;
    memset(&wifiListIn, 0, sizeof(NET_IN_GET_DEV_WIFI_LIST));
    wifiListIn.dwSize = sizeof(NET_IN_GET_DEV_WIFI_LIST);
    safe_strcpy(wifiListIn.szDevIP, [deviceIP UTF8String]);
    wifiListIn.nPort = (unsigned int)port;
    
    NET_OUT_GET_DEV_WIFI_LIST wifiListOut;
    memset(&wifiListOut, 0, sizeof(NET_OUT_GET_DEV_WIFI_LIST));
    wifiListOut.dwSize = sizeof(NET_OUT_GET_DEV_WIFI_LIST);
   
    BOOL isSucceed = CLIENT_GetDevWifiListInfo(&wifiListIn, &wifiListOut, 5000 * 4);
    
    if(!isSucceed){
        NET_IN_GET_DEV_WIFI_LIST wifiListIn;
        memset(&wifiListIn, 0, sizeof(NET_IN_GET_DEV_WIFI_LIST));
        wifiListIn.dwSize = sizeof(NET_IN_GET_DEV_WIFI_LIST);
        safe_strcpy(wifiListIn.szDevIP, [deviceIP UTF8String]);
        wifiListIn.nPort = (unsigned int)port;
        
        NET_OUT_GET_DEV_WIFI_LIST wifiListOut;
        memset(&wifiListOut, 0, sizeof(NET_OUT_GET_DEV_WIFI_LIST));
        wifiListOut.dwSize = sizeof(NET_OUT_GET_DEV_WIFI_LIST);
        isSucceed = CLIENT_GetDevWifiListInfo(&wifiListIn, &wifiListOut, 5000 * 2);
    }
    
    if (isSucceed) {
        NSLog(@"🍎🍎🍎 %@:: Get wifi list count:%d", NSStringFromClass([self class]), wifiListOut.nWlanDevCount);
        for (int i = 0; i < wifiListOut.nWlanDevCount; i++) {
            
            DHDEV_WLAN_DEVICE_EX wlanDeviceInfo = wifiListOut.stuWlanDev[i];
            
            int encrAlgr = wlanDeviceInfo.byEncrAlgr;
            int authorityMode = wlanDeviceInfo.byAuthMode;
            int encryptionAuthority = [self scDevice_convertToEncryptionAuthorityMode:authorityMode withEncryption:encrAlgr];
            
            DHApWifiInfo *wifiInfo = [DHApWifiInfo new];
            wifiInfo.selected = NO;
            
            wifiInfo.name = [NSString stringWithUTF8String: wlanDeviceInfo.szSSID];
            wifiInfo.encryptionAuthority = encryptionAuthority;
            wifiInfo.linkQuality =  wlanDeviceInfo.nRSSIQuality + 100;
            wifiInfo.autoConnect = (authorityMode == 0 && encrAlgr == 0);
            wifiInfo.netcardName = @"wlan0";
            [wifiList addObject:wifiInfo];
            
            NSLog(@"🍎🍎🍎 %@:: Get wifi:%@, authorityMode:%d, encrAlgr:%d, encryptionAuthority: %d, quality:%ld", NSStringFromClass([self class]), wifiInfo.name, authorityMode, encrAlgr, encryptionAuthority, (long)wifiInfo.linkQuality);
        }
    } else {
        NSLog(@"NetSDKInteface:: Load wifilist failed with errorCode:...0x%x", CLIENT_GetLastError());
    }
    
    return wifiList;
}

+ (NSArray<DHApWifiInfo*> *)v3_loadWifiListByLoginHandle:(long)loginHandle errorCode:(unsigned int *)errorCode {
	DHNetworkCardType cardType = [self getNetworkCardType:loginHandle];
	if (loginHandle == 0 || cardType == DHNetworkCardTypeUnknown) {
		return nil;
	}
	
	NSMutableArray<DHApWifiInfo *> * wifiList = [NSMutableArray new];
	
	NET_IN_WLAN_ACCESSPOINT accessPointIn;
	memset(&accessPointIn, 0, sizeof(NET_IN_WLAN_ACCESSPOINT));
	accessPointIn.dwSize = sizeof(NET_IN_WLAN_ACCESSPOINT);
	
	if (cardType == DHNetworkCardTypeWlan0) {
		safe_strcpy(accessPointIn.szName, "wlan0");
	}
	
	NET_OUT_WLAN_ACCESSPOINT accessPointOut;
	memset(&accessPointOut, 0, sizeof(NET_IN_WLAN_ACCESSPOINT));
	accessPointOut.dwSize = sizeof(NET_OUT_WLAN_ACCESSPOINT);
	
	BOOL isSucceed = CLIENT_QueryDevInfo(loginHandle, NET_QUERY_WLAN_ACCESSPOINT, &accessPointIn, &accessPointOut, NULL, 5000 * 2);
	if (isSucceed) {
		NSLog(@"🍎🍎🍎 %@:: Get wifi list count:%d", NSStringFromClass([self class]), accessPointOut.nCount);
		for (int i = 0; i < accessPointOut.nCount; i++) {
			
			NET_WLAN_ACCESSPOINT_INFO accessPointInfo = accessPointOut.stuInfo[i];
			
			int encrAlgr = accessPointInfo.nEncrAlgr;
			int authorityMode = accessPointInfo.nAuthMode;
			int encryptionAuthority = [self v3_convertToEncryptionAuthorityMode:authorityMode withEncryption:encrAlgr];
			
			DHApWifiInfo *wifiInfo = [DHApWifiInfo new];
			wifiInfo.selected = NO;
			
			wifiInfo.name = [NSString stringWithUTF8String: accessPointInfo.szSSID];
			wifiInfo.encryptionAuthority = encryptionAuthority;
			wifiInfo.linkQuality = accessPointInfo.nStrength;
			wifiInfo.autoConnect = (authorityMode == 0 && encrAlgr == 0);
			wifiInfo.netcardName = cardType == DHNetworkCardTypeWlan0 ? @"wlan0" : @"";
			[wifiList addObject:wifiInfo];
			
			NSLog(@"🍎🍎🍎 %@:: Get wifi:%@, authorityMode:%d, encrAlgr:%d, encryptionAuthority: %d, quality:%ld", NSStringFromClass([self class]), wifiInfo.name, authorityMode, encrAlgr, encryptionAuthority, (long)wifiInfo.linkQuality);
		}
	} else {
		NSLog(@"NetSDKInteface:: Load wifilist failed with errorCode:...0x%x", CLIENT_GetLastError());
	}
	
	return wifiList;
}

+ (NSArray<DHApWifiInfo*> *)v2_loadWifiListByLoginHandle:(long)loginHandle errorCode:(unsigned int *)errorCode {
	if (loginHandle == 0) {
		return nil;
	}
	
	NSMutableArray<DHApWifiInfo *> * mCellData = [NSMutableArray new];
	
	unsigned int errCode2 = 0;
	DHDEV_WLAN_DEVICE_LIST_EX wifiList;
	memset(&wifiList, 0, sizeof(wifiList));
	wifiList.dwSize = sizeof(wifiList);
	BOOL bRet = CLIENT_GetDevConfig(loginHandle, DH_DEV_WLAN_DEVICE_CFG_EX, 0, &wifiList, sizeof(wifiList), &errCode2,10000);
	
	NSLog(@"NetSDKInteface:: Load wifilist by CLIENT_GetDevConfig result...%d, errorCode:%d", bRet, errCode2);
	
	if(bRet)
	{
		if(wifiList.bWlanDevCount > 0)
		{
			NSLog(@"🍎🍎🍎 %@:: Get wifi list count:%d", NSStringFromClass([self class]), wifiList.bWlanDevCount);
			for(int i=0;i<wifiList.bWlanDevCount;i++)
			{
				NSString * wifiName = [NSString stringWithUTF8String:wifiList.lstWlanDev[i].szSSID];
				int encrytion = wifiList.lstWlanDev[i].byEncrAlgr;
				int authorityMode = wifiList.lstWlanDev[i].byAuthMode;
				int encrAlgr = wifiList.lstWlanDev[i].byEncrAlgr;
				int encryptionAuthority = [self v2_convertToEncryptionAuthorityMode:authorityMode withEncryption:encrytion];
				
				DHApWifiInfo *wifiInfo = [DHApWifiInfo new];
				wifiInfo.selected = NO;
				wifiInfo.name = wifiName;
				wifiInfo.encryptionAuthority = encryptionAuthority;
				wifiInfo.linkQuality = wifiList.lstWlanDev[i].nRSSIQuality + 100;
				wifiInfo.autoConnect = (authorityMode == 0 && encrAlgr == 0);
				wifiInfo.netcardName = @"";
				[mCellData addObject:wifiInfo];
				
				NSLog(@"🍎🍎🍎 %@:: Get wifi:%@, authorityMode:%d, encrAlgr:%d, encryptionAuthority: %d, quality:%ld", NSStringFromClass([self class]), wifiInfo.name, authorityMode, encrAlgr, encryptionAuthority, (long)wifiInfo.linkQuality);
			}
		}
	} else {
		//#define _EC(x) (0x80000000|x)
		*errorCode = CLIENT_GetLastError();
		NSLog(@"NetSDKInteface:: Load wifilist failed with errorCode:...0x%x", *errorCode);
	}
	
	return mCellData;
}


+ (NSUInteger)connectWIFIByLoginHandle:(long)loginHandle
                                  ssid:(NSString *)mSSID
                              password:(NSString *)password
                   encryptionAuthority:(int)encryptionAuthority
                           netcardName:(NSString *)netcardName
{
    int bufferSize = 1024*40;
    char configBuffer[bufferSize];
    int nErrPhone = 0;
    int nRestPhone = 0;
    CFG_NETAPP_WLAN * _pstRule = new CFG_NETAPP_WLAN();
    memset(_pstRule , 0 , sizeof(CFG_NETAPP_WLAN));
    BOOL bGetPhone = CLIENT_GetNewDevConfig(loginHandle, (char *)CFG_CMD_WLAN, -1, configBuffer, bufferSize, &nErrPhone, 5000*2);
    NSLog(@"CLIENT_GetNewDevConfig 28614 ");
    DWORD errorCode = 0;
    if (bGetPhone)
    {
        bGetPhone = CLIENT_ParseData((char *)CFG_CMD_WLAN, configBuffer, _pstRule, sizeof(CFG_NETAPP_WLAN), NULL);
        if (bGetPhone)
        {
            NSLog(@"CLIENT_ParseData 28614 ");
            const char * ssidStr = [mSSID UTF8String];
            
            if (netcardName.length) {
                safe_strcpy(_pstRule->stuWlanInfo[0].szWlanName, [netcardName UTF8String]);
            }
            
            _pstRule->stuWlanInfo[0].bEnable = TRUE;
            safe_strcpy(_pstRule->stuWlanInfo[0].szSSID, ssidStr);
            safe_strcpy(_pstRule->stuWlanInfo[0].szKeys[0], [password UTF8String]);
            
            _pstRule->stuWlanInfo[0].bKeyFlag = TRUE;
            _pstRule->stuWlanInfo[0].bConnectEnable = TRUE;
            _pstRule->stuWlanInfo[0].nEncryption = encryptionAuthority;
            _pstRule->stuWlanInfo[0].bLinkEnable = FALSE; //自动连接开关, TRUE不自动连接, FALSE自动连接, IPC无意义
            _pstRule->stuWlanInfo[0].nKeyID = 0;
            bGetPhone = CLIENT_PacketData((char *)CFG_CMD_WLAN, _pstRule, sizeof(CFG_NETAPP_WLAN), configBuffer, bufferSize);
            NSLog(@"CLIENT_PacketData 28614 ");
            if (bGetPhone)
            {
                NSLog(@"NetSDKInterface:: Connect wifi by CLIENT_SetNewDevConfig %@, %@, encryption:%d, %@", mSSID, password, encryptionAuthority, netcardName);
                
                bGetPhone = CLIENT_SetNewDevConfig(loginHandle, (char *)CFG_CMD_WLAN, -1, configBuffer, bufferSize, &nErrPhone, &nRestPhone, 5000*2);
                NSLog(@"CLIENT_SetNewDevConfig 28614 ");
                if(!bGetPhone)
                {
                    errorCode = CLIENT_GetLastError();
                }
            }
            else
            {
                errorCode = CLIENT_GetLastError();
            }
        }
        else
        {
            errorCode = CLIENT_GetLastError();
        }
    }
    else
    {
        errorCode = CLIENT_GetLastError();
    }
    
    NSLog(@"%s with errorCode:0x%x", __FUNCTION__, errorCode);
    delete(_pstRule);
    _pstRule = NULL;
    
    return errorCode;
}


#pragma mark - Encryption Convert

/*
 
 DataEncryption  这个是设备传给了NETSDK 范围是01234 然后NETSDK除了0之外都+3 传给了上层 导致APP端看起来不符合标准协议

 Authentication认证方式        DataEncryption数据加密方式        Encryption加密模式(二代对应枚举)
 WPA-NONE    6                NONE                0            "Off"   (0)
 OPEN        0                NONE                0            "On"   (1)
 OPEN        0                WEP                4                "WEP-OPEN" (13)
 SHARD        1                WEP                4                "WEP-SHARED" (14)
 WPA            2                TKIP                5            "WPA-TKIP"    (8)
 WPA-PSK        3                TKIP                5            "WPA-PSK-TKIP" (4)
 WPA2         4               TKIP                5            "WPA2-TKIP"    (10)
 WPA2-PSK    5                TKIP                5            "WPA2-PSK-TKIP" (6)
 WPA            2                AES(CCMP)            6            "WPA-AES"      (9)
 WPA-PSK        3                AES(CCMP)            6            "WPA-PSK-AES"  (5)
 WPA2        4                AES(CCMP)            6            "WPA2-AES"     (11)
 WPA2-PSK    5                AES(CCMP)            6           "WPA2-PSK-AES" (7)
 WPA              2              TKIP+AES( mix Mode，推荐AES)7         "WPA-TKIP"/"WPA-AES"  (8/9)
 WPA-PSK          3              TKIP+AES( mix Mode，推荐AES)7        "WPA-PSK-TKIP"/"WPA-PSK-AES" (4/5)
 WPA2         4               TKIP+AES ( mix Mode，推荐AES)7    "WPA2-TKIP"/"WPA2-AES" (10/11)
 WPA2-PSK     5               TKIP+AES( mix Mode，推荐AES)7        "WPA2-PSK-TKIP"/"WPA2-PSK-AES" (6/7)
 "AUTO" (12)
 以下是混合模式
 WPA-PSK|WPA2-PSK 7    3|5
 WPA|WPA2         8    2|4
 WPA|WPA-PSK      9    2|3
 WPA2|WPA2-PSK    10    4|5
 WPA|WPA-PSK|WPA2|WPA2-PSK 11    2|3|4|5
 */
+ (int)scDevice_convertToEncryptionAuthorityMode:(int)byAuthMode withEncryption:(int)byEncrAlgr {
    int nEncryption = 0;
    
    if (byAuthMode == 6 && byEncrAlgr == 0) {
        nEncryption = 0;
    } else if (byAuthMode == 0 && byEncrAlgr == 0) {
        nEncryption = 1;
    } else if (byAuthMode == 0 && byEncrAlgr == 4) {
        nEncryption = 13;
    } else if (byAuthMode == 1 && byEncrAlgr == 4) {
        nEncryption = 14;
    } else if (byAuthMode == 2 && byEncrAlgr == 5) {
        nEncryption = 8;
    } else if (byAuthMode == 3 && byEncrAlgr == 5) {
        nEncryption = 4;
    } else if (byAuthMode == 4 && byEncrAlgr == 5) {
        nEncryption = 10;
    } else if (byAuthMode == 5 && byEncrAlgr == 5) {
        nEncryption = 6;
    } else if (byAuthMode == 2 && byEncrAlgr == 6) {
        nEncryption = 9;
    } else if (byAuthMode == 3 && byEncrAlgr == 6) {
        nEncryption = 5;
    } else if (byAuthMode == 4 && byEncrAlgr == 6) {
        nEncryption = 11;
    } else if (byAuthMode == 5 && byEncrAlgr == 6) {
        nEncryption = 7;
    } else if (byAuthMode == 2 && byEncrAlgr == 7) {
        nEncryption = 9;  // 8或者9
    } else if (byAuthMode == 3 && byEncrAlgr == 7) {
        nEncryption = 5;  // 4或5
    } else if (byAuthMode == 4 && byEncrAlgr == 7) {
        nEncryption = 11;  // 10或11
    } else if (byAuthMode == 5 && byEncrAlgr == 7) {
        nEncryption = 7;  // 6或7
    } else if (byAuthMode == 7)  // 混合模式WPA-PSK|WPA2-PSK   3或5
    {
        if (byEncrAlgr == 5) {
            nEncryption = 6;  // 4或6
        } else if (byEncrAlgr == 6) {
            nEncryption = 7;  // 5或7
        } else if (byEncrAlgr == 7) {
            nEncryption = 7;  // 4或5或6或7
        } else {
            nEncryption = 12;
        }
    } else if (byAuthMode == 8)  // 混合模式WPA|WPA2    2或4
    {
        if (byEncrAlgr == 5) {
            nEncryption = 10;  // 8或10
        } else if (byEncrAlgr == 6) {
            nEncryption = 11;  // 9或11
        } else if (byEncrAlgr == 7) {
            nEncryption = 10;  // 8或9或10或11
        } else {
            nEncryption = 12;
        }
    } else if (byAuthMode == 9)  // 混合模式WPA|WPA-PSK  2或3
    {
        if (byEncrAlgr == 5) {
            nEncryption = 8;  // 4或8
        } else if (byEncrAlgr == 6) {
            nEncryption = 9;  // 5或9
        } else if (byEncrAlgr == 7) {
            nEncryption = 9;  // 4或5或8或9
        } else {
            nEncryption = 12;
        }
    } else if (byAuthMode == 10)  // 混合模式WPA2|WPA2-PSK  4或5
    {
        if (byEncrAlgr == 5) {
            nEncryption = 10;  // 6或10
        } else if (byEncrAlgr == 6) {
            nEncryption = 11;  // 7或11
        } else if (byEncrAlgr == 7) {
            nEncryption = 11;  // 6或7或10或11
        } else {
            nEncryption = 12;
        }
    } else if (byAuthMode == 11)  // 混合模式WPA|WPA-PSK|WPA2|WPA2-PSK  2或3或4或5
    {
        if (byEncrAlgr == 5) {
            nEncryption = 10;  // 4或6或8或10
        } else if (byEncrAlgr == 6) {
            nEncryption = 11;  // 5或7或9或11
        } else if (byEncrAlgr == 7) {
            nEncryption = 11;  // 4或5或6或7或8或9或10或11
        } else {
            nEncryption = 12;
        }
    } else {
        nEncryption = 12;
    }
    return nEncryption;
}

/**
 *  此映射表查询用的三代接口 {@link com.company.NetSDK.INetSDK#QueryDevInfo}
 *  加密模式
 *  二代byAuthMode  , byEncrAlgr  与三代映射关系
 *  Authentication认证方式          DataEncryption数据加密方式     Encryption加密模式
 *  WPA-NONE 6                      NONE      0                     WPA-NONE       0
 *  OPEN     0                      NONE      0                     On			   1
 *  OPEN     0                      WEP       1                     WEP-OPEN	   2
 *  SHARED   1                      WEP       1                     WEP-SHARED     3
 *  WPA      2                      TKIP      2                     WPA-TKIP       4
 *  WPA-PSK  3                      TKIP      2                     WPA-PSK-TKIP   5
 *  WPA2     4                      TKIP      2                     WPA2-TKIP      6
 *  WPA2-PSK 5                      TKIP      2                     WPA2-PSK-TKIP  7
 *  WPA      2                      AES(CCMP) 3                     WPA-AES        8
 *  WPA-PSK  3                      AES(CCMP) 3                     WPA-PSK-AES    9
 *  WPA2     4                      AES(CCMP) 3                     WPA2-AES       10
 *  WPA2-PSK 5                      AES(CCMP) 3                     WPA2-PSK-AES   11
 *  WPA      2                      TKIP+AES( mix Mode) 4           WPA-TKIP或者WPA-AES  4或8
 *  WPA-PSK  3                      TKIP+AES( mix Mode) 4           WPA-PSK-TKIP或者WPA-PSK-AES 5或9
 *  WPA2     4                      TKIP+AES( mix Mode) 4           WPA2-TKIP或者WPA2-AES   6或10
 *  WPA2-PSK 5                      TKIP+AES( mix Mode) 4           WPA2-PSK-TKIP或者WPA2-PSK-AES 7或11
 *
 * 以下是混合模式
 * WPA-PSK|WPA2-PSK 7
 * WPA|WPA2         8
 * WPA|WPA-PSK      9
 * WPA2|WPA2-PSK    10
 * WPA|WPA-PSK|WPA2|WPA2-PSK 11
 */
+ (int)v3_convertToEncryptionAuthorityMode:(int)byAuthMode withEncryption:(int)byEncrAlgr
{
	/**
	 * 三代映射的加密方式
	 * @param byAuthMode  认证方式,  通过接口{@link com.company.NetSDK.INetSDK#QueryDevInfo},对应命令{@link FinalVar#NET_QUERY_WLAN_ACCESSPOINT}查询得到
	 * @param byEncrAlgr  数据加密方式,   通过接口{@link com.company.NetSDK.INetSDK#QueryDevInfo},对应命令{@link FinalVar#NET_QUERY_WLAN_ACCESSPOINT}查询得到
	 * @return nEncryption   用于{@link FinalVar#CFG_CMD_WLAN}配置WLAN   加密模式, 0: off, 1: on, 2: WEP-OPEN, 3: WEP-SHARED, 4: WPA-TKIP, 5: WPA-PSK-TKIP, 6: WPA2-TKIP, 7: WPA2-PSK-TKIP, 8: WPA-AES, 9: WPA-PSK-AES, 10: WPA2-AES, 11: WPA2-PSK-AES, 12: AUTO
	 */
	int nEncryption = 0;
	
	if(byAuthMode == 6 && byEncrAlgr == 0)
	{
		nEncryption = 0;
	}
	else if(byAuthMode == 0 && byEncrAlgr == 0)
	{
		nEncryption = 1;
	}
	else  if(byAuthMode == 0 && byEncrAlgr == 1)
	{
		nEncryption = 2;
	}
	else  if(byAuthMode == 1 && byEncrAlgr == 1)
	{
		nEncryption = 3;
	}
	else  if(byAuthMode == 2 && byEncrAlgr == 2)
	{
		nEncryption = 4;
	}
	else  if(byAuthMode == 3 && byEncrAlgr == 2)
	{
		nEncryption = 5;
	}
	else  if(byAuthMode == 4 && byEncrAlgr == 2)
	{
		nEncryption = 6;
	}
	else  if(byAuthMode == 5 && byEncrAlgr == 2)
	{
		nEncryption = 7;
	}
	else  if(byAuthMode == 2 && byEncrAlgr == 3)
	{
		nEncryption = 8;
	}
	else  if(byAuthMode == 3 && byEncrAlgr == 3)
	{
		nEncryption = 9;
	}
	else  if(byAuthMode == 4 && byEncrAlgr == 3)
	{
		nEncryption = 10;
	}
	else  if(byAuthMode == 5 && byEncrAlgr == 3)
	{
		nEncryption = 11;
	}
	else  if(byAuthMode == 2 && byEncrAlgr == 4)
	{
		nEncryption = 8;  // 4或者8
	}
	else  if(byAuthMode == 3 && byEncrAlgr == 4)
	{
		nEncryption = 9;  // 5或9
	}
	else  if(byAuthMode == 4 && byEncrAlgr == 4)
	{
		nEncryption = 10;  // 6或10
	}
	else  if(byAuthMode == 5 && byEncrAlgr == 4)
	{
		nEncryption = 11;  // 7或11
	}
	else if(byAuthMode == 7)  // 混合模式WPA-PSK|WPA2-PSK   3或5
	{
		if(byEncrAlgr == 2) {
			nEncryption = 7;  // 5或7
		}
		else if(byEncrAlgr == 3)
		{
			nEncryption = 11;  // 9或11
		}
		else if(byEncrAlgr == 4)
		{
			nEncryption = 11;  // 5或7或9或11
		}
		else
		{
			nEncryption = 12;
		}
	}
	else if(byAuthMode == 8)  // 混合模式WPA|WPA2    2或4
	{
		if(byEncrAlgr == 2) {
			nEncryption = 6;  // 4或6
		}
		else if(byEncrAlgr == 3)
		{
			nEncryption = 10;  // 8或10
		}
		else if(byEncrAlgr == 4)
		{
			nEncryption = 10;  // 4或6或8或10
		}
		else
		{
			nEncryption = 12;
		}
	}
	else if(byAuthMode == 9)  // 混合模式WPA|WPA-PSK  2或3
	{
		if(byEncrAlgr == 2) {
			nEncryption = 5;  // 4或5
		}
		else if(byEncrAlgr == 3)
		{
			nEncryption = 9;  // 8或9
		}
		else if(byEncrAlgr == 4)
		{
			nEncryption = 9;  // 4或5或8或9
		}
		else
		{
			nEncryption = 12;
		}
	}
	else if(byAuthMode == 10)  // 混合模式WPA2|WPA2-PSK  4或5
	{
		if(byEncrAlgr == 2) {
			nEncryption = 7;  // 6或7
		}
		else if(byEncrAlgr == 3)
		{
			nEncryption = 11;  // 10或11
		}
		else if(byEncrAlgr == 4)
		{
			nEncryption = 11;  // 6或7或10或11
		}
		else
		{
			nEncryption = 12;
		}
	}
	else if(byAuthMode == 11)  // 混合模式WPA|WPA-PSK|WPA2|WPA2-PSK  2或3或4或5
	{
		if(byEncrAlgr == 2) {
			nEncryption = 7;  // 4或5或6或7
		}
		else if(byEncrAlgr == 3)
		{
			nEncryption = 11;  // 8或9或10或11
		}
		else if(byEncrAlgr == 4)
		{
			nEncryption = 11;  // 4或5或6或7或8或9或10或11
		}
		else
		{
			nEncryption = 12;
		}
	} else {
		nEncryption = 12;
	}
	return nEncryption;
}

/**
 *  此映射表用的二代接口 {@link com.company.NetSDK.INetSDK#GetDevConfig}
 *  加密模式
 *  二代byAuthMode  , byEncrAlgr  与三代映射关系
 *  Authentication认证方式          DataEncryption数据加密方式     Encryption加密模式
 *  WPA-NONE 6                      NONE      0                     WPA-NONE       0
 *  OPEN     0                      NONE      0                     On			   1
 *  OPEN     0                      WEP       4                     WEP-OPEN	   2
 *  SHARED   1                      WEP       4                     WEP-SHARED     3
 *  WPA      2                      TKIP      5                     WPA-TKIP       4
 *  WPA-PSK  3                      TKIP      5                     WPA-PSK-TKIP   5
 *  WPA2     4                      TKIP      5                     WPA2-TKIP      6
 *  WPA2-PSK 5                      TKIP      5                     WPA2-PSK-TKIP  7
 *  WPA      2                      AES(CCMP) 6                     WPA-AES        8
 *  WPA-PSK  3                      AES(CCMP) 6                     WPA-PSK-AES    9
 *  WPA2     4                      AES(CCMP) 6                     WPA2-AES       10
 *  WPA2-PSK 5                      AES(CCMP) 6                     WPA2-PSK-AES   11
 *  WPA      2                      TKIP+AES( mix Mode) 7           WPA-TKIP或者WPA-AES  4或8
 *  WPA-PSK  3                      TKIP+AES( mix Mode) 7           WPA-PSK-TKIP或者WPA-PSK-AES 5或9
 *  WPA2     4                      TKIP+AES( mix Mode) 7           WPA2-TKIP或者WPA2-AES   6或10
 *  WPA2-PSK 5                      TKIP+AES( mix Mode) 7           WPA2-PSK-TKIP或者WPA2-PSK-AES 7或11
 *
 * 以下是混合模式
 * WPA-PSK|WPA2-PSK 7
 * WPA|WPA2         8
 * WPA|WPA-PSK      9
 * WPA2|WPA2-PSK    10
 * WPA|WPA-PSK|WPA2|WPA2-PSK 11
 */
+ (int)v2_convertToEncryptionAuthorityMode:(int)byAuthMode withEncryption:(int)byEncrAlgr {
	
	/**
	 * 二代映射的加密方式
	 * @param byAuthMode  认证方式,  通过接口{@link com.company.NetSDK.INetSDK#GetDevConfig},对应命令{@link FinalVar#SDK_DEV_WLAN_DEVICE_CFG_EX}查询得到
	 * @param byEncrAlgr  数据加密方式,   通过接口{@link com.company.NetSDK.INetSDK#GetDevConfig},对应命令{@link FinalVar#SDK_DEV_WLAN_DEVICE_CFG_EX}查询得到
	 * @return nEncryption   用于{@link FinalVar#CFG_CMD_WLAN}配置WLAN   加密模式, 0: off, 1: on, 2: WEP-OPEN, 3: WEP-SHARED, 4: WPA-TKIP, 5: WPA-PSK-TKIP, 6: WPA2-TKIP, 7: WPA2-PSK-TKIP, 8: WPA-AES, 9: WPA-PSK-AES, 10: WPA2-AES, 11: WPA2-PSK-AES, 12: AUTO
	 */
	int nEncryption = 0;
	
	if(byAuthMode == 6 && byEncrAlgr == 0)
	{
		nEncryption = 0;
	}
	else if(byAuthMode == 0 && byEncrAlgr == 0)
	{
		nEncryption = 1;
	}
	else  if(byAuthMode == 0 && byEncrAlgr == 4)
	{
		nEncryption = 2;
	}
	else  if(byAuthMode == 1 && byEncrAlgr == 4)
	{
		nEncryption = 3;
	}
	else  if(byAuthMode == 2 && byEncrAlgr == 5)
	{
		nEncryption = 4;
	}
	else  if(byAuthMode == 3 && byEncrAlgr == 5)
	{
		nEncryption = 5;
	}
	else  if(byAuthMode == 4 && byEncrAlgr == 5)
	{
		nEncryption = 6;
	}
	else  if(byAuthMode == 5 && byEncrAlgr == 5)
	{
		nEncryption = 7;
	}
	else  if(byAuthMode == 2 && byEncrAlgr == 6)
	{
		nEncryption = 8;
	}
	else  if(byAuthMode == 3 && byEncrAlgr == 6)
	{
		nEncryption = 9;
	}
	else  if(byAuthMode == 4 && byEncrAlgr == 6)
	{
		nEncryption = 10;
	}
	else  if(byAuthMode == 5 && byEncrAlgr == 6)
	{
		nEncryption = 11;
	}
	else  if(byAuthMode == 2 && byEncrAlgr == 7)
	{
		nEncryption = 8;  // 4或者8
	}
	else  if(byAuthMode == 3 && byEncrAlgr == 7)
	{
		nEncryption = 9;  // 5或9
	}
	else  if(byAuthMode == 4 && byEncrAlgr == 7)
	{
		nEncryption = 10;  // 6或10
	}
	else  if(byAuthMode == 5 && byEncrAlgr == 7)
	{
		nEncryption = 11;  // 7或11
	}
	else if(byAuthMode == 7)  // 混合模式WPA-PSK|WPA2-PSK   3或5
	{
		if(byEncrAlgr == 5) {
			nEncryption = 7;  // 5或7
		}
		else if(byEncrAlgr == 6)
		{
			nEncryption = 11;  // 9或11
		}
		else if(byEncrAlgr == 7)
		{
			nEncryption = 11;  // 5或7或9或11
		}
		else
		{
			nEncryption = 12;
		}
	}
	else if(byAuthMode == 8)  // 混合模式WPA|WPA2    2或4
	{
		if(byEncrAlgr == 5) {
			nEncryption = 6;  // 4或6
		}
		else if(byEncrAlgr == 6)
		{
			nEncryption = 10;  // 8或10
		}
		else if(byEncrAlgr == 7)
		{
			nEncryption = 10;  // 4或6或8或10
		}
		else
		{
			nEncryption = 12;
		}
	}
	else if(byAuthMode == 9)  // 混合模式WPA|WPA-PSK  2或3
	{
		if(byEncrAlgr == 5) {
			nEncryption = 5;  // 4或5
		}
		else if(byEncrAlgr == 6)
		{
			nEncryption = 9;  // 8或9
		}
		else if(byEncrAlgr == 7)
		{
			nEncryption = 9;  // 4或5或8或9
		}
		else
		{
			nEncryption = 12;
		}
	}
	else if(byAuthMode == 10)  // 混合模式WPA2|WPA2-PSK  4或5
	{
		if(byEncrAlgr == 5) {
			nEncryption = 7;  // 6或7
		}
		else if(byEncrAlgr == 6)
		{
			nEncryption = 11;  // 10或11
		}
		else if(byEncrAlgr == 7)
		{
			nEncryption = 11;  // 6或7或10或11
		}
		else
		{
			nEncryption = 12;
		}
	}
	else if(byAuthMode == 11)  // 混合模式WPA|WPA-PSK|WPA2|WPA2-PSK  2或3或4或5
	{
		if(byEncrAlgr == 5) {
			nEncryption = 7;  // 4或5或6或7
		}
		else if(byEncrAlgr == 6)
		{
			nEncryption = 11;  // 8或9或10或11
		}
		else if(byEncrAlgr == 7)
		{
			nEncryption = 11;  // 4或5或6或7或8或9或10或11
		}
		else
		{
			nEncryption = 12;
		}
	} else {
		nEncryption = 12;
	}
	return nEncryption;
}

//MARK: Error
+ (NSString *)getErrorDescription:(unsigned int)erroCode
{
    NSString *strError = nil;
    switch (erroCode) {
        case NET_USER_FLASEPWD:
        case NET_LOGIN_ERROR_PASSWORD:
        case NET_LOGIN_ERROR_USER_OR_PASSOWRD:
            strError = @"login_user_or_pwd_error";
            break;
        case NET_LOGIN_ERROR_USER:
            strError = @"login_user_not_exist";
            break;
        case NET_LOGIN_ERROR_TIMEOUT:
            strError = @"login_timeout";
            break;
        case NET_LOGIN_ERROR_RELOGGIN:
            strError = @"login_user_logined";
            break;
        case NET_LOGIN_ERROR_LOCKED:
            strError = @"login_user_locked"; 
            break;
        case NET_LOGIN_ERROR_BLACKLIST:
            strError = @"login_user_in_black_list";
            break;
        case NET_LOGIN_ERROR_BUSY:
            strError = @"login_system_busy";
            break;
        case NET_LOGIN_ERROR_CONNECT:
            strError = @"login_timeout";
            break;
        case NET_LOGIN_ERROR_MAXCONNECT:
            strError = @"login_out_of_max_con";
            break;
        case NET_LOGIN_ERROR_NETWORK:
            strError = @"common_connect_failed";
            break;
        case NET_ERROR_TALK_RIGHTLESS:
        case NET_NOT_AUTHORIZED:
            strError = @"common_msg_no_permission";
            break;
        case NET_ERROR_UNSUPPORTED:
            strError = @"device_settings_wifi_not_support";
            break;
        case NET_RETURN_DATA_ERROR:
        case NET_NO_RECORD_FOUND:
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

//MARK: 设备重置密码-错误码
+ (NSString *)getDeviceRessetErrorDescription:(unsigned int)erroCode
{
    NSString *strError = nil;
    switch (erroCode) {
        case NET_ERROR_SECURITY_CODE:
            strError = @"device_pwd_reset_error_tip_input_safecode".lc_T;
            break;
        case NET_ERROR_SECURITY_CANNOT_RESET:
            strError = @"device_pwd_reset_error_tip_not_init".lc_T;
            break;
        case NET_ERROR_SECURITY_NOT_SUPPORT_CONTACT_MODE:
        case NET_ERROR_SECURITY_GET_CONTACT:
        case NET_ERROR_SECURITY_GET_QRCODE:
        case NET_ERROR_SECURITY_RESPONSE_TIMEOUT:
        case NET_ERROR_SECURITY_AUTHCODE_FORBIDDEN:
            strError = @"device_pwd_reset_error_tip_try_again".lc_T;
            break;
        default:
            strError = @"device_pwd_reset_error_tip_try_again".lc_T;
            break;
    }
    //2147483650 2147483650 0x80000000|1018
    NSLog(@"errorcode=%u 1=%u, 2=%u 3=%u 4=%u 5=%u 6=%u 7=%u ", erroCode,NET_ERROR_SECURITY_GENERATE_SAFE_CODE,NET_ERROR_SECURITY_CANNOT_RESET,NET_ERROR_SECURITY_NOT_SUPPORT_CONTACT_MODE,NET_ERROR_SECURITY_GET_CONTACT,NET_ERROR_SECURITY_GET_QRCODE,NET_ERROR_SECURITY_RESPONSE_TIMEOUT,NET_ERROR_SECURITY_AUTHCODE_FORBIDDEN);
    return strError;
}

+ (unsigned int)getLastError {
    
    return [LCOpenSDK_SearchDevices getLastError];
}

#pragma mark - Production
+ (DHDeviceProductDefinition *)queryProductDefinitionInfo:(long)loginHandle {
	DH_PRODUCTION_DEFNITION stuProdution = {0};
	stuProdution.dwSize = sizeof(DH_PRODUCTION_DEFNITION);
	
	DHDeviceProductDefinition *definition = nil;
	BOOL isSuccess = CLIENT_QueryProductionDefinition(loginHandle, &stuProdution, 5*1000);
	NSLog(@"🍎🍎🍎 %@:: CLIENT_QueryProductionDefinition result:%d", NSStringFromClass([self class]), isSuccess);
	
	if (isSuccess) {
		definition = [DHDeviceProductDefinition new];
		definition.wlanScanConfigType = stuProdution.emWlanScanAndConfig;
		definition.hasPtz = stuProdution.bPtz;
	}
	
	return definition;
}

+ (DHDeviceUserInfoDefinition *)queryDeviceUserInfo:(long)loginHandle {
    
    USER_MANAGE_INFO_EX *userManagerInfo = new USER_MANAGE_INFO_EX;
    BOOL isSuccess = CLIENT_QueryUserInfoEx(loginHandle, userManagerInfo,5*1000);
    NSLog(@"🍎🍎🍎 %@:: CLIENT_QueryUserInfoEx result:%d", NSStringFromClass([self class]), isSuccess);
    
    DHDeviceUserInfoDefinition *definition = [DHDeviceUserInfoDefinition new];
    definition.hasPtzAuth = false;
    if (isSuccess) {
        for (int i = 0; i<userManagerInfo->dwRightNum; i++) {
            if ((strstr(userManagerInfo->rightList[i].name, "MPTZ") != NULL) ||
                (strstr(userManagerInfo->rightList[i].name, "AuthManuCtr") != NULL)) {
                definition.hasPtzAuth = true;
                break;
            }
        }
    }
    return definition;
}

+ (BOOL)querySupportWlanConfigV3:(long)loginHandle {
	DHDeviceProductDefinition *definition = [self queryProductDefinitionInfo: loginHandle];
	NSLog(@"🍎🍎🍎 %@:: querySupportWlanConfigV3, protocol type:%d", NSStringFromClass([self class]), definition.wlanScanConfigType);

	if (definition.wlanScanConfigType == EM_WLAN_SCAN_AND_CONFIG_V3) {
		return true;
	}
	
	return false;
}

+ (DHNetworkCardType)getNetworkCardType:(long)loginHandle
{
	DHDEV_NETINTERFACE_INFO *stuNetInterface = new DHDEV_NETINTERFACE_INFO[DH_MAX_NETINTERFACE_NUM];
	memset(stuNetInterface, 0, sizeof(DHDEV_NETINTERFACE_INFO) * DH_MAX_NETINTERFACE_NUM);
	for (int i = 0; i < DH_MAX_NETINTERFACE_NUM; ++i)
	{
		stuNetInterface[i].dwSize = sizeof(DHDEV_NETINTERFACE_INFO);
	}
	
	int retLen = 0;
	BOOL isSucceed = CLIENT_QueryDevState(loginHandle, DH_DEVSTATE_NETINTERFACE, (char *)stuNetInterface, sizeof(DHDEV_NETINTERFACE_INFO) * DH_MAX_NETINTERFACE_NUM, &retLen, 5000);
	
	DHNetworkCardType type = DHNetworkCardTypeEth2;
	
	if (isSucceed) {
		int validCount = MIN(DH_MAX_NETINTERFACE_NUM, retLen / (int)sizeof(DHDEV_NETINTERFACE_INFO));
		NSLog(@"🍎🍎🍎 %@:: GetInterface count:%d", NSStringFromClass([self class]), validCount);
		
		for (int i = 0; i < validCount; i++) {
			NSString *name = [NSString stringWithUTF8String:stuNetInterface[i].szName];
			NSLog(@"🍎🍎🍎 %@:: Network card name:%@", NSStringFromClass([self class]), name);
			if ([name.lowercaseString isEqualToString:@"wlan0"]) {
				type = DHNetworkCardTypeWlan0;
				//break;
			}
		}
	} else {
		NSLog(@"🍎🍎🍎 %@:: Get network card failed...:0x%x", NSStringFromClass([self class]), [self getLastError]);
		type = DHNetworkCardTypeUnknown;
	}
	
	return type;
}

//MARK: Device Password Reset
+ (DHDeviceResetPWDInfo *)queryPasswordResetType:(DHDeviceNetInfo *)device byPhoneIp:(NSString *)phoneIp {
	NET_IN_DESCRIPTION_FOR_RESET_PWD inDescription = {0};
	NET_OUT_DESCRIPTION_FOR_RESET_PWD outDescription = {0};
	outDescription.dwSize = sizeof(NET_OUT_DESCRIPTION_FOR_RESET_PWD);
	outDescription.pQrCode = new char[1024];
	outDescription.nQrCodeLen = 1024;
	memset(outDescription.pQrCode, 0, 1024);
	
	//使用safe_strcpy需要判断nil
	//safe_strcpy(inDescription.szMac, [device.mac UTF8String]);
	NSString *userName = @"admin";
	memcpy(inDescription.szMac, [device.mac UTF8String], device.mac.length);
	memcpy(inDescription.szUserName, [userName UTF8String], userName.length);
	inDescription.dwSize = sizeof(NET_IN_DESCRIPTION_FOR_RESET_PWD);
	inDescription.byInitStatus = device.initStatus;
	
	BOOL isSucceed = CLIENT_GetDescriptionForResetPwd(&inDescription, &outDescription, 5*1000, (char *)[phoneIp UTF8String]);

	DHDeviceResetPWDInfo *resetInfo;
	//查询出的实际字节大于1024时，需要重新处理
	if (isSucceed && outDescription.nQrCodeLenRet > 1024) {
		outDescription.pQrCode = new char[outDescription.nQrCodeLenRet];
		memset(outDescription.pQrCode, 0, outDescription.nQrCodeLenRet);
		isSucceed = CLIENT_GetDescriptionForResetPwd(&inDescription, &outDescription, 5*1000, (char *)[phoneIp UTF8String]);
	}
	
	if (isSucceed) {
		//处理result
		resetInfo = [DHDeviceResetPWDInfo new];
		resetInfo.devicePwdResetWay = device.devicePwdResetWay;
		resetInfo.presetPhone = [self private_stringWithUTF8:outDescription.szCellPhone];
		resetInfo.presetEmail = [self private_stringWithUTF8:outDescription.szMailAddr];
		resetInfo.qrCode = [self private_stringWithUTF8:outDescription.pQrCode];
		
	} else {
		long lastError = CLIENT_GetLastError();
		NSLog(@"NetSDKInteface:: CLIENT_GetDescriptionForResetPwd failed with lastError:...0x%lx", lastError);
		
		/*
         #define NET_ERROR_SECURITY_ERROR_SUPPORT_GUI           _EC(1104)           // 校验请求安全码失败,可使用本地GUI方式重置密码
         #define NET_ERROR_SECURITY_ERROR_SUPPORT_MULT          _EC(1105)           // 校验请求安全码失败,可使用大华渠道APP、configtool工具重置密码
         #define NET_ERROR_SECURITY_ERROR_SUPPORT_UNIQUE        _EC(1106)           // 校验请求安全码失败,可登陆Web页面重置密码
         
         NET_ERROR_SECURITY_GENERATE_SAFE_CODE                  _EC(1108)           // 调用大华加密库产生安全码失败
         NET_ERROR_SECURITY_GET_CONTACT                         _EC(1109)           // 获取联系方式失败
         NET_ERROR_SECURITY_GET_QRCODE                          _EC(1110)           // 获取重置密码的二维码信息失败
         NET_ERROR_SECURITY_CANNOT_RESET                        _EC(1111)           // 设备未初始化,无法重置
         NET_ERROR_SECURITY_NOT_SUPPORT_CONTACT_MODE            _EC(1112)           // 不支持设置该种联系方式,如只支持设置手机号，却请求设置邮箱
         NET_ERROR_SECURITY_RESPONSE_TIMEOUT                    _EC(1113)           // 对端响应超时
         NET_ERROR_SECURITY_AUTHCODE_FORBIDDEN                  _EC(1114)           // 尝试校验AuthCode次数过多，禁止校验

		 */
		//_EC(x) (0x80000000|x)
		resetInfo = [DHDeviceResetPWDInfo new];
		if (lastError == NET_ERROR_SECURITY_ERROR_SUPPORT_GUI) {
			resetInfo.errorType = DHDevicePasswordResetErrorGUI;
		} else if (lastError == NET_ERROR_SECURITY_ERROR_SUPPORT_MULT) {
			resetInfo.errorType = DHDevicePasswordResetErrorMulti;
		} else if (lastError == NET_ERROR_SECURITY_ERROR_SUPPORT_UNIQUE) {
			resetInfo.errorType = DHDevicePasswordResetErrorWeb;
		} else {
			resetInfo.errorType = DHDevicePasswordResetErrorOther;
		}
	}
	
	NSLog(@"🍎🍎🍎 %@:: CLIENT_GetDescriptionForResetPwd: Result %d, phone:%s, email:%s, qrcode:%s, newVersion:%d",
		  NSStringFromClass([self class]), isSucceed,  outDescription.szCellPhone, outDescription.szMailAddr, outDescription.pQrCode, resetInfo.isNewVersion);
	
	delete outDescription.pQrCode;
	outDescription.pQrCode = nil;
	
	return resetInfo;
}

+ (DHDevicePWDResetInfo *)resetPassword:(NSString *)password
			   device:(DHDeviceNetInfo *)device
		 securityCode:(NSString *)securityCode
			  contact:(NSString *)contact
		  useAsPreset:(BOOL)useAsPreset
			byPhoneIp:(NSString *)phoneIp {
	NSString *userName = @"admin";
	NET_IN_RESET_PWD inReset = {0};
	inReset.dwSize = sizeof(NET_IN_RESET_PWD);
	memcpy(inReset.szMac, [device.mac UTF8String], device.mac.length);
	memcpy(inReset.szUserName, [userName UTF8String], userName.length);
	memcpy(inReset.szPwd, [password UTF8String], password.length);
	memcpy(inReset.szSecurity, [securityCode UTF8String], securityCode.length);
	memcpy(inReset.szContact, [contact UTF8String], contact.length);
	inReset.byInitStaus = device.initStatus;
	inReset.byPwdResetWay = device.byPWDResetWay;
	inReset.bSetContact = useAsPreset;
	
	NET_OUT_RESET_PWD outReset = {0};
	outReset.dwSize = sizeof(NET_OUT_RESET_PWD);
	
	BOOL result = CLIENT_ResetPwd(&inReset, &outReset, 10*1000, (char *)[phoneIp UTF8String]);
	
    NSLog(@"🍎🍎🍎 %@:: CLIENT_ResetPwd: Result %d, dwSize:%u, byInitStaus:%c, byPwdResetWay:%c, bSetContact:%d",
          NSStringFromClass([self class]), result,  inReset.dwSize, inReset.byInitStaus, inReset.byPwdResetWay, inReset.bSetContact);
    
    DHDevicePWDResetInfo *info = [[DHDevicePWDResetInfo alloc]init];
    info.isSuccess = result;
    if (!result) {
        unsigned int lastError = CLIENT_GetLastError();
        info.errorStr = [DHNetSDKInterface getDeviceRessetErrorDescription:lastError];
        NSLog(@"NetSDKInteface:: CLIENT_GetDescriptionForResetPwd failed with lastError:...0x%x", lastError);
    }
	
	return info;
}

//MARK:Private
+ (NSString *)private_stringWithUTF8:(char *)utf8 {
	if (utf8 == NULL) {
		return @"";
	}
	
	return [NSString stringWithUTF8String:utf8];
}

void CALLBACK fDisconnect(LLONG lLoginID, char *pchDVRIP, LONG nDVRPort, LDWORD dwUser) {
	if ([DHNetSDKInterface sharedInstance].disconnectCallback) {
		NSString *ip = @"";
		if (pchDVRIP != nil) {
			ip = [NSString stringWithUTF8String:pchDVRIP];
		}
		
		[DHNetSDKInterface sharedInstance].disconnectCallback(lLoginID, ip, nDVRPort);
        // 发送断开连接通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LCNotificationLocalNetworkDisconnect" object:nil userInfo:@{@"IP":ip}];
	}
}

@end


//MARK: Safe String Copy
void safe_strcpy(char *__dst, const char *__src) {
	if (__src) {
		strcpy(__dst, __src);
	} else {
		NSLog(@"🍎🍎🍎 %s:: __src can't be nil...", __FUNCTION__ );
	}
}
