//
//  Copyright (c) 2015年 dahua. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,DHActivityIndicatorViewStyle) {
    DHActivityIndicatorViewStyleYellow,
    DHActivityIndicatorViewStyleWhite
};

@interface DHActivityIndicatorView : UIView

@property (nonatomic, strong) UIImageView  *backgroundView;
@property (nonatomic, strong) UIImageView  *rotationView;
@property (nonatomic, assign) DHActivityIndicatorViewStyle  style;

- (void)startAnimating;
- (void)stopAnimating;

@end
