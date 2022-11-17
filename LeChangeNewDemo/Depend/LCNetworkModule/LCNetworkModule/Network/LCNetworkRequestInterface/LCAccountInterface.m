//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "LCAccountInterface.h"
#import "LCNetworkRequestManager.h"
#import "LCApplicationDataManager.h"
#import <LCBaseModule/LCError.h>

@implementation LCAccountInterface

+ (void)accessTokenWithsuccess:(void (^)(LCAuthModel *_Nonnull))success failure:(void (^)(LCError *_Nonnull))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/accessToken" parameters:@{} success:^(id _Nonnull objc) {
        NSLog(@"%@",[NSThread currentThread]);
        LCAuthModel *model = [LCAuthModel mj_objectWithKeyValues:objc];
        [LCApplicationDataManager setManagerToken:model.accessToken];
        [LCApplicationDataManager setExpireTime:model.expireTime];
        if (success) {
            // TODO: 相关数据存本地
            success(model);
        }
    } failure:^(LCError *error) {
        //开发者应自行处理错误
        failure(error);
    }];
  
}

+ (void)createSubAccount:(nonnull NSString *)account success:(void (^)(LCAuthModel *authInfo))success
                 failure:(void (^)(LCError *error))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/createSubAccount" parameters:@{ @"account": account, @"token" : [LCApplicationDataManager managerToken] } success:^(id _Nonnull objc) {
        LCAuthModel *model = [LCAuthModel mj_objectWithKeyValues:objc];
        [LCApplicationDataManager setSubAccountToken:model.openid];
        if (success) {
            // TODO: 相关数据存本地
            success(model);
        }
    } failure:^(LCError *error) {
        //开发者应自行处理错误
        failure(error);
    }];
}

+ (void)subAccountToken:(nonnull NSString *)openId success:(void (^)(LCAuthModel *authInfo))success
                failure:(void (^)(LCError *error))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/subAccountToken" parameters:@{ @"openid": [LCApplicationDataManager openId], @"token" : [LCApplicationDataManager managerToken] } success:^(id _Nonnull objc) {
        LCAuthModel *model = [LCAuthModel mj_objectWithKeyValues:objc];
        [LCApplicationDataManager setSubAccountToken:model.accessToken];
        [LCApplicationDataManager setExpireTime:model.expireTime];
        if (success) {
            // TODO: 相关数据存本地
            success(model);
        }
    } failure:^(LCError *error) {
        //开发者应自行处理错误
        failure(error);
    }];
}


+ (void)getOpenIdByAccount:(nonnull NSString *)account success:(void (^)(LCAuthModel *authInfo))success
                   failure:(void (^)(LCError *error))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/getOpenIdByAccount" parameters:@{ @"account": account , @"token" : [LCApplicationDataManager managerToken]} success:^(id _Nonnull objc) {
        LCAuthModel *model = [LCAuthModel mj_objectWithKeyValues:objc];
        [LCApplicationDataManager setSubAccountId:model.openid];
        if (success) {
            // TODO: 相关数据存本地
            success(model);
        }
    } failure:^(LCError *error) {
        //开发者应自行处理错误
        failure(error);
    }];
}

+ (void)userBindSms:(NSString *)phoneNum success:(void (^)(void))success failure:(void (^)(LCError *_Nonnull))failure {
    [[LCNetworkRequestManager manager] lc_POST:@"/userBindSms" parameters:@{ @"phone": phoneNum } success:^(id _Nonnull objc) {
        if (success) {
            success();
        }
    } failure:^(LCError *error) {
        //开发者应自行处理错误
        failure(error);
    }];
}


@end
