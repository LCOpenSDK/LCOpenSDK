//
//  LCAdvertisementDetailViewController.m
//  LCIphone
//  Owned by peng_qitao on 16/09/20.
//  Created by zhangyp on 16/6/21.
//  Copyright © 2016年 dahua. All rights reserved.
//

#import "LCAdvertisementDetailViewController.h"
#import "DHAppConfig.h"
#import <DHBaseModule/DHPubDefine.h>
#import "LCMacro.h"
#import <DHBaseModule/LCNotificationKey.h>
#import "UINavigationItem+LeChange.h"
#import <DHBaseModule/DHModuleConfig.h>
//微信SDK头文件
#import "WXApi.h"

#import <sys/utsname.h>
#import "NSString+LeChange.h"
#import <SMBUserModule/DHDataManager.h>
#import <DHBaseModule/UIDevice+IPhoneModel.h>
#import <DHBaseModule/DHMobileInfo.h>
#import <DHBaseModule/DHUserManager.h>
#import <DHBaseModule/LCPermissionHelper.h>
#import <DHBaseModule/NSString+DataConversion.h>
#import <Categories/NSObject+JSON.h>
#import <SMBUserModule/NSString+Account.h>
#import <DHBaseModule/DHWebAuthLoginService.h>
#import <LCWeiKit/LCUserInterface.h>
#import <DHBaseModule/DHBaseModule-Swift.h>
#import <DHHomePageModule/DHHomePageModule-Swift.h>
#import <ContactsUI/CNContactViewController.h>
#import <ContactsUI/CNContactPickerViewController.h>
#import <SMBUserModule/SMBUserModule-Swift.h>
#import <AddressBook/AddressBook.h>

#import "LCIphoneAdhocIP-Swift.h"
#import "LCWebLogViewController.h"

#define ADVERSEMENT_REFRESH 101
#define ADVERSEMENT_SHARE   102
#define ADVERSEMENT_SAFARI  103

#define OPEN_PAGE_MAX       5

static NSInteger WebOpenPageNum = 0;

#ifdef LECHANGE
@interface LCAdvertisementDetailViewController ()<LCWebQRCodeScannerVCDelegate>

@end
#endif

@interface LCAdvertisementDetailViewController ()<CNContactViewControllerDelegate, CNContactPickerDelegate, WKScriptMessageHandler>
{
//    UIButton *_shareBtn;
    UIButton *_testShareBtn;   //用来在发测版本显示分享按钮，便于在safari打开
    UITapGestureRecognizer *_tap; //导航栏连点手势，查看前端日志
}

@property (nonatomic, copy) NSString *wechatRedirectUrl;
@property (nonatomic, copy) NSString *domainString;
@property (nonatomic, copy) NSString *curUrl;
@property (nonatomic, assign) BOOL isAcceptNotificatin;
@property (nonatomic, assign) BOOL isViewLoaded;//是否已经加载  防止viewDidAppera中onresume在viewdidload后调用
@property (nonatomic, strong) NSNumber *openPageNum;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic) BOOL shouldShowMore; //是否调用前端的noticeShowMore
@property (nonatomic) BOOL isShowNavi;//保存隐藏navi之前的状态
@end

@implementation LCAdvertisementDetailViewController

- (void)dealloc
{
    DH_LOG_DEALLOCED
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldShowMore = NO;
    self.curUrl = self.playUrl;
    // Do any additional setup after loading the view.
    self.isShowNavi = self.navBar.isHidden;
    [self initRightNavigationItem];

    self.isAcceptNotificatin = NO;

    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = false;
    }

#ifdef LECHANGE
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayCallBack:) name:LCNotificationAlipayResult object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinPayCallBack:) name:LCNotificationWeixinPayResult object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendLoginInfoToHtml:) name:LCNotificationLoginSuccessed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed:) name:LCNotificationLoginFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeLogin:) name:LCNotificationTouchLoginClose object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResume:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewFriendNoti:) name:LCNotificationNewFriendMsg object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addFriendResult:) name:LCNotificationMyFriendListChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetViewData) name:DHNotificationResetShopAndDiscovery object:nil];
#endif
    //性能测试打印
    if (![DHAppConfig isDistributionVersion]) {
        objc_setAssociatedObject(self, "time", [NSDate date], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        NSLog(@"⏱⏱Performance-Analysis-LechangeShop::Start");
    }
    self.wechatRedirectUrl = [DHServerConfig shareInstance].weixinPayScheme;
    self.domainString = [DHServerConfig shareInstance].weixinPayDomain;
    [self.bridge registerHandler:@"testWXInstall" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testWXInstall: %@", data);
        responseCallback([WXApi isWXAppInstalled] ? @"true" : @"false");
    }];

    [self.bridge registerHandler:@"getAppVersion" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        responseCallback(appCurVersion);
    }];

    [self.bridge registerHandler:@"getAppName" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        responseCallback(appCurName);
    }];

    id<DHWebAuthLoginService> loginService = [DHModule implForService:@protocol(DHWebAuthLoginService)];
    NSString *loginSignUrl = [loginService getSignUrlWithSrcUrl:self.playUrl];
    loginSignUrl = loginSignUrl == nil ? self.playUrl : loginSignUrl;

    [self jsAndOcInteraction:loginSignUrl];

    [self configWebviewUserAgent];
}

- (void)configWebviewUserAgent
{
    __weak typeof(self) weakSelf = self;
    if (@available(iOS 12.0, *)) {
        NSString *baseAgent = [self.webView valueForKey:@"applicationNameForUserAgent"];
        NSString *userAgent = [NSString stringWithFormat:@"%@ Imou", baseAgent];
        [self.webView setValue:userAgent forKey:@"applicationNameForUserAgent"];
    }

    [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        NSString *oldAgent = result;
        if ([oldAgent rangeOfString:@"Imou"].location != NSNotFound) {
            return;
        }

        NSString *newAgent = [NSString stringWithFormat:@"%@ %@", oldAgent, @"Imou"];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newAgent, @"UserAgent", nil];

        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
        [[NSUserDefaults standardUserDefaults] synchronize];

        if (@available(iOS 9.0, *)) {
            [weakSelf.webView setCustomUserAgent:newAgent];
        } else {
            [weakSelf.webView setValue:newAgent forKey:@"applicationNameForUserAgent"];
        }
    }];
}

