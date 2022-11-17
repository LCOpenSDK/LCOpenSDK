//
//  Copyright (c) 2015年 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LCMessageActivityIndicatorViewStyle) {
    LCMessageActivityIndicatorViewStyleYellow,
    LCMessageActivityIndicatorViewStyleWhite
};

@interface LCMessageActivityIndicatorView : UIView

@property (nonatomic, strong) UIImageView  *backgroundView;
@property (nonatomic, strong) UIImageView  *rotationView;
@property (nonatomic, assign) LCMessageActivityIndicatorViewStyle  style;

- (void)startAnimating;
- (void)stopAnimating;

@end
