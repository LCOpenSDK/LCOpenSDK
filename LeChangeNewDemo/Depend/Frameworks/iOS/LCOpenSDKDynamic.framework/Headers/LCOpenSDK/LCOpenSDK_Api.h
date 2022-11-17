//
//  LCOpenSDK_Api.h
//  LCOpenSDK
//
//  Created by chenjian on 16/5/16.
//  Copyright (c) 2016年 lechange. All rights reserved.
//

#ifndef LCOpenSDK_LCOpenSDK_Api_h
#define LCOpenSDK_LCOpenSDK_Api_h
#import <Foundation/Foundation.h>

/** [int]：协议类型 0-http 1-https */
typedef NS_ENUM(NSInteger, ProcotolType) {
    PROCOTOL_TYPE_HTTP = 0,
    PROCOTOL_TYPE_HTTPS
};

@interface LCOpenSDK_ApiParam: NSObject

@property (nonatomic, assign)        ProcotolType  procotol; /** 协议类型 */
@property (nonatomic, copy, nonnull) NSString      *addr; /** 地址 */
@property (nonatomic, assign)        NSInteger     port; /** 端口 */
@property (nonatomic, copy, nonnull) NSString      *token; /** token */

@end

@interface LCOpenSDK_Api: NSObject

/// Get LCOpenSDK_Api single case       zh:单例
/// @return LCOpenSDK_Api single case
+ (LCOpenSDK_Api *_Nonnull)shareMyInstance;

/// Initialize LCOpenSDK_ Api         zh:初始化LCOpenSDK_Api
/// @param apiParam parameter model   zh:参数模型
/// @return LCOpenSDK_ Api pointer
- (id _Nonnull)initOpenApi:(LCOpenSDK_ApiParam *_Nonnull)apiParam;

/// LCOpenSDK_ Api request return value. zh:LCOpenSDK_Api请求返回值
/// @param req Structured request body.  zh:结构化请求体
/// @param resp structured return body.  zh:结构化返回体
/// @param timeout timeout
/// @return 0, interface call succeeded  zh:  0, 接口调用成功
///         - 1, interface call failed   zh: -1, 接口调用失败
- (NSInteger)request:(void *_Nonnull)req resp:(void *_Nonnull)resp timeout:(NSInteger)timeout;

/// De initialize LCOpenSDK_ Api Interface   zh:反初始化LCOpenSDK_Api接口
- (void)uninitOpenApi;

/// Get SDK version number information  zh:获取SDK版本号信息
- ( NSString * _Nonnull)sdkVersion;

@end
#endif