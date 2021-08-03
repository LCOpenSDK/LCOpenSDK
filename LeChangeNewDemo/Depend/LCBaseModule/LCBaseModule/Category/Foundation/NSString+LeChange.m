//
//  Copyright (c) 2015年 Dahua. All rights reserved.

#import "NSString+LeChange.h"
#import "NSData+LeChange.h"
#import "NSData+AES.h"
#import "NSString+MD5.h"
#import "NSData+Base64.h"

@implementation  NSString(LeChange)


- (NSString *)lc_EncryptToServerWithPwd:(NSString *)password
{
    NSString *realPwd = [[[password uppercaseString] stringByAppendingString:@"DAHUAKEY"] lc_MD5Digest];
    NSData *srcData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *decData = [srcData lc_AES256CBCEncryptWithKey:realPwd iv:@"0a52uuEvqlOLc5TO"];
    return [decData base64String];
}

- (NSString *)lc_DecryptToServerWithPwd:(NSString *)password
{
    NSData *srcData = [[NSData alloc] initWithBase64EncodedString:self options:0];
    NSString *realPwd = [[[password uppercaseString] stringByAppendingString:@"DAHUAKEY"] lc_MD5Digest];
    NSData *decData = [srcData lc_AES256CBCDecryptWithKey:realPwd iv:@"0a52uuEvqlOLc5TO"];
    NSString *string = [[NSString alloc] initWithData:decData encoding:NSUTF8StringEncoding];
    return string ;
}

#pragma mark - Absent Value

- (BOOL)isAbsent {
    
    if (self == nil || self.length == 0) {
        return YES;
    }
    
    return NO;
}

-(void)setIsAbsent:(BOOL)isAbsent {

}


#pragma mark - Json Value

- (id)lc_jsonValue {
    NSError *error = nil;
    
    id jsonValue = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    
    return jsonValue;
}

+ (NSString*)lc_dictionaryToJson:(NSDictionary *)dic {
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

#pragma mark - String Type

-(BOOL)lc_isStringType:(StringType)type {
    if (self == nil || self.length == 0) {
        return NO;
    }
    
    NSString *regex = @"[A-Za-z0-9]";
    
    switch (type) {
        case StringTypeNumber:
            regex = @"[0-9]";
            break;
            
        case StringTypeLetter:
            regex = @"[A-Za-z]";
            break;

        case StringTypeLetterAndNumber:
            regex = @"[A-Za-z0-9]";
            break;
    }
    
    regex = [NSString stringWithFormat:@"^%@{%lu}$", regex, (unsigned long)self.length];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if (![predicate evaluateWithObject:self]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Int To String

+ (NSString *)lc_stringWithInt:(NSInteger)intNum
{
    return [NSString stringWithFormat:@"%ld", (long)intNum];
}

#pragma mark - Size With Font

- (CGSize)lc_sizeWithFont:(UIFont *)font size:(CGSize)size {

    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font} context:nil].size;
}

- (CGFloat)lc_widthWithFont:(UIFont *)font {
    return [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font} context:nil].size.width;
}


//获取文字所占空间的大小
- (CGRect)lc_rectWithFont:(UIFont *)font
{
    if (self == nil || [self length] == 0) {
        return CGRectMake(0, 0, 0, 0);
    }
    
    NSString* fullDescAndTagStr =self;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:fullDescAndTagStr];
    
    NSRange allRange = [fullDescAndTagStr rangeOfString:fullDescAndTagStr];
    [attrStr addAttribute:NSFontAttributeName
                    value:font
                    range:allRange];
    float labelWidth = 225;
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    return [attrStr boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX)
                                 options:options
                                 context:nil];
}

+ (BOOL)lc_isEmpty:(NSString*)content {

    if (content == nil || content.length == 0) {
        return YES;
    }
    
    return NO;
}

#pragma mark - AES & Base64
- (NSString *)lc_base64String {
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *base64Str = [data base64EncodedStringWithOptions:0];
    return base64Str;
}

- (NSString *)lc_decodeBase64 {
    NSData *dataDecoded = [[NSData alloc] initWithBase64EncodedString:self options:0];
    NSString *string = [[NSString alloc] initWithData:dataDecoded encoding:NSUTF8StringEncoding];
    return string;
}

- (NSString *)lc_AES256Encrypt:(NSString *)key
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    //对数据进行加密
    NSData *result = [data lc_AES256Encrypt:key];
    
    //转换为2进制字符串
    if (result && result.length > 0) {
        
        Byte *datas = (Byte*)[result bytes];
        NSMutableString *output = [NSMutableString stringWithCapacity:result.length * 2];
        
        for(int i = 0; i < result.length; i++){
            [output appendFormat:@"%02x", datas[i]];
        }
        
        return output;
    }
    
    return nil;
}

- (NSString *)lc_AES256Decrypt:(NSString *)key
{
    //转换为2进制Data
    NSMutableData *data = [NSMutableData dataWithCapacity:self.length / 2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    
    for (i=0; i < [self length] / 2; i++) {
        byte_chars[0] = [self characterAtIndex:i*2];
        byte_chars[1] = [self characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    
    //对数据进行解密
    NSData* result = [data lC_AES256Decrypt:key];
    
    if (result && result.length > 0) {
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
    
    return nil;
}

- (NSString *)lc_phoneNumberWithEncrypt {
    NSString *regEx =  @"^\\d{11}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    
    if ([pred evaluateWithObject:self]) {
        //如果是11位数字
        return [self stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    
    return self;
}

- (BOOL)lc_matchTheFormat:(NSString*)format {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", format];
    
    return [pred evaluateWithObject:self];
}

- (BOOL)lc_strictContainString:(NSString*)matchString split:(NSString*)splitString {
    NSArray *strings = [self componentsSeparatedByString:splitString];
    
    for(NSString *item in strings) {
        if ([item isEqualToString:matchString]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)lc_isValidIphoneNum
{
    NSString *regex = @"0?(13|14|15|17|18)[0-9]{9}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}


- (BOOL)lc_isValidEmail
{
	///原 \\w[-\\w.+]*@([A-Za-z0-9][-A-Za-z0-9]+\\.)+[A-Za-z]{2,14}
	NSString *regex = @"\\w[-\\w.+]*@([-A-Za-z0-9]+\\.)+[A-Za-z]{2,14}";
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	return [predicate evaluateWithObject:self];
}

- (BOOL)lc_isAllNum
{
    NSString *regex = @"\\d+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

@end
