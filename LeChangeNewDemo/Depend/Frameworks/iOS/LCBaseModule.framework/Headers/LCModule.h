//
//
//  Created by iblue on 2017/7/12.
//  Copyright © 2017年 jiangbin. All rights reserved.
//

#import "LCServiceProtocol.h"
#import "LCModuleProtocol.h"
#import "LCRouter.h"
#import <UIKit/UIKit.h>

@interface LCModule : NSObject

+ (instancetype)sharedInstance;

/**
 绑定服务协议与实现类
 
 @param service 服务协议
 @param implClass 实现类
 */
+ (void)registerService:(Protocol *)service implClass:(Class)implClass;

/**
 取得服务协议对应的实现类
 
 @param service 服务协议
 @return 实现类
 */
+ (id)implForService:(Protocol *)service;

/**
 加载模块  一般在程序启动时候执行  且只执行一次
 
 @param moduleArray 加载模块的名称数组  模块类必须继承IAppModule协议
 */
+ (void)loadModuleByNameArray:(NSArray <NSString *> *)moduleArray;

/**
 向所有模块传递自定义事件

 @param event 事件名称
 @param userInfo 传递的参数
 */
+ (void)deliveryCustomEvent:(NSString *)event userInfo:(NSDictionary *)userInfo;

/**
 向指定模块传递自定义事件

 @param moduleArray 可以为空，为空时，表示向所有注册的模块传递自定义事件；
 @param event 自定义事件名称
 @param userInfo 传递的参数
 */
+ (void)deliveryModule:(NSArray <NSString *> *)moduleArray customEvent:(NSString *)event userInfo:(NSDictionary *)userInfo;
    
@end
