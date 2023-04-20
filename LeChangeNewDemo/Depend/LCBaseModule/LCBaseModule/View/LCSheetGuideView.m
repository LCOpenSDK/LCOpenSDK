//
//  LCSheetGuideView.m
//  LCBaseModule
//
//  Created by yyg on 2023/3/6.
//  Copyright © 2023 jm. All rights reserved.
//

#import "LCSheetGuideView.h"
#import <QuartzCore/CALayer.h>
#import "UIDevice+IPhoneModel.h"
#import "NSString+LeChange.h"
#import <Masonry/Masonry.h>
#import "UILabel+LeChange.h"

#define SHEET_VIEW_PADDING   12.5
#define SHEET_CONTENT_PADDING    25.0
#define SHEET_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SHEET_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SHEET_CONTENT_WIDTH (SHEET_SCREEN_WIDTH - SHEET_VIEW_PADDING*2 - SHEET_CONTENT_PADDING*2)
#define SHEET_MAX_HEIGHT (SHEET_SCREEN_HEIGHT*0.8)
#define SHEET_BOTTOM_SAFE_HEIGHT 34

@interface LCSheetGuideView () {
    UIView *_contentView;   //显示的视图
    LCButton *_cancleBtn;
    NSString *_title;
    NSString *_msg;
    NSString *_cancelTitle;
    UIImage *_image;
    UIImageView *_topImageView;
}

@property (strong, nonatomic)UILabel *titleLbl;
@property (strong, nonatomic)UILabel *msgLbl;

@end

@implementation LCSheetGuideView

- (void)dealloc {
    NSLog(@"-----LCSheetGuideView delloc!");
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message image:(UIImage*)image cancelButtonTitle:(NSString *)cancelButtonTitle {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _title = title;
        _msg = message;
        _image = image;
        _cancelTitle = cancelButtonTitle;
        [self setUpView];
    }
    return self;
}

- (void)setUpView {
    CGFloat contentWidth = SHEET_SCREEN_WIDTH - 2 * SHEET_VIEW_PADDING;
    CGFloat labelWidth = contentWidth - 2 * SHEET_CONTENT_PADDING;
    if(_contentView == nil) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(SHEET_VIEW_PADDING, SHEET_SCREEN_HEIGHT, contentWidth, [self calculationSheetHeight])];
        _contentView.layer.cornerRadius = 15.0;
        _contentView.layer.masksToBounds = YES;
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        
        //图片
        _topImageView = [[UIImageView alloc] initWithImage:_image];
        _topImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        //标题
        _titleLbl = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLbl.text = _title;
        _titleLbl.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLbl.numberOfLines = 2;
        _titleLbl.lc_left = SHEET_CONTENT_PADDING;
        _titleLbl.font = [UIFont boldSystemFontOfSize:20];
        _titleLbl.textColor = [UIColor colorWithRed:0x2c/255.0 green:0x2c/255.0 blue:0x2c/255.0 alpha:1.0];
        _titleLbl.lc_width = labelWidth;
    
        //消息体
        _msgLbl = [[UILabel alloc]initWithFrame:CGRectZero];
        _msgLbl.lineBreakMode = NSLineBreakByWordWrapping;
        _msgLbl.numberOfLines = 0;
        _msgLbl.font = [UIFont systemFontOfSize:16];
        _msgLbl.textColor = [UIColor colorWithRed:0x2c/255.0 green:0x2c/255.0 blue:0x2c/255.0 alpha:1.0];
