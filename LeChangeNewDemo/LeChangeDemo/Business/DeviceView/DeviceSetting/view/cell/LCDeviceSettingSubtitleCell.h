//
//  Copyright © 2020 dahua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^LCDeviceSettingSubtitleCellClickBlock)(void);

@interface LCDeviceSettingSubtitleCell : UITableViewCell

/// title
@property (strong, nonatomic) NSString *title;

/// subtitle
@property (strong, nonatomic) NSString *subtitle;

/// detail
@property (strong, nonatomic) NSString *detail;

/// block
@property (copy, nonatomic) LCDeviceSettingSubtitleCellClickBlock block;

@end

NS_ASSUME_NONNULL_END
