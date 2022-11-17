//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "LCNewPTZControlView.h"
#import <Masonry/Masonry.h>

@interface LCNewPTZControlView ()

/// 控制面板
@property (strong, nonatomic) UIView *handleArea;

/// 操作杆
@property (strong, nonatomic) UIView *dragView;

/// 关闭按钮
@property (strong, nonatomic) UIButton *closeBtn;

@end

@implementation LCNewPTZControlView

-(instancetype)initWithDirection:(LCNewPTZControlSupportDirection)direction{
    if (self = [super initWithFrame:CGRectZero]) {
        [self setupPTZViewWithDirection:direction];
    }
    return self;
}

///初始化子视图
-(void)setupPTZViewWithDirection:(LCNewPTZControlSupportDirection)direction{
    
//    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self addSubview:self.closeBtn];
//    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self).offset(15);
//        make.right.mas_equalTo(self).offset(-15);
//        make.height.width.mas_equalTo(50);
//    }];
//    self.closeBtn
    _panel = [[LCNewPTZPanel alloc] initWithFrame:CGRectMake(0, 0, 100, 100) style:direction==LCNewPTZControlSupportFour?LCNewPTZPanelStyle4Direction:LCNewPTZPanelStyle8Direction];
    [self addSubview:_panel];
    __weak typeof(self) weakself = self;
    [_panel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(weakself).multipliedBy(0.4);
        make.width.mas_equalTo(weakself.panel.mas_height);
        make.top.mas_equalTo(weakself).offset(120);
        make.centerX.mas_equalTo(weakself.mas_centerX);
    }];
   
}

-(void)layoutSubviews{
    [super layoutSubviews];
    ///对按钮进行圆角处理
}

///关闭按钮点击回调
-(void)closeBtnClicked:(UIButton *)close{
    if (self.close) {
        self.close();
    }
}

@end
