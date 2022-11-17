//
//  NSString+MediaBaseModule.m
//  LCMediaBaseModule
//
//  Created by lei on 2022/10/8.
//

#import "NSString+MediaBaseModule.h"

@implementation NSString (MediaBaseModule)

- (NSString*)lcMedia_T {
    return NSLocalizedStringFromTable(self, @"LCLanguage", nil);
}

@end
