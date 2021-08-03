//
//  Copyright © 2019 dahua. All rights reserved.
//

#import "UINavigationController+Push.h"
#import "LCDeviceSettingViewController.h"
#import "LCVideotapeListViewController.h"
#import "LCSubAccountViewController.h"


@implementation UINavigationController (Push)

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
    UIViewController *mainPage = [(UIViewController *)[NSClassFromString(@"LCDeviceListViewController") alloc] init];
    mainPage.title = @"device_manager_list_title".lc_T;
    [self pushViewController:mainPage animated:YES];
}



/**
 跳转到直播预览
 */
- (void)pushToLivePreview {
    UIViewController *livePreview = [(UIViewController *)[NSClassFromString(@"LCLivePreviewViewController") alloc] init];
    [self pushViewController:livePreview animated:YES];
}

/**
 跳转录像播放
 */
- (void)pushToVideotapePlay {
    UIViewController *videotapePlay = [(UIViewController *)[NSClassFromString(@"LCVideotapePlayerViewController") alloc] init];
    [self pushViewController:videotapePlay animated:YES];
}

/**
 跳转到用户模式简介
 */
- (void)pushToUserModeIntroduce {
    UIViewController *introduceVC = [(UIViewController *)[NSClassFromString(@"LCModeIntroduceViewController") alloc] init];
    introduceVC.title = @"Mode_Introduce_User_Title".lc_T;
    [self pushViewController:introduceVC animated:YES];
}

/**
 跳转到管理员模式简介
 */
- (void)pushToManagerModeIntroduce {
    UIViewController *introduceVC = [(UIViewController *)[NSClassFromString(@"LCModeIntroduceViewController") alloc] init];
    introduceVC.title = @"Mode_Introduce_Manager_Title".lc_T;
    [self pushViewController:introduceVC animated:YES];
}

/**
 跳转到全部录像界面
 */
- (void)pushToVideotapeListPageWithType:(NSInteger)type {
    LCVideotapeListViewController *videotape = [[LCVideotapeListViewController alloc] init];
    videotape.defaultType = type;
    [self pushViewController:videotape animated:YES];
}
/**
 跳转云服务
 */
- (void)pushToCloudService {
    UIViewController *cloudService = [(UIViewController *)[NSClassFromString(@"LCWebViewController") alloc] init];
    cloudService.title = @"云服务";
    [self pushViewController:cloudService animated:YES];
}

/**
 跳转设置主页面
 */
- (void)pushToDeviceSettingPage {
    LCDeviceSettingViewController *deviceSetting = [[LCDeviceSettingViewController alloc] init];
    deviceSetting.style = LCDeviceSettingStyleMainPage;
    deviceSetting.title = @"setting_device_device_info_title".lc_T;
    [self pushViewController:deviceSetting animated:YES];
}

/**
 跳转设置移动检测
 */
- (void)pushToDeviceSettingDeploy {
    LCDeviceSettingViewController *deviceSetting = [[LCDeviceSettingViewController alloc] init];
    deviceSetting.style = LCDeviceSettingStyleDeploy;
    deviceSetting.title = @"setting_device_deployment_switch".lc_T;
    [self pushViewController:deviceSetting animated:YES];
}

/**
跳转设置网络
*/
- (void)pushToWifiSettings:(NSString *)deviceId {
    //【*】路由跳转设备添加模块
    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    userInfo[@"deviceId"] = deviceId;
    [self router:@"/lechange/adddevice/onlineWifiConfig" UserInfo:userInfo];
}

/**
 跳转设置设备详情
 */
- (void)pushToDeviceSettingDeviceDetail {
    LCDeviceSettingViewController *deviceSetting = [[LCDeviceSettingViewController alloc] init];
    deviceSetting.style = LCDeviceSettingStyleDeviceDetailInfo;
    deviceSetting.title = @"setting_device_device_info_title".lc_T;
    [self pushViewController:deviceSetting animated:YES];
}

/**
 跳转设置设备升级
 */
- (void)pushToDeviceSettingVersion {
    LCDeviceSettingViewController *deviceSetting = [[LCDeviceSettingViewController alloc] init];
    deviceSetting.style = LCDeviceSettingStyleVersionUp;
    deviceSetting.title = @"setting_device_version".lc_T;
    [self pushViewController:deviceSetting animated:YES];
}

/**
 跳转设置修改名称
*/
- (void)pushToDeviceSettingEditName {
    LCDeviceSettingViewController *deviceSetting = [[LCDeviceSettingViewController alloc] init];
    deviceSetting.style = LCDeviceSettingStyleDeviceNameEdit;
    deviceSetting.title = @"setting_device_device_info_title".lc_T;
    [self pushViewController:deviceSetting animated:YES];
}


/**
 跳转设置修改缩略图
 */
- (void)pushToDeviceSettingEditSnap {
    LCDeviceSettingViewController *deviceSetting = [[LCDeviceSettingViewController alloc] init];
    deviceSetting.style = LCDeviceSettingStyleDeviceSnap;
    [self pushViewController:deviceSetting animated:YES];
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
    UIViewController *vc = [DHRouter objectForURL:url withUserInfo:userInfo];
    if (vc) {
        [self pushViewController:vc animated:YES];
    }
}

@end
