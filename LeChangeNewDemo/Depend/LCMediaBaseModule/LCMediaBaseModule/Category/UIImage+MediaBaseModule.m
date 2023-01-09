//
//  UIImage+MediaBaseModule.m
//  LCMediaBaseModule
//
//  Created by lei on 2022/10/8.
//

#import "UIImage+MediaBaseModule.h"

@implementation UIImage (MediaBaseModule)

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
