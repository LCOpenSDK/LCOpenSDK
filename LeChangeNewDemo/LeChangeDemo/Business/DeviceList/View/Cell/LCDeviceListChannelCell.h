//
//  Copyright © 2019 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef void(^LCDeviceListChannelCellClickBlock)(LCDeviceInfo * info,NSInteger channelIndex);

@interface LCDeviceListChannelCell : UICollectionViewCell
/// channel
@property (copy, nonatomic) LCChannelInfo *channelInfo;

/// deviceInfo
@property (copy, nonatomic) LCDeviceInfo *deviceInfo;

/// 当前index
@property (nonatomic) NSUInteger index;

@property (copy, nonatomic) LCDeviceListChannelCellClickBlock resultBlock;

@end

NS_ASSUME_NONNULL_END
