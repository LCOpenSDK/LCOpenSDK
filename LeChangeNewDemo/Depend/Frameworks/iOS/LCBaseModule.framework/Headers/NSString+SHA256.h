//
//  Copyright © 2018年 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SHA256)
- (NSString *)sha256;

- (NSData *)lc_MD5Data;

- (NSData *)lc_SHA256Data;

// 十六进制转换成NSString
- (NSString *)lc_convertHexStrToString;

//将NSString转换成十六进制的字符串则可使用如下方式:
- (NSString *)lc_convertStringToHexString;

- (NSString *)lc_AESEncryptStringForkey:(NSString *)key;

- (NSString *)lc_AESDecryptStringForkey:(NSString *)key;



@end
