//
//  LCOpenSDK_NetsdkLogin.h
//  LCOpenSDK
//
//  Created by bzy on 5/20/17.
//  Copyright © 2017 lechange. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LCOpenSDK_Err;

typedef void (^LCOpenSDK_LanLiveLoginSuccess)(NSString *ip, NSInteger port, long loginHandle);
typedef void (^LCOpenSDK_LanLiveLoginFailure)(LCOpenSDK_Err *error);

@interface LCOpenSDK_NetsdkLogin : NSObject

+ (instancetype _Nullable)shareInstance;

- (long)getloginHandle:(NSString *)token deviceID:(NSString *)deviceID;

/// LAN live preview login. Search + NetSDK login are fused inside.
/// Device account (devLoginName / devLoginPassword) is parsed from playToken.
/// @param playToken device playToken, prefer playTokenV2
/// @param token open-platform access token, used to decrypt playToken
/// @param deviceID device serial number, used to match search result
/// @param success login success, returns ip / port / loginHandle
/// @param failure search or login error for the caller to handle
/// zh: 局域网预览登录。内部融合设备搜索与 NetSDK 登录，账号密码从 playToken 解析。
- (void)getLanLiveLoginHandle:(NSString *)playToken
                        token:(NSString *)token
                     deviceID:(NSString *)deviceID
                      success:(LCOpenSDK_LanLiveLoginSuccess)success
                      failure:(LCOpenSDK_LanLiveLoginFailure)failure;

@end

NS_ASSUME_NONNULL_END
