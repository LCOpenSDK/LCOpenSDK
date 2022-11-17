//
//  Copyright © 2017年 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES)
//加密
- (NSData *)lc_AES256CBCEncryptWithKey:(NSString *)key iv:(NSString *)iv;

//解密
- (NSData *)lc_AES256CBCDecryptWithKey:(NSString *)key iv:(NSString *)iv;
@end
