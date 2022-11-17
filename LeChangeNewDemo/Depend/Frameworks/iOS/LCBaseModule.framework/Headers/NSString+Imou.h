//
//  Copyright © 2018 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Imou)

/**n
 国际化字符串
 */
@property(nonatomic, copy, nonnull, readonly) NSString *lc_T;

+ (NSString *_Nonnull)isoLocalizeLanguageString;

+ (NSString *_Nonnull)lc_currentLanguageCode;

//判断密码强度
+ (BOOL)lc_pwdVerifiers:(NSString *_Nullable)password;

// 去除字符头尾特殊字符
- (NSString *_Nullable)lc_stringByTrimmingCharactersInSet:(NSCharacterSet *_Nullable)characterSet;

@end
