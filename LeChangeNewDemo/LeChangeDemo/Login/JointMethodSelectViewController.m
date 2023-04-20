//
//  JointMethodSelectViewController.m
//  LeChangeDemo
//
//  Created by imou on 2019/12/5.
//  Copyright © 2019 dahua. All rights reserved.
//  选择对接方式页面 对接方式有海外imou以及国内乐橙

#import "JointMethodSelectViewController.h"

@interface JointMethodSelectViewController ()

/// 对接海外Btn
@property (strong, nonatomic) UIButton *overseaJointBtn;

/// 对接国内Btn
@property (strong, nonatomic) UIButton *internalJointBtn;

@end

@implementation JointMethodSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)configSubview{
    self.overseaJointBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.overseaJointBtn];
    [self.overseaJointBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@100);
        make.width.equalTo(make.height);
    }];
    self.overseaJointBtn.backgroundColor = [UIColor redColor];
}
//MARK: - Action Methods



@end
