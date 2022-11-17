//
//  Copyright © 2016年 Imou. All rights reserved.
//

#define EMOJI                      @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"
#define SPACE                      @"[//s//p{Zs}]"
#define LC_ILLEGALCHAR             @"[•€`~!#$%^&*+=|{}()':;'@,\\[\\]<>/?~！#¥%⋯⋯&*（）——+|{}【】‘；：\"”“’。，、？]"
#define LCTextFieldDefaultBlankMsg @"Sorry, contents cannot be blank"

#import "LCTextField.h"
#import "UITextField+LeChange.h"
#import "UIFont+Imou.h"

//抽象私有代理类, 封装UITextFieldDelegate代理方法, 默认返回默认值
@interface LCTextFieldSupport : NSObject <UITextFieldDelegate>
//设置代理类属性, 接受外部传入的代理
@property (nonatomic, weak) id<UITextFieldDelegate> delegate;
@property (nonatomic, assign) BOOL checkOnTextChanged;
@property (nonatomic, assign) BOOL checkOnResign;

@end

@implementation LCTextFieldSupport
@synthesize delegate, checkOnTextChanged, checkOnResign;

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [delegate textFieldShouldBeginEditing:textField];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        return [delegate textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [delegate textFieldShouldEndEditing:textField];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        return [delegate textFieldDidEndEditing:textField];
    }
    if (checkOnResign) {
        [(LCTextField *)textField lc_checkIt];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [delegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    if (checkOnTextChanged) {
        [(LCTextField *)textField lc_checkIt];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if ([delegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [delegate textFieldShouldClear:textField];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [delegate textFieldShouldReturn:textField];
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)setDelegate:(id<UITextFieldDelegate>)dele {
    delegate = dele;
}

@end

@interface LCTextField ()
{
    LCTextFieldSupport *support;          //抽象代理类对象
    NSString *blankMsg;                   //空内容提示
    NSString *strRegExCustom;             //自定义正则表达式
    NSMutableArray *arrRegEx;             //RegEx校验规则键值对数组, 用来存储外部自定义的正则表达式及其校验反馈的字符串
}

@property (nonatomic, copy) LCTextFieldMsgBlock blankMsgBlock;
@property (nonatomic, copy) LCTextFieldMsgBlock checkMsgBlock;
@property (nonatomic, copy) LCTextFieldInputBlock result;

@end

@implementation LCTextField
@synthesize /*isMenuItemsEnable, */ isRuled, disableEmoji, disableSpace, disableSpecialChar, disableUnderRegEx, isChecking, checkOnResign, checkOnTextChanged, chineseStrLength, isSetOneTimeCode;

#pragma mark - Default Methods of UITextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setInputingBlock:(LCTextFieldInputingBlock)inputingBlock{
    self.delegate = self;
    _inputingBlock = inputingBlock;
}

//初始化
- (void)setUp {
    //初始化默认限制属性
    //isMenuItemsEnable = YES; //可长按编辑
    isRuled = NO;     //不限制输入
    disableEmoji = YES;     //Emoji禁用
    disableSpace = NO;     //空白符可用
    disableSpecialChar = NO;     //特殊符号可用
    chineseStrLength = 2;
    //初始化默认校验属性
    arrRegEx = [NSMutableArray new];
    isChecking = NO;     //不校验输入
    checkOnResign = NO;     //不在结束编辑时校验
    checkOnTextChanged = NO;     //不在输入过程中校验
    blankMsg = [LCTextFieldDefaultBlankMsg copy];     //默认空内容提示
    //初始化封装代理类对象
    support = [LCTextFieldSupport new];
    self.customClearButton = YES;

    //iOS12自动填充短信内容
    if (@available(iOS 12.0, *)) {
        self.textContentType = UITextContentTypeOneTimeCode;
    }

    //设置监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setDelegate:(id<UITextFieldDelegate>)delegate {
    //1.外部设置的代理(如视图控制器),传入私有类对象support的属性delegate.
    support.delegate = delegate;
    //2.super即UITextField的代理是support
    super.delegate = support;
}

- (void)setCheckOnResign:(BOOL)onResign {
    support.checkOnResign = onResign;
    checkOnResign = onResign;
}

- (void)setCheckOnTextChanged:(BOOL)onTextChanged {
    support.checkOnTextChanged = onTextChanged;
    checkOnTextChanged = onTextChanged;
}

- (void)setIsRuled:(BOOL)isRuledOrNot {
    isRuled = isRuledOrNot;
    disableUnderRegEx = isRuled;
}

- (void)setIsSetOneTimeCode:(BOOL)isSetOneTimeCodeOpen {
    isSetOneTimeCode = isSetOneTimeCodeOpen;

    //iOS12自动填充短信内容
    if (@available(iOS 12.0, *)) {
        if (isSetOneTimeCode == true) {
            self.textContentType = UITextContentTypeOneTimeCode;
        } else {
            self.textContentType = UITextContentTypeName;
        }
    }
}

- (void)textFieldChanged:(NSNotification *)notification {
    //文本输入变化时, 强制限制输入. 默认为NO
    if (isRuled == NO) {
        //密码输入框，进入时，直接回删处理【失去焦点后，重新进入】
        if (notification.object != self) {
            return;
        }

        LCTextField *textFiled = (LCTextField *)notification.object;
        NSInteger length = textFiled.text.length;

        if (self.secureTextEntry && length == 0 && [self.delegate respondsToSelector:@selector(textFieldShouldClear:)]) {
            [self.delegate textFieldShouldClear:self];
        }

        if (self.textChanged) {
            self.textChanged(self.text);
        }

        return;
    }

    //获取过滤后的内容
    NSString *result = self.text;
    //是否支持emoji表情\空白符\特殊符号
    if (disableEmoji) {
        result = [LCTextField disableEmojiInString:self.text];
    }
    if (disableSpace) {
        result = [LCTextField disableSpaceInString:self.text];
    }
    if (disableSpecialChar) {
        result = [LCTextField disableSpecialCharInString:self.text];
    }

    //开启限制isRuled后, 默认开启正则表达式限制
    NSRange selRange = self.selectedRange;
    UITextRange *selectedRange = [self markedTextRange];
    UITextPosition *position = nil;

    if (selectedRange) {
        position = [self positionFromPosition:selectedRange.start offset:0];
    }

    if (!position /*|| !selectedRange*/) {
        unsigned int strLength = 0;
        for (unsigned int i = 0; i < result.length; i++) {
            if (strRegExCustom.length > 0) {
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegExCustom];
                NSString *tmpChar = nil;
                NSRange range;
                range.location = i;
                range.length = 1;
                tmpChar = [result substringWithRange:range];
                if (tmpChar.length > 0 && ![pred evaluateWithObject:tmpChar]) {
                    result = [result stringByReplacingCharactersInRange:range withString:@""];
                    i--;
                } else {
                    unichar uc = [result characterAtIndex:i];
                    NSUInteger customChineseLength = 2;
                    if (chineseStrLength != 2) {
                        customChineseLength = chineseStrLength;
                    }
                    strLength += (isascii(uc) ? 1 : customChineseLength);
                }
            } else {
                unichar uc = [result characterAtIndex:i];
                NSUInteger customChineseLength = 2;
                if (chineseStrLength != 2) {
                    customChineseLength = chineseStrLength;
                }
                strLength += (isascii(uc) ? 1 : customChineseLength);
            }

            if (self.strLengthCustom != 0) {
                if (strLength > self.strLengthCustom) {
                    self.text = [result substringToIndex:i];
                    break;
                } else {
                    self.text = result;
                }
            }
        }
    }

    if (self.text.length > selRange.location) {
        [self setSelectedRange:NSMakeRange(selRange.location, 0)];
    }

    //密码输入框，进入时，直接回删处理【失去焦点后，重新进入】
    if (notification.object != self) {
        return;
    }

    LCTextField *textFiled = (LCTextField *)notification.object;
    NSInteger length = textFiled.text.length;

    if (self.secureTextEntry && length == 0 && [self.delegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        [self.delegate textFieldShouldClear:self];
    }

    if (self.textChanged) {
        self.textChanged(self.text);
    }
}

//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
//{
//    if (self.menuType == LCTextFieldMenuTypeCanNone) {
//        UIMenuController *menuController = [UIMenuController sharedMenuController];
//        if (menuController) {
//            [UIMenuController sharedMenuController].menuVisible = NO;
//        }
//        return NO;
//    }
//    if (self.menuType == LCTextFieldMenuTypeCanCopy && action == @selector(copy:)) {
//        return YES;
//    }
//    if (self.menuType == LCTextFieldMenuTypeCanSelect && action == @selector(select:)) {
//        return YES;
//    }
//    if (self.menuType == LCTextFieldMenuTypeCanSelectAll && action == @selector(selectAll:)) {
//        return YES;
//    }
//    if (self.menuType == LCTextFieldMenuTypeCanPaste && action == @selector(paste:)) {
//        return YES;
//    }
//
//    return NO;
//}

//过滤emoji
+ (NSString *)disableEmojiInString:(NSString *)text {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:EMOJI options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

//过滤空白符
+ (NSString *)disableSpaceInString:(NSString *)text {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:SPACE options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

//过滤特殊符号
+ (NSString *)disableSpecialCharInString:(NSString *)text {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:LC_ILLEGALCHAR options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

#pragma mark -
- (void)delete:(id)sender
{
    self.text = @"";
}

#pragma mark - Public Methods - Rule

- (void)lc_setInputRuleWithRegEx:(NSString *)string andInputLength:(unsigned int)Length {
    strRegExCustom = string;
    self.strLengthCustom = Length;
    self.isRuled = YES;
}

- (void)lc_setBlankMsgBlock:(LCTextFieldMsgBlock)block {
    self.blankMsgBlock = block;
}

- (void)lc_setCheckMsgBlock:(LCTextFieldMsgBlock)block {
    self.checkMsgBlock = block;
}

#pragma mark - Public Methods - Check
//增加校验规则

- (void)lc_addRegExToCheckTextField:(NSString *)strRegEx withMsgBlock:(LCTextFieldMsgBlock)msgBlock {
    isChecking = YES;
    self.checkMsgBlock = msgBlock;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:strRegEx, @"RegEx", self.checkMsgBlock, @"Msg", nil];
    [arrRegEx addObject:dic];
}

//设置确认密码的目标输入框
- (void)lc_addConfirmValidationToCheckTextField:(LCTextField *)targetTextField withMsgBlock:(LCTextFieldMsgBlock)msgBlock {
    isChecking = YES;
    self.checkMsgBlock = msgBlock;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:targetTextField, @"confirm", self.checkMsgBlock, @"Msg", nil];
    [arrRegEx addObject:dic];
}

//正则表达式匹配
- (BOOL)checkString:(NSString *)stringToCheck withRegEx:(NSString *)strRegEx {
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegEx];
    return [regex evaluateWithObject:stringToCheck];
}

- (BOOL)lc_checkIt {
    //校验开关
    if (isChecking) {
        //校验是否为空, 空返回NO;
        if ([self.text length] == 0) {
            NSLog(@"%@", blankMsg);
            if (self.blankMsgBlock != NULL) {
                self.blankMsgBlock(blankMsg);
            }
            return NO;
        }
        //按照规则校验
        for (int i = 0; i < [arrRegEx count]; i++) {
            if (self.checkMsgBlock == NULL) {
                return NO;
            }
            NSDictionary *dic = [arrRegEx objectAtIndex:i];
            if ([dic objectForKey:@"confirm"]) {
                LCTextField *txtConfirm = [dic objectForKey:@"confirm"];
                if (![txtConfirm.text isEqualToString:self.text]) {
                    self.checkMsgBlock([dic objectForKey:@"Msg"]);
                    return NO;
                }
            } else if (![[dic objectForKey:@"RegEx"] isEqualToString:@""] && [self.text length] != 0 && ![self checkString:self.text withRegEx:[dic objectForKey:@"RegEx"]]) {
                self.checkMsgBlock([dic objectForKey:@"Msg"]);
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - PlaceHolder（由于全局设置字体后，导致中文字初始位置偏低）
- (void)setPlaceholder:(NSString *)placeholder
{
    [super setPlaceholder:placeholder];
    UIFont *originFont = self.font;
    self.font = nil;
    self.font = originFont;
}

- (CGRect)textRectForBounds:(CGRect)bounds{
	CGRect inset = [super textRectForBounds:bounds];
	if (self.textAlignment == NSTextAlignmentCenter) {
		inset = CGRectMake(bounds.origin.x + _textOffsetWhenInAlignmentCenter, bounds.origin.y, bounds.size.width, bounds.size.height);
	}

	return inset;
}

+ (instancetype)lcTextFieldWithResult:(void (^)(NSString *result))result {
    LCTextField *textField = [LCTextField new];
    textField.result = result;
    return textField;
}


@end
