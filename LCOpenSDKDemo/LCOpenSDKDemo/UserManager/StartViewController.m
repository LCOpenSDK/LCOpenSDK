//
//  ViewController.m
//  LCOpenSDKDemo
//
//  Created by chenjian on 16/7/11.
//  Copyright (c) 2016年 lechange. All rights reserved.
//

#import "LCOpenSDK_Prefix.h"
#import "HintViewController.h"
#import "StartViewController.h"
#import "LCOpenSDK_Prefix.h"
#import "DeviceViewController.h"
#import "openApiService.h"
#import "UserModeViewController.h"

#define Y_BTN_APPSECRET 40
#define X_BTN_BOUND 35
#define BTN_LENGTH 50

@interface StartViewController ()
{
    UIActivityIndicatorView* _progressInd;
}

@end

@implementation StartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.m_imgBG setImage:[UIImage leChangeImageNamed:Start_Png]];
    // Do any additional setup after loading the view, typically from a nib.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.m_btnMan setImage:[UIImage leChangeImageNamed:Admin_Png] forState:UIControlStateNormal];
    
    UISwitch *switchBtn = [[UISwitch alloc] init];
    switchBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60,[UIScreen mainScreen].bounds.size.height - 40 , 50, 35);
    switchBtn.on = NO;
    [switchBtn addTarget:self action:@selector(switchBtnDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:switchBtn];
    
    NSString *curLanguage = NSLocalizedString(LANGUAGE_TXT, nil);
    if ([curLanguage isEqualToString:@"zh"]) {
        [self.m_btnUser setImage:[UIImage leChangeImageNamed:User_Png] forState:UIControlStateNormal];
    }else if ([curLanguage isEqualToString:@"en"]){
        [self.m_btnUser setImage:[UIImage leChangeImageNamed:User_Png] forState:UIControlStateNormal];
        [self.m_btnUser setTitle:@"" forState:UIControlStateNormal];
        //self.m_btnUser.hidden = YES;
        //self.m_btnUser.enabled = NO;
    }
    [self.m_textAppId setDelegate:self];
    [self.m_textAppSecret setDelegate:self];

    self.m_textServerInfo.delegate = self;
    _progressInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _progressInd.transform = CGAffineTransformMakeScale(2.0, 2.0);
    _progressInd.center = CGPointMake(self.view.center.x, self.view.center.y);
    [self.view addSubview:_progressInd];
    [self.view bringSubviewToFront:_progressInd];
    
    //get info
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString* libraryDirectory = [paths objectAtIndex:0];

    NSString* myDirectory = [libraryDirectory stringByAppendingPathComponent:@"lechange"];
    NSString* davDirectory = [myDirectory stringByAppendingPathComponent:@"openSDK"];

    NSString* infoPath = [davDirectory stringByAppendingPathComponent:@"info"];
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
    if (YES == [fileManage fileExistsAtPath:realPath isDirectory:&isDir]) {
        NSLog(@"%@ exists,isdir[%d]", realPath, isDir);
        NSString* content = [NSString stringWithContentsOfFile:realPath encoding:NSUTF8StringEncoding error:nil];
        char appId[500] = { 0 };
        char appSecret[500] = { 0 };
        char svrInfo[500] = { 0 };
        char appAccount[500] = { 0 };
        NSLog(@"content %s", [content UTF8String]);
        sscanf([content UTF8String], "[%[^]]][%[^]]][%[^]]]%*s", appId, appSecret, svrInfo);
        self.m_textAppId.text = [NSString stringWithUTF8String:appId];
        self.m_textAppSecret.text = [NSString stringWithUTF8String:appSecret];
        self.m_textServerInfo.text = [NSString stringWithUTF8String:svrInfo];

        NSLog(@"appid[%@],appsecret[%@],account[%s],svrInfo[%s]", self.m_textAppId.text, self.m_textAppSecret.text, appAccount, svrInfo);
    }
    //end
    
    /*
     Ch:ios13获取SSID需要用户授权地理位置信息
     En:Ios13 requires the user to authorize the geographic location information to obtain the SSID.
     */
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    CGFloat version = [phoneVersion floatValue];
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined && version >= 13) {
        self.locationManager = [[CLLocationManager alloc] init];
        if ([ self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [ self.locationManager requestWhenInUseAuthorization];
        }
        [self.locationManager startUpdatingLocation];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *curLanguage = NSLocalizedString(LANGUAGE_TXT, nil);
    if ([curLanguage isEqualToString:@"zh"]) {
        
    }
    else if ([curLanguage isEqualToString:@"en"]) {

    }
}

- (void)viewWillLayoutSubviews {
    
    self.m_btnMan.frame = CGRectMake(35, [UIScreen mainScreen].bounds.size.height - 120 - 80, 120, 120);
     self.m_btnUser.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 35-120, [UIScreen mainScreen].bounds.size.height - 120 - 80, 120, 120);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onManagerMode:(id)sender
{
    //save info
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString* libraryDirectory = [paths objectAtIndex:0];

    NSString* myDirectory = [libraryDirectory stringByAppendingPathComponent:@"lechange"];
    NSString* davDirectory = [myDirectory stringByAppendingPathComponent:@"openSDK"];

    NSString* infoPath = [davDirectory stringByAppendingPathComponent:@"info"];
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

    NSString* textTmp = [NSString stringWithFormat:@"[%@][%@][%@]", self.m_textAppId.text, self.m_textAppSecret.text, self.m_textServerInfo.text];
    [textTmp writeToFile:realPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    //end

    if (nil == self.m_textAppId.text || 0 == self.m_textAppId.text.length
        || nil == self.m_textAppSecret.text || 0 == self.m_textAppSecret.text.length) {
        UIStoryboard* currentBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HintViewController* hintView = [currentBoard instantiateViewControllerWithIdentifier:@"HintView"];
        [hintView setInfo:self.m_textAppId.text appSecret:self.m_textAppSecret.text info:NSLocalizedString(CONFIG_TIP_TXT, nil)];
        [self.navigationController pushViewController:hintView animated:NO];
        return;
    }
    [self showLoading];
    self.m_btnMan.enabled = NO;
    dispatch_queue_t enter_device = dispatch_queue_create("enter_device", nil);
    NSString *serverIp = [self parseServerIp:self.m_textServerInfo.text];
    NSInteger serverPort = [self parseServerPort:self.m_textServerInfo.text];
    NSString *appId = self.m_textAppId.text;
    NSString *appSecrect = self.m_textAppSecret.text;
    dispatch_async(enter_device, ^{
        
        NSString* accessTok;
        NSString* errCode;
        NSString* errMsg;
        OpenApiService* openApi = [[OpenApiService alloc] init];
        NSInteger ret = [openApi getAccessToken:serverIp port:serverPort appId:appId appSecret:appSecrect token:&accessTok errcode:&errCode errmsg:&errMsg];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoading];
            self.m_btnMan.enabled = YES;
            if (ret < 0) {
                if ([errCode isEqualToString:@"SN1001"]) {
                    UIStoryboard* currentBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    HintViewController* hintView = [currentBoard instantiateViewControllerWithIdentifier:@"HintView"];
                    [hintView setInfo:self.m_textAppId.text appSecret:self.m_textAppSecret.text info:NSLocalizedString(CONFIG_TIP_TXT, nil)];
                    [self.navigationController pushViewController:hintView animated:NO];
                }
                return;
            }
            UIStoryboard* currentBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            DeviceViewController* devView = [currentBoard instantiateViewControllerWithIdentifier:@"DeviceView"];
            ;
            [self.navigationController pushViewController:devView animated:NO];
            [devView setAdminInfo:accessTok protocol:80 == serverPort ? 0 : 1 address:serverIp port:serverPort];
        });
    });
}
- (void)onUserMode:(id)sender
{
    //save info
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString* libraryDirectory = [paths objectAtIndex:0];

    NSString* myDirectory = [libraryDirectory stringByAppendingPathComponent:@"lechange"];
    NSString* davDirectory = [myDirectory stringByAppendingPathComponent:@"openSDK"];

    NSString* infoPath = [davDirectory stringByAppendingPathComponent:@"info"];
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

    NSString* textTmp = [NSString stringWithFormat:@"[%@][%@][%@]", self.m_textAppId.text, self.m_textAppSecret.text, self.m_textServerInfo.text];
    [textTmp writeToFile:realPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    //end

    if (nil == self.m_textAppId.text || 0 == self.m_textAppId.text.length
        || nil == self.m_textAppSecret.text || 0 == self.m_textAppSecret.text.length) {
        UIStoryboard* currentBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HintViewController* hintView = [currentBoard instantiateViewControllerWithIdentifier:@"HintView"];

        [self.navigationController pushViewController:hintView animated:NO];
        [hintView setInfo:self.m_textAppId.text appSecret:self.m_textAppSecret.text info:NSLocalizedString(CONFIG_TIP_TXT, nil)];
        return;
    }

    UIStoryboard* currentBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    UserModeViewController* userModeView = [currentBoard instantiateViewControllerWithIdentifier:@"UserModeView"];

    [userModeView setAppIdAndSecret:self.m_textAppId.text appSecret:self.m_textAppSecret.text svr:[self parseServerIp:self.m_textServerInfo.text] port:[self parseServerPort:self.m_textServerInfo.text]];
    [self.navigationController pushViewController:userModeView animated:NO];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
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
- (NSString*)parseServerIp:(NSString*)svrInfo
{
    NSArray* arr = [svrInfo componentsSeparatedByString:@":"];
    NSLog(@"parseServerIP[%@],ip[%@]", arr, [arr objectAtIndex:0]);
    return [arr objectAtIndex:0];
}
- (NSInteger)parseServerPort:(NSString*)svrInfo
{
    NSArray* arr = [svrInfo componentsSeparatedByString:@":"];
    NSLog(@"parseServerport[%@]", arr);
    if (arr.count <= 1) {
        if ([[arr objectAtIndex:0] rangeOfString:@"https"].location != NSNotFound) {
            return 443;
        }
        else {
            return 80;
        }
    }
    else {
        return [[arr objectAtIndex:1] intValue];
    }
}

- (void)switchBtnDidTapped:(UISwitch *)sender {
    LCOpenSDK_LogInfo *logInfo = [[LCOpenSDK_LogInfo alloc] init];
    if (sender.isOn) {
        logInfo.levelType = LogLevelTypeDebug;
    }
    else {
        logInfo.levelType = LogLevelTypeFatal;
    }
    [[LCOpenSDK_Log shareInstance] setLogInfo:logInfo];
}

/**
 Ch:显示滚动轮指示器
 En:Show scroll wheel indicator.
 */
- (void)showLoading
{
    [_progressInd startAnimating];
}
/**
 Ch:消除滚动轮指示器
 En:Eliminate scroll wheel indicator.
*/
- (void)hideLoading
{
    if ([_progressInd isAnimating]) {
        [_progressInd stopAnimating];
    }
}

@end
