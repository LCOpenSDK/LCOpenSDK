//
//  LCModule.m
//  LCModule
//
//  Created by iblue on 2017/7/13.
//  Copyright © 2017年 jiangbin. All rights reserved.
//

#import "LCModule.h"
#import "LCServiceManager.h"
#import "LCModuleManager.h"

@implementation LCModule

+ (instancetype)sharedInstance
{
    static LCModule *sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [[[self class] alloc] init];
    }
    return sharedInstance;
}

+ (void)registerService:(Protocol *)service implClass:(Class)implClass
{
    [[LCServiceManager sharedInstance] registerService:service implClass:implClass];
}

+ (id)implForService:(Protocol *)service
{
    return [[LCServiceManager sharedInstance] implForService:service];
}

+ (void)loadModuleByNameArray:(NSArray <NSString *> *)moduleArray
{
    [[LCModuleManager sharedInstance] loadModuleByNameArray:moduleArray];
}
    
#pragma mark - 消息转发
+ (void)deliveryCustomEvent:(NSString *)event userInfo:(NSDictionary *)userInfo
{
    [[LCModuleManager sharedInstance] deliveryCustomEvent:event userInfo:userInfo];
}
    
+ (void)deliveryModule:(NSArray <NSString *> *)moduleArray customEvent:(NSString *)event userInfo:(NSDictionary *)userInfo
{
    [[LCModuleManager sharedInstance] deliveryModule:moduleArray customEvent:event userInfo:userInfo];
}
    
@end
