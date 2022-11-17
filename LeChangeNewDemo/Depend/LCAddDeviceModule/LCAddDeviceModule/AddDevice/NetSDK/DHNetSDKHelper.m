//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

#import "DHNetSDKHelper.h"
#import "DHNetSDKInterface.h"

@implementation DHNetSDKHelper

+ (void)loginDeviceByIp:(NSString *)devIp
				   port:(NSInteger)port
               username:(NSString *)username
               password:(NSString *)password
                success:(void (^)(long loginHandle))success
                failure:(void (^)(NSString *description))failure {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        unsigned int error = 0;
        long loginHandle = [LCOpenSDK_DeviceInit loginDeviceByIP:devIp port:port username:username password:password highLevelSecurity:NO errorCode:&error];
		dispatch_async(dispatch_get_main_queue(), ^{
            if (loginHandle) {
                success(loginHandle);
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
        long loginHandle = [LCOpenSDK_DeviceInit loginDeviceByIP:devIp port:port username:username password:password highLevelSecurity:YES errorCode:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (loginHandle) {
                success(loginHandle);
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

/// 软AP配网   SoftAP distribution network
+ (void)startSoftAPConfig:(NSString *)wifiName
                  wifiPwd:(NSString *)wifiPwd
                wifiEncry:(int)wifiEncry
              netcardName:(NSString *)netcardName
                 deviceIp:(NSString *)deviceIp
                devicePwd:(NSString *)devicePwd
                     isSC:(BOOL)isSC
                  handler:(void(^)(NSInteger result))handler
                  timeout:(int)timeout {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [LCOpenSDK_SoftApConfig startSoftAPConfig:wifiName wifiPwd:wifiPwd wifiEncry:wifiEncry netcardName:netcardName deviceIp:deviceIp devicePwd:devicePwd isSC:isSC handler:^(NSInteger result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) {
                    handler(result);
                }
            });
        } timeout:5000 * 2];
    });
}

/// 软AP配网获取设备wifi列表   Wifi list of soft AP distribution network acquisition equipment
+ (void)getSoftApWifiList:(NSString *)deviceIP
                     port:(NSInteger)port
           devicePassword:(NSString *)password
                     isSC:(BOOL)isSC
                  success:(void(^)(NSArray <LCOpenSDK_WifiInfo *>* _Nullable list))success
                  failure:(void(^)(NSInteger code, NSString* _Nullable describe))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [LCOpenSDK_SoftApConfig getSoftApWifiList:deviceIP port:port devicePassword:password isSC:isSC success:^(NSArray<LCOpenSDK_WifiInfo *> * _Nullable list) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    success(list);
                }
            });
        } failure:^(NSInteger code, NSString * _Nullable describe) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure(code, describe);
                }
            });
        }];
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

+ (void)queryPasswordResetType:(LCDeviceNetInfo *)device
					 byPhoneIp:(NSString *)phoneIp
						result:(void(^) (LCDeviceResetPWDInfo *))result {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        LCDeviceResetPWDInfo * Info = [DHNetSDKInterface queryPasswordResetType:device byPhoneIp:phoneIp];
		dispatch_async(dispatch_get_main_queue(), ^{
			result(Info);
		});
	});
}

+ (void)resetPassword:(NSString *)password
			   device:(LCDeviceNetInfo *)device
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
