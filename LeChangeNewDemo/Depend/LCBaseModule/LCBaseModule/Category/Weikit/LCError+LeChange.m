//
//  Copyright © 2016年 Imou. All rights reserved.
//

#import "LCError+LeChange.h"
#import "LCErrorCode.h"
#import "LCProgressHUD.h"

@implementation LCError (LeChange)

@dynamic errorDescription;

- (void)showPlatformTips {
	//【*】鉴权失败不提示
	if ([LCError isAuthenticationFailed:[self.errorCode integerValue]]) {
		return;
	}
	
    NSString *desc = [self.errorInfo objectForKey:@"Desc"];
    if (desc) {
        [LCProgressHUD showMsg:desc];
    }
}

- (NSString *)platformTips {
    NSString *desc = [self.errorInfo objectForKey:@"Desc"];
    return desc;
}

- (NSString *)errorDescription
{
    NSString *desc;
    switch ([self.errorCode intValue]) {
        //400
        case EC_HTTP_FORMAT:
            return @"mobile_common_network_exception".lc_T;

        //404
        case EC_HTTP_NOT_FOUND:
            return @"device_manager_no_network_tip".lc_T;

        //500
        case EC_HTTP_INTERNAL_SERVER:
            return @"mobile_common_bec_common_network_unusual".lc_T;

        //502
        case EC_HTTP_BAD_GATEWAY:
            return @"mobile_common_bec_common_network_unusual".lc_T;

        //503
        case EC_HTTP_SERVICE_UNAVAILABLE:
            return @"mobile_common_bec_common_network_unusual".lc_T;

        case -1:
        case -100:
            return @"mobile_common_bec_common_network_unusual".lc_T;

        default:
            desc = [self.errorInfo objectForKey:@"Desc"];
    }
    if (desc.length > 0) {
        return desc;
    } else if (self.errorCode.length > 0 || self.errorMessage.length > 0) {
        return [NSString stringWithFormat:@"%@ %@", self.errorCode, self.errorMessage];
    } else {
        return @"mobile_common_bec_common_unknown".lc_T;
    }
}

- (void)showErrorTips:(NSString *)customTips {
	//【*】鉴权失败不提示
	if ([LCError isAuthenticationFailed:[self.errorCode integerValue]]) {
		return;
	}
	
    //SMB 直接使用平台的Desc进行显示
    NSString *desc = [self.errorInfo objectForKey:@"Desc"];
    if (desc && desc.length > 0) {
        [LCProgressHUD showMsg:desc];
        return;
    }

    NSString *mTips;

    if (customTips.length == 0) {
        //自定义提示为空时，可能显示未知错误
        mTips = [self errorDescription];
    } else {
        //当出现未知错误时，显示自定义错误
        mTips = [[self errorDescription] isEqualToString:@"mobile_common_bec_common_unknown".lc_T] ? customTips : [self errorDescription];
    }

    [LCProgressHUD showMsg:mTips];
}

- (void)showErrorTips {
    [self showErrorTips:@""];
}

- (void)showErrorTipsInView:(UIView *)view
{
	//【*】鉴权失败不提示
	if ([LCError isAuthenticationFailed:[self.errorCode integerValue]]) {
		return;
	}
	
    [LCProgressHUD showMsg:[self errorDescription] inView:view];
}

- (NSString *)descriptionByCustom:(NSString *)customTips
{
    NSString *mTips;

    if (customTips.length == 0) {
        //自定义提示为空时，可能显示未知错误
        mTips = [self errorDescription];
    } else {
        //当出现未知错误时，显示自定义错误
        mTips = [[self errorDescription] isEqualToString:@"mobile_common_bec_common_unknown".lc_T] ? customTips : [self errorDescription];
    }

    return mTips;
}

@end
