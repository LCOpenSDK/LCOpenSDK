//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCNewLivePreviewPresenter.h"
#import "LCNewVideoHistoryView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCNewLivePreviewPresenter (VideotapeList)

/// <#注释#>
@property (strong, nonatomic) LCNewVideoHistoryView *historyView;

/**
 加载云录像
 */
-(void)loadCloudVideotape;

/**
 加载本地录像
 */
-(void)loadLocalVideotape;

/**
 加载云图
 */
- (void)loadCloudPicturetape;

@end

NS_ASSUME_NONNULL_END
