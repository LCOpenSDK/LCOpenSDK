//
//  Copyright (c) 2015年 Imou. All rights reserved.
//  Modified by jiangbin on 2017/9/7

#import <UIKit/UIKit.h>

@interface UIView (LeChange)

@property (nonatomic) CGFloat lc_width;
@property (nonatomic) CGFloat lc_height;
@property (nonatomic) CGFloat lc_x;
@property (nonatomic) CGFloat lc_y;

@property (nonatomic) CGFloat lc_top;
@property (nonatomic) CGFloat lc_right;
@property (nonatomic) CGFloat lc_bottom;
@property (nonatomic) CGFloat lc_left;

@property (nonatomic) CGSize lc_size;

@property (nonatomic) CGFloat lc_centerX;
@property (nonatomic) CGFloat lc_centerY;

@property (nonatomic) CGFloat lc_cornerRadius;

/*!
 *  @author peng_kongan, 15-12-11 18:12:25
 *
 *  @brief  移除所有子控件
 */
- (void)lc_removeAllSubview;

/*!
 *  @author peng_kongan, 15-11-26 14:11:52
 *
 *  @brief  设置边框颜色
 *
 *  @param borderWidth 边框宽度
 *  @param borderColor 边框颜色
 */
- (void)lc_setBoraderWith:(CGFloat )borderWidth andColor:(UIColor *)borderColor;

/*!
 *  @author peng_kongan, 15-09-23 11:09:07
 *
 *  @brief  添加一连串的按钮  均匀分布  隐藏的按钮不分布
 *          每个button最好大小都一样
 */
- (void)lc_addIconBtnArray:(NSArray *)btnArray;

/*!
 *  @author peng_kongan, 15-09-29 13:09:51
 *
 *  @brief  将一个View添加到中心
 *
 *  @param view 要添加的view
 */
- (void)lc_addSubviewToCeneter:(UIView *)view;

/**
 *  为UIView添加border
 *
 *  @param width  border的宽度
 *  @param color  border的颜色，默认为浅灰
 *  @param radius 弧度数
 */
- (void)lc_addBorderWidth:(CGFloat)width color:(UIColor*)color radius:(CGFloat)radius;

/**
 *  将界面设置为圆形
 */
- (void)lc_setRound;

/**
 *  设置UIView弧度
 *
 *  @param radius 弧度数
 */
- (void)lc_setRadius:(CGFloat)radius;

/**
 *  加载动画
 *
 *  @param keyPath   动画路径
 *  @param transform 动画
 *  @param duration  持续时间
 *  @param delegate  委托
 */
- (void)lc_animationWithPath:(NSString *)keyPath transform:(CATransform3D)transform duration:(CFTimeInterval)duration delegate:(id)delegate;

/**
 *  抖动动画
 *
 *  @param repeatCount 抖动次数
 */
- (void)lc_shakeViewWithRepeatCount:(NSInteger)repeatCount;

@end
