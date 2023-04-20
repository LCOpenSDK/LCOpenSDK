//
//  Copyright © 2018 Imou. All rights reserved.
//

#import "NSString+Imou.h"
#import "LCProgressHUD.h"
#import "NSString+MD5.h"
#import "NSData+AES.h"

//TT_FIX_CATEGORY_BUG(NSStringImou)

@implementation NSString(Imou)

- (NSString*)lc_T {
    return NSLocalizedStringFromTable(self, @"LCLanguage", nil);
//    //仿单例, 待翻译的语言文件
//    static NSBundle *bundle = nil;
//	//默认的翻译语言文件，支持多语言时为英文
//	static NSBundle *defaultBundle = nil;
//
//    //保证只执行一次
//    if(bundle == nil) {
//        //支持当前语言
//        if ([self isSupportCurrentLanguage] == false) {
//			//设置默认语言为英语
//			bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"]];
//        }
//
//		if (bundle == nil) {
//			// 避免小语种，在部分系统无法生成en.lproj
//			bundle = NSBundle.mainBundle;
//		}
//    }
//
//    NSString *result = [bundle localizedStringForKey:self value:@"" table:nil];
//
//	if ([result isEqualToString:self]) {
//
//		if (defaultBundle == nil) {
//			// 如果当前语言没有key,就取英文的key
//			defaultBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"]];
//		}
//
//		result = [defaultBundle localizedStringForKey:self value:@"" table:nil];
//	}
//
//    return result == nil ? self : result;
}

+ (NSString *_Nonnull)lc_currentLanguageCode
{
    NSString *currentLanguage = [NSLocale preferredLanguages].firstObject;
    if ([currentLanguage hasPrefix:@"zh"]) {
        currentLanguage = [currentLanguage containsString:@"zh-Hant"] ? @"zh-TW" : @"zh-CN";
    }

    return currentLanguage;
}

- (BOOL)isSupportCurrentLanguage {
	NSString *currentLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
	
	NSArray *supportLanguages = @[@"en", @"zh-Hans", @"zh-Hant"];
	
	for (NSString *supportLanguage in supportLanguages) {
		if ([currentLanguage hasPrefix:supportLanguage]) {
			return true;
		}
	}
	return false;
}

+ (NSString *)isoLocalizeLanguageString {
	NSLocale *local = [NSLocale autoupdatingCurrentLocale];
	NSString *area = [local objectForKey:NSLocaleCountryCode];
	NSString *language = [NSLocale preferredLanguages].firstObject;
	NSString *currentLanguage = @"";
	//【*】这里有个问题，当APP新增语言时，旧版本不支持该语言，这个时候获取到的本地语言是语言列表中所APP支持的第一个语言。故这里需要保证获取到的语言是列表中的第一个语言。同时拼接地区。
	if ([language containsString:@"zh-Hant"]) {
		currentLanguage = @"zh_TW";
	} else if(area != nil) {
		currentLanguage = [language componentsSeparatedByString:@"-"].firstObject;
		currentLanguage = [currentLanguage stringByAppendingFormat:@"_%@",area];
	} else {
		currentLanguage = language;
	}
	
	return currentLanguage;
}

+ (BOOL)lc_pwdVerifiers:(NSString *)password {
    int numOfType = [self passwordStrength:password];
    if (numOfType < 2) {
        [LCProgressHUD showMsg:@"device_password_too_simple".lc_T];
        return false;
    }
    //判断密码是否合法
    if ([self checkInvalidPassword:password]) {
        [LCProgressHUD showMsg:@"device_password_too_simple".lc_T];
        return false;
    }
    if ([self checkSameCharacter:password]) {
        [LCProgressHUD showMsg:@"device_password_too_simple".lc_T];\
        return false;
    }
    return true;
}

+ (int)passwordStrength:(NSString *)pasword
{
    int nRet = 0;//默认密码强度
    //   NSString *regex = @"[a-z][A-Z][0-9]";
    NSString *smallChar = @"abcdefghijklmnopqrstuvwxyz";//小写字母
    NSString *bigChar = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";//大写字母
    NSString *numberChar = @"1234567890";//数字
    NSString *otherChar = @" -/:;()$&@\".,?!'[]{}#%^*+=_\\|~<>.,?!'";//特殊字符
    NSString *urlString = pasword;
    
    //    int nIndex = 0;
    NSString *strType[4] = {smallChar, bigChar, numberChar, otherChar};
    for (int j=0;j<4;j++)
    {//4种字符类型：小写字母，大写字母、数字、特殊字符（仅限ASCii码）
        
        for (int i = 0; i < [urlString length]; i++)
        {
            NSRange r ;
            r.length = 1;
            r.location = i;
            NSString* c = [urlString substringWithRange:r];
            //NSString* serialChar = @"1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
            if ([strType[j] rangeOfString:c].location != NSNotFound)
            {
                nRet++;
                break;
            }
        }
    }
    return nRet;
}

+ (BOOL)checkInvalidPassword:(NSString *)password {
    if (password.length > 0) {
        if ([[self initializeInvalidPassword] containsObject:password]) {
            return YES;
        }
    }
    return NO;
}

+ (NSArray *)initializeInvalidPassword {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"InvalidPasswordList" ofType:@"plist"];
    NSArray *list = [[NSArray alloc] initWithContentsOfFile:filePath];
    return list;
}

+ (BOOL)checkSameCharacter:(NSString *)password {
    
    if (password.length > 0) {
        NSString *checkerString = @"^.*(.)\\1{5}.*$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", checkerString];
        return [predicate evaluateWithObject:password];
    }
    return NO;
}

- (NSString *_Nullable)lc_stringByTrimmingCharactersInSet:(NSCharacterSet *_Nullable)characterSet
{
    NSString *newStr = [self stringByTrimmingCharactersInSet:characterSet];
    return newStr;
}

@end
