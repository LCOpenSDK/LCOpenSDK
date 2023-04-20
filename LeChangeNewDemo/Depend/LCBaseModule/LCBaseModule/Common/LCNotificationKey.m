//
//  Copyright © 2016年 Imou. All rights reserved.
//

#import "LCNotificationKey.h"

NSString *const LCNotificationUnbindDeviceUpdated = @"LCNotificationUnbindDeviceUpdated";
NSString *const LCNotificationUnbindDeviceNew = @"LCNotificationUnbindDeviceNew";
NSString *const LCNotificationDeviceChange       = @"LCNotificationDeviceChange";
NSString *const LCNotificationDeviceMaskChange   = @"LCNotificationDeviceMaskChange";
NSString *const LCNotificationGetDeviceFail       = @"LCNotificationGetDeviceFail";
NSString *const LCNotificationUpdateDeviceList   = @"LCNotificationUpdateDeviceList";
NSString *const LCNotificationUpdateAddFriendMsg = @"LCNotificationUpdateAddFriendMsg";
NSString *const LCNotificationAddFriendRequst    = @"LCNotificationAddFriendRequst";
NSString *const LCNotificationChangeFriendRemarkName    = @"LCNotificationChangeFriendRemarkName";
NSString *const LCNotificationNewFriendMsg    = @"LCNotificationNewFriendMsg";
NSString *const LCNotificationNewFriendMsgReadStateChanged = @"LCNotificationNewFriendMsgReadStateChanged";
NSString *const LCNotificationCouponReadStateChanged = @"LCNotificationCouponReadStateChanged";
NSString *const LCNotificationMyFriendListChanged = @"LCNotificationMyFriendListChanged";
NSString *const LCNotificationPasswordChange     = @"LCNotificationPasswordChange";                          //设备处于休眠
NSString *const LCNotificationDeviceSleep     = @"LCNotificationDeviceSleep";                              //todo WEIKIT中还存在这个  需要一起修改
NSString *const LCNotificationUserAccountLock = @"LCNotificationUserAccountLock";
NSString *const LCNotificationSDCardStatusChange = @"LCNotificationSDCardStatusChange";
NSString *const LCNotificationUpgradeDevice      = @"LCNotificationUpgradeDevice";
NSString *const LCNotificationUpgradeAp          = @"LCNotificationUpgradeAp";
NSString *const LCNotificationPlugInPlanChanged  = @"LCNotificationPlugInPlanChanged";
NSString *const LCNotificationSystemAlarmFired   = @"LCNotificationSystemAlarmFired";
NSString *const LCNotificationWifiNetWorkChange  = @"LCNotificationWifiNetWorkChange";
NSString *const LCNotificationWifiNetWorkDidSwitch  = @"LCNotificationWifiNetWorkDidSwitch";//Wi-Fi之间的切换：如wifi1切换到wifi2
NSString *const LCNotificationCountDownEnd       = @"LCNotificationCountDownEnd";
NSString *const LCNotificationFriendListChanged  = @"LCNotificationFriendListChanged";
NSString *const LCNotificationRemarkNameChanged  = @"LCNotificationRemarkNameChanged";
NSString *const LCNotificationCTCallState        = @"LCNotificationCTCallState";
NSString *const LCNotificationMessageAlarmFired  = @"MESSAGEALARMFIRED";                            //todo LCManager 中也有这个宏 需要一起修改
NSString *const LCNotificationNewAlarmMsg        = @"LCNotificationNewAlarmMsg";
NSString *const LCNotificationNewAlarmMsgFromHome = @"LCNotificationNewAlarmMsgFromHome";    //从首页消息跳转消息详情通知
NSString *const LCNotificationSelectedHomePage        = @"LCNotificationSelectedHomePage";
NSString *const LCNotificationNoMsgDetailFromHome = @"LCNotificationNoMsgDetailFromHome"; //点击首页消息跳转详情,但无消息详情通知
NSString *const LCNotificationNewAlarmMsgNeedUpdateMsgList        = @"LCNotificationNewAlarmMsgNeedUpdateMsgList"; //APP内打开推送的通知，更新消息一级列表
NSString *const LCNotificationNewAlarmMsgRead        = @"LCNotificationNewAlarmMsgRead"; //推送的新消息跳转时,标记已读
NSString *const LCNotificationAlarmMsgListChanged        = @"LCNotificationAlarmMsgListChanged"; //报警消息列表数据源变化

