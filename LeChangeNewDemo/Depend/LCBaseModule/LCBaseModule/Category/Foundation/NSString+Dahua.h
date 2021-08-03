//
//  Copyright © 2018 dahua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Dahua)

/**n
 国际化字符串
 */
@property(nonatomic, copy, nonnull, readonly) NSString *lc_T;

+ (NSString *_Nonnull)isoLocalizeLanguageString;

+ (NSString *_Nonnull)dh_currentLanguageCode;
/**
 解密SK SK原始加密值
 @return 解密后的值
 */
- (NSString *_Nullable)dh_decryptSK;

//判断密码强度
+ (BOOL)dh_pwdVerifiers:(NSString *_Nullable)password;

// 去除字符头尾特殊字符
- (NSString *_Nullable)lc_stringByTrimmingCharactersInSet:(NSCharacterSet *_Nullable)characterSet;

@end
