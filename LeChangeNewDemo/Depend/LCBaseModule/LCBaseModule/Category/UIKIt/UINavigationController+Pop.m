//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "UINavigationController+Pop.h"


@implementation UINavigationController (Pop)

- (void)lc_popToViewController:(NSString *)vc Filter:(NSInteger (^)(NSArray * _Nonnull vcs))filter animated:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *VCArray = [NSMutableArray array];
           for (NSInteger a = self.viewControllers.count-1; a>=0; a--) {
               UIViewController *subVC = self.viewControllers[a];
               if ([subVC isKindOfClass:NSClassFromString(vc)] || [NSStringFromClass(subVC.class) hasSuffix:vc]) {
                   [VCArray addObject:subVC];
               }
           }
        if (VCArray.count == 0) {
            NSLog(@"没有找到指定的VC");
            return ;
        }
        NSInteger index = 0;
        if (filter) {
           index = filter(VCArray);
        }
           
        UIViewController * confirmVC = (UIViewController*)VCArray[index];
        [self popToViewController:confirmVC animated:animated];
    });
}

@end
