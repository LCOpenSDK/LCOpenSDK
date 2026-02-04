//
//  LCMediaNetProtocol.h
//  Pods
//
//  Created by lei on 2025/6/16.
//

#import <Foundation/Foundation.h>
#import "LCMediaServerParameter.h"
#import "LCMediaStreamParam.h"
//#import "LCMediaRequestParam.h"
//#import "LCMediaRealRequestParam.h"
//#import "LCMediaDevRecordRequestParam.h"
//#import "LCMediaPasswordModel.h"

@class LCMediaStreamUrlModel;
@class LCMediaRequestParam;
@class LCMediaRealRequestParam;
@class LCMediaDevRecordRequestParam;
@class LCMediaError;
@class LCMediaPasswordModel;
@protocol LCMediaNetProtocol <NSObject>
#pragma mark - 已适配开放平台接口
//获取对讲拉流地址
- (LCMediaStreamUrlModel *)getNewV2TalkStreamURL:(NSString *)deviceID channelId:(NSInteger)channelId isEncrypt:(NSInteger)isEncrypt talkType:(NSString*)talkType deviceType:(NSString*)deviceType isOpt:(BOOL)isOpt isReuse:(BOOL)isReuse AECtrlV2:(BOOL)AECtrlV2 streamId:(NSInteger)streamId isTLS:(BOOL)isTLS RequestId:(NSString*)requestId ServerParam:(LCMediaServerParameter*) serverParam isAssistInfo:(BOOL)isAssistInfo DevicePid:(NSString*)devicePid AudioType:(NSInteger)audioType isQuic:(BOOL)isQuic streamParam:(LCMediaTalkStreamParam*)talkInfoParam errorCode:(NSInteger *)errorCode openSdkError:(LCMediaError **)openMediaError;

//获取实时流拉流地址
-(LCMediaStreamUrlModel *)getNewV2RealTransformStreamURL:(LCMediaRealRequestParam *)requestParam errorCode:(NSInteger *)errorCode openSdkError:(LCMediaError **)openMediaError;

//按时间回放获取拉流地址
-(LCMediaStreamUrlModel *)getNewV2DevTimeStreamURL:(LCMediaDevRecordRequestParam *)requestParam errorCode:(NSInteger *)errorCode openSdkError:(LCMediaError **)openMediaError;

//按文件回放获取拉流地址
-(LCMediaStreamUrlModel *)getNewV2DevFileStreamURL:(LCMediaDevRecordRequestParam *)requestParam errorCode:(NSInteger *)errorCode openSdkError:(LCMediaError **)openMediaError;

//获取云录像拉流地址
- (NSDictionary *)getOpenMediaCloudRecordUrl:(NSString *)token
                deviceId:(NSString *)deviceId
                productId:(NSString *)productId
                channelId:(NSInteger)channelId
           recordRegionId:(NSString *)recordRegionId
                     type:(NSString *)type
                failure:(NSString **)errorCode
                                openSdkError:(LCMediaError **)openMediaError;

//获取rest url前缀
-(NSString *)getRestPrefix;
-(NSString *)getHost;

#pragma mark - 开放平台未适配接口
//按文件回放获取拉流地址协议
- (NSInteger)getPlayBackByFileStreamURL:(NSString *)deviceID Parmamter:(NSMutableDictionary*)paramter isTLS:(BOOL)isTLS outUrl:(NSString**)outUrl quicUrl:(NSString**)quicUrl SslCost:(NSInteger*)sslCost ApiCost:(NSInteger*)apiCost ServerParam:(LCMediaServerParameter*) serverParam;

//按时间回放获取拉流地址协议
- (NSInteger)getPlayBackByTimeStreamURL:(NSString *)deviceID Parmamter:(NSMutableDictionary*)paramter isTLS:(BOOL)isTLS outUrl:(NSString**)outUrl quicUrl:(NSString**)quicUrl SslCost:(NSInteger*)sslCost ApiCost:(NSInteger*)apiCost ServerParam:(LCMediaServerParameter*) serverParam;

//获取对讲拉流地址协议
- (NSInteger)getTalkStreamURL:(NSString *)deviceID channelId:(NSInteger)channelId isEncrypt:(NSInteger)isEncrypt talkType:(NSString*)talkType deviceType:(NSString*)deviceType isOpt:(BOOL)isOpt isReuse:(BOOL)isReuse AECtrlV2:(BOOL)AECtrlV2 streamId:(NSInteger)streamId isTLS:(BOOL)isTLS outUrl:(NSString**)outUrl quicUrl:(NSString**)quicUrl SslCost:(NSInteger*)sslCost ApiCost:(NSInteger*)apiCost RequestId:(NSString*)requestId ServerParam:(LCMediaServerParameter*) serverParam isAssistInfo:(BOOL)isAssistInfo DevicePid:(NSString*)devicePid AudioType:(NSInteger)audioType isQuic:(BOOL)isQuic;

//获取实时拉流地址协议
- (NSInteger)getRealTransformStreamURL:(NSString *)deviceID Parmamter:(NSMutableDictionary*)paramter isTLS:(BOOL)isTLS outUrl:(NSString**)outUrl quicUrl:(NSString**)quicUrl SslCost:(NSInteger*)sslCost ApiCost:(NSInteger*)apiCost ServerParam:(LCMediaServerParameter*)serverParam AliveUseType:(NSInteger*)aliveUseType;

//获取云录像拉流地址
- (NSInteger)generateRecordUrlByRecordId:(NSString*)deviceSN channelId:(NSInteger)channelId recordId:(int64_t)recordID recordType:(NSString*)recordType  Region:(NSString*) region RecordPath:(NSString *) recordPath outUrl:(NSString**)outUrl Token:(NSString**) token SslCost:(NSInteger*)sslCost ApiCost:(NSInteger*)apiCost DevicePid:(NSString*)devicePid;

//获取云盘拉流地址
- (NSInteger)generateRecordDiskUrlByRecordId:(NSString*)deviceSN channelId:(NSInteger)channelId recordId:(int64_t)recordID recordType:(NSString*)recordType  Region:(NSString*) region RecordPath:(NSString *) recordPath outUrl:(NSString**)outUrl Token:(NSString**) token SslCost:(NSInteger*)sslCost ApiCost:(NSInteger*)apiCost;

//获取服务配置
- (NSArray*)getServerConfigByType:(NSString *)typeStr SslCost:(NSInteger*)sslCost ApiCost:(NSInteger*)apiCost;

//密码找回接口
- (LCMediaPasswordModel *)syncQueryMediaPassword:(NSString *)deviceId productId:(NSString * __nullable)productId channelId:(NSString *)channelId bindDevice:(LCBindDeviceInfo *__nullable)bindDevice failure:(LCMediaError *_Nullable *_Nullable)error;

@end
