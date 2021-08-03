//
//  Copyright © 2019 dahua. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHDevicePWDResetInfo : NSObject

/// 是否成功
@property (nonatomic, assign) BOOL isSuccess;

/// 错误码
@property (nonatomic, copy) NSString *errorStr;

@end

NS_ASSUME_NONNULL_END
