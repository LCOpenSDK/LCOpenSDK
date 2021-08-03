//
//  LCNotificationKey.h
//  LCIphone
//
//  Owned by peng_kongan on 16/09/30.
//  Created by peng_kongan on 16/1/16.
//  Copyright © 2016年 dahua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const LCNotificationUnbindDeviceUpdated;
UIKIT_EXTERN NSString *const LCNotificationUnbindDeviceNew;
UIKIT_EXTERN NSString *const LCNotificationDeviceChange;
UIKIT_EXTERN NSString *const LCNotificationDeviceMaskChange;
UIKIT_EXTERN NSString *const LCNotificationGetDeviceFail;
UIKIT_EXTERN NSString *const LCNotificationUpdateDeviceList;
UIKIT_EXTERN NSString *const LCNotificationUpdateAddFriendMsg;
UIKIT_EXTERN NSString *const LCNotificationChangeFriendRemarkName;
UIKIT_EXTERN NSString *const LCNotificationAddFriendRequst;
UIKIT_EXTERN NSString *const LCNotificationNewFriendMsg;
UIKIT_EXTERN NSString *const LCNotificationNewFriendMsgReadStateChanged;
UIKIT_EXTERN NSString *const LCNotificationCouponReadStateChanged;
UIKIT_EXTERN NSString *const LCNotificationMyFriendListChanged;
UIKIT_EXTERN NSString *const LCNotificationPasswordChange;
UIKIT_EXTERN NSString *const LCNotificationUserAccountLock;
UIKIT_EXTERN NSString *const LCNotificationSDCardStatusChange;
UIKIT_EXTERN NSString *const LCNotificationUpgradeDevice;
UIKIT_EXTERN NSString *const LCNotificationUpgradeAp;    //网关配件升级推送
UIKIT_EXTERN NSString *const LCNotificationPlugInPlanChanged;
UIKIT_EXTERN NSString *const LCNotificationSystemAlarmFired;
UIKIT_EXTERN NSString *const LCNotificationWifiNetWorkChange;
UIKIT_EXTERN NSString *const LCNotificationWifiNetWorkDidSwitch;//wifi间的切换
UIKIT_EXTERN NSString *const LCNotificationCountDownEnd;
UIKIT_EXTERN NSString *const LCNotificationFriendListChanged;
UIKIT_EXTERN NSString *const LCNotificationRemarkNameChanged;
UIKIT_EXTERN NSString *const LCNotificationCTCallState;
UIKIT_EXTERN NSString *const LCNotificationMessageAlarmFired;
UIKIT_EXTERN NSString *const LCNotificationNewAlarmMsgNeedUpdateMsgList;
UIKIT_EXTERN NSString *const LCNotificationNewAlarmMsg;
UIKIT_EXTERN NSString *const LCNotificationNewAlarmMsgRead;
UIKIT_EXTERN NSString *const LCNotificationNewAlarmMsgFromHome;
UIKIT_EXTERN NSString *const LCNotificationNoMsgDetailFromHome;
UIKIT_EXTERN NSString *const LCNotificationSelectedHomePage;
UIKIT_EXTERN NSString *const kLCShowHomePageChannelAndApMessage;
UIKIT_EXTERN NSString *const LCNotificationAlarmMsgListChanged;
UIKIT_EXTERN NSString *const LCNotificationNewAlarmMsgUpdateMsgList; //收到报警消息，刷新消息一级页面
UIKIT_EXTERN NSString *const LCNotificationAutomaticLogin;
UIKIT_EXTERN NSString *const LCNotificationSettingLinkage; /**< 设置配件关联 */
UIKIT_EXTERN NSString *const LCNotificationUpdateLiveShareState; /**< 更新通道直播分享状态 */
UIKIT_EXTERN NSString *const LCNotificationPushSoundFuncTipsChanged; //新功能提醒红点改变
UIKIT_EXTERN NSString *const LCNotificationDeviceExceptionChanged; //设备异常改变
UIKIT_EXTERN NSString *const LCNotificationNewPushCenterMsg; //v2.3 推送中心通知
UIKIT_EXTERN NSString *const LCNotificationPersonalPushFired; //v2.3 个人推送通知
UIKIT_EXTERN NSString *const LCNotificationSwitchoverVideoIsReadMessage;/**< 切换录像已读消息标记 */
UIKIT_EXTERN NSString *const LCNotificationDeviceSleep;
//支付宝钱包的支付结果回调通知
UIKIT_EXTERN NSString *const LCNotificationAlipayResult;
UIKIT_EXTERN NSString *const LCNotificationWeixinPayResult;

UIKIT_EXTERN NSString *const LCNotificationLoginSuccessed;/**< 登录成功*/
UIKIT_EXTERN NSString *const LCNotificationLoginFailed;/**< 登录失败*/
UIKIT_EXTERN NSString *const LCNotificationLogout;/**< 登出操作*/
UIKIT_EXTERN NSString *const LCNotificationPresentLoginVC;/**< 弹出登录页面*/
UIKIT_EXTERN NSString *const LCNotificationShowTouchIDAlertView;/**< 弹出TouchID提醒*/
UIKIT_EXTERN NSString *const LCNotificationGoToOpenTouchID;/**< 前往TouchID开启界面*/
UIKIT_EXTERN NSString *const LCNotificationTouchIDLoginBegin;/**< 开始TouchID登录*/
UIKIT_EXTERN NSString *const LCNotificationTouchIDLoginEnd;/**< 结束TouchID登录*/
UIKIT_EXTERN NSString *const LCNotificationTouchLoginClose;/**< 点击登录页面的关闭按钮*/
UIKIT_EXTERN NSString *const LCNotificationQueryTimePhoto;/**< 点击登录页面的关闭按钮*/

