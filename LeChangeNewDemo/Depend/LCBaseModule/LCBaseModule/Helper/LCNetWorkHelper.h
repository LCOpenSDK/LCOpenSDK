//
//  Copyright © 2016年 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LCNetworkReachabilityStatus) {
    LCNetworkReachabilityStatusUnknown          = -1,
    LCNetworkReachabilityStatusNotReachable     = 0,
    LCNetworkReachabilityStatusReachableViaWWAN = 1,
    LCNetworkReachabilityStatusReachableViaWiFi = 2,
};

#define LCWwanAlertTip @"mobile_common_media_play_mobile_network_tip_title".lc_T
#define LCNoNetworkTip @"net_error_and_check".lc_T

static NSString *lastWifiName = nil;

typedef NS_ENUM(NSUInteger, LCNetWorkStatus) {
    LCNetWorkStatusNotReachable = 0,
    LCNetWorkStatusUnknown = 1,
    LCNetWorkStatusWWAN2G = 2,
    LCNetWorkStatusWWAN3G = 3,
    LCNetWorkStatusWWAN4G = 4,
    LCNetWorkStatusWWAN5G = 5,
    LCNetWorkStatusWiFi = 9,
};

@interface LCNetWorkHelper : NSObject

+ (instancetype _Nonnull )sharedInstance;

@property (nonatomic, assign, readonly) LCNetworkReachabilityStatus lcNetworkStatus;
@property (nonatomic, copy) NSString *lc_lastWifiName; // 当前网络的描述字符串
@property (nonatomic, assign) NSInteger             emNetworkStatus;

@property (nonatomic, assign) BOOL                  bShouldShowFlowTip;         //是否显示4g流量提示
@property (nonatomic, assign) BOOL                  bShouldShowFlowTipWhenLoadVideo;         //下载录像时是否显示4g流量提示
@property (nonatomic, assign) BOOL                  bShouldShowFlowTipWhenVideoShare;         //我的文件录像分享时是否显示4g流量提示
@property (nonatomic, copy) NSString * _Nullable networkType; // 当前网络的描述字符串
@property (nonatomic, copy, readonly) dispatch_queue_t interfaceQueue;  /**< 获取网络信息的队伍，异步串行 */

- (NSInteger)currentNetworkStatus;

/**
 *  检测网络，开启网络监听：网络变化后，发送LCNotificationWifiNetWorkChange通知
 */
- (void)checkNetwork;

/**
 *  当前网络状态下是否允许播放视频：Wifi下可播放；3/4G情况下
 *  @return YES,允许播放；NO，不允许播放
 */
- (BOOL)networkAllowPlayVideo;

/**
 *  当前网络状态下是否允许播放视频：Wifi下可播放；3/4G情况下，如果之前确定过允许播放，则可以播放
 *  @param tip  3/4g情况下的提示语
 *  @return YES,允许播放；NO，不允许播放
 */
- (BOOL)isPermittedToPlayVideoWithTip:(NSString *)tip;

/**
 *  当前网络状态下是否允许播放视频，并弹出提示框
 *
 *  @param vc 显示在哪个控制器
 *  @param confirmAction 确定的操作
 *  @param tip           3/4g情况下，直接播放的提示语
 *
 *  @return YES，可以播放；NO，不允许播放
 */
- (BOOL)showPermittedToVC:(UIViewController *)vc playVideoAlert:(dispatch_block_t)confirmAction withTip:(NSString *)tip;

/**
 *  当前网络状态下是否允许播放视频，并弹出提示框
 *
 *  @param confirmAction 确定的操作
 *  @param tip           3/4g情况下，直接播放的提示语
 *
 *  @return YES，可以播放；NO，不允许播放
 */
- (BOOL)showPermittedToPlayVideoAlert:(dispatch_block_t)confirmAction withTip:(NSString *)tip;

/**
 *  当前网络状态下是否允许下载，并弹出提示框
 *
 *  @param confirmAction 确定的操作
 *  @param tip           3/4g情况下，直接下载的提示语
 *
 */
- (void)showPermittedToDownloadAlert:(dispatch_block_t)confirmAction withTip:(NSString *)tip;

/**
 隐藏提示框
 */
- (void)dissmissAlert;

/**
 获取当前Wi-Fi的ssid
 */
- (NSString *)fetchSSIDInfo;

/// 获取当前的WiFi的SSID，异步操作
/// @param callBack 回调
///【*】（iOS 14以上）只有当前App有精确定位权限或者使用NEHotspotConfiguration API配置过当前WiFi才会返回正确的SSID
- (void)fetchCurrentWiFiSSID:(void (^)(NSString * __nullable ssid))callBack;
@end
