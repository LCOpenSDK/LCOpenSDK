//
//  Copyright (c) 2014年 LeChange. All rights reserved.
//

#import <LCBaseModule/UITextField+LeChange.h>
#import <objc/runtime.h>
#import <LCBaseModule/LCModuleConfig.h>

static char customClearKey;


@implementation UITextField (LeChange)

- (NSRange) selectedRange
{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

- (void) setSelectedRange:(NSRange) range
{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextPosition* startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    
    [self setSelectedTextRange:selectionRange];
}

- (void)setSecureTextEntryWithBtn:(id)sender
{
    BOOL bShowState = ![self isSecureTextEntry];//获取状态
    [self setSecureTextEntry:bShowState];//设置状态
    [self setEnabled:YES];
    if (!bShowState)
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"login_icon_openeye"] forState:UIControlStateNormal];
    }
    else
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"login_icon_closeeye"] forState:UIControlStateNormal];
    }
}
 
- (void)setCustomClearButton:(BOOL)customClearButton
{
    objc_setAssociatedObject(self, &customClearKey, @(customClearButton), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (customClearButton) 
    {
        UIButton *clearButton = [self valueForKey:@"_clearButton"];
        [clearButton setImage:[UIImage imageNamed:@"common_listicon_s_empty"] forState:UIControlStateNormal];
		clearButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
}

- (BOOL)customClearButton
{
    return [objc_getAssociatedObject(self, &customClearKey) boolValue];
}

-(void)clearHandleSingleTap:(UITapGestureRecognizer*)tap
{
    self.text = @"";
}

@end
