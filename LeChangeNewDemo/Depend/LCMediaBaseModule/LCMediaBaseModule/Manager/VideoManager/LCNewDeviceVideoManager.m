//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "LCNewDeviceVideoManager.h"
#import <UIKit/UIKit.h>

static LCNewDeviceVideoManager * manager = nil;

@implementation LCNewDeviceVideoManager

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [LCNewDeviceVideoManager new];
        manager.isPlay = NO;
        manager.pausePlay = NO;
        manager.isSD = NO;
        manager.isSoundOn = YES;
        manager.isFullScreen = NO;
        manager.isOpenCloudStage = NO;
        manager.isOpenAudioTalk = NO;
        manager.isOpenRecoding = NO;
        manager.isLockFullScreen = NO;
        manager.playSpeed = 1;
        manager.directionTouch = NO;
    });
    return manager;
}

- (LCChannelInfo *)currentChannelInfo {
    if (self.currentChannelIndex == -1) {
        if (self.currentDevice.channels.count == 1) {
            return self.currentDevice.channels[0];
        }
        return nil;
    }
    if (self.currentDevice.channels.count > 0) {
        LCChannelInfo *channel = self.currentDevice.channels[self.currentChannelIndex];
        return channel;
    }
    return nil;
}

- (NSString *)currentPsk {
    if (!_currentPsk || _currentPsk.length == 0) {
       return self.currentDevice.deviceId;
    }
    return _currentPsk;
}

-(void)setIsFullScreen:(BOOL)isFullScreen{
    _isFullScreen = isFullScreen;
    self.getCurrentVC.navigationController.interactivePopGestureRecognizer.enabled = !isFullScreen;
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [self getViewControllerWindow].rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

//获取RootViewController所在的window
- (UIWindow*)getViewControllerWindow{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [UIApplication sharedApplication].windows;
        for (UIWindow *target in windows) {
            if (target.windowLevel == UIWindowLevelNormal) {
                window = target;
                break;
            }
        }
    }
    return window;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        while ([rootVC presentedViewController]) {
            rootVC = [rootVC presentedViewController];
        }
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
        
    }
    
    return currentVC;
}


@end