#pragma mark -- JS和OC交互的方法
- (void)jsAndOcInteraction:(NSString *)signUrl
{
    //拼接clientUA
    NSMutableDictionary *clientUADic = [[NSMutableDictionary alloc]init];

    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *version = [NSString stringWithFormat:@"V%@", appCurVersion];

    NSString *idfv = [DHDataManager sharedInstance].terminalId;

    [clientUADic setObject:@"phone" forKey:@"clientType"];
    [clientUADic setObject:version forKey:@"clientVersion"];
    [clientUADic setObject:[DHServerConfig shareInstance].protocolVersion forKey:@"clientProtocolVersion"];//
    [clientUADic setObject:@"IOS" forKey:@"clientOS"];
    [clientUADic setObject:DH_CLIENT_OS_VERSION forKey:@"clientOV"];
    [clientUADic setObject:[UIDevice lc_iPhoneType] forKey:@"terminalModel"];

    [clientUADic setObject:idfv forKey:@"terminalId"];
    [clientUADic setObject:[DHServerConfig shareInstance].app_id forKey:@"appid"];

    [clientUADic setObject:[NSString dh_currentLanguageCode] forKey:@"language"];
    [clientUADic setObject:[NSNumber numberWithLongLong:[DHDataManager sharedInstance].userId] forKey:@"userId"];//

    [clientUADic setObject:[DHServerConfig shareInstance].project_id forKey:@"project"];
    //[clientUADic setObject:[DHServerConfig shareInstance].caFileName forKey:@"fileName"];
    NSString *clientUAStr = [NSString lc_dictionaryToJson:clientUADic];
    NSString *clientUABase64 = [clientUAStr lc_base64String];

    //公共JS方法,用于向网页传递信息
    [self.bridge registerHandler:@"getClientInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSMutableDictionary *infoDic = [[NSMutableDictionary alloc]init];

        NSString *versions = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *versionTime = [NSString stringWithFormat:@"V%@", versions];

        [infoDic setValue:@"phone" forKey:@"clientType"];//设备类型
        [infoDic setValue:versionTime forKey:@"clientVersion"];//版本号+发测时间
        [infoDic setValue:@"IOS" forKey:@"clientOS"];//手机系统
        [clientUADic setObject:DH_CLIENT_OS_VERSION forKey:@"clientOV"];
        [infoDic setValue:[UIDevice lc_iPhoneType] forKey:@"terminalModel"];//手机型号
        NSString *infoJson = [NSString lc_dictionaryToJson:infoDic];

        responseCallback(infoJson);
    }];

    __weak typeof(self) weakSelf = self;

    //直播和商城JS调用OC的方法  免登录接口,已登录返回免登录信息,未登录返回空
    [self.bridge registerHandler:@"getLoginStatus" handler:^(id data, WVJBResponseCallback responseCallback) {
        if ([DHDataManager sharedInstance].isLogin == YES) {
            NSString *tempUrl = weakSelf.curUrl;
            if ([data isKindOfClass:[NSString class]]) {
                NSString *dataStr = data;

                if (dataStr.length > 0) {
                    tempUrl = dataStr;
                }
            }

            id<DHWebAuthLoginService> loginService = [DHModule implForService:@protocol(DHWebAuthLoginService)];
            NSString *matchUrl = [loginService getSignUrlWithSrcUrl:tempUrl];
            matchUrl = matchUrl == nil ? tempUrl : matchUrl;

            NSString *removeLoginInfoUrl = [[matchUrl stringByReplacingOccurrencesOfString:tempUrl withString:@""] lc_base64String];

            responseCallback(removeLoginInfoUrl);
            return;
        }
        responseCallback(@"");
    }];

#ifdef LECHANGE

    //直播和商城JS调用OC的方法  免登录接口,已登录返回免登录信息,未登录返回空,并去登录
    [self.bridge registerHandler:@"goLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
        weakSelf.isAcceptNotificatin = YES;

        if ([DHDataManager sharedInstance].isLogin == YES) {
            responseCallback([signUrl lc_base64String]);
            return;
        }
        responseCallback(@"");
        //跳转到登录页面

        NSString *urlString = data;
        if ([NSString lc_isEmpty:urlString] && ![NSString lc_isEmpty:weakSelf.webView.URL.absoluteString]) {
            urlString = weakSelf.webView.URL.absoluteString;
        }
        weakSelf.curUrl = urlString;

        dispatch_async(dispatch_get_main_queue(), ^{
                           UIWindow *window = [[UIApplication sharedApplication].delegate window];
                           LCTabBarController *tabBarViewController = (LCTabBarController *)window.rootViewController;
                           UIViewController *vc = tabBarViewController.presentedViewController;
                           if (window != nil && [window.rootViewController isKindOfClass:[LCTabBarController class]]) {
                               if ([vc isKindOfClass:NSClassFromString(@"DHLoginViewController")]) {
                                   [vc dismissViewControllerAnimated:NO completion:nil];
                               }
                           }
                           UIStoryboard *currentStoryboard = [UIStoryboard storyboardWithName:@"User" bundle:[NSBundle mainBundle]];
                           UIViewController *loginVC = [currentStoryboard instantiateViewControllerWithIdentifier:@"login"];
                           //UIViewController *loginVC = [DHRouter objectForURL:@"/lechange/login/loginViewController"];

                           [weakSelf presentViewController:loginVC animated:YES completion:nil];
                       });
    }];
