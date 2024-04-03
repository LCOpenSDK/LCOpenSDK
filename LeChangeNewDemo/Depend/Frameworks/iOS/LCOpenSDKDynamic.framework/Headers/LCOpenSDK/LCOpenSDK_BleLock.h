//
//  LCOpenSDK_BLELock.h
//  LCOpenSDKDynamic
//
//  Created by dahua on 2024/1/16.
//  Copyright © 2024 Fizz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_Define.h>
NS_ASSUME_NONNULL_BEGIN

@interface LCOpenSDK_BleLock : NSObject

/// @param deviceId device ID    zh:设备ID
/// @param productId product ID    zh:产品ID
/// @param finshed callback after the completion of the connect device, success or not errorMessage failure error prompt    zh:连接完成后回调，success 是否成功  errorMessage 失败错误提示
+ (void) startBleLockConnect:(NSString *)deviceId
                   productId:(NSString * _Nullable)productId
                     bleName:(NSString *)bleName
                     outTime:(NSTimeInterval)outTime
                   isBinding:(BOOL)isBinding
                    finished:(void(^)(BOOL success, NSString *errorMessage))finished;


/// @param deviceId device ID    zh:设备ID
/// @param productId product ID    zh:产品ID
/// @param userId user ID    zh:客户端生成的唯一id
/// @param finshed callback after the completion of the bind device, success or not errorMessage failure error prompt bindToken after the bind device success device return a random code   zh:绑定完成后回调，success 是否成功  errorMessage 失败错误提示 bindToken 绑定成功随机数
+ (void) startBleLockBind:(NSString *)deviceId
                productId:(NSString *_Nullable)productId
                   userId:(NSString *) userId
                  finshed:(void(^)(BOOL success, NSInteger errorCode, NSString *_Nullable bindToken))finshed;


/// @param deviceId device ID    zh:设备ID
/// @param productId product ID    zh:产品ID
/// @param userId user ID    zh:客户端生成的唯一id
/// @param finshed callback after the completion of the login device, success or not errorMessage failure error prompt loginToken after the login device success device return a random code   zh:登录完成后回调，success 是否成功  errorMessage 失败错误提示 loginToken 登录成功随机数
+ (void) startBleLockLogin:(NSString *)deviceId
                 productId:(NSString *_Nullable)productId
                    userId:(NSString *) userId
                   finshed:(void(^)(BOOL success, NSInteger errorCode, NSString *_Nullable loginToken))finshed;


/// @param deviceId device ID    zh:设备ID
/// @param productId product ID    zh:产品ID
/// @param loginToken login Token    zh:登录成功随机数
/// @param bindToken bind Token    zh:绑定成功随机数
/// @param finshed callback after the completion of the open BLE lock, success or not errorMessage failure error prompt    zh:开锁完成后回调，success 是否成功  errorMessage 失败错误提示
+ (void) startBleLockOpen:(NSString *)deviceId
                productId:(NSString *_Nullable)productId
               loginToken:(NSString *)loginToken
                bindToken:(NSString *)bindToken
                  finshed:(void(^)(BOOL success, NSInteger errorCode))finshed;

/// 断开当前连接的蓝牙外设
+ (void)disConnect;
@end

NS_ASSUME_NONNULL_END
