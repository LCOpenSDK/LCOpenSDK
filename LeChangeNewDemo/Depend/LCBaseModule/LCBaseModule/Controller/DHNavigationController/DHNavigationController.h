//
//  Copyright © 2018年 Anson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHNavigationController : UINavigationController


/**
 调用NavigationController的setViewControllers方法时，需要注意，是不是反向设置

 @return 导航栈中的容器
 */
- (NSArray<__kindof UIViewController *> *)dh_viewContainers;

//记录进入的控制器
@property (nonatomic, strong) NSArray *recordVCArr;

@property (nonatomic, strong) UINavigationController *recordNavi;

@end