#endif

    //云存储鉴权JS调用OC的方法
    [self.bridge registerHandler:@"getCloudLoginInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSMutableDictionary *infoDic = [[NSMutableDictionary alloc]init];
        //        NSString *username = [NSString stringWithFormat:@"uuid\%@",[DHDataManager sharedInstance].tokenUserName];
        NSString *username = [DHDataManager sharedInstance].tokenUserName;
        NSString *token = [DHDataManager sharedInstance].accessToken;

        if (![NSString lc_isEmpty:username]) {
            [infoDic setObject:username forKey:@"username"];
        }
        if (![NSString lc_isEmpty:token]) {
            [infoDic setObject:token forKey:@"password"];
        }
        [infoDic setObject:clientUABase64 forKey:@"clientUA"];
        [infoDic setObject:[DHDataManager sharedInstance].webServiceDomain forKey:@"host"];

        if (![NSString lc_isEmpty:weakSelf.curDeviceID] && ![NSString lc_isEmpty:weakSelf.curChannelID]) {
            [infoDic setObject:weakSelf.curDeviceID forKey:@"deviceId"];//进入单个设备云存储页面需要传入设备序列号
            [infoDic setObject:weakSelf.curChannelID forKey:@"channelId"];//进入单个设备云存储页面需要传入通道号,单通道设备默认传0
        }

        //配件传deviceId、apId
        if (![NSString lc_isEmpty:weakSelf.curDeviceID] && ![NSString lc_isEmpty:weakSelf.curApID]) {
            [infoDic setObject:weakSelf.curDeviceID forKey:@"deviceId"];
            [infoDic setObject:weakSelf.curApID forKey:@"apId"];
        }

        NSString *infoJson = [NSString lc_dictionaryToJson:infoDic];
        responseCallback(infoJson);
    }];

    //
    [self.bridge registerHandler:@"noticeShowMore" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"%@", data);
    }];

    //云存储状态改变通知 JS调用OC的方法
    [self.bridge registerHandler:@"noticeNative" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *cloudStateChangeDic;

        if ([data isKindOfClass:[NSDictionary class]]) {
            if ([[(NSDictionary *)data objectForKey:@"action"] isEqualToString:@"getUserPushMessageDetail"]) {
                NSString *infoJson = weakSelf.templateParam;
                responseCallback(infoJson);
            }

            //DTS000285608 未进行赋值问题
            cloudStateChangeDic = (NSDictionary *)data;
        } else if ([data isKindOfClass:[NSString class]]) {
            cloudStateChangeDic = [weakSelf dictionaryWithJsonString:data];
        }

        if ([[cloudStateChangeDic objectForKey:@"action"] isEqualToString:@"openPage"]) {//状态改变,刷新缓存
            dispatch_async(dispatch_get_main_queue(), ^{
                               NSDictionary *dict = [cloudStateChangeDic objectForKey:@"param"];
                               NSString *funcUrl = dict[@"funcUrl"];
                               if (WebOpenPageNum >= OPEN_PAGE_MAX) {
                                   NSURL *tempUrl = [NSURL URLWithString:funcUrl];
                                   NSURLRequest *request = [NSURLRequest requestWithURL:tempUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
                                   [weakSelf.webView loadRequest:request];
                               } else {
                                   WebOpenPageNum = WebOpenPageNum + 1;
                                   LCAdvertisementDetailViewController *vc = [LCAdvertisementDetailViewController new];
                                   vc.isOpenPage = YES;
                                   vc.playUrl = funcUrl;
                                   vc.isShowShareButton = YES;
                                   vc.hidesBottomBarWhenPushed = YES;
                                   [weakSelf.navigationController pushViewController:vc animated:YES];
                               }
                           });
        } else if ([[cloudStateChangeDic objectForKey:@"action"] isEqualToString:@"goScanPage"]) {
            //跳转到二维码扫描页
            dispatch_async(dispatch_get_main_queue(), ^{
                               [LCPermissionHelper requestCameraPermission:^(BOOL granted) {
                                   if (granted) {
                                       NSDictionary *dict = [cloudStateChangeDic objectForKey:@"param"];
                                       NSString *description = dict[@"description"];
                                       NSString *iconUrl = dict[@"icon"];

                                       LCWebQRCodeScannerVC *vc = [LCWebQRCodeScannerVC new];
                                       vc.delegate = weakSelf;
                                       [vc.imageView lc_setImageWithUrl:iconUrl];
                                       vc.tipsLbl.text = description;
                                       [weakSelf presentViewController:vc animated:YES completion:nil];
                                   }
                               }];
                           });
        } else if ([[cloudStateChangeDic objectForKey:@"action"] isEqualToString:@"goFamilyPhoto"]) {
        } else if ([[cloudStateChangeDic objectForKey:@"action"] isEqualToString:@"cloudStrategyStateChange"]) {//状态改变,刷新缓存
            dispatch_async(dispatch_get_main_queue(), ^{
                               NSDictionary *dict = [cloudStateChangeDic objectForKey:@"param"];
                               NSNotification *notification = [NSNotification notificationWithName:LCNotificationCloudStoragePaySuccess object:nil userInfo:dict];
                               //通过通知中心发送通知
                               [[NSNotificationCenter defaultCenter] postNotification:notification];
                           });
        } else if ([[cloudStateChangeDic objectForKey:@"action"] isEqualToString:@"logout"]) {//token失效,帐号被踢
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"GetDeviceList", @"ApiName", @"user get out", @"Desc", nil];
            LCError *error = [[LCError alloc] initWithCode:1112 errorInfo:userInfo];

            dispatch_async(dispatch_get_main_queue(), ^{
                               [[NSNotificationCenter defaultCenter] postNotificationName:LCNotificationPasswordChange object:error];
                           });
        } else if ([[cloudStateChangeDic objectForKey:@"action"] isEqualToString:@"updateUserInfo"]) {
            NSDictionary *dict = [cloudStateChangeDic objectForKey:@"param"];

            if (dict) {
                NSString *userId = dict[@"userId"];

                // 绑定成功后需要更新userID
                [DHDataManager sharedInstance].userId = userId.integerValue;

                //更新用户信息
                [LCUserInterface saas_getUserInfoSuccess:^(LCUserInfo *userInfo) {
                    [DHDataManager sharedInstance].userId = userInfo.userId;
                    [DHUserManager shareInstance].nickname = userInfo.nickname;
                    [DHUserManager shareInstance].phone = userInfo.phoneNumber;
                    [DHUserManager shareInstance].email = userInfo.email;
                    [DHUserManager shareInstance].avatarUrl = userInfo.avatarUrl;
                    [DHUserManager shareInstance].avatarMd5 = userInfo.avatarMD5;
                    [DHUserManager shareInstance].countryCode = userInfo.country;

                    //发送第三方账号绑定成功的通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:LCNotificationThirdBindAccountSuccess object:nil];

                    NSLog(@"H5 bind phoneNumber, getUserInfo success");
                } failure:^(LCError *error) {
                    NSLog(@"H5 bind phoneNumber, getUserInfo failure");
                }];
            }
        } else if ([[cloudStateChangeDic objectForKey:@"action"] isEqualToString:@"AIHumanReminderStrategyBuy"]) {
            // 通知
            [DHDataManager sharedInstance].isTimePhotoEnable = @"true";
            [[NSNotificationCenter defaultCenter] postNotificationName:LCNotificationQueryTimePhoto object:nil];
        } else if ([[cloudStateChangeDic objectForKey:@"action"] isEqualToString:@"goAccountSafe"]) {
            [weakSelf handleAccountSafe:cloudStateChangeDic];
        } else if ([[cloudStateChangeDic objectForKey:@"action"] isEqualToString:@"goFriendApply"]) {
            [weakSelf handleFriendApply:cloudStateChangeDic];
        } else if ([[cloudStateChangeDic objectForKey:@"action"] isEqualToString:@"deviceShareStateChange"]) {
            [weakSelf handleDeviceShareStateChange:cloudStateChangeDic];
        } else if ([[cloudStateChangeDic objectForKey:@"action"] isEqualToString:@"apShareStateChange"]) {
            [weakSelf handleApShareStateChange:cloudStateChangeDic];
        } else if ([[cloudStateChangeDic objectForKey:@"action"] isEqualToString:@"goDefenceSetting"]) {
            [weakSelf handleDefenceSet:cloudStateChangeDic];
        } else if ([[cloudStateChangeDic objectForKey:@"action"] isEqualToString:@"goFamily"]) {
        } else if ([[cloudStateChangeDic objectForKey:@"action"] isEqualToString:@"addContact"]) {
#ifdef LECHANGE
            NSDictionary *dic = [cloudStateChangeDic objectForKey:@"param"];
            NSString *name = [dic objectForKey:@"name"];
            NSArray *numbers = [dic objectForKey:@"numbers"];

            NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];

            [LCPermissionHelper requestContacePermission:^(BOOL granted) {
                if (granted) {
                    if (![weakSelf isExitContact:name]) {
                        [weakSelf addNewContaceName:name phoneNumbers:numbers];
                    }
                    [infoDic setObject:@"true" forKey:@"result"];
                    NSString *infoJson = [NSString lc_dictionaryToJson:infoDic];
                    [weakSelf callBack:infoJson];
                }
            } complete:^(NSInteger index) {
                if (index == 1) {
                    [infoDic setObject:@"noloading" forKey:@"result"];
                    NSString *infoJson = [NSString lc_dictionaryToJson:infoDic];
                    [weakSelf callBack:infoJson];
                } else {
                    [infoDic setObject:@"false" forKey:@"result"];
                    NSString *infoJson = [NSString lc_dictionaryToJson:infoDic];
                    [weakSelf callBack:infoJson];
                }
            }];
#endif
        } else if ([[cloudStateChangeDic objectForKey:@"action"] isEqualToString:@"accountCancellation"]) {
            //注销成功 通知App 跳转到登录界面 账号清空
            [weakSelf handleAccountCancellation:cloudStateChangeDic];
        } else if ([[cloudStateChangeDic objectForKey:@"action"] isEqualToString:@"transferDeviceSuccess"]) {
            //设备转移成功，返回到App页面
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];

            //刷新首页数据：参考云存储实现，需要知道设备id、通道id
            NSDictionary *dict = [cloudStateChangeDic objectForKey:@"param"];
            [[NSNotificationCenter defaultCenter] postNotificationName:LCNotificationTransferDeviceSuccess object:nil userInfo:dict];
        } else if ([[cloudStateChangeDic objectForKey:@"action"] isEqualToString:@"getContactPhoneDetail"]) {
            //唤起手机通讯录
            [weakSelf handleShowContact];
        } else if ([[cloudStateChangeDic objectForKey:@"action"] isEqualToString:@"refreshMyFriendRedDot"]) {
        } else if ([[cloudStateChangeDic objectForKey:@"action"] isEqualToString:@"showMoreButton"]) {
            //唤起手机通讯录
            NSDictionary *dict = [cloudStateChangeDic objectForKey:@"param"];
            BOOL canShow = [dict[@"canShow"] boolValue];
            weakSelf.shareBtn.hidden = !canShow;
            weakSelf.shouldShowMore = YES;
        } else if ([[cloudStateChangeDic objectForKey:@"action"] isEqualToString:@"wechatFriends"]) {
        }
        if ([[cloudStateChangeDic objectForKey:@"action"] isEqualToString:@"wechatMoments"]) {
        }
        if ([[cloudStateChangeDic objectForKey:@"action"] isEqualToString:@"openWithBrowser"]) {
            //浏览器打开

            if (weakSelf.webView.URL.absoluteString.length != 0) {
                [[UIApplication sharedApplication ] openURL:weakSelf.webView.URL];
            } else {
                [[UIApplication sharedApplication ] openURL:[NSURL URLWithString:weakSelf.playUrl]];
            }
        }
        if ([[cloudStateChangeDic objectForKey:@"action"] isEqualToString:@"backHome"]) {
            //回到首页

            NSArray<UIViewController *> *list = weakSelf.navigationController.viewControllers;
            UIViewController *target = nil;
            for (UIViewController *vc in list) {
                if ([vc isKindOfClass:[weakSelf class]]) {
                    LCAdvertisementDetailViewController *adVC = (LCAdvertisementDetailViewController *)vc;
                    if (adVC.isOpenPage) {
                        continue;
                    } else {
                        target = adVC;
                        break;
                    }
                } else {
                    target = vc;
                }
            }
            if (target) {
                [weakSelf.navigationController popToViewController:target animated:YES];
            }
        }
    }];

    [self.bridge registerHandler:@"getOauthInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSMutableDictionary *infoDic = [[NSMutableDictionary alloc]init];
        NSString *username = [DHDataManager sharedInstance].tokenUserName;
        NSString *token = [DHDataManager sharedInstance].accessToken;

        if (![NSString lc_isEmpty:username]) {
            [infoDic setObject:username forKey:@"username"];
        } else {
            [infoDic setObject:[DHServerConfig shareInstance].dh_ak forKey:@"username"];
        }

        if (![NSString lc_isEmpty:token]) {
            [infoDic setObject:token forKey:@"password"];
        } else {
            [infoDic setObject:[[DHServerConfig shareInstance].dh_sk lc_base64String] forKey:@"password"];
        }

        [infoDic setObject:clientUABase64 forKey:@"clientUA"];

        NSString *infoJson = [NSString lc_dictionaryToJson:infoDic];
        responseCallback(infoJson);
    }];

    [self.bridge registerHandler:@"applySignIn" handler:^(id data, WVJBResponseCallback responseCallback) {
        dispatch_async(dispatch_get_main_queue(), ^{
                           weakSelf.isAcceptNotificatin = YES;
                           UIWindow *window = [[UIApplication sharedApplication].delegate window];
                           UIViewController *tabBarViewController = window.rootViewController;
                           if (window != nil && [tabBarViewController isKindOfClass:NSClassFromString(@"LCTabBarController")]) {
                               UIViewController *vc = tabBarViewController.presentedViewController;
                               if ([vc isKindOfClass:NSClassFromString(@"DHLoginViewController")]) {
                                   [vc dismissViewControllerAnimated:NO completion:nil];
                               }
                           }

                           UIStoryboard *currentStoryboard = [UIStoryboard storyboardWithName:@"User" bundle:[NSBundle mainBundle]];
                           UIViewController *loginVC = [currentStoryboard instantiateViewControllerWithIdentifier:@"login"];
                           if (loginVC) {
                               [weakSelf presentViewController:loginVC animated:YES completion:nil];
                           }
                       });
    }];
    //SMB
    //注册选择部门
    [self.bridge registerHandler:@"selectDepartment" handler:^(id data, WVJBResponseCallback responseCallback) {
        dispatch_async(dispatch_get_main_queue(), ^{
                           [[NSNotificationCenter defaultCenter] postNotificationName:SMBNotificationSelectDepartment object:data];
                       });
    }];

    //注册选择部门列表
    [self.bridge registerHandler:@"selectDepartmentList" handler:^(id data, WVJBResponseCallback responseCallback) {
        dispatch_async(dispatch_get_main_queue(), ^{
                           [[NSNotificationCenter defaultCenter] postNotificationName:SMBNotificationSelectDepartmentList object:data];
                       });
    }];

    //注册隐藏navi
    [self.bridge registerHandler:@"hideNavigationBar" handler:^(id data, WVJBResponseCallback responseCallback) {
        dispatch_async(dispatch_get_main_queue(), ^{
                           NSString * hide = (NSString *)(NSDictionary *)data[@"param"][@"hiddden"];
                           if ([hide isEqualToString:@"false"]) {
                               self.navBar.hidden = NO;
                           } else {
                               self.navBar.hidden = YES;
                           }
                       });
    }];
}

