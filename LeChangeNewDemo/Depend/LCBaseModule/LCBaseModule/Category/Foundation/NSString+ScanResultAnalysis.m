//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "NSString+ScanResultAnalysis.h"
#import "LCQRCode.h"
#import <objc/runtime.h>

static const void *KEY_CODE_ANALYSIS = @"KEY_CODE_ANALYSIS";

@interface NSString ()

///
@property (strong, nonatomic) LCQRCode *codeAnalysis;

@end

@implementation NSString (ScanResultAnalysis)

- (NSString *)SNCode {
//    NSString *regex = @"(SN:[A-Za-z0-9]{10,32})";
//    NSRegularExpression *regular = [[NSRegularExpression alloc]initWithPattern:regex options:NSRegularExpressionDotMatchesLineSeparators error:nil];
//    NSArray *resultArray = [regular matchesInString:self options:0 range:NSMakeRange(0, self.length)];
//    if (resultArray.count == 0) {
//        return nil;
//    }
//    NSTextCheckingResult *result = resultArray[0];
//    NSString *textStr = [[self substringWithRange:result.range] substringFromIndex:3];
//    return textStr;
    return self.codeAnalysis.deviceSN;
}

- (NSString *)SCCode {
//    NSString *regex = @"(SC:[A-Za-z0-9]{8})";
//    NSRegularExpression *regular = [[NSRegularExpression alloc]initWithPattern:regex options:NSRegularExpressionDotMatchesLineSeparators error:nil];
//    NSArray *resultArray = [regular matchesInString:self options:0 range:NSMakeRange(0, self.length)];
//    if (resultArray.count == 0) {
//      return  [self RC8Code];
//    }
//    NSTextCheckingResult *result = resultArray[0];
//    NSString *textStr = [[self substringWithRange:result.range] substringFromIndex:3];
//    return textStr;
    return self.codeAnalysis.scCode;
}

- (NSString *)RC8Code {
//    NSString *regex = @"(RC:[A-Za-z0-9]{8})";
//    NSRegularExpression *regular = [[NSRegularExpression alloc]initWithPattern:regex options:NSRegularExpressionDotMatchesLineSeparators error:nil];
//    NSArray *resultArray = [regular matchesInString:self options:0 range:NSMakeRange(0, self.length)];
//    if (resultArray.count == 0) {
//        return nil;
//    }
//    NSTextCheckingResult *result = resultArray[0];
//    NSString *textStr = [[self substringWithRange:result.range] substringFromIndex:3];
//    return textStr;
    return self.codeAnalysis.identifyingCode;
}

- (NSString *)DTCode {
//    NSString *regex = @"(DT:[A-Za-z0-9]+)";
//    NSRegularExpression *regular = [[NSRegularExpression alloc]initWithPattern:regex options:NSRegularExpressionDotMatchesLineSeparators error:nil];
//    NSArray *resultArray = [regular matchesInString:self options:0 range:NSMakeRange(0, self.length)];
//    if (resultArray.count == 0) {
//        return nil;
//    }
//    NSTextCheckingResult *result = resultArray[0];
//    NSString *textStr = [[self substringWithRange:result.range] substringFromIndex:3];
//    return textStr;
    return self.codeAnalysis.deviceType;
}

- (NSString *)RCCode {
//    NSString *regex = @"(RC:[A-Za-z0-9]{6})";
//    NSRegularExpression *regular = [[NSRegularExpression alloc]initWithPattern:regex options:NSRegularExpressionDotMatchesLineSeparators error:nil];
//    NSArray *resultArray = [regular matchesInString:self options:0 range:NSMakeRange(0, self.length)];
//    if (resultArray.count == 0) {
//        return nil;
//    }
//    NSTextCheckingResult *result = resultArray[0];
//    NSString *textStr = [[self substringWithRange:result.range] substringFromIndex:3];
//    return textStr;
    return self.codeAnalysis.identifyingCode;
}

