//
//  LCOpenPlayTokenModel.h
//  LCMediaComponents
//
//  Created by lei on 2024/10/8.
//

#import <Foundation/Foundation.h>

@class LCOpenStreamInfo;

NS_ASSUME_NONNULL_BEGIN

@interface LCOpenPlayTokenModel : NSObject

//管理员token
@property(nonatomic, copy)NSString *accessToken;

// 设备序列号
@property (nonatomic, copy)   NSString  *deviceId;
// 通道号
@property (nonatomic, assign) NSInteger channelId;
/** iot设备产品ID，iot设备必传 */
@property (nonatomic, copy, nullable) NSString *productId;

// 设备接入平台编号：-1-未知平台  0-只支持p2p（netsdk老设备） 1-(海外非pass)接入easy4ip老接入平台 2-海外paas设备接入平台 3-国内非pass设备，4-国内pass设备
@property (nonatomic, assign) int platform;
// 设备登录名
@property (nonatomic, copy)   NSString  *devLoginName;
// 设备登录密码
@property (nonatomic, copy)   NSString  *devLoginPassword;

// 设备能力集
@property (nonatomic, copy)   NSString  *ability;
// 设备大类（NVR/DVR/HCVR/IPC/SD/IHG/ARC）
@property (nonatomic, copy)   NSString  *deviceCatalog;
/* 所要请求码流的加密类型
 * [TCM] 取值:TCM 该字段存在时，encrypt加密方式默认3:AES256加密，且优先级最高
 * [type] 取值:PBSV1/PBSV2 该字段存在时，encrypt加密方式默认2:0x95扩展头加密
 * [encrypt] 取值:encrypt 该字段存在时，encrypt加密方式默认1:I帧全加密，该字段不存在时，表明普通码流不加密0 */
@property (nonatomic, assign) int       encrypt;
@property (nonatomic, assign) int       streamPort;
// p2p port
@property (nonatomic, assign) int       p2pPort;
@property (nonatomic, copy) NSString *wssekey;     /** 设备密码摘要盐值P2P */


// 限制并发路数 -1:不限制路数 其它:具体限制数
@property (nonatomic, assign) int     videoLimit;
// 设备级对讲与通道级对讲类型区分，device：表示设备级对讲，channel：表示通道级对讲
@property (nonatomic, copy) NSString  *deviceType;
// 是否跳过回环认证：true-跳过, false-不跳过
@property (nonatomic, copy) NSString  *skipAuth;
// 是否限流
@property (nonatomic, assign) bool    timeLimit;

// RTSV1:支持私有协议拉流,RTSP:RTSP拉流 参数空默认为RTSP拉流
@property (nonatomic, copy) NSString  *type;
// 流量统计时所属用户的唯一标识，当前用userId
@property (nonatomic, copy) NSString  *owner;
// 设置拉流时长，单位：min
@property (nonatomic, copy) NSString  *duration;
// 所属平台open:开放平台 base:乐橙平台
@property (nonatomic, copy) NSString  *ownerType;
// project标签  appID：开放平台 base:乐橙App
@property (nonatomic, copy) NSString  *project;
// 获取实时流url的入口地址
@property (nonatomic, copy) NSString  *streamAddr;
// 设备加密模式：0-设备默认加密 1-用户自定义加密
@property (nonatomic, assign) NSInteger encryptMode;

//初始化函数
-(instancetype)initWithPlayToken:(NSString *)playToken playTokenKey:(NSString *)playTokenKey deviceId:(NSString *)deviceId channelId:(NSInteger)channelId productId:(nullable NSString *)productId;

/// 拉流是否走私有协议拉流
-(BOOL)isLiveOpt;

/// 对讲是否走私有协议
-(BOOL)isTalkOpt;

/// 卡录像回放支持私有协议
-(BOOL)isDevRecordOpt;

/// 支持共享链路
-(BOOL)isCanReuse;

/// 能力判断
/// - Parameter ability: 相关能力标示字符串
-(BOOL)hasAbility:(NSString *)ability;

/// 是否是海外pass设备
-(BOOL)isPssPlatform;

/// 是否是国内设备
-(BOOL)isLechangePlatform;

/// easy4ip设备
-(BOOL)isEasy4ipPlatform;

@end

NS_ASSUME_NONNULL_END
