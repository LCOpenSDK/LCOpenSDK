//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCNewVideotapePlayerPersenter.h"
#import "LCNewVideotapePlayerPersenter+Control.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCNewVideotapePlayerPersenter (LandscapeControlView)<LCPlayBackLandscapeControlViewDelegate>

/**
 获取横屏状态下控制按钮数组
 */
-(NSMutableArray *)getLandscapeBottomControlItems;

@end

NS_ASSUME_NONNULL_END
