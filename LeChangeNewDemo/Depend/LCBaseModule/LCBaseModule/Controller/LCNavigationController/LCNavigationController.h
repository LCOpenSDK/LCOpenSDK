//
//  Copyright © 2018年 Anson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCNavigationController : UINavigationController

//记录进入的控制器
@property (nonatomic, strong) NSArray *recordVCArr;

@property (nonatomic, strong) UINavigationController *recordNavi;

@end
