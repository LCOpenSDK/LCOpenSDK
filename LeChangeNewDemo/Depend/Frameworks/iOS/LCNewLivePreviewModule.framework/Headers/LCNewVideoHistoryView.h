//
//  Copyright © 2020 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LCNewVideoHistoryViewDatasourceChange)(NSInteger datatType);//切换源回调

typedef void(^LCNewVideoHistoryViewClickBlock)(id userInfo,NSInteger index);//点击视频,index为当前点击类型 0为点击云录像1为点击全部录像

@interface LCNewVideoHistoryView : UIView

///录像列表切换
@property (copy,nonatomic)LCNewVideoHistoryViewDatasourceChange dataSourceChange;

///录像点击
@property (copy,nonatomic)LCNewVideoHistoryViewClickBlock historyClickBlock;

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
