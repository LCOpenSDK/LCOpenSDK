//
//  Copyright © 2016年 dahua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCAddBoxGudieView : UIView

@property (nonatomic,readonly,strong) UIButton *checkButton;

/**
 *  初始化添加盒子引导页
 *
 *  @param frame         盒子引导页视图
 *  @param clickBtnblock 盒子引导页确定按钮单击后回调block
 */
-(instancetype)initWithFrame:(CGRect)frame withClickButton:(void(^)(BOOL isShowAgain))clickBtnblock;

@end
