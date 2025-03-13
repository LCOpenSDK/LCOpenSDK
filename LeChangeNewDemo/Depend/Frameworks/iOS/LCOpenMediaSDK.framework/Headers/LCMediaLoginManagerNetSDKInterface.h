//
//  Easy4ipSDK_LoginManagerListener.h
//  Easy4ipSDK
//
//  Created by yang_pengwei on 2017/10/30.
//  Copyright © 2017年 www.dahuatech.com. All rights reserved.
//

#ifndef __LCMedia_LCMedia_LoginManagerNetSDKInterface_H__
#define __LCMedia_LCMedia_LoginManagerNetSDKInterface_H__
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol LCMediaLoginManagerNetSDKInterface <NSObject>

- (NSString*)netSDKLoginSyn:(NSInteger)p2pPort DeviceSn:(NSString*)deviceSn;

/**
 login result
 @param p2pPort
 @param DeviceSn 序列号 初始化时为空字符串
 */
- (NSInteger)netSDKLoginAsyn:(NSInteger)p2pPort DeviceSn:(NSString*)deviceSn;

@end

#endif /* __LCSDK_LCSDK_LoginManagerListener_H__ */
