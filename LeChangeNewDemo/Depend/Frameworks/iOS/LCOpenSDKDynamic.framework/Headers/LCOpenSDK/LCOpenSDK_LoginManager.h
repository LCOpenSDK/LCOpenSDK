//
//  LCOpenSDK_LoginManager.h 1
//  LCOpenSDK
//
//  Created by bzy on 2018/5/13.
//  Copyright © 2018 lechange. All rights reserved.
//

#ifndef LCOpenSDK_LoginManager_h
#define LCOpenSDK_LoginManager_h

#import <Foundation/Foundation.h>

@class LCOpenSDK_P2PDeviceInfo;
@class LCOpenSDK_P2PPortInfo;
@interface LCOpenSDK_LoginManager : NSObject

+ (LCOpenSDK_LoginManager * _Nonnull) shareMyInstance;

/// P2P pre hole interface    zh:p2p预打洞接口
/// @param token account token
/// @param devices
- (NSInteger)addDevices:(NSString * _Nonnull)token devices:(NSArray <LCOpenSDK_P2PDeviceInfo *>* _Nonnull)devices;

/// Obtain the P2P port (after successful p2p hole drilling)    zh:获取P2P端口(p2p打洞成功后)
/// @param p2pInfo LCOpenSDK_P2PPortInfo
/// @param time Timeout
- (NSUInteger)getP2pPort:(LCOpenSDK_P2PPortInfo * _Nonnull)p2pInfo timeout:(NSInteger)time;

@end

#endif /* LCOpenSDK_LoginManager_h */
