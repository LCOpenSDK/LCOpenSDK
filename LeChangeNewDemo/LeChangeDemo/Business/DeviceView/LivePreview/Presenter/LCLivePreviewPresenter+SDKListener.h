//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCLivePreviewPresenter.h"
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_EventListener.h>
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_TalkerListener.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCLivePreviewPresenter (SDKListener)<LCOpenSDK_EventListener>


-(void)saveThumbImage;

@end

NS_ASSUME_NONNULL_END
