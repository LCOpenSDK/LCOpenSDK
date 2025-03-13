//
//  LCMediaUtils.h
//  LCSDK
//
//  Created by zhou_yuepeng on 16/9/5.
//  Copyright © 2016年 com.lechange.lcsdk. All rights reserved.
//

#ifndef LCMedia_LCMedia_Utils_h
#define LCMedia_LCMedia_Utils_h
#import <Foundation/Foundation.h>

//日志等级
typedef NS_ENUM(NSInteger, E_LOG_LEVEL)
{
    LOGLEVEL_FATAL,     //致命错误
    LOGLEVEL_ERR,       //错误
    LOGLEVEL_WARNING,   //可能导致出错
    LOGLEVEL_INFO,      //当前运行状态
    LOGLEVEL_DEBUG,     //详细调试信息
    LOGLEVEL_SECURITY_ALL, //所有日志信息，但遮蔽账户、密码等敏感信息
    LOGLEVEL_ALL,       //所有日志信息
};

#pragma mark - UTILS
@interface LCMediaUtils: NSObject

/**
 *  设置日志输出文件
 *
 *  @param logFilePath 日志文件全路径
 *  @param maxSize     日志大小最大值
 */
+ (void)setMobileLogFile:(NSString*)logFilePath maxSize:(NSUInteger)maxSize;

/**
 *  设置LCSDK模块日志输出等级
 *
 *  @param logLevel     输出日志等级(参考E_LOG_LEVEL)
 *  @param logTag       需要设置等级的日志tag(如果为nil则表示设置所有日志)
 */
+ (void)setMobileLogLevel:(E_LOG_LEVEL)logLevel logTag:(NSString*)logTag;

/**
*  设置扩展模块日志输出等级（如playsdk等模块日志）
*
*  @param logLevel     输出日志等级(参考E_LOG_LEVEL)
*/
+ (void)setExtendLogLevel:(E_LOG_LEVEL)logLevel;

/**
 设置是否开启码流写文件(全局)
 
 @param isOpen YES/NO 开启/关闭
 @note	在开始播放(对讲)前调用才有效！
 */
+ (void)setSaveStreamFlag:(BOOL)isOpen;
/**
 触发设备升级

 @param deviceSN 设备序列号
 @param userName 设备登陆用户名
 @param passWord 设备登陆密码
 @return 透传服务响应数据(json格式)
     - Result[int] 状态码(20000表示成功, 其他参考协议)
 @note    该接口为同步阻塞接口
 */
+ (NSString*)upgradeDevice:(NSString*)deviceSN userName:(NSString*)userName password:(NSString*)passWord;

/**
 查询设备升级进度

 @param deviceSN 设备序列号
 @param userName 设备登陆用户名
 @param passWord 设备登陆密码
 @return 透传服务响应数据(json格式)
     - Result[int] 状态码(20000表示成功, 其他参考协议)
     - Status[string] 升级状态(download、update、reboot、complete)
     - Progress[string] 升级进度(0-100)
     - SWVersion[string] 设备当前版本信息
     - Build[string] 设备当前的版本编译号
     - LastResult[int] 前一次升级结果 当前状态为complete时有效
 @note    该接口为同步阻塞接口
 */
+ (NSString*)queryUpgradeProcess:(NSString*)deviceSN userName:(NSString*)userName password:(NSString*)passWord;

+ (NSString*)getAHConfigPath;

+ (NSString *)getVersion;

/**
 域名解析

 @param domain 域名
 @return 返回域名解析的json字符串
     - 成功:json格式如下
         {
         "IPv4":"xxx",     // IPv4地址
         "IPv6":"xxx"     // IPv6地址
         }
     - 失败：{}
 */
+ (NSString*)address2IpEx:(NSString*)domain;

/**
 * 记录App启动时间
 */
+ (void)setApplicationStartTime;

/// 解析playToken(openSDK接口)
/// - Parameters:
///   - playToken: playToken
///   - playTokenKey: 秘钥
///   - deviceId: 设备序列号
+ (NSDictionary *)decryptPlayToken:(NSString *)playToken withKey:(NSString *)playTokenKey deviceID:(NSString *)deviceId;

/**
 清理资源
 @note 典型使用场景是app退出(包括被强杀)时调用，用以主动清理资源
 */
+ (void)cleanUp;
@end

#endif //LCSDK_LCSDK_Utils_h
