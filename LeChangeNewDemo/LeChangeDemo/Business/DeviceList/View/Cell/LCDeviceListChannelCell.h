//
//  Copyright © 2019 dahua. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface LCDeviceListChannelCell : UICollectionViewCell
/// channel
@property (copy, nonatomic) LCChannelInfo *channelInfo;

/// deviceInfo
@property (copy, nonatomic) LCDeviceInfo *deviceInfo;

/// 当前index
@property (nonatomic) NSUInteger index;

@end

NS_ASSUME_NONNULL_END
