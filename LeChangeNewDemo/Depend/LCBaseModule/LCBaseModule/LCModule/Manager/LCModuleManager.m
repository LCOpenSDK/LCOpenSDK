//
//  LCModuleManager.m
//
//  Created by iblue on 2017/7/13.
//  Copyright © 2017年 jiangbin. All rights reserved.
//

#import "LCModuleManager.h"
#import <objc/runtime.h>

@interface LCModuleManager()
@property (nonatomic, strong) NSRecursiveLock *lock;
@property (nonatomic, strong) NSMutableArray <id<LCModuleProtocol>> *moduleArray;
@end

@implementation LCModuleManager

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static LCModuleManager *sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [[[self class] alloc] init];
    }
    return sharedInstance;
}

- (void)loadModuleByNameArray:(NSArray <NSString *> *)moduleArray
{
    for (NSString *moduleName in moduleArray)
    {
        Class moduelClass = NSClassFromString(moduleName);
        //如果没有这个模块 提示略过
        if (moduelClass == nil)
        {
            NSLog(@"找不到模块 %@", moduleName);
            continue;
        }
        
        //检测模块是否已经添加
        if ([self isModuleAdded:moduleName]) {
            NSLog(@"模块已经添加 %@", moduleName);
            continue;
        }

        //如果不遵从协议 则断言
        NSAssert(class_conformsToProtocol(moduelClass, @protocol(LCModuleProtocol)),@"模块：%@未遵守协议 IAppModule", moduleName);
        id<LCModuleProtocol> module = [[moduelClass alloc] init];
        [module moduleInit];
        NSLog(@"成功加载模块 %@", moduleName);
        [self.moduleArray addObject:module];
    }
}
    
- (void)deliveryCustomEvent:(NSString *)event userInfo:(NSDictionary *)userInfo
{
    for (id<LCModuleProtocol> module in self.modules) {
        if ([module respondsToSelector:@selector(moduleCustomEvent:userInfo:)]) {
            [module moduleCustomEvent:event userInfo:userInfo];
        }
    }
}
    
- (void)deliveryModule:(NSArray <NSString *> *)moduleArray customEvent:(NSString *)event userInfo:(NSDictionary *)userInfo
{
    if (moduleArray == nil) {
        [self deliveryCustomEvent:event userInfo:userInfo];
        return;
    }
    
    for (NSString *moduleName in moduleArray) {
        Class moduelClass = NSClassFromString(moduleName);
        for (id<LCModuleProtocol> module in self.modules) {
            if (![module isMemberOfClass:moduelClass]) {
                continue;
            }
            
            if ([module respondsToSelector:@selector(moduleCustomEvent:userInfo:)]) {
                [module moduleCustomEvent:event userInfo:userInfo];
            }
        }
    }
}

#pragma mark - Properties
- (NSMutableArray *)moduleArray
{
    if (_moduleArray == nil) {
        _moduleArray = [[NSMutableArray alloc] init];
    }
    
    return _moduleArray;
}
    
- (NSRecursiveLock *)lock
{
    if (!_lock) {
        _lock = [[NSRecursiveLock alloc] init];
    }
    return _lock;
}

- (NSArray *)modules
{
    [self.lock lock];
    NSArray *array = [self.moduleArray copy];
    [self.lock unlock];
    return array;
}

#pragma mark - Other
- (BOOL)isModuleAdded:(NSString *)moduleName
{
    Class moduelClass = NSClassFromString(moduleName);
    for (id<LCModuleProtocol> module in self.modules) {
        if ([module isMemberOfClass:moduelClass]) {
            return YES;
        }
    }
    
    return NO;
}
@end
