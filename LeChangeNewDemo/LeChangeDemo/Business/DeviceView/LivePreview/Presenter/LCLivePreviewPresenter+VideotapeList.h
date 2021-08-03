//
//  Copyright © 2020 dahua. All rights reserved.
//

#import "LCLivePreviewPresenter.h"
#import "LCVideoHistoryView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCLivePreviewPresenter (VideotapeList)

/// <#注释#>
@property (strong, nonatomic) LCVideoHistoryView *historyView;

/**
 加载云录像
 */
-(void)loadCloudVideotape;

/**
 加载本地录像
 */
-(void)loadLocalVideotape;

@end

NS_ASSUME_NONNULL_END
