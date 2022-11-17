//
//  Copyright © 2019 Imou. All rights reserved.
//   账户对接模型包含

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCAuthModel : NSObject

/// Token
@property (strong, nonatomic) NSString *accessToken;

/// 子账户Id
@property (strong, nonatomic) NSString *openid;

/// 剩余过期时间(秒级)
@property (nonatomic) NSUInteger expireTime;

@end

NS_ASSUME_NONNULL_END
