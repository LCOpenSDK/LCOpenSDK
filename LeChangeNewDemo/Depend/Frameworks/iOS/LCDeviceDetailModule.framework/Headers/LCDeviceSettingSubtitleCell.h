//
//  Copyright © 2020 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCDeviceSettingSubtitleCellModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *detail;

@end

typedef void (^LCDeviceSettingSubtitleCellClickBlock)(void);

@interface LCDeviceSettingSubtitleCell : UITableViewCell

@property (strong, nonatomic) LCDeviceSettingSubtitleCellModel *model;

/// block
/// 滑块
@property (copy, nonatomic) LCDeviceSettingSubtitleCellClickBlock block;

@end

NS_ASSUME_NONNULL_END
