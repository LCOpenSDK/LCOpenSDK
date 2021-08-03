//
//  LCDeviceVideoManager.m
//  LeChangeDemo
//
//  Created by imou on 2019/12/16.
//  Copyright © 2019 dahua. All rights reserved.
//

#import "LCDeviceVideoManager.h"

static LCDeviceVideoManager * manager = nil;

@implementation LCDeviceVideoManager

+(instancetype)manager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [LCDeviceVideoManager new];
        manager.isPlay = NO;
    });
    return manager;
}

@end
