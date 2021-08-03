//
//  Copyright © 2020 dahua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LCDeviceSwitchCellValueChangeBlock)(BOOL value);

@interface LCDeviceSwitchCell : UITableViewCell

/**
 操作结果返回
 */
@property (copy,nonatomic) LCDeviceSwitchCellValueChangeBlock block;

/**
 title
 */
@property (strong,nonatomic) NSString * title;

/**
 设定开关

 @param switchValue 开关状态
 */
-(void)setSwitch:(BOOL)switchValue;

/**
 设定状态
 
 @param enable 控制状态
 */
-(void)setEnable:(BOOL)enable;




@end

NS_ASSUME_NONNULL_END
