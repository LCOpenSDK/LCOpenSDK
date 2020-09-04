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
    LogLevelTypeFatal = 1,
    LogLevelTypeError,
    LogLevelTypeWarning,
    LogLevelTypeInfo,
    LogLevelTypeDebug
} LogLevelType;

@interface LCOpenSDK_LogInfo : NSObject

@property (nonatomic) LogLevelType levelType;

@end

@interface LCOpenSDK_Log : NSObject

+ (instancetype)shareInstance;

/*
 设置日志信息，设置后自动打开，打印设置等级以上的日志，包含设置等级，不设置默认LogLevelTypeDebug
 */

- (void)setLogInfo:(LCOpenSDK_LogInfo *)logInfo;


- (void)closeLog;

@end

NS_ASSUME_NONNULL_END
