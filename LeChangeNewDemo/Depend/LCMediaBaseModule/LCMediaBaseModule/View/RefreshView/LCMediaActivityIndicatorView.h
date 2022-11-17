//
//  Copyright (c) 2015年 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LCMediaActivityIndicatorViewStyle) {
    LCMediaActivityIndicatorViewStyleYellow,
    LCMediaActivityIndicatorViewStyleWhite
};

@interface LCMediaActivityIndicatorView : UIView

@property (nonatomic, strong) UIImageView  *backgroundView;
@property (nonatomic, strong) UIImageView  *rotationView;
@property (nonatomic, assign) LCMediaActivityIndicatorViewStyle  style;

- (void)startAnimating;
- (void)stopAnimating;

@end
