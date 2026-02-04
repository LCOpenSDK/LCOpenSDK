//
//  LCMediaDownLoadInfo.h
//  LCMediaComponents
//
//  Created by 王威 on 2023/2/24.
//

#import <Foundation/Foundation.h>
#import "LCMediaDefine.h"
#import <LCOpenMediaSDK/LCMediaServerParameter.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCMediaDownLoadInfo : NSObject

@property(nonatomic, assign)NSInteger index;
// 设备ID
@property (nonatomic, copy)   NSString *deviceID;
// 协议类型
@property(nonatomic, assign)OC_PROTO_TYPE protoType;
// 通道ID
@property (nonatomic, assign) NSInteger channelID;
// 产品ID
@property (nonatomic, copy)   NSString *productId;
// 文件名
@property (nonatomic, copy) NSString *fileId;
// 下载时的MP4中间文件路径  在tmp下 下载完成后移动到localVideoPath中
@property (nonatomic, copy) NSString *filePath;
// 加密模式
@property(nonatomic, assign)NSInteger encryptMode;
// 加密秘钥
@property (nonatomic, copy)   NSString *encryptKey;
// 是否使用tls链接
@property (nonatomic, assign) BOOL isTls;
// 设备用户名
@property (nonatomic, copy)   NSString *userName;
// 设备密码
@property (nonatomic, copy)   NSString *passWord;

@property(nonatomic, strong)LCMediaServerParameter *serverParam;

// 是否支持Quic协议
@property (nonatomic, assign) BOOL isQuic;
//录像下载的结束位置
@property (nonatomic, assign)NSInteger endPos;

/// 绑定设备信息
@property(nonatomic, nullable, copy)NSString *bindProductId;
@property(nonatomic, nullable, copy)NSString *bindDeviceId;
@property(nonatomic, nullable, copy)NSString *bindChannelId;

@end

NS_ASSUME_NONNULL_END
