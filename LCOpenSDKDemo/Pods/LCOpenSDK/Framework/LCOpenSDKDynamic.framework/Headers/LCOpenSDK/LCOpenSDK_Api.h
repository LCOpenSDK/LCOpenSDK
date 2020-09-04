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

@property (nonatomic) ProcotolType             procotol; /** 协议类型 */
@property (nonatomic, copy, nonnull) NSString *addr; /** 地址 */
@property (nonatomic)NSInteger                 port; /** 端口 */
@property (nonatomic, copy, nonnull) NSString *token; /** token */

@end

@interface LCOpenSDK_Api: NSObject
/**
 *  获取LCOpenSDK_Api单例
 *
 *  @return LCOpenSDK_Api单例指针
 */
+ (LCOpenSDK_Api*_Nonnull) shareMyInstance;

/**
 *  初始化LCOpenSDK_Api
 *
 *  @param procotol 协议
 *  @param addr     域名
 *  @param port     端口
 *  @param caPath   CA证书路径
 *
 *  @return LCOpenSDK_Api指针
 */
- (id _Nonnull)initOpenApi:(ProcotolType)procotol addr:(NSString *_Nonnull)addr port:(NSInteger)port CA_PATH:(NSString *_Nonnull)caPath DEPRECATED_MSG_ATTRIBUTE("use initOpenApi: instead");;

/**
*  初始化LCOpenSDK_Api
*
*  @param apiParam 参数模型
*
*  @return LCOpenSDK_Api指针
*/
- (id _Nonnull)initOpenApi:(LCOpenSDK_ApiParam *_Nonnull)apiParam;

/**
*  LCOpenSDK_Api请求返回值
*
*  @param req     结构化请求体
*  @param resp    结构化返回体
*  @param timeout 超时时长
*
*  @return      0, 接口调用成功
*              -1, 接口调用失败
*/

- (NSInteger)request:(void *_Nonnull)req resp:(void *_Nonnull)resp timeout:(NSInteger)timeout;
/**
 *  反初始化LCOpenSDK_Api接口
 */
- (void)uninitOpenApi;

@end
#endif
