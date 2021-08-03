//
//  Copyright (c) 2015年 Anson. All rights reserved.
//LCSheetView

#import "LCSheetView.h"
#import <QuartzCore/CALayer.h>

//CONTENTVIEW最小高度
#define SHEETVIEW_MIN_HEIGHT 80
#define SHEETVIEW_LINE_HEIGHT 1

#define SHEET_MARGIN_LEFT   0.0
#define SHEET_MARGIN_RIGHT 0.0

#define SHEET_PADDING_TOP  15.0
#define SHEET_PADDING_LABEL_LEFT    20.0
#define SHEET_PADDING_LABEL_RIGHT   20.0
#define SHEET_PADDING_BUTTON_LEFT   0.0
#define SHEET_PADDING_BUTTON_RIGHT  0.0
#define SHEET_PADDING_BOTTOM  0.0
#define SHEET_BUTTON_PADDING_TOP 0

#define SHEET_PADDING_BETWEEN_TITLE_MSG  10.0
#define SHEET_PADDING_BETWEEN_CANCLE_OTHER  10.0

#define SHEET_PADDING_INSERT  0.0

#define SHEET_FONT_TITLE_SIZE 16
#define SHEET_FONT_MESSAGE_SIZE 14
#define SHEET_FONT_TITLE_HEIGHT 40
#define SHEET_FONT_SIZE 15

#define SHEET_HRIGHT 200
#define SHEET_TEXTFILED_HEIGHT 40

#define SHEET_BUTTON_HEIGHT 50

#define SHEET_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SHEET_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define SHEET_MSG_PADDING_BOTTOM 10

/// iPhoneX底部安全区域高度
#define SHEET_BOTTOM_SAFE_HEIGHT 34

@interface UILabel (LCSheetView)
@end
@implementation UILabel (LCSheetView)
- (void)adjustForHeight
{
    if(self.text.length == 0)
    {
        CGRect txtFrame = self.frame;
        txtFrame.size.height = 0.0;
        self.frame = txtFrame;
        return ;
    }
    
    //自动折行设置
    self.lineBreakMode = NSLineBreakByWordWrapping;
    self.numberOfLines = 0;
    
    CGRect txtFrame = self.frame;
    
    self.frame = CGRectMake(txtFrame.origin.x, txtFrame.origin.y, txtFrame.size.width,
                            txtFrame.size.height =[self.text boundingRectWithSize:
                                                   CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)
                                                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                       attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil] context:nil].size.height);
}
@end

@interface NSString(LCSheetView)
- (NSString *)trimNewLine;
@end

@implementation NSString(LCSheetView)

- (NSString *)trimNewLine
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}
@end




//LCButtonContainer 主要用于不传递点击响应链
@interface LCButtonContainer : UIView
@end
@implementation LCButtonContainer

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

@end

@interface LCSheetView ()
{
    UIView *_contentView;   //显示的视图
    
    NSMutableArray *_otherArray;  //其他按钮
    
    NSMutableArray *_btnArray;  //所有按钮
    
    LCButtonContainer *_btnContainer;  //按钮容器
    
    UITextField *_textFiled;    //文本框
    
    UIView *_topBgView;
    
    UIView *_topLine;
    
    UIButton *_cancleBtn;
    
    NSString *_title;
    NSString *_msg;
    NSString *_cancleBtnTitle;
    
    
}
@property (strong, nonatomic)UILabel *titleLbl;
@property (strong, nonatomic)UILabel *msgLbl;

@end

@implementation LCSheetView

- (UILabel *)titleLbl
{
    if (_titleLbl == nil) {
        _titleLbl = [[UILabel alloc]initWithFrame:CGRectZero];
        
    }
    return _titleLbl;
}

- (UILabel *)msgLbl
{
    if (_msgLbl == nil) {
        _msgLbl = [[UILabel alloc]initWithFrame:CGRectZero];
    }
    return _msgLbl;
}


- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<MMSheetViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    
    NSMutableArray *otherButtons = [NSMutableArray new];
    
    va_list params;  //定义一个指向个数可变的参数列表指针；
    id argument;
    if (otherButtonTitles) {
        //使参数列表指针arg_ptr指向函数参数列表中的第一个可选参数，说明：argN是位于第一个可选参数之前的固定参数，（或者说，最后一个 固定参数；…之前的一个参数），函数参数列表中参数在内存中的顺序与函数声明时的顺序是一致的。如果有一va函数的声明是void va_test(char a, char b, char c, …)，则它的固定参数依次是a,b,c，最后一个固定参数argN为c，因此就是va_start(arg_ptr, c)。
        [otherButtons addObject:otherButtonTitles];
        va_start(params, otherButtonTitles);
        while ((argument = va_arg(params, id))) {//返回参数列表中指针arg_ptr所指的参数，返回类型为type，并使指针arg_ptr指向参数列表中下一个参数
            [otherButtons addObject:argument];
        }
        va_end(params);//释放列表指针
    }
    
    return [self initWithTitle:title message:message delegate:delegate cancelButton:cancelButtonTitle otherButtons:otherButtons];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<MMSheetViewDelegate>*/)delegate cancelButton:(NSString *)cancelTitle otherButtons:(NSArray*)otherTitles {
    
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _sheetViewStyle = LCSheetViewStyleDefault;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismiss) name:MMSHEETVIEW_DISMISS_NOTIFICATION object:nil];
        
        _delegate = delegate;
        _title = title;
        _msg = message;
        _cancleBtnTitle = cancelTitle;
        _titleColor = [LCSheetView appearance].titleColor;
        _titleFont = [LCSheetView appearance].titleFont;
        _msgFont = [LCSheetView appearance].msgFont;
        _buttonBgColor = [LCSheetView appearance].buttonBgColor;
        
        _separateLineColor = [LCSheetView appearance].separateLineColor;
        _containerBgColor = [LCSheetView appearance].containerBgColor;
        
        _msgColor = [LCSheetView appearance].msgColor;
        
        //接受other不定参数
        _btnArray = [NSMutableArray new];
        _otherArray = [[NSMutableArray alloc] initWithArray:otherTitles];
        
        _showButtonBackground = [LCSheetView appearance].showButtonBackground;
        
        [self setUpView];
    }
    
    return self;
}

