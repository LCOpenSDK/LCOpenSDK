//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//

#import <LCBaseModule/UIView+Ex.h>

@implementation UIView (Ex)

- (BOOL)dh_enable {
    return self.userInteractionEnabled;
}

- (void)setDh_enable:(BOOL)dh_enable {
    self.userInteractionEnabled = dh_enable;
    self.alpha = dh_enable ? 1.0 : 0.3;
}

@end
