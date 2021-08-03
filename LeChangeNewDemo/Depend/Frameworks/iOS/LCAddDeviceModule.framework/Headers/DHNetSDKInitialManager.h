//
//  Copyright © 2018年 dahua. All rights reserved.
//  初始化管理器

#import <Foundation/Foundation.h>
#import "DHNetSDKSearchManager.h"

typedef void(^InitialSuccessHandle)(void);
typedef void(^InitialFailHandle)(void);

@interface DHNetSDKInitialManager : NSObject

/**
 @单例
 */
+ (instancetype)sharedInstance;

/**
 @初始化账户
 
 #param pwdString 设备初始化密码
 #param isSoftAp 是否软AP配置
 #param initialType 初始化方式
 #param success 初始化成功回调block
 #param failure 初始化失败会掉block
 */
- (void)initialDeviceWithPassWord:(NSString *)pwdString
						 isSoftAp:(BOOL)isSoftAp
				  withInitialType:(DHDeviceInitType)initialType
				 withSuccessBlock:(InitialSuccessHandle)success
				 withFailureBlock:(InitialFailHandle)fail;

@end
