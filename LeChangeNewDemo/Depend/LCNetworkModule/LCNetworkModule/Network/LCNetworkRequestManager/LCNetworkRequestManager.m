//
//  Copyright © 2019 Imou. All rights reserved.
//。网络请求处理类

#import "LCNetworkRequestManager.h"
#import <AFNetworking/AFNetworking.h>
#import "LCApplicationDataManager.h"
#import "LCAccountInterface.h"
#import <LCBaseModule/LCBaseModule.h>

#define TIMEOUT_INTERVAL 10.0 //请求超时时间

@interface LCNetworkRequestManager ()

/// 网络请求管理者
@property (strong, nonatomic) AFURLSessionManager *sessionManager;

@end

@implementation LCNetworkRequestManager

+ (instancetype)manager {
    return [[LCNetworkRequestManager alloc] init];
}

//MARK: - Public Methods
- (void)lc_POST:(NSString *)URLString parameters:(id)parameters success:(requestSuccessBlock)success failure:(requestFailBlock)failure {
    [self post:URLString parameters:parameters success:success failure:failure];
}

- (void)post:(NSString *)URLString parameters:(id)parameters success:(requestSuccessBlock)success failure:(requestFailBlock)failure {
    //请求模型转字典
    NSDictionary *requestDic = [[LCRequestModel lc_WrapperNetworkRequestPackageWithParams:parameters] mj_keyValues];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestDic options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    //拼接请求基地址
    URLString = [[LCApplicationDataManager.hostApi stringByAppendingString:@"/openapi"] stringByAppendingString:URLString];
    NSLog(@"LCOpenSDKDemo request url: %@", URLString);
    NSLog(@"LCOpenSDKDemo request data: \n%@", requestDic);
    //method 为时post请求还是get请求
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:requestDic error:nil];
    //设定超时时间
    request.timeoutInterval = 60;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"text/plain" forHTTPHeaderField:@"Accept"];
    //将对象设置到requestbody中
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    //发起网络请求
    NSURLSessionDataTask *task = [self.sessionManager dataTaskWithRequest:request uploadProgress:^(NSProgress *_Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress *_Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse *_Nonnull response, id _Nullable responseObject, NSError *_Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                NSDictionary *res = [responseObject mj_JSONObject];
                NSLog(@"LCOpenSDKDemo now recv: %@", URLString);
                NSLog(@"LCOpenSDKDemo recv data: \n%@", res);
                LCResponseModel *respObjc = [LCResponseModel mj_objectWithKeyValues:res];
                if ([respObjc.result.code isEqualToString:@"0"]) {
                    success(respObjc.result.data);
                } else {
                    failure([LCError errorWithCode:respObjc.result.code errorMessage:respObjc.result.msg errorInfo:nil]);
                }
            } else {
                NSLog(@"LCOpenSDKDemo now recv error: %@", error);
                LCError *tempError
                = [LCError errorWithCode:@"9999" errorMessage:[NSString stringWithFormat:@"mobile_common_net_fail".lc_T, error.code] errorInfo:error.userInfo];
                failure(tempError);
            }
        });
    }];
    [task resume];
}

//MARK: - Private Methods
- (AFURLSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager =  [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        _sessionManager.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
    }
    return _sessionManager;
}

@end