/**
获取NC码
*/
- (NSString *)NCCode {
//    NSString *regex = @"(NC:[0-9]{3})";
//    NSRegularExpression *regular = [[NSRegularExpression alloc]initWithPattern:regex options:NSRegularExpressionDotMatchesLineSeparators error:nil];
//    NSArray *resultArray = [regular matchesInString:self options:0 range:NSMakeRange(0, self.length)];
//    if (resultArray.count == 0) {
//        return nil;
//    }
//    NSTextCheckingResult *result = resultArray[0];
//    NSString *textStr = [[self substringWithRange:result.range] substringFromIndex:3];
//    return textStr;
    return self.codeAnalysis.ncCode;
}

- (NSInteger)numberWithHexString:(NSString *)hexString {
    const char *hexChar = [hexString cStringUsingEncoding:NSUTF8StringEncoding];

    int hexNumber;

    sscanf(hexChar, "%x", &hexNumber);

    return (NSInteger)hexNumber;
}

/**
是否支持新声波配网
*/
- (BOOL)isNetConfigSupportNewSound {
    NSString *ncCode = [self NCCode];
    if (!ncCode) {
        return NO;
    }
    NSInteger ncInt =  [self numberWithHexString:ncCode];
    if ((ncInt & LC_NC_CODE_TYPE_NEW_SOUND) != 0) {
        return YES;
    }
    return NO;
}

/**
是否支持老声波配网
*/
- (BOOL)isNetConfigSupportOldSound {
    NSString *ncCode = [self NCCode];
    if (!ncCode) {
        return NO;
    }
    NSInteger ncInt =  [self numberWithHexString:ncCode];
    if ((ncInt & LC_NC_CODE_TYPE_OLD_SOUND) != 0) {
        return YES;
    }
    return NO;
}

/**
是否支持SmartConfig配网
*/
- (BOOL)isNetConfigSupportSmartConfig {
    NSString *ncCode = [self NCCode];
    if (!ncCode) {
        return NO;
    }
    NSInteger ncInt =  [self numberWithHexString:ncCode];
    if ((ncInt & LC_NC_CODE_TYPE_SMARTCONFIG) != 0) {
        return YES;
    }
    return NO;
}

/**
是否支持软AP配网
*/
- (BOOL)isNetConfigSupportSoftAP {
    NSString *ncCode = [self NCCode];
    if (!ncCode) {
        return NO;
    }
    NSInteger ncInt =  [self numberWithHexString:ncCode];
    if ((ncInt & LC_NC_CODE_TYPE_SOFTAP) != 0) {
        return YES;
    }
    return NO;
}

/**
是否支持有线配网
*/
- (BOOL)isNetConfigSupportLAN {
    NSString *ncCode = [self NCCode];
    if (!ncCode) {
        return NO;
    }
    NSInteger ncInt =  [self numberWithHexString:ncCode];
    if ((ncInt & LC_NC_CODE_TYPE_LAN) != 0) {
        return YES;
    }
    return NO;
}

/**
是否支持蓝牙配网
*/
- (BOOL)isNetConfigSupportBLE {
    NSString *ncCode = [self NCCode];
    if (!ncCode) {
        return NO;
    }
    NSInteger ncInt =  [self numberWithHexString:ncCode];
    if ((ncInt & LC_NC_CODE_TYPE_BLE) != 0) {
        return YES;
    }
    return NO;
}

/**
是否支持二维码配网
*/
- (BOOL)isNetConfigSupportQRCode {
    NSString *ncCode = [self NCCode];
    if (!ncCode) {
        return NO;
    }
    NSInteger ncInt =  [self numberWithHexString:ncCode];
    if ((ncInt & LC_NC_CODE_TYPE_QRCODE) != 0) {
        return YES;
    }
    return NO;
}

//MARK: - Private Methods

- (LCQRCode *)codeAnalysis {
    
    id obj = objc_getAssociatedObject(self, KEY_CODE_ANALYSIS);
    if (!obj) {
        LCQRCode * code = [LCQRCode new];
        [code pharseQRCode:self];
        [self setCodeAnalysis:code];
        obj = code;
    }
    return obj;
}

- (void)setCodeAnalysis:(LCQRCode *)codeAnalysis {
    objc_setAssociatedObject(self, KEY_CODE_ANALYSIS, codeAnalysis, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
