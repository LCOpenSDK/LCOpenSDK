//
//  LCOpenSDK_LoginManager.h
//  LCOpenSDK
//
//  Created by bzy on 2018/5/13.
//  Copyright © 2018 lechange. All rights reserved.
//

#ifndef LCOpenSDK_LoginManager_h
#define LCOpenSDK_LoginManager_h

#import <Foundation/Foundation.h>

@interface LCOpenSDK_LoginManager : NSObject

+ (LCOpenSDK_LoginManager*) shareMyInstance;

- (void)addDevices:(NSString*)token devicesJsonStr:(NSString*)devicesJsonStr failure:(void (^)(NSString* err))failure;

@end

#endif /* LCOpenSDK_LoginManager_h */
