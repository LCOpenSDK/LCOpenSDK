//
//  DHModule.m
//  DHModule
//
//  Created by iblue on 2017/7/13.
//  Copyright © 2017年 jiangbin. All rights reserved.
//

#import "DHModule.h"
#import "DHServiceManager.h"
#import "DHModuleManager.h"

@implementation DHModule

+ (instancetype)sharedInstance
{
    static DHModule *sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [[[self class] alloc] init];
    }
    return sharedInstance;
}

+ (void)registerService:(Protocol *)service implClass:(Class)implClass
{
    [[DHServiceManager sharedInstance] registerService:service implClass:implClass];
}

+ (id)implForService:(Protocol *)service
{
    return [[DHServiceManager sharedInstance] implForService:service];
}

+ (void)loadModuleByNameArray:(NSArray <NSString *> *)moduleArray
{
    [[DHModuleManager sharedInstance] loadModuleByNameArray:moduleArray];
}
    
#pragma mark - 消息转发
+ (void)deliveryCustomEvent:(NSString *)event userInfo:(NSDictionary *)userInfo
{
    [[DHModuleManager sharedInstance] deliveryCustomEvent:event userInfo:userInfo];
}
    
+ (void)deliveryModule:(NSArray <NSString *> *)moduleArray customEvent:(NSString *)event userInfo:(NSDictionary *)userInfo
{
    [[DHModuleManager sharedInstance] deliveryModule:moduleArray customEvent:event userInfo:userInfo];
}
    
@end
