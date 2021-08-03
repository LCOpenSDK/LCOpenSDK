//
//  Copyright © 2019 jm. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define PHONE_NUMBER_LENGTH  11

/// 数据转换类
@interface NSString (DataConversion)

/// 转换手机号
- (NSString *)dh_conversionPhoneNumber;


@end

NS_ASSUME_NONNULL_END
