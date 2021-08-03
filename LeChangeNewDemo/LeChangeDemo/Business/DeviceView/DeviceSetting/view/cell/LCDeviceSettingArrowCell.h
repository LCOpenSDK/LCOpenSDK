//
//  Copyright © 2020 dahua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^LCDeviceSettingArrowCellClickBlock)(NSInteger index);

@interface LCDeviceSettingArrowCell : UITableViewCell
/// title
@property (strong, nonatomic) NSString *title;

/// subtitle
@property (strong, nonatomic) NSString *subtitle;

/// block
@property (copy, nonatomic) LCDeviceSettingArrowCellClickBlock block;

- (void)loadImage:(NSString *)imageUrl DeviceId:(NSString *)deviceId ChannelId:(NSString *)channelId;

- (void)setArrowImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