//        _msgLbl.text = _msg;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_msg attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        //行间距
        [paragraphStyle setLineSpacing:8];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
        _msgLbl.attributedText = attributedString;
        
        _cancleBtn = [LCButton createButtonWithType:LCButtonTypePrimary];
        _cancleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _cancleBtn.layer.cornerRadius = 22.5;
        _cancleBtn.layer.masksToBounds = YES;
        [_cancleBtn addTarget:self action:@selector(cancleBtnCliked:) forControlEvents:UIControlEventTouchUpInside];
        [_cancleBtn setTitle:_cancelTitle forState:UIControlStateNormal];

        [_contentView addSubview:_topImageView];
        [_contentView addSubview:_titleLbl];
        [_contentView addSubview:_msgLbl];
        [_contentView addSubview:_cancleBtn];
        [self addSubview:_contentView];
        
        if (_image != nil) {
            CGFloat height = ((_contentView.frame.size.width - 25 * 2) / _image.size.width) * _image.size.height;
            [_topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(25);
                make.leading.equalTo(_contentView).offset(25);
                make.trailing.equalTo(_contentView).offset(-25);
                make.height.mas_equalTo(height);
            }];
        } else {
            [_topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.leading.equalTo(_contentView).offset(25);
                make.trailing.equalTo(_contentView).offset(-25);
                make.height.mas_equalTo(0);
            }];
        }
        
        [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topImageView.mas_bottom).offset(20);
            make.leading.equalTo(_contentView).offset(25);
            make.trailing.equalTo(_contentView).offset(-25);
        }];
        
        [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_contentView).offset(25);
            make.trailing.equalTo(_contentView).offset(-25);
            make.bottom.equalTo(_contentView).offset(-35);
            make.height.mas_equalTo(45);
        }];
        
        [_msgLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_contentView).offset(25);
            make.trailing.equalTo(_contentView).offset(-25);
            make.bottom.equalTo(_cancleBtn.mas_top).offset(-35);
            make.top.equalTo(_titleLbl.mas_bottom).offset(20);
        }];
    }
}

- (CGFloat)calculationSheetHeight {
    CGFloat imageHeight = _image != nil ? 226+20 : 0;
    CGSize titleSize = [_title lc_sizeWithFont:[UIFont systemFontOfSize:20] size:CGSizeMake(SHEET_CONTENT_WIDTH, 40)];
    CGFloat descMaxHeight = SHEET_MAX_HEIGHT - (25 + imageHeight + titleSize.height + 20 + 35 + 45 + 35);
    CGFloat descHeight = [UILabel lc_heightOfAttributedText:_msg textSize:16 lineSpace:8 width:SHEET_CONTENT_WIDTH];
//    CGSize descSize = [_msg lc_sizeWithFont:[UIFont systemFontOfSize:16] size:CGSizeMake(SHEET_CONTENT_WIDTH, descMaxHeight)];
    CGFloat height = 25 + imageHeight + titleSize.height + 20 + (descHeight > descMaxHeight ? descHeight : descHeight) + 35 + 45 + 35;
    
    return height;
}

- (void)show {
    UIView *pView;
    if([UIApplication sharedApplication].keyWindow == nil || [UIApplication sharedApplication].keyWindow.hidden) {
        NSLog(@"MMSheetView-show-keyWindow nil or hidden");
        int maxState = -1;
        UIWindow* keyWind = nil;
        for (UIWindow* wind in [UIApplication sharedApplication].windows ) {
            if (wind.hidden == NO) {
                if (wind.windowLevel > maxState) {
                    keyWind = wind;
                    maxState = wind.windowLevel;
                }
            }
        }
        pView = keyWind;
        //一般不会进这个地方
        if (pView == nil)
        {
            pView = [[UIApplication sharedApplication].windows lastObject];
        }
    } else {
        pView = [UIApplication sharedApplication].delegate.window;
    }
    
    [self showAtView:pView];
    
}

- (void)showAtView:(UIView *)view {
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f =  self->_contentView.frame;
        f.origin.y = self.frame.size.height - self->_contentView.frame.size.height;
        
        //iPhoneX 底部向上偏移32
        if ([UIDevice lc_isIphoneX] && [view isKindOfClass:[UIWindow class]]) {
            f.origin.y -= SHEET_BOTTOM_SAFE_HEIGHT;
        }
        
        self->_contentView.frame = f;
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    } completion:^(BOOL finished){ } ];
}

- (void)dismiss {
    dispatch_async(dispatch_get_main_queue(), ^ {
                       if (self.cancleBlock) {
                           self.cancleBlock();
                       }
                       
                       [UIView animateWithDuration:0.3 animations:^ {
                            CGRect f =  self->_contentView.frame;
                            f.origin.y = self.frame.size.height;
                           self->_contentView.frame = f;
                            [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0]];
                        } completion:^(BOOL finished) {
                            [self removeFromSuperview];
                            
                        }];
                   });
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //防止标题等非UIControl点击消失
    CGPoint location = [[touches anyObject] locationInView:_contentView];
    if (CGRectContainsPoint(_contentView.bounds, location)) {
        return;
    }
    [self dismiss];
}

- (void)cancleBtnCliked:(id)sender {
    [self dismiss];
    if (self.cancleBlock) {
        self.cancleBlock();
    }
}

@end