NSString *const LCNotificationNewAlarmMsgUpdateMsgList        = @"LCNotificationNewAlarmMsgUpdateMsgList";   //收到报警消息，刷新消息一级页面

NSString *const LCNotificationAutomaticLogin     = @"LCNotificationAutomaticLogin";
NSString *const LCNotificationSettingLinkage     = @"LCNotificationSettingLinkage";


NSString *const LCNotificationUpdateLiveShareState = @"LCNotificationUpdateLiveShareState";
NSString *const LCNotificationNewPushCenterMsg   = @"LCNotificationNewPushCenterMsg"; //v2.3 推送中心通知
NSString *const LCNotificationPersonalPushFired   = @"LCNotificationPersonalPushFired"; //v2.3 个人推送通知
NSString *const LCNotificationPushSoundFuncTipsChanged = @"LCNotificationPushSoundFuncTipsChanged"; //2.5新功能提醒通知
NSString *const LCNotificationDeviceExceptionChanged = @"@LCNotificationDeviceExceptionChanged";
NSString *const LCNotificationSwitchoverVideoIsReadMessage = @"@LCNotificationSwitchoverVideoIsReadMessage";/**< 切换录像已读消息标记 */
NSString *const LCNotificationNewMsgUpdateRedDot = @"LCNotificationNewMsgUpdateRedDot";//更新红点
NSString *const LCNotificationTransferDeviceSuccess = @"LCNotificationTransferDeviceSuccess";//刷新首页数据

NSString *const LCNotificationAlipayResult = @"LCNotificationAlipayResult";
NSString *const LCNotificationWeixinPayResult = @"LCNotificationWeixinPayResult";

NSString *const LCNotificationLoginSuccessed = @"LCNotificationLoginSuccessed";/**< 登录成功*/
NSString *const LCNotificationLoginFailed = @"LCNotificationLoginFailed";/**< 登录失败*/
NSString *const LCNotificationLogout = @"LCNotificationLogout";/**< 登出操作*/
NSString *const LCNotificationPresentLoginVC = @"LCNotificationPresentLoginVC";/**< 弹出登录页面*/
NSString *const LCNotificationShowTouchIDAlertView = @"LCNotificationShowTouchIDAlertView";/**< 弹出TouchID提醒*/
NSString *const LCNotificationGoToOpenTouchID = @"LCNotificationGoToOpenTouchID";/**< 前往TouchID开启界面*/
NSString *const LCNotificationTouchIDLoginBegin = @"LCNotificationTouchIDLoginBegin";/**< 开始TouchID登录*/
NSString *const LCNotificationTouchIDLoginEnd = @"LCNotificationTouchIDLoginEnd";/**< 结束TouchID登录*/
NSString *const LCNotificationTouchLoginClose = @"LCNotificationTouchLoginClose";/**< 点击登录页面的关闭按钮*/

NSString *const LCNotificationQueryTimePhoto = @"LCNotificationQueryTimePhoto";/**< 查询每日影集权限*/

NSString *const LCNotificationDeviceDecryptionUpdated = @"LCNotificationDeviceDecryptionUpdated";
NSString *const LCNotificationCustomVideoDecryptionUpdated = @"LCNotificationCustomVideoDecryptionUpdated"; ///设备自定义加密需要更新状态

//定向广告通知
NSString *const LCNotificationCustomAd = @"@LCNotificationCustomAd";

NSString *const LCNotificationSkipLaunchAd = @"@LCNotificationSkipLaunchAd";

NSString *const LCNotificationKeyRename = @"LCNotificationKeyRename";//钥匙重命名

NSString *const LCNotificationBuyPassengerSuccess = @"LCNotificationBuyPassengerSuccess";   //购买客流统计套餐成功
NSString *const LCNotificationBuyShareSuccess = @"LCNotificationBuyShareSuccess";     //购买分享套餐成功
NSString *const LCNotificationBuyCloudSuccess = @"LCNotificationBuyCloudSuccess";     //购买云套餐成功

