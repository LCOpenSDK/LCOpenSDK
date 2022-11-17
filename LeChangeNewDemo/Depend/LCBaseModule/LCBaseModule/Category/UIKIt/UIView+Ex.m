//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

#import <LCBaseModule/UIView+Ex.h>

@implementation UIView (Ex)

- (BOOL)lc_enable {
    return self.userInteractionEnabled;
}

- (void)setLc_enable:(BOOL)lc_enable {
    self.userInteractionEnabled = lc_enable;
    self.alpha = lc_enable ? 1.0 : 0.3;
}

@end
