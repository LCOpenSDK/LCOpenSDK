//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "NSString+Verify.h"
#import "LCProgressHUD.h"

#define EMOJI          @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"
#define SPACE          @"[//s//p{Zs}]"
#define LC_ILLEGALCHAR @"[•€`~!#$%^&*+=|{}()':;',\\[\\]<>/?~！#¥%⋯⋯&*（）+|{}【】‘；：\"”“’。，、？]"
#define LC_NEMECHAR @"[0-9a-zA-Z\u4e00-\u9fa5\\@\\_\\-\\ ]+"



@implementation NSString (Verify)

//检查空串
- (BOOL)isNull {
    if ([self isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

//检查有效手机号
- (BOOL)isVaildPhone {
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 16[6], 17[5, 6, 7, 8], 18[0-9], 170[0-9], 19[89]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705,198
     * 联通号段: 130,131,132,155,156,185,186,145,175,176,1709,166
     * 电信号段: 133,153,180,181,189,177,1700,199
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|6[6]|7[05-8]|8[0-9]|9[89])\\d{8}$";

    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478]|9[8])\\d{8}$)|(^1705\\d{7}$)";

    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|66|7[56]|8[56])\\d{8}$)|(^1709\\d{7}$)";

    NSString *CT = @"(^1(33|53|77|73|8[019]|99)\\d{8}$)|(^1700\\d{7}$)";

    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";

    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    // NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];

    if (([regextestmobile evaluateWithObject:self] == YES)
        || ([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES)) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)vaildDeviceName {
    NSString *vaildStr = @"";
    vaildStr = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    vaildStr = [self disableSpecialCharInString:vaildStr];
    if (vaildStr.length > 40) {
        vaildStr = [vaildStr substringToIndex:40];
    }
    return vaildStr;
}

//过滤emoji
- (NSString *)disableEmojiInString:(NSString *)text {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:EMOJI options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

//过滤空白符
- (NSString *)disableSpaceInString:(NSString *)text {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:SPACE options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

//过滤特殊符号
- (NSString *)disableSpecialCharInString:(NSString *)text {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:LC_ILLEGALCHAR options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

//根据正则，过滤特殊字符
- (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr{
    NSString *searchText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
    return result;
}

-(BOOL)isCharactor{
    NSString *regex = @"[^\u4e00-\u9fa5]";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL result = [predicate evaluateWithObject:self];
    return result;
}

-(BOOL)isVaildDeviceName{
    NSString *regex = LC_NEMECHAR;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL result = [predicate evaluateWithObject:self];
    return result;
}

- (BOOL)isSafeCode {
    NSString *regex = @"^[A-Za-z0-9]{5,7}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL result = [predicate evaluateWithObject:self];
    return result;
}

- (BOOL)isVaildEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL result = [emailTest evaluateWithObject:self];
    return result;
}

- (BOOL)isVaildSNCode {
    if (self.length < 10 || self.length > 32) {
        return NO;
    }
    NSString *regex = @"^[A-Za-z0-9]{10,32}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL result = [predicate evaluateWithObject:self];
    return result;
}

- (BOOL)isVaildOverseaSNCode {
    return YES;
}

- (BOOL)isFullNumber {
    NSString *regex = @"^[0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL result = [predicate evaluateWithObject:self];
    return result;
}

- (BOOL)isFullChar {
    NSString *regex = @"^[A-Za-z]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL result = [predicate evaluateWithObject:self];
    return result;
}

- (BOOL)isVaildPasswordBit {
    return [self lc_pwdVerifiers];
}

- (BOOL)isExistBlankSpace {
    NSString *regex = @"^[^ ]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL result = [predicate evaluateWithObject:self];
    return result;
}

- (BOOL)isVaildURL {
    NSString *regex = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL result = [predicate evaluateWithObject:self];
    return result;
}

- (BOOL)lc_pwdVerifiers {
    if (self.length < 8 || self.length > 32) {
        [LCProgressHUD showMsg:@"device_manager_encryption_password_rule".lc_T];
        return false;
    }
    int numOfType = [self passwordStrength:self];
    if (numOfType < 2) {
        [LCProgressHUD showMsg:@"device_password_too_simple".lc_T];
        return false;
    }
    //判断密码是否合法
    if ([self checkInvalidPassword:self]) {
        [LCProgressHUD showMsg:@"device_password_too_simple".lc_T];
        return false;
    }
    if ([self checkSameCharacter:self]) {
        [LCProgressHUD showMsg:@"device_password_too_simple".lc_T];
        return false;
    }
    if ([self checkSameCharacter:self]) {
        [LCProgressHUD showMsg:@"device_password_too_simple".lc_T];
        return false;
    }
    return true;
}

- (int)passwordStrength:(NSString *)pasword
{
    int nRet = 0;//默认密码强度
    //   NSString *regex = @"[a-z][A-Z][0-9]";
    NSString *smallChar = @"abcdefghijklmnopqrstuvwxyz";//小写字母
    NSString *bigChar = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";//大写字母
    NSString *numberChar = @"1234567890";//数字
    NSString *otherChar = @" -/:;()$&@\".,?!'[]{}#%^*+=_\\|~<>.,?!'";//特殊字符
    NSString *urlString = pasword;

    //    int nIndex = 0;
    NSString *strType[4] = { smallChar, bigChar, numberChar, otherChar };
    for (int j = 0; j < 4; j++) {//4种字符类型：小写字母，大写字母、数字、特殊字符（仅限ASCii码）
        for (int i = 0; i < [urlString length]; i++) {
            NSRange r;
            r.length = 1;
            r.location = i;
            NSString *c = [urlString substringWithRange:r];
            //NSString* serialChar = @"1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
            if ([strType[j] rangeOfString:c].location != NSNotFound) {
                nRet++;
                break;
            }
        }
    }
    return nRet;
}

- (BOOL)checkInvalidPassword:(NSString *)password {
    if (password.length > 0) {
        if ([[self initializeInvalidPassword] containsObject:password]) {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)initializeInvalidPassword {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"InvalidPasswordList" ofType:@"plist"];
    NSArray *list = [[NSArray alloc] initWithContentsOfFile:filePath];
    return list;
}

- (BOOL)checkSameCharacter:(NSString *)password {
    if (password.length > 0) {
        NSString *checkerString = @"^.*(.)\\1{5}.*$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", checkerString];
        return [predicate evaluateWithObject:password];
    }
    return NO;
}

@end