- (void)setUpView
{
    CGFloat contentWidth = SHEET_SCREEN_WIDTH - SHEET_MARGIN_LEFT - SHEET_MARGIN_RIGHT;
    CGFloat labelWidth = contentWidth - SHEET_PADDING_LABEL_LEFT - SHEET_PADDING_LABEL_RIGHT;
    CGFloat buttonWidth = contentWidth - SHEET_PADDING_BUTTON_LEFT - SHEET_PADDING_BUTTON_RIGHT;
    if(_contentView == nil)
    {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(SHEET_MARGIN_LEFT, self.frame.size.height , contentWidth, SHEET_HRIGHT)];
        [_contentView setBackgroundColor:_containerBgColor];
        
        _topBgView = UIView.new;
        _topBgView.backgroundColor = [UIColor whiteColor];
        _topBgView.frame = CGRectMake(0, 0, SHEET_SCREEN_WIDTH, 0);
        [_contentView addSubview:_topBgView];
        
        _topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SHEET_SCREEN_WIDTH, 1.0)];
        [_topLine setBackgroundColor:_separateLineColor];
        [_contentView addSubview:_topLine];
        
        //标题
        _titleLbl = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLbl.font = _titleFont;
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.textColor = _titleColor;
        _titleLbl.text = [_title trimNewLine];
        [_titleLbl adjustForHeight];
        _titleLbl.dh_left = SHEET_PADDING_LABEL_LEFT;
        _titleLbl.dh_width = labelWidth;
    
        //消息体
        _msgLbl = [[UILabel alloc]initWithFrame:CGRectZero];
        _msgLbl.textColor = _msgColor;
        _msgLbl.dh_width = self.frame.size.width;
        _msgLbl.text = [_msg trimNewLine];
        _msgLbl.font = _msgFont;
        _msgLbl.textAlignment = NSTextAlignmentCenter;
        [_msgLbl adjustForHeight];
        
        _textFiled = [[UITextField alloc]initWithFrame:CGRectZero];
        _textFiled.isAccessibilityElement = YES;
        _textFiled.accessibilityIdentifier = @"textFieldInInitWithTitleOfSheetView";
        _textFiled.dh_left = SHEET_PADDING_LABEL_LEFT;
        _textFiled.dh_width = labelWidth;
        _textFiled.dh_height = 0.0;
        _textFiled.borderStyle = UITextBorderStyleRoundedRect;
        
        _btnContainer  = [[LCButtonContainer alloc]initWithFrame:CGRectZero];
        _btnContainer.dh_left = SHEET_PADDING_BUTTON_LEFT;
        _btnContainer.dh_width = buttonWidth;
        
        if (_cancleBtnTitle!=nil) {
            _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _cancleBtn.isAccessibilityElement = YES;
            _cancleBtn.accessibilityIdentifier = @"cancleBtnInInitWithTitleOfSheetView";
            _cancleBtn.backgroundColor = [UIColor whiteColor];
            _cancleBtn.titleLabel.font = [LCSheetView appearance].btnFont;
            [_cancleBtn setTitleColor:[LCSheetView appearance].cancleTitleColor forState:UIControlStateNormal];
            [_cancleBtn addTarget:self action:@selector(cancleBtnCliked:) forControlEvents:UIControlEventTouchUpInside];
            [_cancleBtn setTitle:_cancleBtnTitle forState:UIControlStateNormal];
            _cancleBtn.dh_left = 0.0;
            _cancleBtn.dh_width = buttonWidth;
            [_btnArray addObject:_cancleBtn];
        }
        
        _cancleBtn.dh_height = SHEET_BUTTON_HEIGHT;
        for (NSString *btnTitle in _otherArray){
            UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            tempBtn.isAccessibilityElement = YES;
            tempBtn.accessibilityIdentifier = @"tempBtnInInitWithTitleOfSheetView";
            [tempBtn setTitle:btnTitle forState:UIControlStateNormal];
            [tempBtn setTitleColor:[UIColor colorWithRed:44.0/255.0 green:44.0/255.0 blue:44.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [tempBtn setTitleColor:[UIColor colorWithRed:0xc3/255.0 green:0xc3/255.0 blue:0xc8/255.0 alpha:1.0] forState:UIControlStateDisabled];
            [tempBtn addTarget:self action:@selector(otherBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            tempBtn.titleLabel.font = [LCSheetView appearance].btnFont;
            NSInteger index = [_otherArray indexOfObject:btnTitle];
            CGFloat top = index * (SHEET_BUTTON_HEIGHT + 1 + SHEET_PADDING_INSERT);
            CGFloat bottom = top + SHEET_BUTTON_HEIGHT;
            if (_showButtonBackground == NO) {
                tempBtn.dh_top = top;
                tempBtn.dh_left = 0.0;
                tempBtn.dh_width = buttonWidth;
                tempBtn.dh_height = SHEET_BUTTON_HEIGHT;
                [tempBtn setBackgroundColor:[UIColor whiteColor]];
                [tempBtn setTitleColor:[LCSheetView appearance].btnTitleColor forState:UIControlStateNormal];
                [_btnContainer addSubview:tempBtn];
            } else {
                UIView *btnBgView = [UIView new];
                btnBgView.frame = CGRectMake(0, top, buttonWidth, SHEET_BUTTON_HEIGHT);
                [_btnContainer addSubview:btnBgView];
                
                tempBtn.dh_width = 250;
                tempBtn.dh_height = 40;
                tempBtn.dh_left = (SHEET_SCREEN_WIDTH - tempBtn.dh_width) / 2.0;
                tempBtn.dh_top = (SHEET_BUTTON_HEIGHT - tempBtn.dh_height) / 2.0;
                tempBtn.layer.cornerRadius = tempBtn.dh_height / 2.0;
                tempBtn.layer.masksToBounds = YES;
                [tempBtn setBackgroundColor:_buttonBgColor];
                [tempBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btnBgView addSubview:tempBtn];
            }
            
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, bottom, SHEET_SCREEN_WIDTH, 1.0)];
            [lineView setBackgroundColor:_separateLineColor];
            [_btnContainer addSubview:lineView];
            
            [_btnArray addObject:tempBtn];
            if ([btnTitle isEqual:[_otherArray lastObject]] && _cancleBtnTitle!=nil) {
                _cancleBtn.dh_top = bottom + [LCSheetView appearance].paddingBetwennCancleAndOther;
                _btnContainer.dh_height = _cancleBtn.dh_bottom;
                [_cancleBtn setBackgroundColor:[UIColor whiteColor]];
            }
            else
            {
                _btnContainer.dh_height = bottom;
            }
        }
        
        [_btnContainer addSubview:_cancleBtn];
        if (_cancleBtnTitle!=nil)
        {
            _btnContainer.dh_height = _cancleBtn.dh_bottom;
            
            //添加底部分隔线
            if (_showButtonBackground) {
                UIView *bottomLine = UIView.new;
                bottomLine.backgroundColor = [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0];
                bottomLine.frame = CGRectMake(0, _cancleBtn.dh_top - 1, SHEET_SCREEN_WIDTH, 0.5);;
                [_btnContainer addSubview:bottomLine];
            }
        }
        
        [_contentView addSubview:_titleLbl];
        [_contentView addSubview:_msgLbl];
        [_contentView addSubview:_textFiled];
        [_contentView addSubview:_btnContainer];
        
        [self resetFrame];
        [self addSubview:_contentView];
    }
}

