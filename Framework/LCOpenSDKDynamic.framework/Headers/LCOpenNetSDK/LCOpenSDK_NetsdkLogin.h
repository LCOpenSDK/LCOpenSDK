//
//  LCOpenSDK_NetsdkLogin.h
//  LCOpenSDK
//
//  Created by bzy on 5/20/17.
//  Copyright © 2017 lechange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCOpenSDK_NetsdkLogin : NSObject

+ (instancetype)shareInstance;

- (long)getloginHandle:(NSString*)token deviceID:(NSString*)deviceID;

@end
