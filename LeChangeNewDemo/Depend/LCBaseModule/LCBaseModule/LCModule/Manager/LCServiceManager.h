//
//  LCServiceManager.h
//
//  Created by iblue on 2017/7/12.
//  Copyright © 2017年 jiangbin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCServiceManager : NSObject

+ (instancetype)sharedInstance;

/**
 绑定服务协议与实现类

 @param service 服务协议
 @param implClass 实现类
 */
- (void)registerService:(Protocol *)service implClass:(Class)implClass;

/**
 绑定服务协议与实现类
 
 @param service 服务协议
 @param storyboardName storyboard名称
 @param identifier 控件的唯一标识
 */
- (void)registerService:(Protocol *)service withStoryboard:(NSString *)storyboardName identifier:(NSString *)identifier;

/**
 取得服务协议对应的实现类

 @param service 服务协议
 @return 实现类
 */
- (id)implForService:(Protocol *)service;

@end
