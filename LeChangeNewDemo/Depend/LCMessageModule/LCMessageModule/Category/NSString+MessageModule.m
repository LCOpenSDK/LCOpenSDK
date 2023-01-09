//
//  NSString+MessageModule.m
//  LCMessageModule
//
//  Created by lei on 2022/10/11.
//

#import "NSString+MessageModule.h"

@implementation NSString (MessageModule)

- (NSString*)lcMessage_T {
    return NSLocalizedStringFromTable(self, @"LCLanguage", nil);
}

@end
