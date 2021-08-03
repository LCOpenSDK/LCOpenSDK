//
//  Copyright © 2020 dahua. All rights reserved.
//

#import "LCVideotapeDownloadStatusView.h"
#import "LCUIKit.h"

@interface LCVideotapeDownloadStatusView ()

/// 计时器
@property (strong, nonatomic) NSTimer * timer;

/// TitleLab
@property (strong, nonatomic) UILabel *lab;

/// statusLab
@property (strong, nonatomic) UILabel *statusLab;

/// Process
@property (strong, nonatomic) UIProgressView *processView;

/// CloseBtn
@property (strong, nonatomic) LCButton *closeBtn;

@end

@implementation LCVideotapeDownloadStatusView

+ (instancetype)showDownloadStatusInView:(UIView *)view Size:(NSInteger)size {
    LCVideotapeDownloadStatusView *statusView = [LCVideotapeDownloadStatusView new];
    statusView.size = size;
    [view addSubview:statusView];
    [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(view);
        make.bottom.mas_equalTo(view);
        make.height.mas_equalTo(kIs_iPhoneX ? 87 : 57);
    }];
    return statusView;
}

- (void)setSize:(NSInteger)size {
    _size = size;
    [self setView];
}

- (void)setView {
    weakSelf(self);
    self.backgroundColor = [UIColor dhcolor_c61];
    self.lab = [UILabel new];
    self.lab.text = [NSString stringWithFormat:@"mobile_common_data_downloading".lc_T, self.totalRevieve / (1024.0 * 1024.0), self.size / (1024.0 * 1024.0)];
    [self addSubview:_lab];
    _lab.font = [UIFont lcFont_t6];
    _lab.textColor = [UIColor dhcolor_c43];
    [_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
    }];

    self.closeBtn = [LCButton lcButtonWithType:LCButtonTypeCustom];
    [self.closeBtn setImage:LC_IMAGENAMED(@"videotape_icon_download_close") forState:UIControlStateNormal];
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakself.mas_right).offset(-12);
        make.top.mas_equalTo(weakself.mas_top).offset(15);
    }];
    self.closeBtn.touchUpInsideblock = ^(LCButton *_Nonnull btn) {
        if (weakself.cancleBlock) {
            [weakself dismiss];
            weakself.recieve = 0;
            weakself.totalRevieve = 0;
            weakself.cancleBlock();
        }
        [weakself dismiss];
    };

    self.processView = [UIProgressView new];
    [self addSubview:self.processView];
    [self.processView setProgressTintColor:[UIColor dhcolor_c43]];
    [self.processView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakself.lab.mas_left);
        make.top.mas_equalTo(weakself.lab.mas_bottom).offset(15);
        make.right.mas_equalTo(weakself.closeBtn.mas_left).offset(-15);
    }];
    
    if (nil == _timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                  target:self
                                                selector:@selector(changeValue)
                                                userInfo:nil
                                                 repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)setRecieve:(NSInteger)recieve {
    _recieve = recieve;
//    if (recieve == 0) {
//        self.totalRevieve = 0;
//    }
    if (recieve == 0) {
        return;
    }
    self.totalRevieve += recieve;
    
    if (self.totalRevieve >= self.size) {
        self.totalRevieve = self.size;
    }
}

- (void)changeValue {
    self.lab.text = [NSString stringWithFormat:@"mobile_common_data_downloading".lc_T, self.totalRevieve / (1024.0*1024.0), self.size / (1024.0*1024.0)];
    
    self.closeBtn.enabled = self.totalRevieve >= self.size ? NO : YES;
    weakSelf(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.totalRevieve == self.recieve) {
            [weakself.processView setProgress:weakself.totalRevieve * 1.000 / self.size * 1.000 animated:NO];
        } else {
            [weakself.processView setProgress:weakself.totalRevieve * 1.000 / self.size * 1.000 animated:YES];
        }
    });
}

- (void)dismiss {
    self.alpha = 0;
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

@end
