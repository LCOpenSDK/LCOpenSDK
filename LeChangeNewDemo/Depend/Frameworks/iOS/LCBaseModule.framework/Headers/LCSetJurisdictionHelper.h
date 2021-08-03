//
//  Copyright © 2016年 dahua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCSetJurisdictionHelper : NSObject

+ (void)setJurisdictionAlertView:(NSString *)title message:(NSString *)message;

+(void)setJurisdictionAlertView:(NSString*)title message:(NSString*)message complete:(void(^)(NSInteger index))complete;

@end
