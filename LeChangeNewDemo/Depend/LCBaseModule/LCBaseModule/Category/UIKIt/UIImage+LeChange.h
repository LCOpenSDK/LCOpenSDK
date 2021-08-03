//
//  Copyright © 2015年 Anson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>
#import <Availability.h>

@interface UIImage (LeChange)

//图片宽度
@property(nonatomic, assign, readonly) CGFloat width;

//图片高度
@property(nonatomic, assign, readonly) CGFloat height;

/*!
 *  @author peng_kongan, 15-12-10 14:12:02
 *
 *  @brief  毛玻璃效果
 *
 *  @param blur 效果级别  最小为0 最大为1
 *
 *  @return 毛玻璃化后的图片
 */
- (UIImage *)lc_imageWithBlurLevel:(CGFloat)blur;

/*!
 *  @author peng_kongan, 16-01-15 09:01:30
 *
 *  @brief  将图片存到本地
 *
 *  @param aPath 本地路径
 *
 *  @return 操作结果
 */
- (BOOL)lc_writeToFileAtPath:(NSString*)aPath;

/*!
 *  @author peng_kongan, 15-12-12 13:12:00
 *
 *  @brief  获取屏幕截图
 *
 *  @return 屏幕截图
 */
+ (UIImage *)lc_imageWithScreenContents;



/*!
 *  @author peng_kongan, 15-12-12 13:12:11
 *
 *  @brief  根据颜色创建图片
 *
 *  @param color 颜色
 *
 *  @return UIImage
 */
+ (UIImage *)lc_createImageWithColor:(UIColor *)color;

/*!
 *  @author peng_kongan, 15-12-12 13:12:21
 *
 *  @brief  获取图片模块区域的图
 *
 *  @param rect 区域
 *
 *  @return 截取后的图片
 */
-(UIImage *)lc_imageAtRect:(CGRect)rect;

/*!
 *  @author peng_kongan, 15-12-12 13:12:08
 *
 *  @brief  //成比例的缩小图片
 *
 *  @param targetSize <#targetSize description#>
 *
 *  @return <#return value description#>
 */
- (UIImage *)lc_imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;

/*!
 *  @author peng_kongan, 15-12-12 13:12:30
 *
 *  @brief  //成比例的缩放图片
 *
 *  @param targetSize <#targetSize description#>
 *
 *  @return <#return value description#>
 */
- (UIImage *)lc_imageByScalingProportionallyToSize:(CGSize)targetSize;

/*!
 *  @author peng_kongan, 15-12-12 13:12:15
 *
 *  @brief  拉伸图片到指定大小
 *
 *  @param targetSize <#targetSize description#>
 *
 *  @return <#return value description#>
 */
- (UIImage *)lc_imageByScalingToSize:(CGSize)targetSize;

/*!
 *  @author peng_kongan, 15-12-12 13:12:26
 *
 *  @brief  按弧度旋转
 *
 *  @param radians <#radians description#>
 *
 *  @return <#return value description#>
 */
- (UIImage *)lc_imageRotatedByRadians:(CGFloat)radians;

/*!
 *  @author peng_kongan, 15-12-12 13:12:35
 *
 *  @brief  按角度旋转
 *
 *  @param degrees <#degrees description#>
 *
 *  @return <#return value description#>
 */
- (UIImage *)lc_imageRotatedByDegrees:(CGFloat)degrees;  //按角都旋转

/*!
 *  @author peng_kongan, 15-12-12 13:12:50
 *
 *  @brief  根据宽度 按比例缩放图片
 *
 *  @param newWidth 心的宽度
 *
 *  @return <#return value description#>
 */
- (UIImage *)lc_keepScaleWithWidth:(float) newWidth;     //根据宽度 按比例缩放图片

/*!
 *  @author peng_kongan, 15-12-12 13:12:07
 *
 *  @brief  无损拉伸  适用于IOS5.0以上
 *
 *  @param top    上边距
 *  @param left   左边距
 *  @param bottom 下边距
 *  @param right  右边距
 *
 *  @return 拉伸后的图
 */
- (UIImage *)lc_scaleWithOutDamageInTop:(CGFloat)top     //无损拉伸  试用于ios5.0
                                left:(CGFloat)left
                              bottom:(CGFloat)bottom
                               right:(CGFloat)right;

/**
 *  图片缩放
 *
 *  @param scaleSize 缩放比例
 *
 *  @return 缩放后图片
 */
- (UIImage *)lc_chnageToScale:(float)scaleSize;

/**
 *  中心区域裁剪成方形图片
 *
 *  @param size 目标尺寸，不自动进行放大，实际可能比size要小
 *
 *  @return 裁剪后的图片
 */
- (UIImage *)lc_centerClipBySize:(CGFloat)size;

/**
 *  中心区域裁剪成方形图片
 *
 *  @param size 目标尺寸，不自动进行放大，实际可能比size要小
 *
 *  @return 裁剪后的图片
 */
- (UIImage *)lc_centerScaleToSize:(CGSize)size;

/**
 *  裁剪中心区域固定比例的最大图片
 *
 *  @param rate 裁剪图片比例,比例大于1
 *
 *  @return 裁剪后的图片
 */
- (UIImage *)lc_cutWithWideRate:(CGFloat)rate;

/**
 拉伸图片到指定大小

 @param size 制定大小
 @return 新图片
 */
- (UIImage *)lc_imageScalingWithSize:(CGSize)size;

- (UIImage *)lc_imageWithColor:(UIColor *)color;

/**
 *  压缩图片到指定文件大小
 *
 *  @param size  目标大小（最大值）
 *
 *  @return 返回的图片文件
 */
- (NSData *)compressToMaxDataSizeKBytes:(CGFloat)size;

@end
