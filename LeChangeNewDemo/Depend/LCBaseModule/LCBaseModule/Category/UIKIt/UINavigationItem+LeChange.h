//
//  Copyright © 2016年 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>

//把导航栏里面左右两边的按钮都进行sizeToFit
//所以给导航栏添加按钮的时候不用设置frame
//若有特殊的 必须留白的控件 不要用此接口
@interface UINavigationItem (LeChange)

//导航栏左侧item集合
@property (nonatomic)NSArray<UIBarButtonItem *> *lc_leftBarButtonItems;

//导航栏右侧item集合  从右边开始 第一个在最右
@property (nonatomic)NSArray<UIBarButtonItem *> *lc_rightBarButtonItems;

//导航栏左侧button集合
@property (nonatomic)NSArray<UIView *> *lc_leftBarButtons;

//导航栏右侧button集合 从右边开始 第一个在最右
@property (nonatomic)NSArray<UIView *> *lc_rightBarButtons;
@end
