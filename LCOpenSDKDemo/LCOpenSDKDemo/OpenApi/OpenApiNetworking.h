//
//  OpenApiNetworking.h
//  LCOpenSDKDemo
//
//  Created by bzy on 17/3/21.
//  Copyright © 2017年 lechange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenApiNetworking : NSObject
+ (instancetype)shareMyInstance;
- (NSString *)requestByPost:(NSString*)url params:(NSString*)params;

- (void)cancelRequest;
@end
