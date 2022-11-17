//
//  LCModuleManager.h
//
//  Created by iblue on 2017/7/13.
//  Copyright © 2017年 jiangbin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LCModuleProtocol.h"

@interface LCModuleManager : NSObject

/**
 获取内部的模块
 */
@property (nonatomic, strong, readonly) NSArray<id<LCModuleProtocol>> *modules;

+ (instancetype)sharedInstance;

/**
 加载模块  一般在程序启动时候执行  且只执行一次
 
 @param moduleArray 加载模块的名称数组  模块类必须继承IAppModule协议
 */
- (void)loadModuleByNameArray:(NSArray <NSString *> *)moduleArray;

    
/**
 向模块传递自定义事件

 @param event 事件名称
 @param userInfo 传递的参数
 */
- (void)deliveryCustomEvent:(NSString *)event userInfo:(NSDictionary *)userInfo;
 
/**
 向模块传递自定义事件
 
 @param moduleArray 可以为空，为空时，表示向所有注册的模块传递自定义事件；
 @param event 自定义事件名称
 @param userInfo 传递的参数
 */
- (void)deliveryModule:(NSArray <NSString *> *)moduleArray customEvent:(NSString *)event userInfo:(NSDictionary *)userInfo;
@end
