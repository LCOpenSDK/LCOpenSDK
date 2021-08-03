//
//  Copyright (c) 2014年 dahua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCNameRule : NSObject<UITextFieldDelegate>
{
    UITextField *field;
}

- (id)initWithTarget:(UITextField *)target;

- (NSString *)getResult;

@end
