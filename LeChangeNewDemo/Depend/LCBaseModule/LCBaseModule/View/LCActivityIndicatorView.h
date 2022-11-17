//
//  Copyright (c) 2015年 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LCActivityIndicatorViewStyle) {
    LCActivityIndicatorViewStyleYellow,
    LCActivityIndicatorViewStyleWhite
};

@interface LCActivityIndicatorView : UIView

@property (nonatomic, strong) UIImageView  *backgroundView;
@property (nonatomic, strong) UIImageView  *rotationView;
@property (nonatomic, assign) LCActivityIndicatorViewStyle  style;

- (void)startAnimating;
- (void)stopAnimating;

@end