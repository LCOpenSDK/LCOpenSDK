//
//  Copyright © 2020 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^LCDeviceSettingArrowCellClickBlock)(NSInteger index);

@interface LCDeviceSettingArrowCell : UITableViewCell
/// title
/// 标题
@property (strong, nonatomic) NSString *title;

/// subtitle
/// 子标题
@property (strong, nonatomic) NSString *subtitle;

@property (nonatomic, assign) BOOL deviceSnapHidden;

/// block
/// 滑块
@property (copy, nonatomic) LCDeviceSettingArrowCellClickBlock block;

- (void)loadImage:(NSString *)imageUrl DeviceId:(NSString *)deviceId ChannelId:(NSString *)channelId;

- (void)setArrowImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
