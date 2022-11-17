//
//  Copyright © 2020 jm. All rights reserved.
//

#import <LCBaseModule/LCCTextField.h>
#import <LCBaseModule/UITextField+LeChange.h>
#import <LCBaseModule/UIColor+LeChange.h>
#import <LCBaseModule/UIFont+Imou.h>

@interface LCCTextField ()<UITextFieldDelegate>

/// result
@property (nonatomic, copy) LCCTextFieldInputBlock result;
/// 反馈结果
@property (strong, nonatomic) NSString *resultString;

@end


@implementation LCCTextField

@synthesize placeholder = _placeholder;

+ (instancetype)lcTextFieldWithResult:(void (^)(NSString *result))result {
    LCCTextField *textField = [LCCTextField new];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.result = result;
    return textField;
}
- (void)setInputingBlock:(LCCTextFieldInputingBlock)inputingBlock{
    self.delegate = self;
    _inputingBlock = inputingBlock;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.font = [UIFont lcFont_t4];
        self.delegate = self;
    }
    return self;
}

// 未输入时文本的位置，向右缩进10
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 0);
}

// 输入后文本的位置，向右缩进10
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 0);
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.attributedPlaceholder = [[NSAttributedString alloc]initWithString:placeholder attributes:@{ NSFontAttributeName: [UIFont lcFont_t4], NSForegroundColorAttributeName: [UIColor lccolor_c41] }];
}
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    if (self.result) {
        self.result(@"");
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    if (self.result) {
        self.result(textField.text);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"%@--------%@", string, textField.text);
    if (self.inputingBlock) {
       return self.inputingBlock(textField.text,string);
    }
    if ([self hasEmoji:string]) {
        return NO;
    }

    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"-++++++----%@", textField.text);
    return YES;
}
/**
 *  判断字符串中是否存在emoji
 * @param string 字符串
 * @return YES(含有表情)
 */
- (BOOL)hasEmoji:(NSString *)string;
{
    NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}

/**
 判断是否含有中文

 @param str 字符串
 @return YES 含有中文
 */
- (BOOL)isChinese:(NSString *)str
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:str];
}



@end
