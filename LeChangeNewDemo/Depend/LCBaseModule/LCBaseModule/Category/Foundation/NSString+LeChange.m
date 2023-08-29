//
//  Copyright (c) 2015年 Imou. All rights reserved.

#import "NSString+LeChange.h"
#import "NSData+LeChange.h"
#import "NSData+AES.h"
#import "NSString+MD5.h"
#import "NSData+Base64.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "UIDevice+LeChange.h"

@implementation  NSString(LeChange)


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

+ (NSString *)getGatewayIpForCurrentWiFi {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                    //routerIP----192.168.1.255 广播地址
                    NSLog(@"广播地址：%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)]);
                    
                    //--192.168.1.106 本机地址
                    NSLog(@"本机地址：%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]);
                    
                    //--255.255.255.0 子网掩码地址
                    NSLog(@"子网掩码地址：%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)]);
                    
                    //--en0 接口
                    //  en0       Ethernet II    protocal interface
                    //  et0       802.3             protocal interface
                    //  ent0      Hardware device interface
                    NSLog(@"接口名：%@",[NSString stringWithUTF8String:temp_addr->ifa_name]);
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    in_addr_t i = inet_addr([address cStringUsingEncoding:NSUTF8StringEncoding]);
    in_addr_t* x = &i;
    unsigned char *s = getdefaultgateway(x);
    NSString *ip=[NSString stringWithFormat:@"%d.%d.%d.%d",s[0],s[1],s[2],s[3]];
    free(s);
    
    NSString *newIp = @"";
    // 如果获取到的路由器 ip 跟本机地址 address不在同一网段，需要处理ip地址（解决从蜂窝网络，首次连接上wifi时获取到的ip有可能不对的问题）
    NSArray *addressArray = [address componentsSeparatedByString:@"."];
    NSArray *IPArray = [ip componentsSeparatedByString:@"."];
    if (addressArray.count >= 3 && IPArray.count >= 3 && (![addressArray[0] isEqualToString:IPArray[0]] || ![addressArray[1] isEqualToString:IPArray[1]] || ![addressArray[2] isEqualToString:IPArray[2]]) ) {
        if (addressArray.count == IPArray.count) {
            for (int i = 0; i < 4; i++) {
                if (i != 3) {
                    if (addressArray[i] == IPArray[i]) {
                        newIp = [newIp stringByAppendingString:[NSString stringWithFormat:@"%@.", IPArray[i]]];
                    } else {
                        newIp = [newIp stringByAppendingString:[NSString stringWithFormat:@"%@.", addressArray[i]]];
                    }
                } else {
                    newIp = [newIp stringByAppendingString:@"1"];
                }
            }
            return newIp;
        }
    }
    
    return ip;
}

+ (NSString *)getCurreWiFiSsid {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    return [(NSDictionary*)info objectForKey:@"SSID"];
}

+ (NSString *)lc_currentLanguageCode
{
    NSString *currentLanguage = [NSLocale preferredLanguages].firstObject;
    if ([currentLanguage hasPrefix:@"zh"]) {
        currentLanguage = [currentLanguage containsString:@"zh-Hant"] ? @"zh-TW" : @"zh-CN";
    }

    return currentLanguage;
}

@end
