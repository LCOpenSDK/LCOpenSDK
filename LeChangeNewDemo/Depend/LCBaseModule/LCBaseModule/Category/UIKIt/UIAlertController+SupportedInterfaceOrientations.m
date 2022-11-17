//
//  Copyright © 2016年 Imou. All rights reserved.
//

#import "UIAlertController+SupportedInterfaceOrientations.h"

@implementation UIAlertController (SupportedInterfaceOrientations)

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return true;
}
@end