- (void)resetFrame
{
    _titleLbl.dh_top = [LCSheetView appearance].paddingTop;
    if (self.title==nil || self.title.length==0) {
        _msgLbl.dh_top = 0;
    }
    else
    {
        _msgLbl.dh_top = _titleLbl.frame.origin.y + _titleLbl.frame.size.height + [LCSheetView appearance].paddingBetwennTiltAndMsg;
    }
    
    switch (_sheetViewStyle) {
        case LCSheetViewStyleDefault:
            _textFiled.dh_height  = 0.0;
            break;
        case LCSheetViewSecureTextInput:
            _textFiled.dh_height = SHEET_TEXTFILED_HEIGHT;
            _textFiled.secureTextEntry = YES;
            break;
        case LCSheetViewStylePlainTextInput:
            _textFiled.dh_height = SHEET_TEXTFILED_HEIGHT;
            _textFiled.secureTextEntry = NO;
            break;
        default:
            break;
    }
    
    if (self.msgLbl.text.length == 0)
    {
        _textFiled.dh_top = self.msgLbl.dh_bottom;
    }
    else
    {
        _textFiled.dh_top = self.msgLbl.dh_bottom + SHEET_PADDING_INSERT;
    }
    
    if (_sheetViewStyle == LCSheetViewStyleDefault)
    {
        CGFloat offset = 0;
        if (_msgLbl.text.length) {
            offset = [LCSheetView appearance].paddingMsgBottom;
        } else if(_titleLbl.text.length == 0) {
            offset = [LCSheetView appearance].buttonPaddingTop;
        }
        _btnContainer.dh_top = _textFiled.dh_bottom + offset ;
    }
    else
    {
        _btnContainer.dh_top = _textFiled.dh_bottom + SHEET_PADDING_INSERT;
    }
    
    _contentView.dh_height = _btnContainer.dh_bottom + SHEET_PADDING_BOTTOM;
    
    if (_contentView.dh_height < SHEETVIEW_MIN_HEIGHT) {
        _contentView.dh_height = SHEETVIEW_MIN_HEIGHT;
        //        _btnContainer.height = SHEETVIEW_MIN_HEIGHT - SHEET_PADDING_BOTTOM - _btnContainer.top;
        _btnContainer.dh_bottom = SHEETVIEW_MIN_HEIGHT - SHEET_PADDING_BOTTOM;
    }
    
    _topBgView.dh_height = _btnContainer.dh_top - SHEETVIEW_LINE_HEIGHT;
    _topLine.dh_top = _btnContainer.dh_top - SHEETVIEW_LINE_HEIGHT;
}

