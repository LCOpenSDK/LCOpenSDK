//
//  OpenApiInfo.h
//  LCOpenSDKDemo
//
//  Created by 韩燕瑞 on 2020/7/11.
//  Copyright © 2020 lechange. All rights reserved.
//

#import "MJExtension.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Device : NSObject

@property (nonatomic, copy) NSString  *deviceId;
@property (nonatomic, copy) NSString  *status;
@property (nonatomic, copy) NSString  *deviceModel;
@property (nonatomic, copy) NSString  *catalog;
@property (nonatomic, copy) NSString  *version;
@property (nonatomic, copy) NSString  *name;
@property (nonatomic, copy) NSString  *ability;
@property (nonatomic, copy) NSString  *accessType;
@property (nonatomic, copy) NSString  *playToken;
@property (nonatomic, assign) NSInteger encryptMode;
@property (nonatomic, strong) NSArray   *channels;

@end

@interface Channel : NSObject

@property (nonatomic, copy) NSString  *channelId;
@property (nonatomic, copy) NSString  *deviceId;
@property (nonatomic, copy) NSString  *channelName;
@property (nonatomic, copy) NSString  *status;
@property (nonatomic, copy) NSString  *picUrl;
@property (nonatomic, copy) NSString  *remindStatus;
@property (nonatomic, copy) NSString  *cameraStatus;
@property (nonatomic, copy) NSString  *storageStrategyStatus;
@property (nonatomic, copy) NSString  *shareStatus;
@property (nonatomic, copy) NSString  *playToken;
@property (nonatomic, copy) NSString  *shareFunctions;
@property (nonatomic, copy) NSString  *ability;
/** 非平台返回*/
@property (nonatomic, copy) NSString  *encryptKey;

@end

NS_ASSUME_NONNULL_END
