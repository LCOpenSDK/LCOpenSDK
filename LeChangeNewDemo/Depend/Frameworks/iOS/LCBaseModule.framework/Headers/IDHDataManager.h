//
//  Copyright © 2018年 jm. All rights reserved.
//

#ifndef IDHDataManager_h
#define IDHDataManager_h

#import "DHModule.h"

@protocol IDHDataManager<DHServiceProtocol>

/// 用户名
@property (nonatomic, copy) NSString      *username;

/// 密码【海外旧接口鉴权依然需要，暂时不能去除】
@property (nonatomic, copy) NSString      *password;

/// web服务域名
@property (nonatomic, copy) NSString      *webServiceDomain;

///临时tokenUserName 15天有效期-3.2.0单点登录
@property (nonatomic, copy) NSString      *tokenUserName;

/// 加密保存在plist中，保证tokenUsername先赋值
@property (nonatomic, copy) NSString *accessToken;

/// 是否弹出乐盒添加指引
@property (nonatomic, assign) BOOL needShowAddBox;

/// 是否登录，存储变量，不存在本地
@property (nonatomic, assign) BOOL isLogin;

/// 是否满足自动登录的条件（username、token都有）
@property (nonatomic, assign, readonly) BOOL isAutoLoginSatisfied;

/// 登录类型
@property (nonatomic, assign) NSInteger loginType;

/// 用户id
@property (nonatomic, assign) int64_t userId;

/// 入口地址 【不包括http前缀】
@property (nonatomic, copy) NSString *entryAddress;

/// H5入口域名 不包含Https
@property (nonatomic, copy) NSString *h5Entryurl;

/// 入口端口
@property (nonatomic, copy) NSString *entryPort;

/// 精确到小数点后6位，东经0~180度，西经-180~0度(自动登录时，如果在调用UserLogin前未获取到当前的经纬度，使用保存的信息经度)
@property (nonatomic, assign) double latitude;

/// 纬度，精确到小数点后6位，北纬0~90度, 南纬-90~0度
@property (nonatomic, assign) double longitude;

/// 设备推送deviceToken
@property (nonatomic, copy) NSString *deviceToken;

/// 是否苹果测试账号
@property (nonatomic, assign, readonly) BOOL isAuditAccount;


@end

#endif /* IDHDataManager_h */
