//
//  LCOpenSDK_DeviceOperateApi.h
//  LCOpenSDKDynamic
//
//  Created by admin on 2024/10/26.
//  Copyright © 2024 Fizz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCOpenSDK_Param.h"

NS_ASSUME_NONNULL_BEGIN

#define LOG_TAG "LCOpenSDK_DeviceOperateApi"

@interface LCOpenSDK_DeviceOperateApi : NSObject

- (void)controlMovePTZ: (NSString*)accessToken deviceId:(NSString* )deviceId productId:(NSString* _Nullable)productId channelId:(NSString*) channelId PTZControllerInfo:(LCOpenSDK_PTZControllerInfo *)PTZControllerInfo playToken: (NSString* )playToken;

@end

NS_ASSUME_NONNULL_END
