//
//  HintViewController.m
//  LCOpenSDKDemo
//
//  Created by chenjian on 16/7/11.
//  Copyright (c) 2016年 lechange. All rights reserved.
//

#import "LCOpenSDK_Prefix.h"
#import "HintViewController.h"
#import <Foundation/Foundation.h>
@interface HintViewController ()

@end

@implementation HintViewController
@synthesize m_appId, m_appSecret, m_hint;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UINavigationItem* item = [[UINavigationItem alloc] initWithTitle:NSLocalizedString(HINT_TITLE_TXT, nil)];
    super.m_navigationBar.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [self.m_bgImg setImage:[UIImage leChangeImageNamed:Start_Png]];
    UIButton* left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(0, 0, 50, 30)];
    UIImage* img = [UIImage leChangeImageNamed:Back_Btn_Png];

    [left setBackgroundImage:img forState:UIControlStateNormal];
    [left addTarget:self action:@selector(onback:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc] initWithCustomView:left];
    [item setLeftBarButtonItem:leftBtn animated:NO];
    [super.m_navigationBar pushNavigationItem:item animated:NO];

    [self.view addSubview:super.m_navigationBar];

    if (nil != m_appId || nil != m_appSecret || nil != m_hint) {
        self.m_lblAppId.text = [m_appId mutableCopy];
        self.m_lblAppId.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.m_lblAppSecret.text = [m_appSecret mutableCopy];
        self.m_lblAppSecret.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        m_lblHint = [[UILabel alloc] initWithFrame:CGRectMake(20, self.m_lblAppSecret.frame.origin.y + self.m_lblAppSecret.frame.size.height + super.m_yOffset - 30, self.view.frame.size.width - 40, 150)];
        [self.view addSubview:m_lblHint];
        m_lblHint.text = [m_hint mutableCopy];
        m_lblHint.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [m_lblHint setFont:[UIFont systemFontOfSize:12.0f]];
        m_lblHint.lineBreakMode = NSLineBreakByWordWrapping;
        m_lblHint.numberOfLines = 0;

        m_lblHint.textColor = [UIColor redColor];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setInfo:(NSString*)appId appSecret:(NSString*)appSecret info:(NSString*)info
{
    m_appSecret = [appSecret mutableCopy];
    m_appId = [appId mutableCopy];
    m_hint = [info mutableCopy];
}

- (void)onback:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