- (NSString *)title
{
    //    if (_titleLbl.text.length == 0) {
    //        return nil;
    //    }
    //
    return _titleLbl.text;
}

- (NSString *)message
{
    //    if (_msgLbl.text.length == 0) {
    //        return nil;
    //    }
    return _msgLbl.text;
}

- (void)setSheetViewStyle:(LCSheetViewStyle)sheetViewStyle
{
    _sheetViewStyle = sheetViewStyle;
    [self resetFrame];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    NSLog(@"-----MMSheetView delloc!");
}

-(void)keyboardChange:(NSNotification *)notification
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *userInfo = [notification userInfo];
        NSTimeInterval animationDuration;
        UIViewAnimationCurve animationCurve;
        CGRect keyboardEndFrame;
        
        [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
        [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
        [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        
        CGRect newFrame = _contentView.frame;
        newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height;
        _contentView.frame = newFrame;
        
        [UIView commitAnimations];
        
    });
}

- (void)show
{
    //     [self setUpView];
    UIView *pView;
    if([UIApplication sharedApplication].keyWindow == nil || [UIApplication sharedApplication].keyWindow.hidden)
    {
        NSLog(@"MMSheetView-show-keyWindow nil or hidden");
        int maxState = -1;
        UIWindow* keyWind = nil;
        for (UIWindow* wind in [UIApplication sharedApplication].windows )
        {
            if (wind.hidden == NO)
            {
                if (wind.windowLevel > maxState)
                {
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
    }
    else
    {
        pView = [UIApplication sharedApplication].delegate.window;
    }
    
    [self showAtView:pView];
    
}

- (void)showAtView:(UIView *)view
{
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f =  _contentView.frame;
        f.origin.y = self.frame.size.height - _contentView.frame.size.height;
        
        //iPhoneX 底部向上偏移32
        if ([self isIphoneX] && [view isKindOfClass:[UIWindow class]]) {
            f.origin.y -= SHEET_BOTTOM_SAFE_HEIGHT;
            f.size.height += SHEET_BOTTOM_SAFE_HEIGHT;
        }
        
        _contentView.frame = f;
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    }
                     completion:^(BOOL finished){
                         
                     }
     ];
}


+ (void)dismissAll
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MMSHEETVIEW_DISMISS_NOTIFICATION object:nil];
}

- (void)dismiss
{
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       if (_delegate!=nil && [_delegate respondsToSelector:@selector(sheetViewCancel:)]) {
                           [_delegate sheetViewCancel:self];
                       }
                       
                       if (self.cancleBlock)
                       {
                           self.cancleBlock();
                       }
                       
                       [UIView animateWithDuration:0.3 animations:^
                        {
                            CGRect f =  _contentView.frame;
                            f.origin.y = self.frame.size.height;
                            _contentView.frame = f;
                            [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0]];
                        }
                                        completion:^(BOOL finished)
                        {
                            
                            [self removeFromSuperview];
                            
                        }
                        ];
                   });
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //防止标题等非UIControl点击消失
    CGPoint location = [[touches anyObject] locationInView:_contentView];
    if (CGRectContainsPoint(_contentView.bounds, location)) {
        return;
    }
    
    [self dismiss];
}


