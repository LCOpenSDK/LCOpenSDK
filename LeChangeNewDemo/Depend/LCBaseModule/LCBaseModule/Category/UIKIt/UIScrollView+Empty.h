//
//  Copyright © 2016年 Anson. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 *  @author peng_kongan, 16-02-19 13:02:21
 *
 *  @brief 主要用于UITableView和UICollectionView无数据时的提示信息加载  使用KVO机制监听contentSize实现
 *         注意:在controller中如果设置了提示信息   那么在dealloc中必须调用lc_clearEmptyViewInfo 否则controller释放时会崩溃
 *             使用此类别的Controller 请不要在外部对contentSzie进行KVO监测 容易造成问题
 */
@interface UIScrollView (Empty)

/*!
 *  @author peng_kongan, 16-02-19 13:02:12
 *
 *  @brief 默认的提示图片  放在正中央
 */
@property (strong, nonatomic)UIImage *lc_emptyImage;

/*!
 *  @author peng_kongan, 16-02-19 13:02:22
 *
 *  @brief 自定义的提示控件
 */
@property (strong, nonatomic)UIView *lc_emptyView;

/*!
 *  @author peng_kongan, 16-02-19 13:02:44
 *
 *  @brief 清除KVO监听
 */

- (void)lc_clearEmptyViewInfo; 

@end
