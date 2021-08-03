//
//  DHServiceManager.m
//  DHHive
//
//  Created by iblue on 2017/7/12.
//  Copyright © 2017年 jiangbin. All rights reserved.
//

#import "DHServiceManager.h"
#import "DHServiceProtocol.h"
#import "DHImplementObject.h"

@interface DHServiceManager ()
@property (nonatomic, strong) NSMutableDictionary< NSString*, DHImplementObject*> *dicServiceProtocol;
@property (nonatomic, strong) NSRecursiveLock *lock;
@end

@implementation DHServiceManager

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (void)registerService:(Protocol *)service implClass:(Class)implClass
{
    if (service == nil || implClass == nil) {
        NSLog(@"🐝🐝 DHServiceManager:: service and implClass must not be nil...");
        return;
    }
    
    //CheckService
    if ([self isServiceRegisted:service]) {
        NSLog(@"🐝🐝 DHServiceManager:: %@, service has been registed...", NSStringFromProtocol(service));
        return;
    }
    
    //CheckClass
    if (![implClass conformsToProtocol:service]) {
        NSLog(@"🐝🐝 DHServiceManager:: implClass %@ doesn't comply with protocol %@...", NSStringFromClass(implClass), NSStringFromProtocol(service));
        return;
    }
    
    [self.lock lock];
    DHImplementObject *implObject = [DHImplementObject new];
    implObject.implementClass = implClass;
    [self.dicServiceProtocol setObject:implObject forKey:NSStringFromProtocol(service)];
    [self.lock unlock];
}

- (void)registerService:(Protocol *)service withStoryboard:(NSString *)storyboardName identifier:(NSString *)identifier
{
    if (service == nil || storyboardName == nil || identifier == nil) {
        NSLog(@"🐝🐝 DHServiceManager:: service and implClass must not be nil...");
        return;
    }
    
    id implClass = nil;
    
    @try {
        UIStoryboard *currentStoryboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        implClass = [currentStoryboard instantiateViewControllerWithIdentifier:identifier];
    } @catch (NSException *exception) {
        NSString *errorMsg = @"🐝🐝 DHServiceManager:: storyboard not pair...";
        NSLog(@"%@", errorMsg);
        return;
        
    } @finally {
        
        //CheckClass
        if (![implClass conformsToProtocol:service]) {
            NSLog(@"🐝🐝 DHServiceManager:: implClass %@ doesn't comply with protocol %@...", NSStringFromClass(implClass), NSStringFromProtocol(service));
            return;
        }
        
        [self.lock lock];
        DHImplementObject *implObject = [DHImplementObject new];
        implObject.implementType = DHImplementTypeStoryboard;
        implObject.implementClass = implClass;
        implObject.storyboardName = storyboardName;
        implObject.storyboardIdentifier = identifier;
        [self.dicServiceProtocol setObject:implObject forKey:NSStringFromProtocol(service)];
        [self.lock unlock];
    }
}

- (id)implForService:(Protocol *)service
{
    if (service == nil ) {
        NSLog(@"🐝🐝 DHServiceManager:: service must not be nil...");
        return nil;
    }
    
    //CheckService
    if (![self isServiceRegisted:service]) {
        NSLog(@"🐝🐝 DHServiceManager:: %@, service has not been registed...", NSStringFromProtocol(service));
        return nil;
    }
    
    DHImplementObject *implObject = [self.dicServiceProtocol objectForKey:NSStringFromProtocol(service)];
    Class implClass = implObject.implementClass;
    
    if ([[implClass class] respondsToSelector:@selector(isSingleton)]) {
        if ([[implClass class] isSingleton]) {
            if ([[implClass class] respondsToSelector:@selector(sharedInstance)]) {
                return [[implClass class] sharedInstance];
            }
            
            return [[implClass alloc] init];
        }
    }
    
    if (implObject.implementType == DHImplementTypeStoryboard) {
        UIStoryboard *currentStoryboard = [UIStoryboard storyboardWithName:implObject.storyboardName bundle:nil];
        return [currentStoryboard instantiateViewControllerWithIdentifier:implObject.storyboardIdentifier];
    }
    
    return [[implClass alloc] init];
}

#pragma mark - Properties and private function
- (NSMutableDictionary *)dicServiceProtocol
{
    if (_dicServiceProtocol == nil) {
        _dicServiceProtocol = [[NSMutableDictionary alloc] init];
    }
    
    return _dicServiceProtocol;
}

- (NSRecursiveLock *)lock
{
    if (!_lock) {
        _lock = [[NSRecursiveLock alloc] init];
    }
    return _lock;
}

- (NSDictionary *)disServices
{
    [self.lock lock];
    NSDictionary *dict = [self.dicServiceProtocol copy];
    [self.lock unlock];
    return dict;
}

- (BOOL)isServiceRegisted:(Protocol *)service
{
    DHImplementObject *implObject = [[self disServices] objectForKey:NSStringFromProtocol(service)];
    Class class = implObject.implementClass;
    if (class) {
        return YES;
    }
    return NO;
}
@end
