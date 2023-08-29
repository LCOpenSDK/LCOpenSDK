//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "LCApplicationDataManager.h"


#define APPID             @"GLOBAL_CONFIG_APPLICATION_APPID"
#define OVERSEAAPPID      @"GLOBAL_CONFIG_APPLICATION_OVERSEA_APPID"
#define APPSECRET         @"GLOBAL_CONFIG_APPLICATION_APPSECRET"
#define OVERSEAAPPSECRET  @"GLOBAL_CONFIG_APPLICATION_OVERSEA_APPSECRET"
#define HOSTAPI           @"GLOBAL_CONFIG_APPLICATION_HOSTAPI"
#define OVERSEAHOSTAPI    @"GLOBAL_CONFIG_APPLICATION_OVERSEA_HOSTAPI"
#define MANAGERTOKEN      @"GLOBAL_AUTH_MANAGER_TOKEN"
#define SUBACCOUNTTOKEN   @"GLOBAL_AUTH_SUBACCOUNT_TOKEN"
#define SUBACCOUNOPENID   @"GLOBAL_AUTH_SUBACCOUNT_OPENID"
#define EXPIRETIME        @"GLOBAL_AUTH_EXPIRE_TIME"
#define SUBACCOUNT        @"GLOBAL_SUBACCOUNT"
#define DebugFlag         @"GLOBAL_DEBUGFLAG"

///默认请求基地址
//#define DEFAULTHOSTAPICHN @"https://funcopenapi.lechange.cn:443/openapi" //中国大陆(测试)
//#define DEFAULTHOSTAPIOVS @"https://openapifunc.easy4ip.com:443/openapi" //海外（测试） https://openapi-func-sz.imoulife.com
#define DEFAULTHOSTAPICHN @"https://openapi.lechange.cn:443" //中国大陆(正式)
#define DEFAULTHOSTAPIOVS @"https://openapi.easy4ip.com:443" //海外（正式）
static NSMutableDictionary *serialCachePool;
//设备信息缓存
static NSMutableDictionary *deviceInfosPool;

@implementation LCApplicationDataManager

+ (NSString *)appId {
//    return @"lcad69e70cc6304e91";
    return (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:[LCApplicationDataManager isChinaMainland] ? APPID : OVERSEAAPPID];
}

+ (NSString *)appSecret {
//    return @"d8e838cf5ade420f9c46dfdd24c774";
    return (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:[LCApplicationDataManager isChinaMainland] ? APPSECRET : OVERSEAAPPSECRET];
}

+ (NSString *)hostApi {
    //若没有自定义地址直接返回默认地址
    NSString *hostApi = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:[LCApplicationDataManager isChinaMainland]?HOSTAPI:OVERSEAHOSTAPI];
    hostApi = ((hostApi == nil || [hostApi isNull]) ? ([LCApplicationDataManager isChinaMainland] ? DEFAULTHOSTAPICHN : DEFAULTHOSTAPIOVS) : hostApi);
    return hostApi;
}

