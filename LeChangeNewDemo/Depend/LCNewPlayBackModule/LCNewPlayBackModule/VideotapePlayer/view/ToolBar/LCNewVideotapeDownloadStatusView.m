//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCNewVideotapeDownloadStatusView.h"
#import <LCBaseModule/LCButton.h>
#import <LCMediaBaseModule/LCMediaBaseDefine.h>
#import <LCMediaBaseModule/UIColor+MediaBaseModule.h>
#import <LCBaseModule/UIFont+Imou.h>
#import <LCMediaBaseModule/NSString+MediaBaseModule.h>
#import <Masonry/Masonry.h>
//#import "LCUIKit.h"

@interface LCNewVideotapeDownloadStatusView ()

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

/// xiaImage
@property (strong, nonatomic) UIImageView *xiaImage;


@end

@implementation LCNewVideotapeDownloadStatusView

+ (instancetype)showDownloadStatusInView:(UIView *)view Size:(NSInteger)size {
    LCNewVideotapeDownloadStatusView *statusView = [LCNewVideotapeDownloadStatusView new];
    statusView.size = size;
    [view addSubview:statusView];
    [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(view);
        make.bottom.mas_equalTo(view);
        make.height.mas_equalTo(114);
    }];
    return statusView;
}

- (void)setSize:(NSInteger)size {
    _size = size;
    [self setView];
}

- (void)setView {
    weakSelf(self);
    
    self.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    self.lab = [UILabel new];
    self.lab.text = @"mobile_common_data_downloading1".lcMedia_T;
    [self addSubview:_lab];
    _lab.font = [UIFont fontWithName:@"pingFang SC" size:16.0f];
    _lab.textColor = [UIColor colorWithRed:44.0/255.0 green:44.0/255.0 blue:44.0/255.0 alpha:1.0];
    [_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(49);
        make.bottom.mas_equalTo(-71);
    }];
    
    self.xiaImage = [UIImageView new];
    [self.xiaImage setImage:LC_IMAGENAMED(@"icon_bofang")];
    [self addSubview:self.xiaImage];
    [self.xiaImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(14);
        make.bottom.mas_equalTo(-74);
    }];
    
    self.closeBtn = [LCButton createButtonWithType:LCButtonTypeCustom];
    [self.closeBtn setImage:LC_IMAGENAMED(@"icon_quxiao") forState:UIControlStateNormal];
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakself.mas_right).offset(-20);
        make.bottom.mas_equalTo(weakself.mas_bottom).offset(-67);
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
    _processView.layer.masksToBounds = true;
    _processView.layer.cornerRadius = 3;
    [self addSubview:self.processView];
    [self.processView setProgressTintColor:[UIColor colorWithRed:241.0/255.0 green:141.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [self.processView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(25);
        make.top.mas_equalTo(weakself.lab.mas_bottom).offset(12);
        make.right.mas_equalTo(weakself.closeBtn.mas_left);
        make.height.mas_equalTo(8);
    }];
    
    self.statusLab = [UILabel new];
    self.statusLab.text =[NSString stringWithFormat:@"mobile_common_data_downloading".lcMedia_T, self.totalRevieve / (1024.0 * 1024.0), self.size / (1024.0 * 1024.0)];
    _statusLab.font = [UIFont fontWithName:@"pingFang SC" size:11.0f];
    _statusLab.textColor = [UIColor colorWithRed:194.0/255.0 green:194.0/255.0 blue:194.0/255.0 alpha:1.0];
    [self addSubview:_statusLab];
    [_statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakself.processView);
        make.bottom.mas_equalTo(-30);
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
    if (recieve == 0) {
        return;
    }
    self.totalRevieve = recieve;
    
//    if (self.totalRevieve >= self.size) {
//        self.totalRevieve = self.size;
//    }
}

- (void)changeValue {
    self.statusLab.text =[NSString stringWithFormat:@"mobile_common_data_downloading".lcMedia_T, self.totalRevieve / (1024.0 * 1024.0), self.size / (1024.0 * 1024.0)];
    
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
