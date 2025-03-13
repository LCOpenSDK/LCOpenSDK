//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCNewLivePreviewPresenter.h"
#import <LCOpenMediaSDK/LCOpenMediaSDK-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCNewLivePreviewPresenter (SDKListener)<LCOpenMediaLiveDelegate, LCOpenMediaLiveMultiviewDelegate, LCOpenMediaLiveGestureDelegate>


-(void)saveThumbImage;

@end

NS_ASSUME_NONNULL_END
