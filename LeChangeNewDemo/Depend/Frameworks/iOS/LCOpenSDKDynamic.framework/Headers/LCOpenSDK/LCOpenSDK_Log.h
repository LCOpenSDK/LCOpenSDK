//
//  LCOpenSDK_Log.h
//  LCOpenSDKDynamic
//
//  Created by 韩燕瑞 on 2020/4/20.
//  Copyright © 2020 Fizz. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    LogLevelTypeFatal,           // critical error    zh:重大错误
    LogLevelTypeError,           // error message    zh:错误信息  
    LogLevelTypeWarning,         // Warning message    zh:警告信息
    LogLevelTypeInfo,            // It is mainly used to output some important information about the operation of the program in the production environment    zh:主要用于生产环境中输出程序运行的一些重要信息
    LogLevelTypeDebug,           // run debug info    zh:运行调试信息
    logLevelTypeSecurityAll,     // security all
    LogLevelTypeALL              // all
} LogLevelType;

@interface LCOpenSDK_LogInfo : NSObject

@property (nonatomic) LogLevelType levelType;

@end

@interface LCOpenSDK_Log : NSObject

+ (instancetype)shareInstance;

/// Set the log information, automatically open after setting, print the log above the set level, including the set level, do not set the default LogLevelTypeFatal    zh:设置日志信息，设置后自动打开，打印设置等级以上的日志，包含设置等级，不设置默认LogLevelTypeFatal
- (void)setLogInfo:(LCOpenSDK_LogInfo *)logInfo;

/// close log
- (void)closeLog;

@end

NS_ASSUME_NONNULL_END
