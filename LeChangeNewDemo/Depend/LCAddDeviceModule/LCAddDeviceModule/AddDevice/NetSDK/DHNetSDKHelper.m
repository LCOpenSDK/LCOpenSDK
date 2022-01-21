//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//

#import "DHNetSDKHelper.h"
#import "DHNetSDKInterface.h"
#import <LCOpenSDKDynamic/LCOpenSDKDynamic.h>

@implementation DHNetSDKHelper

+ (void)loginDeviceByIp:(NSString *)devIp
				   port:(NSInteger)port
               username:(NSString *)username
               password:(NSString *)password
                success:(void (^)(long loginHandle))success
                failure:(void (^)(NSString *description))failure {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        unsigned int error = 0;
		DHNetLoginDeviceInfo *deviceInfo = [DHNetSDKInterface loginDeviceByIP:devIp port:port username:username password:password errorCode:&error];
		dispatch_async(dispatch_get_main_queue(), ^{
            if (deviceInfo.loginHandle) {
                success(deviceInfo.loginHandle);
            } else {
                NSString *description = [DHNetSDKInterface getErrorDescription:error];
                failure(description);
            }
		});
	});
}

+ (void)loginDeviceExByIp:(NSString *)devIp
                     port:(NSInteger)port
                 username:(NSString *)username
                 password:(NSString *)password
                  success:(void (^)(DHNetLoginDeviceInfo *deviceInfo))success
                  failure:(void (^)(NSString *description))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        unsigned int error = 0;
        DHNetLoginDeviceInfo *deviceInfo = [DHNetSDKInterface loginDeviceByIP:devIp port:port username:username password:password errorCode:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (deviceInfo.loginHandle) {
                success(deviceInfo);
            } else {
                NSString *description = [DHNetSDKInterface getErrorDescription:error];
                failure(description);
            }
        });
    });
}

/// 安全登陆
/// @param devIp IP地址
/// @param port 端口号
/// @param username 用户名
/// @param password 密码
/// @param success
/// @param failure
+ (void)loginWithHighLevelSecurityByIp:(NSString *)devIp
                                  port:(NSInteger)port
                              username:(NSString *)username
                              password:(NSString *)password
                               success:(void (^)(long loginHandle))success
                               failure:(void (^)(NSString *description))failure
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        unsigned int error = 0;
        DHNetLoginDeviceInfo *deviceInfo = [DHNetSDKInterface loginWithHighLevelSecurityByIP:devIp port:port username:username password:password errorCode:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (deviceInfo.loginHandle) {
                success(deviceInfo.loginHandle);
            } else {
                if (error == -1) {
                    //设备不支持高安全等级登录
                    failure(@"-1");
                }else {
                    NSString *description = [DHNetSDKInterface getErrorDescription:error];
                    failure(description);
                }
            }
        });
    });
}

+ (void)loginWithHighLevelSecurityExByIp:(NSString *)devIp
                                  port:(NSInteger)port
                              username:(NSString *)username
                              password:(NSString *)password
                               success:(void (^)(DHNetLoginDeviceInfo *deviceInfo))success
                               failure:(void (^)(NSString *description))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        unsigned int error = 0;
        DHNetLoginDeviceInfo *deviceInfo = [DHNetSDKInterface loginWithHighLevelSecurityByIP:devIp port:port username:username password:password errorCode:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (deviceInfo.loginHandle) {
                success(deviceInfo);
            } else {
                if (error == -1) {
                    //设备不支持高安全等级登录
                    failure(@"-1");
                }else {
                    NSString *description = [DHNetSDKInterface getErrorDescription:error];
                    failure(description);
                }
            }
        });
    });
}

+ (void)logoutDevice:(long)loginHandle completion:(dispatch_block_t)completion {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[DHNetSDKInterface logout:loginHandle];
		dispatch_async(dispatch_get_main_queue(), ^{
			if (completion) {
				completion();
			}
		});
	});
}

+ (void)scDeviceApConnectWifi:(NSString *)mSSID
                     password:(NSString *)password
                           ip:(NSString *)deviceIP
                         port:(NSInteger)port
          encryptionAuthority:(int)encryptionAuthority complete:(void (^)(NSInteger error))complete {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        unsigned int error = 0;
        [DHNetSDKInterface scDeviceApConnectWifi:mSSID password:password ip:deviceIP port:port encryptionAuthority:encryptionAuthority];
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(error);
        });
    });
}

+(void)scDeviceSoftAPConnectWifi:(NSString *)wifiName wiFiPsw:(NSString *)wiFiPsw deviceId:(NSString *)deviceId devicePsw:(NSString *)devicePsw isSC:(BOOL)isSC complete:(void (^)(BOOL))complete{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        LCOpenSDK_SoftAP *softAP = [LCOpenSDK_SoftAP new];
        NSInteger result = [softAP startSoftAPConfig:wifiName wifiPwd:wiFiPsw deviceId:deviceId devicePwd:devicePsw?devicePsw:@"" isSC:isSC];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result<0) {
                
                complete(NO);
            }else{
                complete(YES);
            }
        });
    });
}

