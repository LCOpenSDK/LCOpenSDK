//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "UINavigationController+Push.h"
#import "LCSubAccountViewController.h"
#import "LeChangeDemo-Swift.h"
#import <LCDeviceDetailModule/LCDeviceDetailModule.h>
#import <LCDeviceDetailModule/LCDeviceDetailModule-Swift.h>


@implementation UINavigationController (Push)

/**
 跳转到消息
 */
- (void)pushToMessagePage:(NSDictionary *)userInfo {
    UIViewController *messagePage = [LCRouter objectForURL:@"messageModule_MessageList" withUserInfo:userInfo];
    if (messagePage) {
        [self pushViewController:messagePage animated:YES];
    }
    NSLog(@"===>  pushToMessagePage");
}


/**
 跳转到子账户页面
 */
- (void)pushToSubAccountPage:(BOOL)isRegist  {
    LCSubAccountViewController *subAccountPage = [[LCSubAccountViewController alloc] init];
    subAccountPage.isRegist = isRegist;
    [self pushViewController:subAccountPage animated:YES];
}
/**
 跳转到乐橙主页
 */
- (void)pushToLeChanegMainPage {
    UIViewController *mainPage = [[LCDeviceListViewController alloc] init];
    mainPage.title = @"device_manager_list_title".lc_T;
    [self pushViewController:mainPage animated:YES];
}

/**
 跳转录像播放
 */
- (void)pushToVideotapePlay {
    UIViewController *videotapePlay = [(UIViewController *)[NSClassFromString(@"LCVideotapePlayerViewController") alloc] init];
    [self pushViewController:videotapePlay animated:YES];
}


/**
 跳转设置主页面
 */
- (void)pushToDeviceSettingPage:(LCDeviceInfo *)deviceInfo selectedChannelId:(NSString *) selectedChannelId {
    LCChannelInfo *selectedChannel = nil;
    for (LCChannelInfo *channel in deviceInfo.channels) {
        if ([channel.channelId isEqualToString:selectedChannelId]) {
            selectedChannel = channel;
            break;
        }
    }
    LCDeviceDetailPresenter *presenter = [[LCDeviceDetailPresenter alloc] initWithDeviceInfo:deviceInfo selectedChannelId:selectedChannelId];
    LCDeviceDetailVC *deviceDetail = [[LCDeviceDetailVC alloc] init];
    deviceDetail.title = @"setting_device_device_info_title".lc_T;
    deviceDetail.presenter = presenter;
    presenter.viewController = deviceDetail;
    [self pushViewController:deviceDetail animated:YES];
}

/**
 跳转添加设备扫描页面
 */
- (void)pushToAddDeviceScanPage {
    //【*】路由跳转设备添加模块
    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    
    //【*】无权限时，可以手动输入序列号
    [self router:@"/lechange/addDevice/qrScanVC" UserInfo:userInfo];
    [LCPermissionHelper requestCameraPermission:^(BOOL granted) {
        
    }];
}

/**
 跳转添加输入验证码扫描页面
 */
- (void)pushToSerialNumberPage {
    UIViewController *addDeviceSerialNumberVC = [(UIViewController *)[NSClassFromString(@"LCInputSerialNumberViewController") alloc] init];
    addDeviceSerialNumberVC.title = @"Add_Device_Title".lc_T;
    [self pushViewController:addDeviceSerialNumberVC animated:YES];
}

/**
 跳转产品选择页面页面
 */
- (void)pushToProductChoosePage {
    UIViewController *productPage = [(UIViewController *)[NSClassFromString(@"LCProductListViewController") alloc] init];
    productPage.title = @"Add_Device_Title".lc_T;
    [self pushViewController:productPage animated:YES];
}

//MARK: - Private Methods

/**
 * 获取当前呈现的ViewController
 */
- (UIViewController *)getCurrentViewController {
    UIViewController *result = nil;

    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }

    UIView *frontView = [window subviews].firstObject;
    id nextResponder = [frontView nextResponder];

    if ([nextResponder isKindOfClass:[UIViewController class]]) result = nextResponder;
    else result = window.rootViewController;

    return result;
}

- (void)removeViewController:(UIViewController *)VC {
    //倒序搜，保证只移除最近一个
    NSMutableArray *tempVCA = [NSMutableArray arrayWithArray:self.viewControllers];
    NSUInteger index = tempVCA.count - 1;
    while (index >= 0) {
        UIViewController *tempVC = (UIViewController *)tempVCA[index];
        if ([tempVC isKindOfClass:[VC class]]) {
            [tempVCA removeObject:tempVC];
            break;
        }
        index--;
    }

    self.viewControllers = tempVCA;
}

- (void)router:(NSString *)url UserInfo:(NSMutableDictionary *)userInfo {
    UIViewController *vc = [LCRouter objectForURL:url withUserInfo:userInfo];
    if (vc) {
        [self pushViewController:vc animated:YES];
    }
}

@end
