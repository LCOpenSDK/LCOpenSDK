//
//  HistoryVideoListView.m
//  LeChangeDemo
//
//  Created by 梁明哲 on 2024/6/18.
//  Copyright © 2024 dahua. All rights reserved.
//
@protocol HistoryVideoListViewProtocol <NSObject>

- (void)dataSourceChange:(int)index;

- (void)selectVideoItem:(id _Nonnull )item;
@end

#import "HistoryVideoListView.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HistoryVideoListViewDatasourceChange)(NSInteger datatType);//切换源回调

typedef void(^HistoryVideoListViewClickBlock)(id userInfo,NSInteger index);//点击视频,index为当前点击类型 0为点击云录像1为点击全部录像

@interface HistoryVideoListView : UIView

///录像列表切换
@property (copy,nonatomic)HistoryVideoListViewDatasourceChange dataSourceChange;

///录像点击
@property (copy,nonatomic)HistoryVideoListViewClickBlock historyClickBlock;

/// 当前是否云录像
@property (nonatomic) BOOL isCurrentCloud;


@property (weak, nonatomic) id <HistoryVideoListViewProtocol> delegate;
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
