//
//  LCDeviceTimeV2VideoItem.h
//  LCMediaComponents
//
//  Created by lei on 2022/5/26.
//

#import <LCOpenMediaSDK/LCOpenMediaSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCDeviceTimeV2VideoItem : LCBaseVideoItem

// 主加密模式
@property(nonatomic, assign)int encrypt;
//是否开启了安恒加密
@property(nonatomic, assign)BOOL isOpenAHEncrypt;

//开始时间(utc公历时间 例:2022_5_26_17_45_12)
@property(nonatomic, copy)NSString * formatBeginTime;
//结束时间(utc公历时间 例:2022_5_26_17_45_12)
@property(nonatomic, copy)NSString * formatEndTime;

@property(nonatomic, assign)NSInteger offsetTime;

@property(nonatomic, copy)NSString *psk;  //秘钥(明文MD5, 32位小写)
// 是否强制MTS
@property(nonatomic, assign)BOOL isForceMts;

@property(nonatomic, assign)int isOpt; //是否开启优化拉流,需要设备同时支持(0:RTSP 1:RTSV1)

@property(nonatomic, assign)BOOL isTls;

@property(nonatomic, assign)BOOL isThrowP2PAuthErr;

@property(nonatomic, assign)CGFloat speed;
// 盐值,给P2P用
@property (nonatomic, copy) NSString *salt;

@property(nonatomic, assign)LCVideoStreamType streamType;


// 拉流优化新增字段(获取实时流url的入口地址参数)
@property (nonatomic, copy) NSString *serverParamHost;

@property (nonatomic, assign) NSInteger serverParamPort;

@property (nonatomic, assign) NSInteger serverParamProtocol;

@property (nonatomic, assign) NSInteger serverParamKeepAlive;

//走MQTT拉流优化域名和端口
@property (nonatomic, copy) NSString *mqttHost;
@property (nonatomic, assign) NSInteger mqttPort;

@property (nonatomic, strong)NSArray<NSString *> *fileNames; //双目文件名称列表

//是否支持Quic协议
@property(nonatomic, assign) BOOL isQuic;
/// 文件类型，1为视频，2为图片, 3为图片JPEG流（封装dhav头尾）
@property (nonatomic, assign) NSInteger fileType;

@end

NS_ASSUME_NONNULL_END
