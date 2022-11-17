//
//  LCModuleProtocol.h
//
//  Created by iblue on 2017/7/13.
//  Copyright © 2017年 jiangbin. All rights reserved.
//  Module需要实现的协议

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@protocol LCModuleProtocol <NSObject,UIApplicationDelegate,UNUserNotificationCenterDelegate>

@required

/**
 初始化模块，在此方法实现的功能：
 1、注册路由URL
 2、绑定模块的协议与实现类
 */
- (void)moduleInit;

@optional
/**
 接受传递的自定义事件

 @param eventname 事件名称
 @param userInfo 传递的参数
 */
- (void)moduleCustomEvent:(NSString *)eventname userInfo:(NSDictionary *)userInfo;
    
@end
