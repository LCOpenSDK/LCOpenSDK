//
//  Copyright © 2019 dahua. All rights reserved.
//   账户对接模型包含

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCAuthModel : NSObject

/// 管理员Token（仅为管理员模式时此项有效）
@property (strong, nonatomic) NSString *accessToken;

/// 用户Token（仅为用户模式时此项有效）
@property (strong, nonatomic) NSString *userToken;

/// 子账户Id
@property (strong, nonatomic) NSString *openid;

/// 剩余过期时间(秒级)
@property (nonatomic) NSUInteger expireTime;

@end

NS_ASSUME_NONNULL_END
