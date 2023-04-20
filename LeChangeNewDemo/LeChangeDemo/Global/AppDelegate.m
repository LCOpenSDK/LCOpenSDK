//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "AppDelegate.h"
#import "LCAccountJointViewController.h"
#import "LCToolKit.h"
#import "LCUIKit.h"
#import <LCBaseModule/LCPermissionHelper.h>
#import <LCBaseModule/LCLogManager.h>
#import <LCBaseModule/LCModule.h>
#import <LCAddDeviceModule/LCAddDeviceModule-Swift.h>
#import <LCNewPlayBackModule/LCNewPlayBackRouter.h>
#import <LCMessageModule/LCMessageModule-Swift.h>

@interface AppDelegate ()

@property (strong, nonatomic) LCPermissionHelper *helper;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    NSString *addDeviceModule = NSStringFromClass([LCAddDeviceModule class]);
    NSString *newPlaybackModule = NSStringFromClass([LCNewPlayBackRouter class]);
    NSString *messageModule = NSStringFromClass([LCMessageRouter class]);
    //【*】加载模块，如果外部代码没有引用，则无法加载
    [LCModule loadModuleByNameArray:@[addDeviceModule, newPlaybackModule, messageModule]];

    [[LCUserManager shareInstance] getUserConfigFile];
    
    [LCLogManager shareInstance].maxLogSize = 10;
    [LCLogManager shareInstance].isCycle = YES;
    [[LCLogManager shareInstance] startFileLog];
    
    self.window = [[UIWindow alloc] initWithFrame:SCREEN_BOUNDS];
    LCAccountJointViewController *vc = [LCAccountJointViewController new];
    LCNavigationController *navi = [[LCNavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
    [LCNetTool lc_ObserveNetStatus:^(LCNetStatus status) {
        
    }];
    
    //权限申请
    self.helper = [LCPermissionHelper new];
    
    [LCPermissionHelper requestAlbumPermission:^(BOOL granted) {
    }];
    
    [LCPermissionHelper requestAudioPermission:^(BOOL granted) {
    }];
    
    [LCPermissionHelper requestCameraPermission:^(BOOL granted) {
    }];
    
    [self.helper requestAlwaysLocationPermissions:YES completion:^(BOOL granted) {
        
    }];
    
    [[LCNetWorkHelper sharedInstance] checkNetwork]; //检测网络，接口已修改为异步，不影响程序启动流程
    
    if ([self isCanExplorerForCydiaUrlScheme]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [LCProgressHUD showMsg:@"the_mobile_phone_has_been_jailbroken".lc_T];
        });
    }
    
    return YES;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark - Check Jailbreak
- (BOOL)isCanExplorerForCydiaUrlScheme {
    NSURL *url = [NSURL URLWithString:@"cydia://"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        NSLog(@" %@:: The device is jail broken!", NSStringFromClass([self class]));
        return YES;
    }
    
    return NO;
}

@end
