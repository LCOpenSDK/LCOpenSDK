//
//  Copyright © 2015年 Imou. All rights reserved.
//

#import "LCMediaRefreshHeader.h"
#import "LCMediaActivityIndicatorView.h"
#import <LCMediaBaseModule/NSString+MediaBaseModule.h>

@interface LCMediaRefreshHeader ()
{
    LCMediaActivityIndicatorView *actionView;
    UILabel *statelabel;
}
@end

@implementation LCMediaRefreshHeader
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    

    self.pullString = @"mobile_common_pull_down_to_refresh".lcMedia_T;
    self.releaseString = @"mobile_common_data_loading".lcMedia_T;
    self.refreshString = @"mobile_common_data_loading".lcMedia_T;
	
	statelabel = [[UILabel alloc]initWithFrame:CGRectZero];
	statelabel.font = MJRefreshLabelFont;
	statelabel.textColor = MJRefreshLabelTextColor;
	statelabel.textAlignment = NSTextAlignmentCenter;
	statelabel.backgroundColor = [UIColor clearColor];
	[statelabel setNumberOfLines:0];
    
    actionView = [[LCMediaActivityIndicatorView alloc]init];
    [self addSubview:statelabel];
    [self addSubview:actionView];
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];

	statelabel.frame = CGRectMake(0,0, self.frame.size.width , self.frame.size.height);
	statelabel.hidden = _hideTips;
	
	if (_hideTips) {
		actionView.frame = CGRectMake((self.frame.size.width - 22) / 2 , (self.frame.size.height - 22) / 2, 22, 22);
	} else {
		actionView.frame = CGRectMake(self.frame.size.width / 2 - 100, (self.frame.size.height - 22) / 2, 22, 22);
	}
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    CGFloat angle = M_PI * self.scrollView.contentOffset.y / MJRefreshHeaderHeight ;
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


#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
             [actionView stopAnimating];
            statelabel.text = self.pullString;
            break;
        case MJRefreshStatePulling:
            
            statelabel.text = self.releaseString;
            break;
        case MJRefreshStateRefreshing:
            statelabel.text = self.refreshString;
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
