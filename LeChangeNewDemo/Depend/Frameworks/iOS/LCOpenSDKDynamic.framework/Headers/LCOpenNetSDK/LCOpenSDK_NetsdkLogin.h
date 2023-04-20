//
//  LCOpenSDK_NetsdkLogin.h
//  LCOpenSDK
//
//  Created by bzy on 5/20/17.
//  Copyright © 2017 lechange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCOpenSDK_NetsdkLogin : NSObject

+ (instancetype _Nullable)shareInstance;

- (long)getloginHandle:(NSString * _Nonnull)token deviceID:(NSString * _Nonnull)deviceID;

@end
