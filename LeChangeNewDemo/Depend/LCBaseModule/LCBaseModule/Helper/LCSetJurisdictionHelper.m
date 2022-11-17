//
//  Copyright © 2016年 Imou. All rights reserved.
//

#import <LCBaseModule/LCSetJurisdictionHelper.h>
#import <LCBaseModule/LCBaseModule-Swift.h>
#import <LCBaseModule/LCAlertController.h>

@implementation LCSetJurisdictionHelper

+(void)setJurisdictionAlertView:(NSString*)title message:(NSString*)message 

{
    void (^aBlock)(void) =  ^(void){
        NSString *  urlString = UIApplicationOpenSettingsURLString;
        NSURL* url = [NSURL URLWithString:urlString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    };
    [LCAlertController showWithTitle:title
                             message:message
                   cancelButtonTitle:@"common_cancel".lc_T
                    otherButtonTitle:@"common_set".lc_T
                             handler:^(NSInteger index) {
        if (index == 1) {
            aBlock();
        }
    }];
}

+(void)setJurisdictionAlertView:(NSString*)title message:(NSString*)message complete:(void(^)(NSInteger index))complete{
    void (^aBlock)(void) =  ^(void) {
        NSString *  urlString = UIApplicationOpenSettingsURLString;
        NSURL* url = [NSURL URLWithString:urlString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    };
    [LCAlertController showWithTitle:title
                             message:message
                   cancelButtonTitle:@"common_cancel".lc_T
                    otherButtonTitle:@"common_set".lc_T
                             handler:^(NSInteger index) {
        complete(index);
        if (index == 1) {
            aBlock();
        }
    }];
}

@end