- (void)addNewContaceName:(NSString *)name phoneNumbers:(NSArray<NSDictionary *> *)phoneNumbers {
}

- (CNMutableContact *)crateServiceContact:(NSString *)name phoneNumber:(NSArray<NSDictionary *> *)phoneNumbers {
    CNMutableContact *contact = [[CNMutableContact alloc] init];
    contact.organizationName = name;

    CNPhoneNumber *mobileNumber = [[CNPhoneNumber alloc] initWithStringValue:[phoneNumbers.firstObject objectForKey:@"phone"]];
    CNLabeledValue *mobilePhone = [[CNLabeledValue alloc] initWithLabel:CNLabelPhoneNumberMobile value:mobileNumber];
    CNPhoneNumber *secondMobileNumber = [[CNPhoneNumber alloc] initWithStringValue:[phoneNumbers.lastObject objectForKey:@"phone"]];
    CNLabeledValue *secondMobilePhone = [[CNLabeledValue alloc] initWithLabel:CNLabelPhoneNumberiPhone value:secondMobileNumber];
    contact.phoneNumbers = @[mobilePhone, secondMobilePhone];
    return contact;
}

- (BOOL)addContact:(CNMutableContact *)contact phoneNumber:(NSString *)name {
    if ([self isExitContact:name]) {
        return false;
    }

    // 创建联系人请求
    CNSaveRequest *saveRequest = [[CNSaveRequest alloc] init];
    [saveRequest addContact:contact toContainerWithIdentifier:nil];
    // 写入联系人
    CNContactStore *store = [[CNContactStore alloc] init];
    return [store executeSaveRequest:saveRequest error:nil];
}