UIKIT_EXTERN NSString *const LCNotificationDeviceDecryptionUpdated; /**< 视频设备密码更新 */
UIKIT_EXTERN NSString *const LCNotificationCustomVideoDecryptionUpdated; ///设备自定义加密需要更新状态

UIKIT_EXTERN NSString *const LCNotificationNewMsgUpdateRedDot;//更新tabbar红点

UIKIT_EXTERN NSString *const LCNotificationTransferDeviceSuccess;   //设备转移成功，通过H5

/// 更新DHChannel属性
UIKIT_EXTERN NSString *const DHNotificationUpdateDHChannelProperty;

//定向广告
UIKIT_EXTERN NSString *const LCNotificationCustomAd;
UIKIT_EXTERN NSString *const LCNotificationSkipLaunchAd;

UIKIT_EXTERN NSString *const LCNotificationTouchIDLoginBegin;
UIKIT_EXTERN NSString *const LCNotificationTouchIDLoginEnd;

//钥匙重命名
UIKIT_EXTERN NSString *const LCNotificationKeyRename;

UIKIT_EXTERN NSString *const LCNotificationBuyPassengerSuccess;/**< 切换录像已读消息标记 */
UIKIT_EXTERN NSString *const LCNotificationBuyCloudSuccess;
UIKIT_EXTERN NSString *const LCNotificationBuyShareSuccess;

UIKIT_EXTERN NSString *const LCNotificationModifyLoginPasword; /**< 修改登录密码通知 */
UIKIT_EXTERN NSString *const LCNotificationGetPushStatusSuccess;


UIKIT_EXTERN NSString *const LCNotificationWXPay;

UIKIT_EXTERN NSString *const LCNotificationNeedUpdateP2PService; /**< 需要更新p2p服务通知 */

//帐号操作成功通知
UIKIT_EXTERN NSString *const LCNotificationThirdBindAccountSuccess; /**< 第三方账号绑定手机/邮箱通知 */
UIKIT_EXTERN NSString *const LCNotificationChangeAccountSuccess; /**< 更换账号手机/邮箱通知 */
UIKIT_EXTERN NSString *const LCNotificationEmailBindPhoneSuccess; /**< 邮箱绑定手机号通知 */
UIKIT_EXTERN NSString *const LCNotificationEmailUnbindSuccess; /**< 邮箱解绑通知 */
//查询白光相机警笛与白光灯状态
UIKIT_EXTERN NSString *const LCNotificationDeviceSirenChanged;
UIKIT_EXTERN NSString *const LCNotificationDeviceWhiteLightChanged;
UIKIT_EXTERN NSString *const LCNotificationDeviceSearchLightChanged;
UIKIT_EXTERN NSString *const LCNotificationDeviceSearchLightModeChanged;

// 修改了增值服务套餐刷新预览页增值服务数据
UIKIT_EXTERN NSString *const LCNotificationDeviceAddedServicesChanged;

//H5交互中web通知native
UIKIT_EXTERN NSString *const LCNotificationDeviceWebNoticeNative;

//云存储支付成功（旧的JS桥接中使用）
UIKIT_EXTERN NSString *const LCNotificationCloudStoragePaySuccess;

//云存储更新成功（支付成功后，查询状态，新的使用）
UIKIT_EXTERN NSString *const LCNotificationCloudStorageUpdated;

/// 设备添加融合OMS
UIKIT_EXTERN NSString *const LCNotificationOMSIntrodutionUpdated;
UIKIT_EXTERN NSString *const LCNotificationOMSIModelsUpdated;

UIKIT_EXTERN NSString *const LCNotificationADDDeviceSuccess;

/// 更新单个设备通知至设备列表（添加添加完成、收到设备共享时发送）
UIKIT_EXTERN NSString *const DHNotificationUpdateDeviceToListById;

/// 更新下载tabbar图片通知
UIKIT_EXTERN NSString *const DHNotificationUpdateTabListGet;

/// 退出账户重置 商城、发现 webView
UIKIT_EXTERN NSString *const DHNotificationResetShopAndDiscovery;

/// 退出账户 重置蓝牙连接数据状态
UIKIT_EXTERN NSString *const DHNotificationResetBLEConnectDataKey;

/// 网关情景模式推送
UIKIT_EXTERN NSString *const LCNotificationGatewayDeviceSceneModeChange;

/// 更新SOS 消息的处理状态
UIKIT_EXTERN NSString *const LCNotificationMessageAPSOSAlarmIsStopSosAlarm;

/// 网关SOS消息被人处理了
UIKIT_EXTERN NSString *const LCNotificationMessageAPSOSAlarmIsStopSosAlarmByOther;

/// 局域网断开通知
UIKIT_EXTERN NSString *const LCNotificationLocalNetworkDisconnect;

UIKIT_EXTERN NSString *const LCNotificationDeviceLogStateChange;

/// 人形摘要
UIKIT_EXTERN NSString *const LCNotificationCondensedAlarm;

///呼叫挂断
UIKIT_EXTERN NSString *const LCNotificationInterruptCallEvent;
