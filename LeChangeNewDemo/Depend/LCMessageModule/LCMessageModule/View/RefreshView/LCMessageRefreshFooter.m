//
//  Copyright © 2015 Imou. All rights reserved.
//

#import "LCMessageRefreshFooter.h"
#import "LCMessageActivityIndicatorView.h"
#import "NSString+MessageModule.h"

#define SCREEN_WIDTH        [[UIScreen mainScreen] bounds].size.width

@interface LCMessageRefreshFooter ()

{
    LCMessageActivityIndicatorView *actionView;
}

@end

@implementation LCMessageRefreshFooter

#pragma makr - 重写父类的方法

- (void)prepare
{
    [super prepare];
    
    self.pullString = @"mobile_common_release_to_load".lcMessage_T;
    self.noMoreDataString = @"footer_no_more_data".lcMessage_T;
    self.refreshString = @"footer_refresh".lcMessage_T;
    
    actionView = [[LCMessageActivityIndicatorView alloc]init];
    actionView.frame = CGRectMake((SCREEN_WIDTH / 2 - 100), (self.frame.size.height - 22) / 2, 22, 22);
    [self addSubview:actionView];
    [self setTitle:self.pullString forState:MJRefreshStateIdle];
    [self setTitle:self.pullString forState:MJRefreshStatePulling];
    [self setTitle:self.refreshString forState:MJRefreshStateRefreshing];
    [self setTitle:self.noMoreDataString forState:MJRefreshStateNoMoreData];
}

- (void)placeSubviews
{
    [super placeSubviews];
    actionView.frame = CGRectMake((SCREEN_WIDTH / 2 - 100), (self.frame.size.height - 22) / 2, 22, 22);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    CGFloat angle = M_PI * self.scrollView.contentOffset.y / MJRefreshFooterHeight ;
    actionView.rotationView.transform = CGAffineTransformMakeRotation(angle);
    actionView.backgroundView.transform = CGAffineTransformMakeRotation(-angle);
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
}

#pragma mark 监听控件的加载状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;

    switch (state) {
        case MJRefreshStateIdle:
            [actionView stopAnimating];
            break;
        case MJRefreshStatePulling:
            break;
        case MJRefreshStateNoMoreData:
            break;
        case MJRefreshStateRefreshing:
            [actionView startAnimating];
            break;
        default:
            break;
            
    }
    
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
}

@end
