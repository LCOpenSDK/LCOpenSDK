//
//  Copyright © 2019 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCUIKit.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LCDeviceListCellClickBlock)(LCDeviceInfo * info,NSInteger channelIndex,NSInteger index);

@interface LCDeviceListCell : UITableViewCell

/// 设备信息模型
@property (copy, nonatomic) LCDeviceInfo *deviceInfo;

@property (copy, nonatomic) LCDeviceListCellClickBlock resultBlock;

@end

NS_ASSUME_NONNULL_END
