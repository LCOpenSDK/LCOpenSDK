//
//  Copyright © 2019 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LCBaseModule/LCButton.h>


typedef enum : NSUInteger {
    LCNAVIGATION_STYLE_DEFAULT,//默认，黑字，黑返回按钮
    LCNAVIGATION_STYLE_DEFAULT_BLACK,//默认，黑字，黑返回按钮
    LCNAVIGATION_STYLE_CLEARWITHLINE,//navi 隐藏navibar
    LCNAVIGATION_STYLE_LIGHT,//闪光灯
    LCNAVIGATION_STYLE_DEVICELIST,//设备列表
    LCNAVIGATION_STYLE_LIVE,//直播预览
    LCNAVIGATION_STYLE_LIVE_BLACK,//直播预览
    LCNAVIGATION_STYLE_SUBMIT//提交
} LCNAVIGATION_STYLE;

typedef void(^NavigationBtnClickBlock)(NSInteger index);

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (LCNavigationBar)


/**
 创建导航栏

 @param style 导航栏类型
 @param block 按钮点击回调事件
 */
- (void)lcCreatNavigationBarWith:(LCNAVIGATION_STYLE)style buttonClickBlock:(nullable NavigationBtnClickBlock)block;

/**
 获取右侧按钮

 @return 右侧按钮
 */
- (LCButton *)lc_getRightBtn;

@end

NS_ASSUME_NONNULL_END