+ (void)setAppIdWith:(NSString *)appId {
    [[NSUserDefaults standardUserDefaults] setObject:appId forKey:[LCApplicationDataManager isChinaMainland] ? APPID : OVERSEAAPPID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setAppSecretWith:(NSString *)appSecret {
    [[NSUserDefaults standardUserDefaults] setObject:appSecret forKey:[LCApplicationDataManager isChinaMainland] ? APPSECRET : OVERSEAAPPSECRET];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setHostApiWith:(NSString *)api {
    [[NSUserDefaults standardUserDefaults] setObject:api forKey:[LCApplicationDataManager isChinaMainland]?HOSTAPI:OVERSEAHOSTAPI];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

///保存管理员模式Token
+ (void)setManagerToken:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:MANAGERTOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setSubAccountToken:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:SUBACCOUNTTOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setSubAccountId:(NSString *)openId {
    [[NSUserDefaults standardUserDefaults] setObject:openId forKey:SUBACCOUNOPENID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)openId {
    NSString *openId = [[NSUserDefaults standardUserDefaults] objectForKey:SUBACCOUNOPENID];
    return openId;
}

///保存Token过期时间
+ (void)setExpireTime:(NSInteger)second {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:EXPIRETIME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

///获取Token过期时间
+ (BOOL)isVaildToken {
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:EXPIRETIME];
    NSInteger now = [date timeIntervalSinceNow];
    if (now > 300) {
        //如果五分钟内不过期则认为是有效的
        return YES;
    }
    return NO;
}

///获取当前Token（自动判断当前用户类型）
+ (NSString *)token {
    NSString *subAccountToken = [[NSUserDefaults standardUserDefaults] objectForKey:SUBACCOUNTTOKEN];
    return subAccountToken;
//    NSString *managerToken = [[NSUserDefaults standardUserDefaults] objectForKey:MANAGERTOKEN];
//    return managerToken;
}

+ (NSString *)managerToken {
    NSString *managerToken = [[NSUserDefaults standardUserDefaults] objectForKey:MANAGERTOKEN];
    return managerToken;
}

+ (NSString *)SDKHost {
    
    NSString *host = [NSString stringWithFormat:@"%@/openapi",[LCApplicationDataManager hostApi]];
    NSString *textStr = [[[[[[host componentsSeparatedByString:@"//"] objectAtIndex:1] componentsSeparatedByString:@"/"] objectAtIndex:0] componentsSeparatedByString:@":"] objectAtIndex:0];
    return textStr;
}

+ (NSInteger)SDKPort {
//    (([a-zA-Z0-9\._-]+\.[a-zA-Z]{2,6})|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,4})?

    NSString *host = [LCApplicationDataManager hostApi];
    NSString *regex = @"(:[0-9]{1,4})";
    NSRegularExpression *regular = [[NSRegularExpression alloc]initWithPattern:regex options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    NSArray *resultArray = [regular matchesInString:host options:0 range:NSMakeRange(0, host.length)];
    if (resultArray.count == 0) {
        return [host containsString:@"https"]?443:80;
    }
    NSTextCheckingResult *result = resultArray[0];
    NSString *textStr = [[host substringWithRange:result.range] substringFromIndex:1];
    return [textStr integerValue];
}

+ (void)setDebugFlag:(BOOL)debugFlag {
    
    [[NSUserDefaults standardUserDefaults] setBool:debugFlag forKey:DebugFlag];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (BOOL)getDebugFlag {
    BOOL debugFlagValue = [[NSUserDefaults standardUserDefaults] boolForKey:DebugFlag];
    return debugFlagValue;
}


///存储当前对接模式
+ (void)setCurrentMode:(LCJointModeType)type {
    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:@"GLOBAL_JOINT_CURRENT_MODE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

///是否对接国内版本
+ (BOOL)isChinaMainland {
    LCJointModeType type = [[NSUserDefaults standardUserDefaults] integerForKey:@"GLOBAL_JOINT_CURRENT_MODE"];
    return type == LCJointModeChinaMainland ? YES : NO;
}

//MARK: - SubAccount
///保存子账号
+ (void)setSubAccount:(NSString *)account {
    NSString *appId = [self appId];
    NSString *key = [NSString stringWithFormat:@"%@_%@", SUBACCOUNT, appId];
    [[NSUserDefaults standardUserDefaults] setObject:account forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// 获取子账号
+ (NSString *)subAccout {
    NSString *appId = [self appId];
    NSString *key = [NSString stringWithFormat:@"%@_%@", SUBACCOUNT, appId];
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

//MARK: - Private Methods

#define kRandomLength 32 ///随机数位数
+ (NSString *)serial
{
    //1.UUIDString
    NSString *string = [[[UIDevice currentDevice] identifierForVendor] UUIDString];

    //2.时间戳
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%.0f", time];

    //3.随机字符串kRandomLength位
    static const NSString *kRandomAlphabet = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:kRandomLength];
    for (int i = 0; i < kRandomLength; i++) {
        [randomString appendFormat:@"%C", [kRandomAlphabet characterAtIndex:arc4random_uniform((u_int32_t)[kRandomAlphabet length])]];
    }

    //==> UUIDString去掉最后一项,再拼接上"时间戳"-"随机字符串kRandomLength位"
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[string componentsSeparatedByString:@"-"]];
    [array removeLastObject];
    [array addObject:timeStr];
    [array addObject:randomString];
    NSString *serialStr = [array componentsJoinedByString:@"-"];
    //保证5分钟内不重复逻辑，如果数据池中已存在该key则递归调用，否则检查数据池中大于5分钟的key并将其删除，然后将新key存入数据池
    if ([serialCachePool objectForKey:serialStr]) {
        return [LCApplicationDataManager serial];
    }
    NSRecursiveLock *lock = [[NSRecursiveLock alloc] init];
    [lock lock];
    for (NSString *key in serialCachePool) {
        NSDate *date = (NSDate *)[serialCachePool objectForKey:key];
        NSTimeInterval timeInterval = [date timeIntervalSinceNow];
        timeInterval = -timeInterval;
        if (timeInterval > 5) {
            [serialCachePool removeObjectForKey:key];
        }
    }
    [serialCachePool setObject:[NSDate new] forKey:serialStr];
    [lock unlock];
    return serialStr;
}

//获取当前时间戳
+ (NSString *)getCurrentTimeStamp {
    return [NSString stringWithFormat:@"%.0f", [[NSDate new] timeIntervalSince1970]];
}

+ (NSMutableDictionary *)defaultPool {
    if (!serialCachePool) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            serialCachePool = [NSMutableDictionary dictionary];
        });
    }
    return serialCachePool;
}

+ (NSMutableDictionary *)defaultDeviceInfosPool {
    if (!deviceInfosPool) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            deviceInfosPool = [NSMutableDictionary dictionary];
        });
    }
    return deviceInfosPool;
}

@end
