//
//  DHNotificationKey.h
//  DHBaseModule
//
//  Created by 安森 on 2018/9/3.
//  Copyright © 2018年 jm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHNotificationKey : NSObject
//设备信息改变通知
+ (NSString *)deviceChange;
//布防信息改变通知
+ (NSString *)defenceInfoChange;
@end
