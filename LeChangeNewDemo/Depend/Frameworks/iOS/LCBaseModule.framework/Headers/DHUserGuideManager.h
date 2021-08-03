//
//  Copyright © 2016年 dahua. All rights reserved.
//  修改为用户引导标志管理类

#import <Foundation/Foundation.h>

@interface DHUserGuideManager : NSObject

//单例
+ (instancetype)sharedInstance;

@property (nonatomic, assign) BOOL  needShowPtzHelp;//使用云台，展示云台遮罩；
@property (nonatomic, assign) BOOL  needShowLinkagePtzHelp; //设置视频联动，展示云台遮罩
@property (nonatomic, assign) BOOL  needShowLiveShareAlert;//直播分享弹框；
@property (nonatomic, assign) BOOL  needShowNotificationSwitchAlert;//主页消息通知按钮
@property (nonatomic, assign) BOOL  needOpenNotificationMessageSound;//消息通知声音开关；
@property (nonatomic, assign) BOOL  needOpenNotificationMessageShake;//消息通知震动开关；
@property (nonatomic, assign) BOOL  needOpenHomeAlarmMessageShake;//消息首页显示开关；
@property (nonatomic, assign) BOOL  isFirstUsePanoPic;// 生成全景图；
@property (nonatomic, assign) BOOL  needShowNewFriendFlag; //是否显示乐橙好友添加标志
@property (nonatomic, assign) BOOL  needShowMessagePlayBackHitCoverImageHelp;// 点击封面图看大图引导页
@property (nonatomic, assign) BOOL  needShowMessageSwitchoverVideoHelp;// 点击封面图切换录像引导页
@property (nonatomic, assign) BOOL  needShowPictureSwitchoverVideoHelp;// 点击图片切换录像引导页
@property (nonatomic, assign) BOOL  needShowSplitScreenLiveMonitorHelp;// 预览分屏遮罩
@property (nonatomic, assign) BOOL  needShowMoreOperationLiveMonitorHelp;// 预览更多操作遮罩
@property (nonatomic, assign) BOOL  needShowPageChangeLiveMonitorHelp;// 打开对讲或者录制翻页遮罩
@property (nonatomic, assign) BOOL  needShowDialogLiveMonitorHelp;// 语音交互遮罩
@property (nonatomic, assign) BOOL  needShowWeatherLiveMonitorHelp;// 天气遮罩
@property (nonatomic, assign) BOOL  needShowCloseTalkLiveMonitorHelp;// 关闭对讲遮罩
@property (nonatomic, assign) BOOL  needShowPanoLiveMonitorHelp;// 全景图遮罩
@property (nonatomic, assign) BOOL  needShowCollectionLiveMonitorHelp;// 收藏点遮罩
@property (nonatomic, assign) BOOL  needShowVideoTapeLiveMonitorHelp;// 录像遮罩
@property (nonatomic, assign) BOOL  needShowMarkLiveMonitorHelp;// 时间轴遮罩
@property (nonatomic, assign) BOOL  needShowAllRecordLiveMonitorHelp;// 全部录像遮罩
@property (nonatomic, assign) BOOL  needShowMotionAreaHelp;// 设置动检区域遮罩
@property (nonatomic, assign) BOOL  needShowDeviceShareGuideHelp;// 设置设备分享引导遮罩
@property (nonatomic, assign) BOOL  needShowTouchLoginGuideHelp;// 指纹登录功能引导
@property (nonatomic, assign) int   wifiAutoPairIndex;// WIFI配对index
@property (nonatomic, assign) BOOL  needShowZoomFocusGuideHelp;// 变焦相机功能引导
@property (nonatomic, assign) NSInteger listViewMode; /**< 设备模式/通道模式 */
@property (nonatomic, assign) BOOL  needShowCloudRecordQuickPlayHelp;// 变焦相机功能引导
@property (nonatomic, assign) BOOL  needShowMotionDetectAlertHelp;// 移动检测功能引导
@property (nonatomic, assign) BOOL  needShowAlarmMessageAlertHelp;// 报警消息提醒功能引导
@property (nonatomic, assign) BOOL  needShowSirenHelp;// 警笛功能引导
@property (nonatomic, assign) BOOL  needShowWhiteLightHelp;// 白光灯功能引导
@property (nonatomic, assign) BOOL  needShowSearchLightHelp;// 探照灯功能引导
@property (nonatomic, assign) BOOL  needShowSearchLightLiveSettingHelp;// 实时监控探照灯设置功能引导
@property (nonatomic, assign) BOOL  needShowSearchLightDetailGiud;// 探照灯详情页引导
@property (nonatomic, assign) BOOL  needShowNotificationSetting;//推送通知

// MARK: - SMB引导页标识
@property (nonatomic, assign) BOOL  needShowWorkplatGuideHelp;     // 工作台界面引导
@property (nonatomic, assign) BOOL  needShowOrganizationGuideHelp; // 组织架构界面引导
@property (nonatomic, assign) BOOL  needShowMineGuideHelp;         // 我的界面引导

- (void)loadUserConfig;
- (void)saveUserConfig;
@end
