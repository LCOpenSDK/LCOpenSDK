//
//  Copyright © 2020 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LCDeviceSwitchCellValueChangeBlock)(BOOL value);

@interface LCDeviceSwitchCell : UITableViewCell

/**
 操作结果返回
 Operation Result
 */
@property (copy,nonatomic) LCDeviceSwitchCellValueChangeBlock block;

/**
 标题
 title
 */
@property (strong,nonatomic) NSString * title;

/**
 设定开关
 Set the switch
 @param switchValue 开关状态
 */
/**
 Set the switch
 @param switchValue  Set the switch
 */
-(void)setSwitch:(BOOL)switchValue;

/**
 设定状态
 
 @param enable 控制状态
 */
/**
 Set the state
 
 @param enable Control state
 */
-(void)setEnable:(BOOL)enable;




@end

NS_ASSUME_NONNULL_END