NSString *const LCNotificationModifyLoginPasword = @"LCNotificationModifyLoginPasword";
NSString *const LCNotificationGetPushStatusSuccess = @"LCNotificationGetPushStatusSuccess";
NSString *const kLCShowHomePageChannelAndApMessage = @"kLCShowHomePageChannelAndApMessage";

NSString *const LCNotificationADDDeviceSuccess = @"LCNotificationADDDeviceSuccess";

/// 网关情景模式推送
NSString *const LCNotificationGatewayDeviceSceneModeChange = @"LCNotificationGatewayDeviceSceneModeChange";

/// 更新SOS 消息的处理状态
NSString *const LCNotificationMessageAPSOSAlarmIsStopSosAlarm = @"LCNotificationMessageAPSOSAlarmIsStopSosAlarm";

/// 网关SOS消息被人处理了
NSString *const LCNotificationMessageAPSOSAlarmIsStopSosAlarmByOther = @"LCNotificationMessageAPSOSAlarmIsStopSosAlarmByOther";

/// 局域网断开通知
NSString *const LCNotificationLocalNetworkDisconnect = @"LCNotificationLocalNetworkDisconnect";

/// 设备体验计划开关变化
NSString *const LCNotificationDeviceLogStateChange = @"LCNotificationDeviceLogStateChange";

/// 人形摘要
NSString *const LCNotificationCondensedAlarm = @"LCNotificationCondensedAlarm";

///呼叫挂断
NSString *const LCNotificationInterruptCallEvent = @"LCNotificationInterruptCallEvent";


//MARK: - SMB Methods
///通知客户端选择部门结果，用于视频预览选择部门
NSString *const SMBNotificationSelectDepartment = @"SMBNotificationSelectDepartment";
///通知客户端选择部门结果，用于设备切换部门
NSString *const SMBNotificationSelectDepartmentList = @"SMBNotificationSelectDepartmentList";
///通知客户端选择成员结果(单选)，用于企业过户
NSString *const SMBNotificationSelectEmployee = @"SMBNotificationSelectEmployee";
///通知客户端选择成员结果(多选)，用于设置应用可见范围
NSString *const SMBNotificationSelectEmployees = @"SMBNotificationSelectEmployees";
///通知客户端首次创建部门后，去邀请员工
NSString *const SMBNotificationInviteEmployee = @"SMBNotificationInviteEmployee";

///存在未读消息
NSString *const SMBNotificationHaveUnReadApplyMessage = @"SMBNotificationHaveUnReadApplyMessage";
///无未读消息
NSString *const SMBNotificationNoneUnReadApplyMessage = @"SMBNotificationNoneUnReadApplyMessage";
///企业数据存在更改，需要刷新数据
NSString *const SMBNotificationCorpDataDidChange = @"SMBNotificationCorpDataDidChange";

///有新消息，需要刷新当前列表
NSString *const SMBNotificationHaveNewMessageRecieve = @"SMBNotificationHaveNewMessageRecieve";
///需要刷新工作台右上角红色角标
NSString *const SMBNotificationWorkpaltRetDotDidChange = @"SMBNotificationWorkpaltRetDotDidChange";

// MARK: - 视频监控
///重命名成功
NSString *const SMBNotificationDeviceRenameSuccess = @"SMBNotificationDeviceRenameSuccess";
/// 升级成功
NSString *const SMBNotificationDeviceUpgradeSuccess = @"SMBNotificationDeviceUpgradeSuccess";
/// WIFI刷新完成
NSString *const SMBNotificationDeviceWiFiUpdateSuccess = @"SMBNotificationDeviceWiFiUpdateSuccess";
/// 动检更改完成
NSString *const SMBNotificationDeviceMotionDetectUpdate = @"SMBNotificationDeviceMotionDetectUpdate";
/// SD卡存储变化
NSString *const SMBNotificationDeviceSDCardUpdate = @"SMBNotificationDeviceSDCardUpdate";
