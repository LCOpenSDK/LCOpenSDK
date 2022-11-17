//
//  Copyright © 2019 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCRequestSystemModel : NSObject

/// 协议版本信息，当前为1.0
@property (strong, nonatomic) NSString *ver;
/// 签名值,服务端用来做签名校验
@property (strong, nonatomic) NSString *sign;
/// appID
@property (strong, nonatomic) NSString *appId;
/// 发起Api调用的客户端的时间戳（秒级单位），时间与乐橙开放平台同步（两者时间不能相差5分钟）
@property (strong, nonatomic) NSString *time;
/// 随机数（32位），5分钟内不能重复，否则会抛出SN1005错误码
@property (strong, nonatomic) NSString *nonce;

@end

@interface LCRequestModel : NSObject

/// 开放平台请求格式中的system
@property (strong, nonatomic) LCRequestSystemModel *system;
/// 开放平台请求格式中的params
@property (strong, nonatomic,readonly) id params;
/// 请求消息ID号，同步调用时传入任意字符串
@property (strong, nonatomic) NSString * identifier;

+(instancetype)lc_WrapperNetworkRequestPackageWithParams:(id)params;

@end

NS_ASSUME_NONNULL_END
