//
//  Copyright © 2019 dahua. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHDeviceInfoLogModel : NSObject

@property (nonatomic, assign) BOOL isSuccess;

@property (nonatomic, copy) NSString *ip;
@property (nonatomic, assign) int pwdResetWay;
//@property (nonatomic, assign) BOOL isDeviceNeedInit;
//@property (nonatomic, assign) BOOL isDeviceSupportInit;
@property (nonatomic, assign) BOOL isEffectiveIP;
@property (nonatomic, assign) BOOL isNewDeviceVersion;
@property (nonatomic, copy) NSString *mac;

@end

NS_ASSUME_NONNULL_END
