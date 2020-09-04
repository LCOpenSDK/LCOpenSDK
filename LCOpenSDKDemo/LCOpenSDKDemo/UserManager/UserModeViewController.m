//
//  HintViewController.m
//  LCOpenSDKDemo
//
//  Created by chenjian on 16/7/11.
//  Copyright (c) 2016年 lechange. All rights reserved.
//

#import "LCOpenSDK_Prefix.h"
#import "DeviceViewController.h"
#import "UserModeViewController.h"
#import "openApiService.h"
#import "RestApiService.h"
#import <Foundation/Foundation.h>

@interface UserModeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *m_userLockBtn;
@property (weak, nonatomic) IBOutlet UIButton *m_enterDeviceBtn;
@end

@implementation UserModeViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    UINavigationItem* item = [[UINavigationItem alloc] initWithTitle:NSLocalizedString(USER_TITLE_TXT, nil)];
    self.m_textPhone.text = NSLocalizedString(USER_ACCOUNT_TIP_TXT, nil);
    self.m_lblHint.text = NSLocalizedString(ACCOUNT_NOTICE_TIP_TXT, nil);
    [self.m_userLockBtn setTitle:NSLocalizedString(BIND_USER_TXT, nil) forState:UIControlStateNormal];
    [self.m_enterDeviceBtn setTitle:NSLocalizedString(ENTER_DEVICE_LIST_TXT, nil) forState:UIControlStateNormal];
    
    super.m_navigationBar.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

    UIButton* left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(0, 0, 50, 30)];
    UIImage* img = [UIImage leChangeImageNamed:Back_Btn_Png];

    [left setBackgroundImage:img forState:UIControlStateNormal];
    [left addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc] initWithCustomView:left];
    [item setLeftBarButtonItem:leftBtn animated:NO];

    [super.m_navigationBar pushNavigationItem:item animated:NO];

    [self.view addSubview:super.m_navigationBar];
    self.m_textPhone.delegate = self;

    m_progressInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    m_progressInd.transform = CGAffineTransformMakeScale(2.0, 2.0);
    m_progressInd.center = CGPointMake(self.view.center.x, self.view.center.y);
    [self.view addSubview:m_progressInd];
    [self.view bringSubviewToFront:m_progressInd];

    self.m_lblHint.lineBreakMode = NSLineBreakByWordWrapping;
    self.m_lblHint.numberOfLines = 0;
    self.m_lblHint.layer.masksToBounds = YES;
    self.m_lblHint.textAlignment = NSTextAlignmentCenter;
    self.m_lblHint.hidden = NO;

    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString* libraryDirectory = [paths objectAtIndex:0];

    NSString* infoPath = [libraryDirectory stringByAppendingPathComponent:User_Info_Path];
    NSFileManager* fileManage = [NSFileManager defaultManager];
    BOOL isDir;
    if (YES == [fileManage fileExistsAtPath:infoPath isDirectory:&isDir]) {
        NSLog(@"%@ exists,isdir[%d]", infoPath, isDir);
        NSString* content = [NSString stringWithContentsOfFile:infoPath encoding:NSUTF8StringEncoding error:nil];
        char textPhone[255] = { 0 };
        NSLog(@"content %s", [content UTF8String]);
        sscanf([content UTF8String], "[%[^]]]%*s", textPhone);

        self.m_textPhone.text = [NSString stringWithUTF8String:textPhone];
        NSLog(@"textPhone[%@]", self.m_textPhone.text);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveUserInfo
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString* libraryDirectory = [paths objectAtIndex:0];

    NSString* myDirectory = [libraryDirectory stringByAppendingPathComponent:@"lechange"];
    NSString* davDirectory = [myDirectory stringByAppendingPathComponent:@"openSDK"];

    NSString* infoPath = [davDirectory stringByAppendingPathComponent:@"userAccount"];
    NSString* realPath = [infoPath stringByAppendingString:@".txt"];

    NSFileManager* fileManage = [NSFileManager defaultManager];
    NSError* pErr;
    BOOL isDir;
    if (NO == [fileManage fileExistsAtPath:myDirectory isDirectory:&isDir]) {
        [fileManage createDirectoryAtPath:myDirectory withIntermediateDirectories:YES attributes:nil error:&pErr];
    }
    if (NO == [fileManage fileExistsAtPath:davDirectory isDirectory:&isDir]) {
        [fileManage createDirectoryAtPath:davDirectory withIntermediateDirectories:YES attributes:nil error:&pErr];
    }

    NSString* textTmp = [NSString stringWithFormat:@"[%@]", self.m_textPhone.text];
    [textTmp writeToFile:realPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)onBindUser:(id)sender
{
    [self hideHint:YES];

    if (nil == self.m_textPhone.text || 0 == self.m_textPhone.text.length || [self.m_textPhone.text isEqualToString:NSLocalizedString(USER_ACCOUNT_TIP_TXT, nil)]) {
        self.m_lblHint.text = NSLocalizedString(BIND_TIMEOUT_TXT, nil);
        [self hideHint:NO];
        return;
    }
    [self saveUserInfo];
    [self showLoading];

    NSString* errMsg;
    OpenApiService* openApi = [[OpenApiService alloc] init];
    NSInteger iret = [openApi userBindNoVerify:m_strSrv port:m_iPort appId:m_strAppId appSecret:m_strAppSecret phone:self.m_textPhone.text errmsg:&errMsg];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideLoading];
        [self hideHint:NO];
        if (iret < 0) {
            if (nil != errMsg) {
                self.m_lblHint.text = [NSString stringWithFormat:@"[%@][%@]", NSLocalizedString(BIND_FAILED_TXT, nil), errMsg];
            }
            else {
                self.m_lblHint.text = NSLocalizedString(BIND_TIMEOUT_TXT, nil);
                self.m_lblHint.lineBreakMode = NSLineBreakByWordWrapping;
                self.m_lblHint.numberOfLines = 0;
            }
            return;
        }
        else {
            self.m_lblHint.text = NSLocalizedString(BIND_SUCCEED_TXT, nil);
        }
    });
}
- (void)onEnterDevice:(id)sender
{
    [self hideHint:YES];

    if (nil == self.m_textPhone.text || 0 == self.m_textPhone.text.length || [self.m_textPhone.text isEqualToString:NSLocalizedString(USER_ACCOUNT_TIP_TXT, nil)]) {
        self.m_lblHint.text = NSLocalizedString(WRONG_ACCOUNT_TXT, nil);
        [self hideHint:NO];
        return;
    }
    [self saveUserInfo];
    [self showLoading];
    NSString *phone = self.m_textPhone.text;
    dispatch_queue_t enter_device = dispatch_queue_create("enter_device", nil);
    dispatch_async(enter_device, ^{
        NSString* acessTok;
        NSString* errCode;
        NSString* errMsg;
        OpenApiService* openApi = [[OpenApiService alloc] init];
        NSInteger ret = [openApi userTokenByAccount:m_strSrv port:m_iPort appId:m_strAppId appSecret:m_strAppSecret phone:phone token:&acessTok errcode:&errCode errmsg:&errMsg];
        
         dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoading];
            if (ret < 0) {
                if (![errCode isEqualToString:@"TK1004"]) {
                    self.m_lblHint.text = NSLocalizedString(USER_ACCOUNT_BIND_TIP_TXT, nil);
                    [self hideHint:NO];
                    return;
                }
                if (nil != errMsg) {
                    self.m_lblHint.text = [errMsg mutableCopy];
                    [self hideHint:NO];
                    return;
                }
            }
            else {
                m_strUserTok = [acessTok mutableCopy];
                NSLog(@"userToken=%@", m_strUserTok);
                [self hideHint:YES];
            }
            UIStoryboard* currentBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            DeviceViewController* devView = [currentBoard instantiateViewControllerWithIdentifier:@"DeviceView"];
            [devView setAdminInfo:m_strUserTok protocol:80 == m_iPort ? 0 : 1 address:m_strSrv port:m_iPort];
            [self.navigationController pushViewController:devView animated:NO];
        });

    });
}
- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    [self hideHint:YES];
    self.m_textPhone.textColor = [UIColor blackColor];
    self.m_textPhone.text = @"";

    CGFloat offset = self.view.frame.size.height - (textField.frame.origin.y + textField.frame.size.height + 216 + 50);
    if (offset <= 0) {
        [UIView animateWithDuration:0.1 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField*)textField
{
    [UIView animateWithDuration:0.1 animations:^{
        CGRect rect = self.view.frame;
        rect.origin.y = 0;
        self.view.frame = rect;
    }];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)hideHint:(BOOL)bFlag
{
    self.m_lblHint.hidden = bFlag;
    self.m_imgRemind.hidden = bFlag;
}
- (void)updateText:(NSString*)text
{
    self.m_textPhone.textColor = [UIColor blackColor];
    self.m_textPhone.text = text;
}

- (void)setAppIdAndSecret:(NSString*)appId appSecret:(NSString*)appSecret svr:(NSString*)svr port:(NSInteger)port
{
    m_strAppId = [appId mutableCopy];
    m_strAppSecret = [appSecret mutableCopy];
    m_strSrv = [svr mutableCopy];
    m_iPort = port;
}

- (void)showLoading
{
    [m_progressInd startAnimating];
}

- (void)hideLoading
{
    if ([m_progressInd isAnimating]) {
        [m_progressInd stopAnimating];
    }
}
@end
