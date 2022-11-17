//
//  LCServiceProtocol.h
//
//  Created by iblue on 2017/7/12.
//  Copyright © 2017年 jiangbin. All rights reserved.
//  服务协议：实现需要实现的协议

#import <Foundation/Foundation.h>

@protocol LCServiceProtocol <NSObject>

@optional

/**
 是否为单例

 @return YES,单例；NO，非单例
 */
+ (BOOL)isSingleton;

/**
 如果为单例，取得对应的单例

 @return 单例对象
 */
+ (id)sharedInstance;

@end
