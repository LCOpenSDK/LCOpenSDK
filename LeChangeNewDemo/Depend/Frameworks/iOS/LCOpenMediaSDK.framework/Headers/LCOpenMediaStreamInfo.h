//
//  LCOpenMediaStreamInfo.h
//  LCOpenSDKDynamic
//
//  Created by lei on 2024/10/17.
//  Copyright © 2024 Fizz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCOpenMediaStreamInfo : NSObject

// 是否需要辅助帧，当url为实时流时有效(当该字段不存在或者为空，表示不需要辅助帧)，true：表示需要辅助帧，false：表示不需要辅助帧
@property (nonatomic, copy) NSString  *assistStream;
// 限制并发路数 -1:不限制路数 其它:具体限制数
@property (nonatomic, assign) int     videoLimit;
// 设备级对讲与通道级对讲类型区分，device：表示设备级对讲，channel：表示通道级对讲
@property (nonatomic, copy) NSString  *deviceType;
// 是否跳过回环认证：true-跳过, false-不跳过
@property (nonatomic, copy) NSString  *skipAuth;
// 一次性token
@property (nonatomic, copy) NSString  *rtspToken;
// 是否限流
@property (nonatomic, assign) bool    timeLimit;
// 请求拉流分类，real：实时预览；playbackByTime：按时间回放；playbackByRecordId：按文件id回放；talk：对讲
@property (nonatomic, copy) NSString  *requestType;
/* 所要请求码流的加密类型
 * [TCM] 取值:TCM 该字段存在时，encrypt加密方式默认3:AES256加密，且优先级最高
 * [type] 取值:PBSV1/PBSV2 该字段存在时，encrypt加密方式默认2:0x95扩展头加密
 * [encrypt] 取值:encrypt 该字段存在时，encrypt加密方式默认1:I帧全加密，该字段不存在时，表明普通码流不加密0 */
@property (nonatomic, copy) NSString  *encrypt;
// RTSV1:支持私有协议拉流,RTSP:RTSP拉流 参数空默认为RTSP拉流
@property (nonatomic, copy) NSString  *type;
// 回放开始时间，requestType为playbackByTime时有值返回，其他为空字符串
@property (nonatomic, copy) NSString  *startTime;
// 回放结束时间，requestType为playbackByTime时有值返回，其他为空字符串
@property (nonatomic, copy) NSString  *endTime;
// 回放文件id，requestType为playbackByRecordId时有值返回，其他为空字符串
@property (nonatomic, copy) NSString  *recordId;
// 流量统计时所属用户的唯一标识，当前用userId
@property (nonatomic, copy) NSString  *owner;
// 设置拉流时长，单位：min
@property (nonatomic, copy) NSString  *duration;
// pc客户端拉流窗口号
@property (nonatomic, copy) NSString  *windowNum;
// 所属平台open:开放平台 base:乐橙平台
@property (nonatomic, copy) NSString  *ownerType;
// project标签  appID：开放平台 base:乐橙App
@property (nonatomic, copy) NSString  *project;
// 主辅流编号 0-主码流,1-辅码流1,2-辅码流2,3-辅码流3
@property (nonatomic, copy) NSString  *streamId;

// 通道号
@property (nonatomic, assign) int     channelId;
// 获取实时流url的入口地址
@property (nonatomic, copy) NSString  *streamAddr;
/// 对讲类型
@property (nonatomic, copy) NSString *talkType;
/// 码流分辨率
@property (nonatomic, assign) NSInteger imageSize;

@end

NS_ASSUME_NONNULL_END
