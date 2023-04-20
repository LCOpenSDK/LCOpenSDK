//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCNewLivePreviewPresenter.h"
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_PlayRealListener.h>
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_TalkerListener.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCNewLivePreviewPresenter (SDKListener)<LCOpenSDK_PlayRealListener>


-(void)saveThumbImage;

@end

NS_ASSUME_NONNULL_END
