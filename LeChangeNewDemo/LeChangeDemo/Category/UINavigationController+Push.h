//
//  Copyright © 2019 dahua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (Push)

/**
 跳转到模式选择页面
 */
- (void)pushToModeSelect;

/**
 跳转到用户账号登录
 */
- (void)pushToUserModeLogin;

/**
 跳转到用户账号登录
 */
- (void)pushToUserModeRegist;

/**
 跳转到子账户页面
 */
- (void)pushToSubAccountPage:(BOOL)isRegist;

/**
 跳转到乐橙主页
 */
- (void)pushToLeChanegMainPage;

/**
 跳转到直播预览
 */
- (void)pushToLivePreview;

/**
 跳转用户模式介绍
 */
- (void)pushToUserModeIntroduce;

/**
 跳转管理员模式介绍
 */
- (void)pushToManagerModeIntroduce;

/**
 跳转到全部录像界面 0:云录像 1:本地录像
 */
- (void)pushToVideotapeListPageWithType:(NSInteger)type;

/**
 跳转录像播放
 */
- (void)pushToVideotapePlay;

/**
 跳转云服务
 */
- (void)pushToCloudService;

/**
 跳转设置
 */
- (void)pushToDeviceSettingPage;

/**
 跳转设置移动检测
 */
- (void)pushToDeviceSettingDeploy;

/**
跳转设置网络
*/
- (void)pushToWifiSettings:(NSString *)deviceId;

/**
 跳转设置设备详情
 */
- (void)pushToDeviceSettingDeviceDetail;

/**
 跳转设置设备升级
 */
- (void)pushToDeviceSettingVersion;

/**
 跳转设置修改名称
 */
- (void)pushToDeviceSettingEditName;

/**
 跳转设置修改缩略图
 */
- (void)pushToDeviceSettingEditSnap;

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
