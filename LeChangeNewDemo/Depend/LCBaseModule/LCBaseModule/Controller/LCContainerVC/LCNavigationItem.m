//
//  Copyright © 2019 jm. All rights reserved.
//

#import "LCNavigationItem.h"

@implementation LCNavigationItem
- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    [self setRightBarButtonItems:@[rightBarButtonItem]];
}

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    [self setLeftBarButtonItems:@[leftBarButtonItem]];
}

- (void)setLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)leftBarButtonItems
{
    for (UIBarButtonItem *item in leftBarButtonItems) {
        [item.customView sizeToFit];
    }

    [super setLeftBarButtonItems:leftBarButtonItems];
}

- (void)setRightBarButtonItems:(NSArray<UIBarButtonItem *> *)rightBarButtonItems
{
    for (UIBarButtonItem *item in rightBarButtonItems) {
        [item.customView sizeToFit];
    }
    [super setRightBarButtonItems:rightBarButtonItems];
}

@end
