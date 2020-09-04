//
//  MyNavigationController.m
//  LCOpenSDKDemo
//
//  Created by mac318340418 on 16/7/13.
//  Copyright © 2016年 lechange. All rights reserved.
//

#import "MyNavigationController.h"
#import "UIAlertController+supportedInterfaceOrientations.h"
@interface MyNavigationController ()

@end

@implementation MyNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotate
{
    return self.visibleViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return self.visibleViewController.supportedInterfaceOrientations;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
