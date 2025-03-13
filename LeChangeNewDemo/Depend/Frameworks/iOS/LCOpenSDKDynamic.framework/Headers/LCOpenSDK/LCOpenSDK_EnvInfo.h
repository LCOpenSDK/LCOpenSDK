//
//  LCOpenSDK_EvnInfo.h
//  LCOpenSDK
//
//  Created by bzy on 5/10/17.
//  Copyright © 2017 lechange. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TODO_OPENAPI @"TODO-OPENAPI"    // 设备非easy4ip或netsdk平台

@interface LCOpenSDK_Sevice : NSObject
@property (nonatomic, copy) NSString *host;
@property (nonatomic, copy) NSString *port;
@property (nonatomic, copy) NSString *type;
@end

@interface LCOpenSDK_NotifyServer : NSObject
@property (nonatomic, strong) LCOpenSDK_Sevice *authService;
@property (nonatomic, strong) LCOpenSDK_Sevice *pushService;
@end

@interface LCOpenSDK_P2p : NSObject
@property (nonatomic, copy)   NSString *authId;
@property (nonatomic, strong) NSArray<LCOpenSDK_Sevice*> *services;
@property (nonatomic, assign) bool isP2PRelay;
@end

@interface LCOpenSDK_CloudPrefix : NSObject
@property (nonatomic, copy) NSString *domian;
@property (nonatomic, copy) NSString *port;
@property (nonatomic, copy) NSString *encryptPort;
@property (nonatomic, copy) NSString *openapiUrl;
@end

@interface LCOpenSDK_Err : NSObject
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;

- (instancetype)initWithCode:(NSString *)code msg:(NSString *)msg;
@end
