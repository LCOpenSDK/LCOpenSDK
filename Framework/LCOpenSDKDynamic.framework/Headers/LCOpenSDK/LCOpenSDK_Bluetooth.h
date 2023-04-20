//
//  LCOpenSDK_Bluetooth.h
//  LCOpenSDKDynamic
//
//  Created by yyg on 2022/5/12.
//  Copyright © 2022 Fizz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCOpenSDK_Bluetooth : NSObject
/// Start asynchronous Bluetooth distribution network    zh:开始异步蓝牙配网
/// @param wifiName wifi ssid    zh:wifi名字
/// @param wifiPwd wifi password    zh:wifi密码
/// @param productId product ID    zh:产品ID
/// @param deviceId device ID    zh:设备ID
/// @param finshed callback after the completion of the distribution network, success or not errorMessage failure error prompt    zh:配网完成后回调，success 是否成功  errorMessage 失败错误提示
+ (void)startAsyncBLEConfig:(NSString *)wifiName
                    wifiPwd:(NSString *_Nullable)wifiPwd
                  productId:(NSString *)productId
                   deviceId:(NSString *)deviceId
                    finshed:(void(^_Nullable)(BOOL success, NSString *_Nullable errorMessage))finshed;

@end

NS_ASSUME_NONNULL_END
