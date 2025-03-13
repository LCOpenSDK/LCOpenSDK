//
//  LCOpenMediaApiManager.h
//  LCOpenSDKDynamic
//
//  Created by lei on 2024/10/11.
//  Copyright © 2024 Fizz. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@class LCOpenMediaSource;
@class LCOpenSDK_Device;
@class LCOpenSDK_Record;
@class LCOpenSDK_Stream;
@class LCOpenSDK_Err;
@interface LCOpenMediaApiManager : NSObject

@property (nonatomic, strong) LCOpenSDK_Stream *stream;
@property (nonatomic, strong) LCOpenSDK_Device *device;
@property (nonatomic, strong) LCOpenSDK_Record *record;
@property (nonatomic, copy) NSString *token; //管理员token
@property (nonatomic, assign)BOOL isTls; //是否TLS拉流
@property (nonatomic, assign)BOOL isAssistFrame; //是否请求辅助帧

+ (instancetype)shareInstance;

//-(void)configMediaSource:(LCOpenMediaSource *)mediaSource;

/// 获取对讲拉流MTS地址
/// - Parameters:
///   - success: url回调
///   - errorCode: 错误码回调
-(void)getTalkStreamUrl:(void (^)(NSDictionary *))success failure:(void(^)(LCOpenSDK_Err *err))failure;

/// 获取实时拉流MTS地址
/// - Parameters:
///   - success: url回调
///   - errorCode: 错误码回调
-(void)getRealStreamUrl:(void (^)(NSDictionary *))success failure:(void(^)(LCOpenSDK_Err *err))failure;

/// 获取按文件回放录像MTS地址
/// - Parameters:
///   - success: url回调
///   - errorCode: 错误码回调
-(void)getDeviceRecordFileStreamUrl:(void (^)(NSDictionary *))success failure:(void(^)(LCOpenSDK_Err *err))failure;

/// 获取按时间回放录像拉流MTS地址
/// - Parameters:
///   - success: url回调
///   - errorCode: 错误码回调
-(void)getDeviceRecordTimeStreamUrl:(void (^)(NSDictionary *))success failure:(void(^)(LCOpenSDK_Err *err))failure;

/// 获取playToken解析秘钥
/// - Parameters:
///   - token: 管理员token
///   - success: 成功回调
///   - failure: 失败回调
- (void)getPlayTokenKey:(NSString *)token
                success:(void(^)(NSString *playTokenKey))success
                failure:(void(^)(NSString *errorCode))failure;


/// 获取云录像拉流地址
/// - Parameters:
///   - deviceId: 设备序列号
///   - productId: 产品Id
///   - recordRegionId: 录像id
///   - type: 录像类型
///   - channelID: 通道id
///   - success: 成功回调
///   - failure: 失败回调
- (NSDictionary *)getCloudRecordUrl:(NSString *)token
                deviceId:(NSString *)deviceId
                productId:(NSString *)productId
                channelId:(NSInteger)channelId
           recordRegionId:(NSString *)recordRegionId
                     type:(NSString *)type
                            failure:(LCOpenSDK_Err *_Nullable*_Nullable)error;


@end

NS_ASSUME_NONNULL_END
