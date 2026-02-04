//
//  LCOpenBindDeviceInfo.h
//  LCOpenMediaSDK
//
//  Created by lei on 2025/9/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCOpenBindDeviceInfo : NSObject

// 设备能力集
@property(nonatomic, copy)   NSString  *ability;
// 设备接入平台编号：-1-未知平台  0-只支持p2p（netsdk老设备） 1-(海外非pass)接入easy4ip老接入平台 2-海外paas设备接入平台 3-国内非pass设备，4-国内pass设备
@property(nonatomic, assign) int platform;

/** iot设备产品ID，iot设备必传 */
@property(nonatomic, copy, nullable) NSString *productId;

@property(nonatomic, copy)NSString *connectState; //与NVR连接状态 unlink/linked

@property(nonatomic, copy)NSString *connectProtocol; //与NVR连接协议 imou/onvif/gb

@property(nonatomic, copy)NSString *deviceId; //NVR设备Id

@property(nonatomic, copy)NSString *timestamp; //时间戳

@property(nonatomic, copy)NSString *salt; //P2P拉流盐值
/* 所要请求码流的加密类型
 * [TCM] 取值:TCM 该字段存在时，encrypt加密方式默认3:AES256加密，且优先级最高
 * [type] 取值:PBSV1/PBSV2 该字段存在时，encrypt加密方式默认2:0x95扩展头加密
 * [encrypt] 取值:encrypt 该字段存在时，encrypt加密方式默认1:I帧全加密，该字段不存在时，表明普通码流不加密0 */
@property(nonatomic, assign) int encrypt;

@property (nonatomic, assign) BOOL tlsEnable; // tls开关

//初始化函数
-(instancetype)initWithDeviceDictionary:(NSDictionary *)deviceInfo;

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


@end

NS_ASSUME_NONNULL_END
