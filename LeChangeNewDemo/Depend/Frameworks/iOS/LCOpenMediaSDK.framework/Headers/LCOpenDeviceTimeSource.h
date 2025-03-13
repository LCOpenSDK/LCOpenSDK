//
//  LCOpenDeviceTimeSource.h
//  LCMediaComponents
//
//  Created by lei on 2024/10/14.
//

#import <LCOpenMediaSDK/LCOpenMediaSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCOpenDeviceTimeSource : LCBaseVideoItem

//播放token,包含拉流相关参数和能力
@property(nonatomic, copy)NSString *playToken;
//playToken解析秘钥
@property(nonatomic, copy)NSString *playTokenKey;
//管理员token
@property(nonatomic, copy)NSString *accessToken;
//设备密钥
@property (nonatomic, copy, nullable)NSString  *psk;
/// begin time    zh:开始时间
@property (nonatomic, assign) long             startTime;
/// end time    zh:结束时间
@property (nonatomic, assign) long             endTime;
//是否使用tls链接
@property(nonatomic, assign)BOOL isTls;
// 码流类型
@property(nonatomic, assign)BOOL isMainStream;
//是否强制MTS
@property(nonatomic, assign)BOOL forceMts;
/// play double speed    zh:播放倍速
@property (nonatomic, assign)float speed;

@end

NS_ASSUME_NONNULL_END
