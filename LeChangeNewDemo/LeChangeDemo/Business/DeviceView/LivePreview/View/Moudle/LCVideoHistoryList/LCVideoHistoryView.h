//
//  Copyright © 2020 dahua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LCVideoHistoryViewDatasourceChange)(NSInteger datatType);//切换源回调

typedef void(^LCVideoHistoryViewClickBlock)(id userInfo,NSInteger index);//点击视频,index为当前点击类型 0为点击云录像1为点击全部录像

@interface LCVideoHistoryView : UIView

///录像列表切换
@property (copy,nonatomic)LCVideoHistoryViewDatasourceChange dataSourceChange;

///录像点击
@property (copy,nonatomic)LCVideoHistoryViewClickBlock historyClickBlock;

/// 当前是否云录像
@property (nonatomic) BOOL isCurrentCloud;


/**
 刷新数据

 @param dataArys 数据数组
 */
-(void)reloadData:(NSMutableArray *)dataArys;

-(void)setupErrorView:(UIView *)errorView;

-(void)startAnimation;

-(void)stopAnimation;


@end

NS_ASSUME_NONNULL_END