- (CNContact *)isExitContact:(NSString *)organizationName {
    CNContactStore *store = [[CNContactStore alloc] init];
    //检索条件
    NSPredicate *predicate = [CNContact predicateForContactsMatchingName:organizationName];
    //过滤的条件 , ,CNContactEmailAddressesKey,, [CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName]
    NSArray *keysToFetch = @[CNContactEmailAddressesKey, [CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName]];
    NSArray *contact = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keysToFetch error:nil];
    return [contact firstObject];
}

- (void)updateContact:(CNMutableContact *)contact {
    // 创建联系人请求
    CNSaveRequest *saveRequest = [[CNSaveRequest alloc] init];
    [saveRequest updateContact:contact];
    // 重新写入
    CNContactStore *store = [[CNContactStore alloc] init];
    NSError *error = nil;
    BOOL saveStatus = [store executeSaveRequest:saveRequest error:&error];
    if (saveStatus == NO) {
        NSLog(@"%@", error);
    }
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        NSLog(@"json解析失败：%@", err);
        return nil;
    }
    return dic;
}

- (void)viewDidAppear:(BOOL)animated
{
    self.isAcceptNotificatin = NO;
    [super viewDidAppear:YES];

    if (self.disableLockScreen) {
        [UIApplication sharedApplication].idleTimerDisabled = YES;
    }

    if (self.isViewLoaded) {
        [self.bridge callHandler:@"noticeWebviewStatus" data:@{ @"status": @"onResume" }.dh_jsonString responseCallback:^(id responseData) {
            NSLog(@"oc请求js - noticeWebviewStatus 后接受的回调结果：%@", responseData);
        }];
    }
    self.isViewLoaded = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    self.navBar.hidden = self.isShowNavi;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 非线上版本打开前端日志
    if (![DHAppConfig isDistributionVersion]) {
//        [self openWebLog];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 非线上版本关闭前端日志
    if (![DHAppConfig isDistributionVersion]) {
        [self stopWebLog];
    }
}

#pragma mark - Navigation
- (void)initRightNavigationItem
{
    _testShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _testShareBtn.isAccessibilityElement = YES;
    [_testShareBtn setTitle:@"⚠️" forState:UIControlStateNormal];
    [_testShareBtn addTarget:self action:@selector(onRightShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.isAccessibilityElement = YES;
    button.accessibilityIdentifier = @"buttonInInitRightNavItemOfPlaybackCloudVC";
    //    button.frame = CGRectMake(0, 0, 40, 40);

    [button setImage:DH_IMAGENAMED(@"common_image_nav_moreinfo") forState:UIControlStateNormal];
    [button setImage:DH_IMAGENAMED(@"common_image_nav_moreinfo") forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(onRightShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _shareBtn = button;

    if (self.isShowShareButton) {
        self.navigationItem.lc_rightBarButtons = @[_shareBtn];
    }

    //发测版本额外显示一个分享按钮
    if (![DHAppConfig isDistributionVersion]) {
        self.navigationItem.lc_rightBarButtons = self.isShowShareButton ? @[_shareBtn, _testShareBtn] : @[_testShareBtn];
    }

    [self setNavgationLeftItem:NO];
}

- (void)onLeftNaviItemClick:(UIButton *)button
{
    if ([self.webView canGoBack] || self.isOpenPage) {
        //        [self.webView goBack];
        [super onLeftNaviItemClick:nil];
        if (self.isOpenPage) {
            WebOpenPageNum = WebOpenPageNum - 1;
        }
    } else {
        if (self.closeBlock) {
            self.closeBlock();
        }

        if (![NSString lc_isEmpty:_animationTypeStr]) {
            [DHAnimationManager animationType:_animationTypeStr directionType:kDirectionLeft onView:self.navigationController.view];
        }

        [self.navigationController popViewControllerAnimated:YES];
        if ([self.delegate respondsToSelector:@selector(dismissAdvertisementDetailViewController:)]) {
            [self.delegate dismissAdvertisementDetailViewController:self];
        }
    }
}

- (void)onRightShareBtnClick:(UIButton *)button
{
    if (self.shouldShowMore) {
        [self.bridge callHandler:@"noticeShowMore" data:nil responseCallback:^(id responseData) {
            NSLog(@"oc请求js - noticeShowMore 后接受的回调结果：%@", responseData);
        }];
    } else {
        //调用前端方法

        [DHAppStatistics eventWithEvent:advertisement_Share];
        LCSheetView *sheetView;

        sheetView = [[LCSheetView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"common_cancel".lc_T otherButtonTitles:@"common_tip_click_refresh".lc_T, nil];

        [sheetView buttonAtIndex:1].tag = ADVERSEMENT_REFRESH;

        [sheetView showAtView:self.view.window];
    }
}

- (void)setNavgationLeftItem:(BOOL)canGoBack
{
    if (canGoBack || self.isOpenPage) {
        //取消按钮
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        closeButton.frame = CGRectMake(0, 0, 40, 40);
        [closeButton setImage:[UIImage imageNamed:@"common_image_nav_cancel"] forState:UIControlStateNormal];
        [closeButton setImage:[UIImage imageNamed:@"common_image_nav_cancel"] forState:UIControlStateHighlighted];
        [closeButton addTarget:self action:@selector(onCloseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.lc_rightBarButtons = self.isShowShareButton ? @[closeButton, _shareBtn] : @[closeButton];

        //发测版本额外显示一个分享按钮
        if (![DHAppConfig isDistributionVersion]) {
            self.navigationItem.lc_rightBarButtons = self.isShowShareButton ? @[closeButton, _shareBtn, _testShareBtn, ] : @[closeButton, _testShareBtn];
        }
    } else {
        self.navigationItem.lc_rightBarButtons = self.isShowShareButton ? @[_shareBtn] : nil;

        //发测版本额外显示一个分享按钮
        if (![DHAppConfig isDistributionVersion]) {
            self.navigationItem.lc_rightBarButtons = self.isShowShareButton ? @[_shareBtn, _testShareBtn] : @[_testShareBtn];
        }
    }
}

//关闭整个webViewController
- (void)onCloseButtonClick:(UIButton *)btn
{
    if (self.closeBlock) {
        self.closeBlock();
    } else {
        //反序遍历导航栈
        NSArray<UIViewController *> *vcs = [[self.navigationController.viewControllers reverseObjectEnumerator] allObjects];
        UIViewController *pop2VC = nil;
        for (UIViewController *vc in vcs) {
            if ([vcs isMemberOfClass:[self class]]) {
                continue;
            } else {
                pop2VC = vc;
            }
        }

        if (pop2VC) {
            [self.navigationController popToViewController:pop2VC animated:YES];
        } else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }

    WebOpenPageNum = 0;

    if (![NSString lc_isEmpty:_animationTypeStr]) {
        [DHAnimationManager animationType:_animationTypeStr directionType:kDirectionLeft onView:self.navigationController.view];
    }

    if ([self.delegate respondsToSelector:@selector(dismissAdvertisementDetailViewController:)]) {
        [self.delegate dismissAdvertisementDetailViewController:self];
    }
}

#pragma mark - H5 交互
- (void)handleDefenceSet:(NSDictionary *)cloudStateChangeDic
{
    NSDictionary *dict = [cloudStateChangeDic objectForKey:@"param"];

    NSMutableDictionary<NSString *, NSString *> *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"deviceId"] = dict[@"deviceId"];
    userInfo[@"channelId"] = dict[@"channelId"];

    //不在线跳转到设备详情，在线跳转到防护配置
    id<IDHDeviceListManager> deviceManager = [DHModule implForService:@protocol(IDHDeviceListManager)];
    DHORMChannelObject *channelObject = [deviceManager getChannelWithDeviceId:dict[@"deviceId"] channelId:dict[@"channelId"]];
    if ([channelObject.status isEqualToString:@"online"]) {
        UIViewController *vc = [DHRouter objectForURL:@"/lechange/devicemanager/defenceset" withUserInfo:userInfo];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        UIViewController *vc = [DHRouter objectForURL:@"/lechange/devicemanager/deviceDetail" withUserInfo:userInfo];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)handleApShareStateChange:(NSDictionary *)cloudStateChangeDic
{
}

- (void)handleDeviceShareStateChange:(NSDictionary *)cloudStateChangeDic
{
}

- (void)handleFriendApply:(NSDictionary *)cloudStateChangeDic {
}

- (void)handleAccountSafe:(NSDictionary *)cloudStateChangeDic {
}

- (void)handleAccountCancellation:(NSDictionary *)cloudStateChangeDic {
    //【*】国内使用H5进行注销，海外是native的； 清除用户登录信息
    if ([DHModuleConfig shareInstance].isLeChange) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LCNotificationPasswordChange object:nil];
        [DHDataManager sharedInstance].username = nil;
    }
}

//点击通讯录查询按钮
- (void)handleShowContact
{
}

#pragma mark - DHAddressBookDelegate
- (void)selected:(NSString *)name phoneNumber:(NSString *)phoneNumber {
    NSString *purePhoneNumber = phoneNumber.dh_conversionPhoneNumber;
    //获取到手机通讯录联系人返回数据给h5
    NSDictionary *phoneDict = @{ @"phone": purePhoneNumber };
    NSMutableArray *resultArray = [[NSMutableArray alloc]initWithObjects:phoneDict, nil];
    [self callHandlerNoticeWebviewPhoneResult:resultArray];
}

- (void)selectPhoneNumbers:(NSArray *)phoneNumbers {
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < phoneNumbers.count; i++) {
        NSString *purePhoneNumber = phoneNumbers[i];
        //获取到手机通讯录联系人返回数据给h5
        NSDictionary *phoneDict = @{ @"phone": purePhoneNumber.dh_conversionPhoneNumber };
        [resultArray addObject:phoneDict];
    }
    [self callHandlerNoticeWebviewPhoneResult:resultArray];
}

- (void)callHandlerNoticeWebviewPhoneResult:(NSMutableArray *)resultArray
{
    NSDictionary *dict = @{ @"result": resultArray };
    //回调数据给h5
    [self.bridge callHandler:@"noticeWebviewPhoneResult" data:dict.dh_jsonString responseCallback:^(id responseData) {
        NSLog(@"oc请求js后接受的回调结果：%@", responseData);
    }];
}

#pragma mark - MMSheetView Delegate

- (void)sheetView:(LCSheetView *)sheetView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIButton *btn = [sheetView buttonAtIndex:buttonIndex];

    if (btn.tag == ADVERSEMENT_REFRESH) {
        [self.webView reload];
    } else if (btn.tag == ADVERSEMENT_SHARE) {
    } else if (btn.tag == ADVERSEMENT_SAFARI) {
        if (self.webView.URL.absoluteString.length != 0) {
            [[UIApplication sharedApplication ] openURL:self.webView.URL];
        } else {
            [[UIApplication sharedApplication ] openURL:[NSURL URLWithString:self.playUrl]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#ifdef LECHANGE
#pragma mark - Notifications
- (void)alipayCallBack:(NSNotification *)notification
{
    [self processWithAlipayResult:notification.object];
}

- (void)weixinPayCallBack:(NSNotification *)notification
{
    //[self.webView goBack];
    [super onLeftNaviItemClick:nil];

    //根据url网页获取标题
    [self.webView evaluateJavaScript:@"document.title"  completionHandler:^(NSString *response, NSError *_Nullable error) {
        if (response.length != 0) {
            self.title = response;
        }
    }];
}

- (void)sendLoginInfoToHtml:(NSNotification *)notification
{
    if (self.isAcceptNotificatin) {
        id<DHWebAuthLoginService> loginService = [DHModule implForService:@protocol(DHWebAuthLoginService)];
        NSString *matchUrl = [loginService getSignUrlWithSrcUrl:self.curUrl];
        matchUrl = matchUrl == nil ? self.curUrl : matchUrl;
        //直播和商城OC调用JS的方法  APP通知H5登录成功接口,入参免登录信息
        [self.bridge callHandler:@"getLoginInfo" data:[matchUrl lc_base64String] responseCallback:^(id responseData) {
            NSLog(@"oc请求js后接受的回调结果：%@", responseData);
        }];

        [self.bridge callHandler:@"noticeSignInResult" data:@{ @"result": @"true" }.dh_jsonString responseCallback:^(id responseData) {
            NSLog(@"oc请求js后接受的回调结果：%@", responseData);
        }];
    }
}

- (void)loginFailed:(NSNotification *)notification
{
    if (self.isAcceptNotificatin) {
        [self.bridge callHandler:@"noticeSignInResult" data:@{ @"result": @"false" }.dh_jsonString responseCallback:^(id responseData) {
            NSLog(@"oc请求js后接受的回调结果：%@", responseData);
        }];
    }
}

- (void)closeLogin:(NSNotification *)notification
{
    if (self.isAcceptNotificatin) {
        //直播和商城OC调用JS的方法  登录页面主动关闭,回传html地址给前端
        [self.bridge callHandler:@"getLoginInfo" data:[self.curUrl lc_base64String] responseCallback:^(id responseData) {
            NSLog(@"oc请求js后接受的回调结果：%@", responseData);
        }];
    }
}

/*
 9000——订单支付成功
 8000——正在处理中
 4000——订单支付失败
 5000——重复请求
 6001——用户中途取消
 6002——网络连接出错 */
- (void)processWithAlipayResult:(NSDictionary *)dicResult
{
    NSString *resultStatus =  [dicResult objectForKey:@"resultCode"];
    if ([resultStatus isEqualToString:@"9000"]) {
        NSString *returnUrl = dicResult[@"returnUrl"];

        if (returnUrl.length > 0) {
            //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:returnUrl]];
            [self.webView goBack];
        }
    } else {
    }
}

- (void)onResume:(NSNotification *)notification {
    [self.bridge callHandler:@"noticeWebviewStatus" data:@{ @"status": @"onResume" }.dh_jsonString responseCallback:^(id responseData) {
        NSLog(@"oc请求js - noticeWebviewStatus 后接受的回调结果：%@", responseData);
    }];
}

- (void)addFriendResult:(NSNotification *)notification {
    [self.bridge callHandler:@"noticeAddFriendSuccess"];
}

- (void)addNewFriendNoti:(NSNotification *)notification {
    //h5刷新页面
    [self.bridge callHandler:@"noticeNewFriendAdd"];
}

- (void)resetViewData
{
    // 返回webView首层级并刷新下页面
    if ([self.webView canGoBack]) {
        WKBackForwardListItem *item = [[[self.webView backForwardList] backList] objectAtIndex:0];
        [self.webView goToBackForwardListItem:item];
    }
    [self.webView reload];
}

- (void)callBack:(NSString *)infoJson {
    [self.bridge callHandler:@"noticeAddContactResult" data:infoJson responseCallback:^(id responseData) {
    }];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    [super webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
}

#endif
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    [super webView:webView didFinishNavigation:navigation];

    [self setNavgationLeftItem:webView.canGoBack];
}

- (id<IDHDeviceListManager>)listManager {
    return [DHModule implForService:@protocol(IDHDeviceListManager)];
}

#pragma mark - LCWebQRCodeScannerVCDelegate

- (void)scanResultWithText:(NSString *)text
{
//    noticeH5ScanResult//
    [self.bridge callHandler:@"noticeH5ScanResult" data:@{ @"result": text.lc_base64String }.dh_jsonString responseCallback:^(id responseData) {
    }];
}

#pragma mark - OpenPage 个数统计
//- (NSInteger)numOfOpenPage

#pragma mark - 日志搜集
- (void)openWebLog
{
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"log"];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"error"];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"warn"];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"info"];

    [self addJSScript];

    if (!_tap) {
        // 添加手势，触发进入LogVC
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLogVC)];
        [_tap setNumberOfTapsRequired:5];     // 设置当前需要点击的次数
        [_tap setNumberOfTouchesRequired:1];  // 设置当前需要触发事件的手指数量
        [self.navBar addGestureRecognizer:_tap];
    }
}

- (void)stopWebLog {
    //移除Handler
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"log"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"error"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"warn"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"info"];
    //移除JSScript
    [self.webView.configuration.userContentController removeAllUserScripts];
}

- (void)addJSScript
{
    // 重新console方法
    NSString *jsLogCode = @"console.log = (function(oriLogFunc){\
    return function(str)\
    {\
    window.webkit.messageHandlers.log.postMessage(str);\
    oriLogFunc.call(console,str);\
    }\
    })(console.log);";

    NSString *jsErrorCode = @"console.error = (function(oriLogFunc){\
    return function(str)\
    {\
    window.webkit.messageHandlers.error.postMessage(str);\
    oriLogFunc.call(console,str);\
    }\
    })(console.error);";

    NSString *jsWarnCode = @"console.warn = (function(oriLogFunc){\
    return function(str)\
    {\
    window.webkit.messageHandlers.warn.postMessage(str);\
    oriLogFunc.call(console,str);\
    }\
    })(console.warn);";

    NSString *jsInfoCode = @"console.info = (function(oriLogFunc){\
    return function(str)\
    {\
    window.webkit.messageHandlers.info.postMessage(str);\
    oriLogFunc.call(console,str);\
    }\
    })(console.info);";

    // 注入JS
    [self.webView.configuration.userContentController addUserScript:[[WKUserScript alloc] initWithSource:jsLogCode injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES]];
    [self.webView.configuration.userContentController addUserScript:[[WKUserScript alloc] initWithSource:jsErrorCode injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES]];
    [self.webView.configuration.userContentController addUserScript:[[WKUserScript alloc] initWithSource:jsWarnCode injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES]];
    [self.webView.configuration.userContentController addUserScript:[[WKUserScript alloc] initWithSource:jsInfoCode injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES]];
}

// JS回调
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    // 目前前端打印的日志，只有字符串和数字
    NSString *str;
    if ([message.body isKindOfClass:[NSString class]]) {
        str = [message.body stringByReplacingOccurrencesOfString:@"\n" withString:@""];   // 会有多行字符串的打印，去掉换行符，否则过滤时会有问题
    } else if ([message.body isKindOfClass:[NSNumber class]]) {
        str = [NSString stringWithFormat:@"%@", message.body];
    }
    NSLog(@"【Web %@】 Source: %@  Content: %@", message.name, message.webView.URL, str);
}

// 跳转到查看日志的控制器
- (void)showLogVC
{
    LCWebLogViewController *logVC = [[LCWebLogViewController alloc]init];
    [self presentViewController:logVC animated:YES completion:nil];
}

@end
