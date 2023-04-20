//
//  Copyright © 2016年 Imou. All rights reserved.
//

#import "UINavigationItem+LeChange.h"

@implementation UINavigationItem (LeChange)

- (void)setLc_leftBarButtonItems:(NSArray<UIBarButtonItem *> *)lc_leftBarButtonItems
{
    NSMutableArray *leftItems = [NSMutableArray new];
    for (UIBarButtonItem *item in lc_leftBarButtonItems) {
        //添加一个空的，调整左边距
        UIBarButtonItem *spacer = [self spaceItemWithWidth:-5];
        [leftItems addObject:spacer];
        
        item.customView.contentMode = UIViewContentModeLeft; //居左
        [leftItems addObject:item];
        //[item.customView sizeToFit]; //会导致文字的长度变成系统默认的
        
//#if DEBUG
//        item.customView.backgroundColor = [UIColor greenColor];
//#endif
    }
    
    self.leftBarButtonItems = leftItems;
}

- (NSArray<UIBarButtonItem *> *) lc_leftBarButtonItems
{
    return self.leftBarButtonItems;
}

- (void)setLc_rightBarButtonItems:(NSArray<UIBarButtonItem *> *)lc_rightBarButtonItems
{
    NSMutableArray *rightItems = [NSMutableArray new];
    for (UIBarButtonItem *item in lc_rightBarButtonItems) {
        //添加一个空的，调整右边距
        UIBarButtonItem *spacer = [self spaceItemWithWidth:-5];
        [rightItems addObject:spacer];
        
        if ([item isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)item;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            button.imageView.contentMode = UIViewContentModeRight;
        }
        
        [rightItems addObject:item];
        item.customView.contentMode = UIViewContentModeRight; //居右
        //[item.customView sizeToFit]; //会导致文字的长度变成系统默认的
        
//#if DEBUG
//        item.customView.backgroundColor = [UIColor redColor];
//#endif
    }
    
    self.rightBarButtonItems = rightItems;
}

- (NSArray<UIBarButtonItem *> *) lc_rightBarButtonItems
{
    return self.rightBarButtonItems;
}

- (void)setLc_leftBarButtons:(NSArray<UIView *> *)lc_leftBarButton
{
    self.leftBarButtonItems = [self barItemsFromButtonViewArray:lc_leftBarButton];
}

- (NSArray <UIView *> *)lc_leftBarButtons
{
    return [self buttonsFromBarItems:self.lc_leftBarButtonItems];
}

- (void)setLc_rightBarButtons:(NSArray<UIView *> *)lc_rightBarButton
{
    self.rightBarButtonItems = [self barItemsFromButtonViewArray:lc_rightBarButton];
}

- (NSArray<UIView *> *)lc_rightBarButtons
{
    return [self buttonsFromBarItems:self.lc_rightBarButtonItems];
}

#pragma mark - custom methods
- (NSArray<UIBarButtonItem *> *)barItemsFromButtonViewArray:(NSArray <UIView *>*)buttonArray
{
    NSMutableArray *batItems = [NSMutableArray new];
    for (UIView *oneView in buttonArray)
    {
        //添加一个空的，调整左边距
        UIBarButtonItem *spacer = [self spaceItemWithWidth:-5];
        [batItems addObject:spacer];
        
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:oneView];

        [batItems addObject:barItem];
    }
    return batItems;
}

- (NSArray<UIView *> *)buttonsFromBarItems:(NSArray<UIBarButtonItem *>*)barItems
{
    NSMutableArray *barButtons = [NSMutableArray new];
    for (UIBarButtonItem *item in barItems)
    {
        UIView *oneView = item.customView;
        if (oneView) {
            [barButtons addObject:oneView];
        }
        
    }
    return barButtons;
}

- (UIBarButtonItem *)spaceItemWithWidth:(CGFloat)width
{
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = width;
    return spacer;
}
@end
