//
//  LCLiveSource.h
//  LCMediaComponents
//
//  Created by lei on 2024/7/11.
//

#import <LCOpenMediaSDK/LCOpenMediaSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCLiveSource : LCMediaBaseVideoItem

// 加密模式
@property(nonatomic, assign)int encryptMode;
// 码流类型
@property(nonatomic, assign)BOOL isMainStream;
//秘钥(明文MD5, 32位小写)
@property(nonatomic, copy)NSString *psk;
// 是否强制MTS
@property(nonatomic, assign)BOOL forceMts;
// 是否跳过MTS鉴权
@property(nonatomic, assign)BOOL isSkipAuth;
//是否开启优化拉流,需要设备同时支持(0:RTSP 1:RTSV1)
@property(nonatomic, assign)int protocolMode;
//是否使用tls链接
@property(nonatomic, assign)BOOL isTls;
// 是否支持共享链路复用
@property (nonatomic, assign) BOOL isSharedLinkMode;
//是否回调P2P鉴权错误
@property(nonatomic, assign)BOOL isThrowP2pAuthErr;
// 盐值,给P2P用
@property (nonatomic, copy) NSString *salt;
@property (nonatomic, assign)int imageSize;
// 码流地址：用于MQTT获取拉流地址
@property (nonatomic, copy)NSString *streamUrlV4;
//是否支持Quic协议
@property(nonatomic, assign)BOOL isQuic;


//可视对讲配置
@property(nonatomic, assign)BOOL isSupportVisualTalk;
@property(nonatomic, assign)NSInteger resolutionWidth;
@property(nonatomic, assign)NSInteger resolutionHeight;

@end

NS_ASSUME_NONNULL_END
