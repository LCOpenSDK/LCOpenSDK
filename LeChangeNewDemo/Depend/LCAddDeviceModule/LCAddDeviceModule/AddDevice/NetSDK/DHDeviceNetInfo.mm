//
//  Copyright © 2018年 dahua. All rights reserved.
//

#import "DHDeviceNetInfo.h"
#import <LCOpenSDKDynamic/LCOpenNetSDK/netsdk.h>

@implementation DHDeviceNetInfo
- (instancetype)initWithNetInfo:(void *)pDevice
{
    if(self = [super init])
    {
		DEVICE_NET_INFO_EX *pDevNetInfo = (DEVICE_NET_INFO_EX *)pDevice;
        self.ipVersion = pDevNetInfo->iIPVersion;
        self.ip = [NSString stringWithUTF8String:pDevNetInfo->szIP];
		self.port = pDevNetInfo->nPort > 0 ? pDevNetInfo->nPort : 37777;
        self.submask = [NSString stringWithUTF8String:pDevNetInfo->szSubmask];
        self.mac = [NSString stringWithUTF8String:pDevNetInfo->szMac];
        self.gateway = [NSString stringWithUTF8String:pDevNetInfo->szGateway];
        self.deviceType = [NSString stringWithUTF8String:pDevNetInfo->szDeviceType];
        self.definition = pDevNetInfo->byDefinition;
        self.manuFactory = pDevNetInfo->byManuFactory;
        self.dhcpEn = pDevNetInfo->bDhcpEn;
        self.reserved1 = pDevNetInfo->byReserved1;
        self.verifyData = [NSString stringWithUTF8String:pDevNetInfo->verifyData];
        
        self.serialNo = [NSString stringWithUTF8String:pDevNetInfo->szSerialNo];
        self.devSoftVersion = [NSString stringWithUTF8String:pDevNetInfo->szDevSoftVersion];
        self.detailType = [NSString stringWithUTF8String:pDevNetInfo->szDetailType];
        self.vendor = [NSString stringWithUTF8String:pDevNetInfo->szVendor];
        self.devName = [NSString stringWithUTF8String:pDevNetInfo->szDevName];
        self.userName = [NSString stringWithUTF8String:pDevNetInfo->szUserName];
        self.passWord = [NSString stringWithUTF8String:pDevNetInfo->szPassWord];
        self.httpPort = pDevNetInfo->nHttpPort;
        self.videoInputCh = pDevNetInfo->wVideoInputCh;
        self.remoteVideoInputCh = pDevNetInfo->wRemoteVideoInputCh;
        self.videoOutputCh = pDevNetInfo->wVideoOutputCh;
        self.alarmInputCh = pDevNetInfo->wAlarmInputCh;
        self.alarmOutputCh = pDevNetInfo->wAlarmOutputCh;
        self.newWordLen = pDevNetInfo->bNewWordLen;
        self.nowPassWord = [NSString stringWithUTF8String:pDevNetInfo->szNewPassWord];
        self.initStatus = pDevNetInfo->byInitStatus;
        self.byPWDResetWay = pDevNetInfo->byPwdResetWay;
        self.specialAbility = pDevNetInfo->bySpecialAbility;
        self.nowDetailType = [NSString stringWithUTF8String:pDevNetInfo->szNewDetailType];
        self.bNowUserName = pDevNetInfo->bNewUserName;
        self.nowUserName = [NSString stringWithUTF8String:pDevNetInfo->szNewUserName];
	}
	
    return self;
}

#pragma mark - ISearchDeviceNetInfo

- (NSString *)deviceSN
{
    return self.serialNo;
}

- (NSString *)deviceIP
{
    return self.ip;
}

- (NSString *)deviceMac
{
    return self.mac;
}

- (DHDevicePasswordResetType)devicePwdResetWay
{
	DHDevicePasswordResetType type = DHDevicePasswordResetUnkown;
	if ((self.byPWDResetWay >> 3) & 0B01) {
		type = DHDevicePasswordResetPresetPhone;
	} else if ((self.byPWDResetWay >> 1) & 0B01) {
		type = DHDevicePasswordResetPresetEmail;
	} else if (self.byPWDResetWay & 0B01) {
		type = DHDevicePasswordResetPresetPhone;
	}
	
	return type;
}

- (DHIPType)ipType
{
    return (DHIPType)self.ipVersion;
}

- (DHDeviceInitType)deviceInitType
{
    int bySpecialAbility = self.specialAbility;
    int flag = (bySpecialAbility >> 2)&0B11;
    if (flag == 0B00) {
        //老设备
        return DHDeviceInitTypeOldDevice;
    }else if (flag == 0B01){
        //IP无效
        return DHDeviceInitTypeIPUnable;
    }else if (flag == 0B10){
        //IP有效
        return DHDeviceInitTypeIPEnable ;
    }
	
    return DHDeviceInitTypeOldDevice;
}

- (DHDeviceInitStatus)deviceInitStatus
{
    BYTE byInitStatus = self.initStatus;
    if((byInitStatus & 0B01) == 0B01)
    {
        return DHDeviceInitStatusUnInit;
    }
    else if((byInitStatus & 0B10) == 0B10)
    {
        return DHDeviceInitStatusInit;
    }

    
    return DHDeviceInitStatusNoAbility;
}

- (void)setDeviceInitStatus:(DHDeviceInitStatus)status {
	if (status == DHDeviceInitStatusInit) {
		self.initStatus = (self.initStatus & (0xFF << 2)) | 0B10;
	} else if (status == DHDeviceInitStatusUnInit) {
		self.initStatus = (self.initStatus & (0xFF << 2)) | 0B01;
	}
}


- (BOOL)isSupportPWDReset {
	// bit6~7: 0- 未知 1-不支持密码重置 2-支持密码重置
	BYTE status = (self.initStatus >> 6) & 0B11 ;
	if (status == 2) {
		//只有这一种情况才支持重置
		return YES;
	}
	
	return NO;
}

//@property (nonatomic, copy)NSString *deviceSN; // 序列号
//@property (nonatomic, copy)NSString *deviceIP; // 设备IP
@end




//MARK: Product Definition
@implementation DHDeviceProductDefinition

@synthesize deviceInitStatus;

@synthesize deviceInitType;

@synthesize deviceIP;

@synthesize deviceMac;

@synthesize devicePwdResetWay;

@synthesize deviceSN;

@synthesize ipType;

@synthesize isSupportPWDReset;

@synthesize isVaild;

@synthesize port;

@synthesize searchSequence;

@end

//MARK: DHDeviceUserInfoDefinition
@implementation DHDeviceUserInfoDefinition

@end

//MARK: DHNetLoginDeviceInfo
@implementation DHNetLoginDeviceInfo

@end
