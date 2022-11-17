//
//  Copyright © 2020 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    LCIMGCirclePlayStyleCircle,//循环播放。例如：1-2-3-1-2-3
    LCIMGCirclePlayStyleOnce,//只循环一次。 例如：1-2-3
    LCIMGCirclePlayStyleNature,//循环播放。例如：1-2-3-2-1
} LCIMGCirclePlayStyle;

@interface UIImageView (Circle)

//图片
@property (nonatomic) NSArray <NSString *> * image;
//定时器
@property (strong, nonatomic) NSTimer * timer;
//当前展示模式
@property (nonatomic) LCIMGCirclePlayStyle style;
//当前播放index
@property (nonatomic) NSUInteger  index;

/// 加载多张图片形成动态图
/// @param images 图片数组
/// @param interval 播放间隔
/// @param style 播放类型
-(void)loadGifImageWith:(NSArray <NSString *>*)images TimeInterval:(NSTimeInterval)interval Style:(LCIMGCirclePlayStyle)style;

/// 停止播放，注销定时器
-(void)releaseImgs;

@end

NS_ASSUME_NONNULL_END
