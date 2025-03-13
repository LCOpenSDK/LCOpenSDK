//
//  LCMediaRestApi.h
//  LCSDK
//
//  Created by zhou_yuepeng on 16/9/13.
//  Copyright © 2016年 com.lechange.lcsdk. All rights reserved.
//

#ifndef LCMedia_RestApi_h
#define LCMedia_RestApi_h
#import <Foundation/Foundation.h>
#import "LCVideoPlayerDefines.h"

typedef NS_ENUM(NSInteger, LCMEDIA_CLIENT_UA_USER)
{
    LCMEDIA_UNIVERSAL_SAAS = 0,    /* 通用client类型 */
    LCMEDIA_HHY_SAAS       = 1,    /* client for 和慧眼 */
};

@interface LCMediaRestApiParameter : NSObject

@property (nonatomic, copy) NSString  *host;
@property (nonatomic)       NSUInteger port;
@property (nonatomic, copy) NSString  *clientType;
@property (nonatomic, copy) NSString  *clientID;
@property (nonatomic, copy) NSString  *clientVersion;
@property (nonatomic, copy) NSString  *project;
@property (nonatomic, copy) NSString  *pushID;
@property (nonatomic, copy) NSString  *authUserName;
@property (nonatomic, copy) NSString  *authPassWordMd5;
@property (nonatomic, copy) NSString  *clientOS;

/* add for APP 3.3 */
@property (nonatomic, copy) NSString  *clientOV;
@property (nonatomic, copy) NSString  *terminalModel;
@property (nonatomic, copy) NSString  *terminalId;
@property (nonatomic, copy) NSString  *language;
@property (nonatomic, copy) NSString  *clientProtoVersion;

/* add for Saas */
@property (nonatomic, copy) NSString  *appId;
@property (nonatomic) NSInteger  isHttps;

/* add for CA */
/* CA认证所需证书的路径，不设置默认使用easy4ip和乐橙基线的内置证书 */
@property (nonatomic, copy) NSString  *caPath;
/* 0: 表示不使用CA认证，1或者不赋值代表使用CA认证 */
@property (nonatomic) NSInteger  isUseCA;

@property (nonatomic) NSInteger isUseKeepAlive;

/* add for 和慧眼 */
@property (nonatomic) LCMEDIA_CLIENT_UA_USER  clientUaUser;
@property (nonatomic, copy) NSString  *appKey;
@property (nonatomic, copy) NSString  *appSecret;
@property (nonatomic, copy) NSString  *accessToken;
/* 终端品牌上报 */
@property (nonatomic, copy) NSString  *terminalBrand;

- (NSString*)toJSONString;
@end

@interface LCMediaRestApi : NSObject

/**
 *  初始化LCSDK-RestApi
 *
 *  @param parameter 初始化参数(参考LCSDK_RestApiParameter定义)
 *  @param networkProtocol 网络协议(REST/MQTT)
 *
 *  @return YES/NO 成功/失败
 */
+ (BOOL)initLCSDKRestWithParameter:(LCMediaRestApiParameter*)parameter networkProtocol:(LCMediaComponentsNetProtocolType)networkProtocol;


/**
 *  反初始化RestApi，释放资源
 */
+ (void)uninitLCSDKRest;

@end

#endif /* LCMedia_RestApi_h */
