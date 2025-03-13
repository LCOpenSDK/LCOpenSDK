//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCNewVideotapePlayerPersenter.h"
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_PlayBackListener.h>
#import <LCOpenMediaSDK/LCOpenMediaSDK-Swift.h>
#import <LCOpenMediaSDK/LCOpenMediaSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCNewVideotapePlayerPersenter (SDKListener)<LCRecordPluginDelegate, LCRecordDoubleCamWindowDelegate, LCRecordPluginGestureDelegate>

@end

NS_ASSUME_NONNULL_END
