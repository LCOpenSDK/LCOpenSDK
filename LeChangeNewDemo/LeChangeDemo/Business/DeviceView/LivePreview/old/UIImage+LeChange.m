//
//  Copyright © 2017 lechange. All rights reserved.
//

#import "UIImage+LeChange.h"

@implementation UIImage(LeChange)
+ (UIImage *)leChangeImageNamed:(NSString *)name
{
    NSString* regex = @".*\\.png";
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject:name]) {
        NSString *theName;
        NSArray* array = [name componentsSeparatedByString:@"."];
        NSString *curLanguage = NSLocalizedString(@"", nil);
        if ([curLanguage isEqualToString:@"en"] && array[0] ) {
            theName = [array[0] stringByAppendingString:@"_en.png"];
        }else if ([curLanguage isEqualToString:@"zh"]){
            theName = name;
        }
        UIImage *image = [UIImage imageNamed:theName];
        return image ? image : [UIImage imageNamed:name];
    }
    return nil;
}
@end