+(void)searchDeviceInitInfo:(NSString *)deviceId timeOut:(int)timeOut callBack:(void (^)(NSDictionary *))callBack{
    
    LCOpenSDK_DeviceInit *deviceInit = [LCOpenSDK_DeviceInit new];
    [deviceInit searchDeviceInitInfo:deviceId timeOut:timeOut success:^(LCOPENSDK_DEVICE_INIT_INFO info) {
       
        NSString *theMac = [NSString stringWithUTF8String:info.mac];
        NSString *theIp = [NSString stringWithUTF8String:info.ip];
        NSString *thePort = [NSString stringWithFormat:@"%d",info.port];
        NSString *theStatus = [NSString stringWithFormat:@"%d",info.status];
        callBack(@{@"theMac":theMac,@"theIp":theIp,@"thePort":thePort,@"theStatus":theStatus});
    }];
}

+ (void)scDeviceApLoadWifiList:(NSString *)deviceIP port:(NSInteger)port complete:(void (^)(NSArray<DHApWifiInfo *> * Wifilist, NSInteger error))complete {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        unsigned int error = 0;
        NSArray *arr = [DHNetSDKInterface scDeviceApLoadWifiList:deviceIP port:port error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(arr, error);
        });
    });
}

+ (void)loadWifiListByLoginHandle:(long)loginHandle
						 complete:(void (^)(NSArray<DHApWifiInfo *> * Wifilist, NSInteger error))complete {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		unsigned int error = 0;
		NSArray *arr = [DHNetSDKInterface loadWifiListByLoginHandle:loginHandle errorCode:&error];
		dispatch_async(dispatch_get_main_queue(), ^{
			complete(arr, error);
		});
	});
}

+ (void)connectWIFIByLoginHandle:(long)loginHandle
                            ssid:(NSString *)ssid
                        password:(NSString *)password
             encryptionAuthority:(int)encryptionAuthority
                     netcardName:(NSString *)netcardName
                        complete:(void (^)(BOOL result))complete {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSUInteger errorCode = [DHNetSDKInterface connectWIFIByLoginHandle:loginHandle
                                                                      ssid:ssid
                                                                  password:password
                                                       encryptionAuthority:encryptionAuthority
                                                               netcardName:netcardName];
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(errorCode == 0);
        });
    });
}

+ (void)queryProductDefinition:(long)loginHandle
					   success:(void (^)(DHDeviceProductDefinition *))success
					   failure:(dispatch_block_t)failure {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		DHDeviceProductDefinition *definition = [DHNetSDKInterface queryProductDefinitionInfo:loginHandle];
		dispatch_async(dispatch_get_main_queue(), ^{
			if (definition) {
				success(definition);
			} else {
				failure();
			}
		});
	});
}

+ (void)queryDeviceUserInfoDefinition:(long)loginHandle
                              success:(void (^)(DHDeviceUserInfoDefinition *))success
                              failure:(dispatch_block_t)failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        DHDeviceUserInfoDefinition *definition = [DHNetSDKInterface queryDeviceUserInfo:loginHandle];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (definition) {
                success(definition);
            } else {
                failure();
            }
        });
    });
}

+ (void)queryPasswordResetType:(DHDeviceNetInfo *)device
					 byPhoneIp:(NSString *)phoneIp
						result:(void(^) (DHDeviceResetPWDInfo *))result {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		DHDeviceResetPWDInfo * Info = [DHNetSDKInterface queryPasswordResetType:device byPhoneIp:phoneIp];
		dispatch_async(dispatch_get_main_queue(), ^{
			result(Info);
		});
	});
}

+ (void)resetPassword:(NSString *)password
			   device:(DHDeviceNetInfo *)device
		 securityCode:(NSString *)securityCode
			  contact:(NSString *)contact
		  useAsPreset:(BOOL)useAsPreset
			byPhoneIp:(NSString *)phoneIp
			   result:(void(^) (DHDevicePWDResetInfo *))result {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		DHDevicePWDResetInfo *info = [DHNetSDKInterface resetPassword:password device:device securityCode:securityCode contact:contact useAsPreset:useAsPreset byPhoneIp:phoneIp];
		dispatch_async(dispatch_get_main_queue(), ^{
			result(info);
		});
	});
}

+ (void)startNetSDKReportByRequestId:(NSString *)requestId;
{
    [DHNetSDKInterface startNetSDKReportByRequestId:requestId];
    
}

+ (void)stopNetSDKReport{
    [DHNetSDKInterface stopNetSDKReport];
}
@end
