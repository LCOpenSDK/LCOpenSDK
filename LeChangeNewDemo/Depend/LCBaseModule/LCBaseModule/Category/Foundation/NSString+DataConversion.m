//
//  Copyright © 2019 jm. All rights reserved.
//

#import "NSString+DataConversion.h"

@implementation NSString (DataConversion)

- (NSString *)dh_conversionPhoneNumber
{
    NSString *rowData = self;//传入手机号
    if ([self hasPrefix:@"+86"])//清除中国区号
        rowData = [self substringFromIndex:3];
    
    //手机号只能是数字,处理 130-1234-5678
    NSString *purePhoneNumber = nil;
    
    for (int i = 0; i < [rowData length]; i++)
    {
        NSRange r ;
        r.length = 1;
        r.location = i;
        NSString* c = [rowData substringWithRange:r];
        NSString* serialChar = @"1234567890";
        if ([serialChar rangeOfString:c].location != NSNotFound)
        {
            purePhoneNumber = [NSString stringWithFormat:@"%@%@",(nil==purePhoneNumber) ? @"" : purePhoneNumber, c];
        }
    }
    if (purePhoneNumber.length > PHONE_NUMBER_LENGTH)
    {
        purePhoneNumber = [purePhoneNumber substringFromIndex:purePhoneNumber.length - PHONE_NUMBER_LENGTH];
    }
    // 返回类型 purePhoneNumber -> @""
    return purePhoneNumber;
}

@end
