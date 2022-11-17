//
//  Copyright © 2019 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^selectBlock)(NSUInteger index);

@interface LCSegmentController : UIView

/// 选项
@property (strong, nonatomic ,readonly) NSArray <NSString *> *items;


/// 回调准备开始
@property (copy, nonatomic) dispatch_block_t valueWillChageBlock;


/**
 创建切换控制器

 @param items 选项数组
 @param selected 选择后回调
 @return 实例
 */
+(instancetype)segmentWithItems:(nonnull NSArray <NSString *> *)items SelectedBlock:(selectBlock)selected;

/**
 创建切换控制器
 @param frame 尺寸
 @param items 选项数组
 @param selected 选择后回调
 @return 实例
 */
+(instancetype)segmentWithFrame:(CGRect)frame DefaultSelect:(NSInteger)select Items:(NSArray<NSString *> *)items SelectedBlock:(selectBlock)selected;

/**
 设置选中index

 @param index 选中的索引
 */
-(void)setSelectIndex:(NSInteger)index;

/// enable
@property (nonatomic) BOOL enable;


@end

NS_ASSUME_NONNULL_END
