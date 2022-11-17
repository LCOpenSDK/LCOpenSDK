//
//  Copyright (c) 2015年 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,DHMessageActivityIndicatorViewStyle) {
    DHMessageActivityIndicatorViewStyleYellow,
    DHMessageActivityIndicatorViewStyleWhite
};

@interface DHMessageActivityIndicatorView : UIView

@property (nonatomic, strong) UIImageView  *backgroundView;
@property (nonatomic, strong) UIImageView  *rotationView;
@property (nonatomic, assign) DHMessageActivityIndicatorViewStyle  style;

- (void)startAnimating;
- (void)stopAnimating;

@end
