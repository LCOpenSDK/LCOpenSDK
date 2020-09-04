//
//  OpenApiClient.h
//  LCOpenSDKDemo
//
//  Created by bzy on 17/3/21.
//  Copyright © 2017年 lechange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenApiClient : NSObject

@property (nonatomic, copy) NSString *host;
@property (nonatomic, assign) NSInteger port;
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *appSecret;
@property (nonatomic, copy) NSString *method;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *params;
@property (nonatomic, strong) NSDictionary *system;

+ (instancetype)shareMyInstance;
- (void)setParams:(NSString*)host port:(NSInteger)port appId:(NSString*)appId appSecret:(NSString*)appSecret method:(NSString*)method;
- (NSDictionary*)request:(NSDictionary*)req;

- (void)cancelRequest;
@end
