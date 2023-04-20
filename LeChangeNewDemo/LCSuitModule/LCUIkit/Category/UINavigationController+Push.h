//
//  Copyright © 2019 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (Push)


/**
 跳转到消息
 */
- (void)pushToMessagePage:(NSDictionary *)userInfo;


/**
 跳转到子账户页面
 */
- (void)pushToSubAccountPage:(BOOL)isRegist;

/**
 跳转到乐橙主页
 */
- (void)pushToLeChanegMainPage;

/**
 跳转录像播放
 */
- (void)pushToVideotapePlay;

/**
 跳转设置
 */
- (void)pushToDeviceSettingPage:(id)deviceInfo selectedChannelId:(NSString *) selectedChannelId;

/**
 跳转添加设备扫描页面
 */
- (void)pushToAddDeviceScanPage;

/**
 跳转添加设备输入验证码
 */
- (void)pushToSerialNumberPage;

/**
 跳转产品选择页面页面
 */
- (void)pushToProductChoosePage;

/**
 从导航栏移除

 @param VC 需要移除的控制器
 */
- (void)removeViewController:(UIViewController *)VC;



@end

NS_ASSUME_NONNULL_END
