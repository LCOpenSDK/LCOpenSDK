//
//  LCOpenSDK_BuryPoint.h
//  LCOpenSDKDynamic
//
//  Created by yyg on 2023/11/20.
//  Copyright © 2023 Fizz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LCOpenSDK_BuryPointProtocol <NSObject>

- (void)buryPoint:(NSString *)jsonString;

@end

@interface LCOpenSDK_BuryPoint : NSObject

+ (void)addBuryPointListener:(id<LCOpenSDK_BuryPointProtocol>)listener;

+ (void)removeBuryPointListener:(id<LCOpenSDK_BuryPointProtocol>)listener;

+ (void)setRequestID:(NSString * __nullable)requestID;

@end

NS_ASSUME_NONNULL_END
