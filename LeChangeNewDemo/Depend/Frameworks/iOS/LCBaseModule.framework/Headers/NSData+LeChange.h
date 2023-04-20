//
//  Copyright © 2016年 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (LeChange)

//加密
- (NSData *)lc_AES256Encrypt:(NSString *)key;

//解密
- (NSData *)lC_AES256Decrypt:(NSString *)key;


@end
