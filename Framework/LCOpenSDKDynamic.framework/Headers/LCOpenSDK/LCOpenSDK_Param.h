//
//  LCOpenSDK_Param.h
//  LCOpenSDKDynamic
//
//  Created by 韩燕瑞 on 2020/7/9.
//  Copyright © 2020 Fizz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// Media streaming mode    zh:媒体流模式
typedef NS_ENUM(NSInteger, DEFINITION_MODE) {
    DEFINITION_MODE_HG = 0,   // Main code stream    zh:主码流
    DEFINITION_MODE_SD        // Subcode stream    zh:子码流
};

/// Video recording type    zh:录像类型
/// RECORD_TYPE_ALL    all    zh:全部
/// RECORD_TYPE_ALARM  alarm    zh:报警
/// RECORD_TYPE_TIMING timing    zh:定时
typedef NS_ENUM(NSInteger, RECORD_TYPE) {
    RECORD_TYPE_ALL = 0,
    RECORD_TYPE_ALARM = 1000,
    RECORD_TYPE_TIMING = 2000
};

/// Audio noise reduction level              zh:音频降噪等级
/// LCOpenSDK_EnhanceMode_Close  close       zh:关闭
/// LCOpenSDK_EnhanceMode_Level1 1，worst     zh:降噪1级，最差
/// LCOpenSDK_EnhanceMode_Level2 2            zh:降噪2级
/// LCOpenSDK_EnhanceMode_Level3 3            zh:降噪3级
/// LCOpenSDK_EnhanceMode_Level4 4            zh:降噪4级
/// LCOpenSDK_EnhanceMode_Level5 5，optimal    zh:降噪5级，最优
typedef NS_ENUM(NSInteger, LCOpenSDK_EnhanceMode) {
    LCOpenSDK_EnhanceMode_Close = -1,
    LCOpenSDK_EnhanceMode_Level1 = 0,
    LCOpenSDK_EnhanceMode_Level2 = 1,
    LCOpenSDK_EnhanceMode_Level3 = 2,
    LCOpenSDK_EnhanceMode_Level4 = 3,
    LCOpenSDK_EnhanceMode_Level5 = 4
};

@interface LCOpenSDK_Param : NSObject <NSCopying>

//管理员token/用户token
@property (nonatomic, copy, nonnull)  NSString  *accessToken;
//设备ID
@property (nonatomic, copy, nonnull)  NSString  *deviceID;
//产品ID
@property (nonatomic, copy, nullable) NSString  *productId;
//通道
@property (nonatomic, assign)         NSInteger channel;
//设备密钥
@property (nonatomic, copy, nullable) NSString  *psk;
//播放token
@property (nonatomic, copy, nullable) NSString  *playToken;
//TLS
@property (nonatomic, assign) BOOL useTLS;
//是否展示播放window, 默认展示
@property (nonatomic, assign) BOOL showWindow;

@end

/// 实时播放
@interface LCOpenSDK_ParamReal : LCOpenSDK_Param <NSCopying>

// 流媒体HD/SD模式
@property (nonatomic, assign) DEFINITION_MODE  defiMode;
// 是否使用长链接优化
@property (nonatomic, assign) BOOL             isOpt;
// 码流分辨率
@property (nonatomic, assign) NSInteger        imageSize;
// 是否开启音频 默认开启
@property (nonatomic, assign) BOOL        isOpenAudio;
// 是否辅助帧默认关闭
@property (nonatomic, assign) BOOL        isAssistFrame;
// 是否支持可视对讲
@property (nonatomic, assign) BOOL        isSupportVideoTalk;
@end

/// 对讲(设备级对讲，通道为-1,通道级为对应通道号)
@interface LCOpenSDK_ParamTalk : LCOpenSDK_Param <NSCopying>

// 是否使用长链接优化
@property (nonatomic) BOOL  isOpt;
/// 请求类型，talk对讲，call呼叫，如果不传，默认为talk
@property (nonatomic, copy) NSString *talkType;

@end

@interface LCOpenSDK_P2PPortInfo : NSObject

@property (nonatomic, copy)NSString *sn;

@property (nonatomic, copy)NSString *productId;

@property(nonatomic, assign)NSInteger port;

@property(nonatomic, copy)NSString *user;

@property(nonatomic, copy)NSString *pwd;

@end

@interface LCOpenSDK_P2PDeviceInfo : NSObject

@property (nonatomic, copy)NSString *did;

@property (nonatomic, copy)NSString *playToken;

@end

@interface LCOpenSDK_PTZControllerInfo : NSObject
/// Direction of head rotation zh:云台转动方向
@property (nonatomic, copy) NSString *operation;
/// The head movement duration (ms) must be greater than 0. The device will rotate according to the set duration. If the duration is too long, the device will rotate once and reach the boundary
/// zh:云台移动时长（ms)，时长必须大于0，设备会根据设置时长进行转动，时长过大会导致设备旋转一周到达边界
@property (nonatomic,assign) int duration;

@end

@interface LCOpenSDK_MediaVideoSampleConfigParam : NSObject

@property(nonatomic, assign)NSInteger width;
@property(nonatomic, assign)NSInteger height;
@property(nonatomic, assign)NSInteger I_frame_interval;
@property(nonatomic, assign)NSInteger encodeType;
@property(nonatomic, assign)NSInteger frameRate;
@property(nonatomic, assign)BOOL isCameraOpen;
@property(nonatomic, assign)BOOL softEncodeMode;

/// 生成默认配置
+ (instancetype)initWithParam:(NSInteger)width height:(NSInteger)height I_frame_interval:(NSInteger)I_frame_interval encodeType:(NSInteger)encodeType frameRate:(NSInteger)frameRate isCameraOpen:(BOOL)isCameraOpen softEncodeMode:(BOOL)softEncodeMode;
-(NSDictionary *)toDictionary;

@end


NS_ASSUME_NONNULL_END