-(IBAction)cancleBtnCliked:(id)sender
{
    [self dismiss];
    
    if (_delegate!=nil && [_delegate respondsToSelector:@selector(sheetViewCancel:)]) {
        [_delegate sheetViewCancel:self];
    }
    
    if (self.clickedBlock) {
        self.clickedBlock(0);
    }
}

- (IBAction)otherBtnClicked:(UIButton *)sender
{
    [self dismiss];
    NSInteger clickIndex = [_btnArray indexOfObject:sender];
    if (_delegate!=nil && [_delegate respondsToSelector:@selector(sheetView:clickedButtonAtIndex:)])
    {
        [_delegate sheetView:self clickedButtonAtIndex:clickIndex];
    }
    
    if (self.clickedBlock) {
        self.clickedBlock(clickIndex);
    }
}

- (UIButton *)buttonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex > _btnArray.count-1)
    {
        return nil;
    }
    
    return _btnArray[buttonIndex];
}

- (UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex
{
    return _textFiled;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

static LCSheetView *oneAppearance;

+ (instancetype)appearance
{
    if(oneAppearance == nil)
    {
        oneAppearance = [[LCSheetView alloc]initWithFrame:CGRectZero];
        oneAppearance.titleColor = [UIColor blackColor];
        oneAppearance.titleFont = [UIFont systemFontOfSize:SHEET_FONT_TITLE_SIZE];
        oneAppearance.msgFont = [UIFont systemFontOfSize:SHEET_FONT_MESSAGE_SIZE];
        
        oneAppearance.buttonBgColor = [UIColor colorWithRed:10.0/255.0 green:155.0/255.0 blue:255.0/255.0 alpha:1.0];
        oneAppearance.separateLineColor = [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0];
        oneAppearance.containerBgColor = [UIColor colorWithRed:0xef/255.0 green:0xef/255.0 blue:0xf4/255.0 alpha:1.0];         
        oneAppearance.msgColor = [UIColor colorWithRed:0x8f/255.0 green:0x8f/255.0 blue:0x8f/255.0 alpha:1.0];
        oneAppearance.titleColor = [UIColor blackColor];
        oneAppearance.titleFont = [UIFont systemFontOfSize:SHEET_FONT_TITLE_SIZE];
        oneAppearance.msgFont = [UIFont systemFontOfSize:SHEET_FONT_MESSAGE_SIZE];
        oneAppearance.cancleTitleColor = [UIColor blackColor];
        
        oneAppearance.btnFont = [UIFont systemFontOfSize:SHEET_FONT_SIZE];
        oneAppearance.btnTitleColor = [UIColor blackColor];
        
        oneAppearance.paddingTop = SHEET_PADDING_TOP;
        oneAppearance.paddingBetwennTiltAndMsg = SHEET_PADDING_BETWEEN_TITLE_MSG;
        oneAppearance.paddingMsgBottom = SHEET_MSG_PADDING_BOTTOM;
        oneAppearance.paddingBetwennCancleAndOther = SHEET_PADDING_BETWEEN_CANCLE_OTHER;
        oneAppearance.buttonPaddingTop = SHEET_BUTTON_PADDING_TOP;
    }
    return oneAppearance;
}


#pragma mark - Properties
- (void)setAttrMessage:(NSAttributedString *)attrMessage
{
    _msgLbl.attributedText = attrMessage;
}

#pragma mark - iPhone X
- (BOOL)isIphoneX
{
	CGRect frame = [UIScreen mainScreen].bounds;
	CGFloat width = MIN(frame.size.width, frame.size.height);
	CGFloat height = MAX(frame.size.width, frame.size.height);
	
	if ((width == 375 && height == 812) ||
		(width == 414 && height == 896)) {
		return YES;
	}
	
	return NO;
}

@end
