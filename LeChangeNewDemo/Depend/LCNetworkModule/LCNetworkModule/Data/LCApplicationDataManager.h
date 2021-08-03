//
//  Copyright © 2019 dahua. All rights reserved.
//  模拟服务器的全局配置文件

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    LCJointModeChinaMainland,
    LCJointModeOversea
} LCJointModeType;


@interface LCApplicationDataManager : NSObject

//MARK: - 获取全局信息
///获取AppId
+ (NSString *)appId;
///获取AppSecret
+ (NSString *)appSecret;
///获取请求基地址
+ (NSString *)hostApi;
///保存AppId
+ (void)setAppIdWith:(NSString *)appId;
///保存AppSecret
+ (void)setAppSecretWith:(NSString *)appSecret;
///保存请求基地址
+ (void)setHostApiWith:(NSString *)api;
///保存管理员模式Token
+(void)setManagerToken:(NSString *)token;
///保存用户模式Token
+(void)setUserToken:(NSString *)token;
///保存子账户模式Token
+(void)setSubAccountToken:(NSString *)token;
///保存子账户id
+(void)setSubAccountId:(NSString *)openId;
///保存Token过期时间
+(void)setExpireTime:(NSInteger)second;
///获取Token过期时间
+(BOOL)isVaildToken;
///获取子账户Token
+(NSString *)token;
///获取管理员Token
+(NSString *)managerToken;

///子账户Id
+(NSString *)openId;
///当前是否管理员模式
+(BOOL)isManagerMode;
///存储当前对接模式
+(void)setCurrentMode:(LCJointModeType)type;
///是否对接国内版本
+(BOOL)isChinaMainland;
///SDK连接时的HostApi
+(NSString *)SDKHost;
///SDK连接时的Port
+(NSInteger)SDKPort;

///保存子账号
+ (void)setSubAccount:(NSString *)account;

/// 获取子账号
+ (NSString *)subAccout;

///根据设备序列号获取设备信息
+(id)getDeviceInfoWithSerialNumber:(NSString *)serialNumber;
///存储设备信息
+(void)setDeviceInfoWithInfo:(id)deviceInfo;

//MARK: - 工具方法

///获取32位随机数
+ (NSString *)serial;
///获取当前时间戳(秒级)
+ (NSString *)getCurrentTimeStamp;
@end

NS_ASSUME_NONNULL_END
