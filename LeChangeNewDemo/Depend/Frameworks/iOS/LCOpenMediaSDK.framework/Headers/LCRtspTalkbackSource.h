//
//  LCRtspTalkbackSource.h
//  LCMediaComponents
//
//  Created by lei on 2021/10/11.
//

#import <LCOpenMediaSDK/LCBaseTalkbackSource.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCRtspTalkbackSource : LCBaseTalkbackSource

// 加密模式
@property(nonatomic, assign)int encrypt;

@property(nonatomic, copy)NSString *psk;

//设备名称(未加密)
@property(nonatomic, copy)NSString *username;
//设备密码
@property(nonatomic, copy)NSString *password;
//是否开启了安恒加密
@property(nonatomic, assign)BOOL isOpenAHEncrypt;

// 是否强制MTS
@property(nonatomic, assign)BOOL isForceMts;

//是否是单通道对讲(true:单通道对讲, false:多通道对讲)
@property(nonatomic, assign)BOOL isSingleChannel;

//是否为呼叫对讲(true:呼叫对讲, false:普通对讲)
@property(nonatomic, assign)BOOL isCallTalk;

//是否为通道级对讲(true:通道级对讲, false:设备级对讲)
@property(nonatomic, assign)BOOL isChannelTalk;

//是否开启优化拉流,需要设备同时支持(0:RTSP 1:RTSV1)
@property(nonatomic, assign)int isOpt;

//是否使用tls链接
@property(nonatomic, assign)BOOL isTls;

// 是否支持共享链路复用
@property (nonatomic, assign) BOOL isReuse;

//音频编码控制，只影响实时、音频录像，不影响对讲音频
@property(nonatomic, assign)BOOL AECtrlV2;

// 盐值,给P2P用
@property (nonatomic, copy) NSString *salt;

//是否请求辅助帧
@property(nonatomic, assign)BOOL isAssistInfo;

// 拉流优化新增字段(获取实时流url的入口地址参数)
@property (nonatomic, copy) NSString *serverParamHost;

@property (nonatomic, assign) NSInteger serverParamPort;

@property (nonatomic, assign) NSInteger serverParamProtocol;

@property (nonatomic, assign) NSInteger serverParamKeepAlive;

//走MQTT拉流优化域名和端口
@property (nonatomic, copy) NSString *mqttHost;
@property (nonatomic, assign) NSInteger mqttPort;

///是否支持Quic协议
@property (nonatomic, assign) BOOL isQuic;

@end

NS_ASSUME_NONNULL_END
