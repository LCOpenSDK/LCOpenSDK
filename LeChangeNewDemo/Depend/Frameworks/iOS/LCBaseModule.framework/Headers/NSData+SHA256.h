//
//  Copyright © 2018年 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (SHA256)

- (NSData *)lc_SHA256Data;

- (NSData *)reverseData;

- (NSString *)data2Str;

/// CCOperation
- (NSData *)AES256CBCOperation:(uint32_t)operation keyData:(NSData *)key ivData:(NSData *)iv;

//将NSString转换成十六进制的字符串则可使用如下方式:
- (NSString *)lc_convertToHexString;

@end
