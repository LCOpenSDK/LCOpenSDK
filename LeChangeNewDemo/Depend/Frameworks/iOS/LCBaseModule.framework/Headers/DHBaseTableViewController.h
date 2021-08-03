//
//  Copyright © 2015 dahua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LCBaseModule/UIViewController+Base.h>

@interface DHBaseTableViewController : UITableViewController



#pragma mark - 导航栏相关
@property (nonatomic)BOOL navigationBarHidden;
- (void)setNavigationBarHidden:(BOOL)navigationBarHidden animated:(BOOL)animated;

//外部不要使用  返回原来的navigationItem
- (UINavigationItem *)superNavigationItem;
@end
