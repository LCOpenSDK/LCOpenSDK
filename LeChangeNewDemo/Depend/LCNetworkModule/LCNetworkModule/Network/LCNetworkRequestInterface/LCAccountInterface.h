//
//  Copyright © 2019 Imou. All rights reserved.
//  账户对接相关接口

#import <Foundation/Foundation.h>
#import "LCModel.h"

NS_ASSUME_NONNULL_BEGIN

@class LCError;

@interface LCAccountInterface : NSObject

/**
 获取管理员模式Token

 @param success 成功回调
 @param failure 失败回调
 */
+ (void)accessTokenWithsuccess:(void (^)(LCAuthModel *authInfo))success
                       failure:(void (^)(LCError *error))failure;

/**
 创建子账户

 @param account 账户
 @param success 成功回调
 @param failure 失败回调
 */

+ (void)createSubAccount:(nonnull NSString *)account success:(void (^)(LCAuthModel *authInfo))success
                   failure:(void (^)(LCError *error))failure;

/**
 获取子账户Token

 @param openId  子账户Id
 @param success 成功回调
 @param failure 失败回调
 */

+ (void)subAccountToken:(nonnull NSString *)openId success:(void (^)(LCAuthModel *authInfo))success
                failure:(void (^)(LCError *error))failure;

/**
 获取子账户id

 @param account 账户
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)getOpenIdByAccount:(nonnull NSString *)account success:(void (^)(LCAuthModel *authInfo))success
                   failure:(void (^)(LCError *error))failure;

/**
 向用户发送短信验证码

 @param phoneNum 接收验证码的手机号
 @param success 成功回调
 @param failure 失败回调
 */
+(void)userBindSms:(NSString *)phoneNum success:(void (^)(void))success
           failure:(void (^)(LCError *error))failure;


@end

NS_ASSUME_NONNULL_END
