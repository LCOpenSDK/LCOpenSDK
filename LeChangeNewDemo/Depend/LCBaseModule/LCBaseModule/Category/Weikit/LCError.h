//
//  Copyright © 2019 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCError : NSObject

@property (nonatomic, strong)   NSString * errorCode;
@property (nonatomic, strong)   NSString * errorMessage;
@property (nonatomic, strong, readonly) NSDictionary *errorInfo;

- (id)init;

+ (instancetype)errorWithCode:(NSString *)errorCode errorMessage:(nullable NSString *)errorMessage errorInfo:(nullable NSDictionary *)userInfo;

/**
 是否为鉴权失败：对新旧错误码进行统一处理

 @param errorCode 错误码
 @return YES/NO
 */
+ (BOOL)isAuthenticationFailed:(NSInteger)errorCode;

@end

NS_ASSUME_NONNULL_END
