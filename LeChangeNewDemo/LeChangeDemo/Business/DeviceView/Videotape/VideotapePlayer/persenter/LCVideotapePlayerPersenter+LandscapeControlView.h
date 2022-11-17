//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCVideotapePlayerPersenter.h"
#import "LCVideotapePlayerPersenter+Control.h"
NS_ASSUME_NONNULL_BEGIN

@interface LCVideotapePlayerPersenter (LandscapeControlView)

/**
 获取横屏状态下控制按钮数组
 */
-(NSMutableArray *)getLandscapeBottomControlItems;

@end

NS_ASSUME_NONNULL_END
