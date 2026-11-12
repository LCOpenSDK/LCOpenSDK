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

/// token 由调用方从云端取到后传入。空 token 直接结束，不扫描。timeout <= 0 时使用 30 秒。不回调连接结果，调用方用 isConnectedBle 查询。
+ (void)connectBleLockWithToken:(NSString *)deviceId
                      productId:(NSString *)productId
                        bleName:(NSString *)bleName
                          token:(NSString *)token
                        timeout:(NSTimeInterval)timeout;

/// 页面离开或不打算继续用这条链路时调用。不走 disConnect。
+ (void)closeBleLockDevice:(NSString *)deviceId;

/// 仅会话已登录时加密写入 message。message 由调用方传入，例如 {"inputData":{},"service":"26600"}。未就绪直接失败，不写蓝牙。
/// 成功时 response 为设备回包解密后的 JSON，例如 {"service":"26600","outputData":{"26621":0}}；失败时 response 为 nil。
+ (void)sendMessage:(NSString *)deviceId
          productId:(NSString *)productId
            message:(NSString *)message
           finished:(void (^)(BOOL success, NSInteger errorCode, NSString * _Nullable response))finished;

/// 该设备是否已登录且可以发送蓝牙报文。true 走 sendMessage，false 只能走云端开锁。
+ (BOOL)isConnectedBle:(NSString *)deviceId;

@end

NS_ASSUME_NONNULL_END
