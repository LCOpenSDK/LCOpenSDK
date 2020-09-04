//
//  MyViewController.m
//  LCOpenSDKDemo
//
//  Created by mac318340418 on 16/7/15.
//  Copyright © 2016年 lechange. All rights reserved.
//

#import "MyViewController.h"

@interface MyViewController ()

@end

@implementation MyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.m_navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 40)];
        self.m_yOffset = [[[UIApplication sharedApplication] delegate] window].frame.origin.y + 10 + 40 + 20;
        // ios系统大于7，为避免出现输入框字符下沉，需添加以下配置
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        [self setExtendedLayoutIncludesOpaqueBars:NO];
    }
    else {
        self.m_navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, [[[UIApplication sharedApplication] delegate] window].frame.origin.y, self.view.bounds.size.width, 40)];
        self.m_yOffset = [[[UIApplication sharedApplication] delegate] window].frame.origin.y + 10 + 40;
    }
    self.m_navigationBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)viewWillLayoutSubviews
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

@end
