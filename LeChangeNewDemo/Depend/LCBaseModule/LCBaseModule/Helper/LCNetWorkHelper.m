//
//  Copyright © 2016年 Imou. All rights reserved.
//

#import <LCBaseModule/LCNetWorkHelper.h>
#import <LCBaseModule/LCAlertController.h>
#import <LCBaseModule/LCPubDefine.h>
#import <LCBaseModule/LCProgressHUD.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <LCBaseModule/NSString+Imou.h>
#import <LCBaseModule/LCUserManager.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <NetworkExtension/NEHotspotNetwork.h>
#import <AFNetworking/AFNetworking.h>

@interface LCNetWorkHelper()
@property (nonatomic, strong) LCAlertController	*alertVc;
@end

@implementation LCNetWorkHelper

+ (instancetype)sharedInstance {
	static dispatch_once_t once;
	static LCNetWorkHelper *sharedInstance;
	
	dispatch_once(&once, ^ {
		sharedInstance = [[self alloc] init];
	});
	
	return sharedInstance;
}

- (instancetype)init
{
	if (self = [super init])
	{
		_bShouldShowFlowTip = ![LCUserManager shareInstance].isAllowCellularPlay; //默认需要提示4g改变
		_bShouldShowFlowTipWhenLoadVideo = YES;
		_bShouldShowFlowTipWhenVideoShare  = YES;
		_interfaceQueue = dispatch_queue_create("interfaceQueue", DISPATCH_QUEUE_SERIAL);
		
		//连接软AP免费的WIFI，很快就分配了IP地址，但是wifi点亮比较慢
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
										NULL,
										systemNetworkChanged,
										CFSTR("com.apple.system.config.network_change"),
										(__bridge const void *)(self),
										CFNotificationSuspensionBehaviorHold);
	}
	
	return self;
}

- (NSInteger)currentNetworkStatus {
    return  self.emNetworkStatus;
}

- (NSString *)networkType {
    if (_emNetworkStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
        return @"wifi";
    }else if (_emNetworkStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
//        return @"WWAN";
        CTTelephonyNetworkInfo *networkStatus = [[CTTelephonyNetworkInfo alloc]init];
        NSString *currentStatus = networkStatus.currentRadioAccessTechnology;
        NSArray *typeStrings2G = @[CTRadioAccessTechnologyEdge,
                           CTRadioAccessTechnologyGPRS,
                           CTRadioAccessTechnologyCDMA1x];
        
        NSArray *typeStrings3G = @[CTRadioAccessTechnologyHSDPA,
                           CTRadioAccessTechnologyWCDMA,
                           CTRadioAccessTechnologyHSUPA,
                           CTRadioAccessTechnologyCDMAEVDORev0,
                           CTRadioAccessTechnologyCDMAEVDORevA,
                           CTRadioAccessTechnologyCDMAEVDORevB,
                           CTRadioAccessTechnologyeHRPD];
        
        NSArray *typeStrings4G = @[CTRadioAccessTechnologyLTE];
        //ios14 api调用崩溃，先用下面未注释的方式处理
//        NSArray *typeStrings5G;
//        if (@available(iOS 14.0, *)) {
//            typeStrings5G = @[CTRadioAccessTechnologyNRNSA,CTRadioAccessTechnologyNR];
//        }
        if ([typeStrings4G containsObject:currentStatus]) {
            return @"4g";
        } else if ([typeStrings3G containsObject:currentStatus]){
            return @"3g";
        } else if ([typeStrings2G containsObject:currentStatus]){
            return @"2g";
        } else {
            return @"5g";
        }
    } else if (_emNetworkStatus == AFNetworkReachabilityStatusNotReachable) {
        return @"notreachable";
    } else {
        return @"unknown";
    }
}

- (LCNetWorkStatus)currentReachabilityStatus
{
    LCNetWorkStatus returnValue = LCNetWorkStatusNotReachable;
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityRef reachabilityRef;
    if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags))
    {
        returnValue = [self networkStatusForFlags:flags];
    }
    
    return returnValue;
}

- (LCNetWorkStatus)networkStatusForFlags:(SCNetworkReachabilityFlags)flags
{
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
    {
        // The target host is not reachable.
        return LCNetWorkStatusNotReachable;
    }
    
    LCNetWorkStatus returnValue = LCNetWorkStatusNotReachable;
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
    {
        /*
         If the target host is reachable and no connection is required then we'll assume (for now) that you're on Wi-Fi...
         */
        returnValue = LCNetWorkStatusWiFi;
    }
    
    if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
         (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
    {
        /*
         ... and the connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs...
         */
        
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
        {
            /*
             ... and no [user] intervention is needed...
             */
            returnValue = LCNetWorkStatusWiFi;
        }
    }
    
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
    {
        /*
         ... but WWAN connections are OK if the calling application is using the CFNetwork APIs.
         */
        NSArray *typeStrings2G = @[CTRadioAccessTechnologyEdge,
                           CTRadioAccessTechnologyGPRS,
                           CTRadioAccessTechnologyCDMA1x];
        
        NSArray *typeStrings3G = @[CTRadioAccessTechnologyHSDPA,
                           CTRadioAccessTechnologyWCDMA,
                           CTRadioAccessTechnologyHSUPA,
                           CTRadioAccessTechnologyCDMAEVDORev0,
                           CTRadioAccessTechnologyCDMAEVDORevA,
                           CTRadioAccessTechnologyCDMAEVDORevB,
                           CTRadioAccessTechnologyeHRPD];
        
        NSArray *typeStrings4G = @[CTRadioAccessTechnologyLTE];
//        NSArray *typeStrings5G;
//        if (@available(iOS 14.0, *)) {
//            typeStrings5G = @[CTRadioAccessTechnologyNRNSA,CTRadioAccessTechnologyNR];
//        }

        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            CTTelephonyNetworkInfo *teleInfo= [[CTTelephonyNetworkInfo alloc] init];
            NSString *accessString = teleInfo.currentRadioAccessTechnology;
            if ([typeStrings2G containsObject:accessString]) {
                return LCNetWorkStatusWWAN2G;
            } else if ([typeStrings3G containsObject:accessString]) {
                return LCNetWorkStatusWWAN3G;
            } else if ([typeStrings4G containsObject:accessString]) {
                return LCNetWorkStatusWWAN4G;
            } else {
                return LCNetWorkStatusWWAN5G;
            }
        } else {
            return LCNetWorkStatusUnknown;
        }
    }

    return returnValue;
}

//static NSString *lc_lastWifiName = nil;
//void systemNetworkChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
void systemNetworkChanged() {
	dispatch_queue_t queue = LCNetWorkHelper.sharedInstance.interfaceQueue;
	dispatch_async(queue, ^{
		NSString *wifiName = @"";
		NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
		for (NSString *ifnam in ifs) {
			NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
			NSLog(@"systemNetworkChanged wifiInfo = %@", info);
			if (info[@"SSID"]) {
				wifiName = info[@"SSID"];
			}
		}
		
		NSLog(@"28614-*-* systemNetworkChanged wifi name: %@ - %@", lastWifiName, wifiName);
		
		if(wifiName.length && [lastWifiName isEqualToString:wifiName]){
			return;
		}
		
		//通知及网络切换需要放在主线程中处理，内部可能涉及UI
		dispatch_async(dispatch_get_main_queue(), ^{
			NSLog(@"28614-*-* LCNotificationWifiNetWorkChange111111  %ld",[LCNetWorkHelper sharedInstance].emNetworkStatus);
			NSLog(@"28614-*-* SSID  %@",wifiName);
			//WIFI连接
			if (wifiName.length > 0) {
				[[LCNetWorkHelper sharedInstance] configureByStatus:AFNetworkReachabilityStatusReachableViaWiFi];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LCNotificationWifiNetWorkDidSwitch" object:wifiName];
            }
            
		});
        lastWifiName = wifiName;
        [LCNetWorkHelper sharedInstance].lc_lastWifiName = wifiName;
	});
}

- (NSString *)lc_lastWifiName {
    if (_lc_lastWifiName == nil || !_lc_lastWifiName.length) {
        systemNetworkChanged();
    }
    return  _lc_lastWifiName;
}

- (NSString *)fetchSSIDInfo {
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
    id info = nil;
    for (NSString *ifnam in ifs)
    {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count])
        {
            break;
        }
    }
    NSString *ssid = [[info objectForKey:@"SSID"] copy];
    
    return ssid;
}
- (void)fetchCurrentWiFiSSID:(void (^)(NSString * __nullable ssid))callBack {
    if (@available(iOS 14.0, *)) {
        [NEHotspotNetwork fetchCurrentWithCompletionHandler:^(NEHotspotNetwork * _Nullable currentNetwork) {
            // 主线程回调
            if (currentNetwork != nil) {
                callBack(currentNetwork.SSID);
            } else {
                callBack(nil);
            }
        }];
    } else {
        dispatch_async(self.interfaceQueue, ^{
            NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
            NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
            id info = nil;
            for (NSString *ifnam in ifs) {
                info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
                if (info && [info count]) {
                    break;
                }
            }
            NSString *ssid = [[info objectForKey:@"SSID"] copy];
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(ssid);
            });
        });
    }
}

- (void)checkNetwork
{
	AFNetworkReachabilityManager *reachalilityManager = [AFNetworkReachabilityManager sharedManager];
	self.emNetworkStatus = reachalilityManager.networkReachabilityStatus;
	
	//监听网络变化，app生命周期内只需要初始化一次
	__weak typeof(self) weakSelf = self;
	static dispatch_once_t predicate;
	dispatch_once(&predicate, ^{
		[reachalilityManager startMonitoring];
		[reachalilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
			[weakSelf configureByStatus:status];
		}];
	});
}

- (void)configureByStatus:(AFNetworkReachabilityStatus)status {
	
	NSLog(@"LCNetWorkHelper::Before Network Sattus:%ld", (long)self.emNetworkStatus);
	
	//【*】网络变化时才处理后续流程
	if (self.emNetworkStatus == status) {
		return;
	}
	
	self.emNetworkStatus = status;
	
	//【*】优化：程序第一次启动时，不弹出无网络的提示框
	BOOL firstLaunched = [[NSUserDefaults standardUserDefaults] boolForKey:@"LCNetWorkTipHaveLaunched"];
	
	NSLog(@"LCNetWorkHelper::Current Network Sattus:%ld", (long)status);
	
	if (status == AFNetworkReachabilityStatusReachableViaWWAN)
	{
		//网络变化后，需要提示4g情况下播放
		_bShouldShowFlowTip = ![LCUserManager shareInstance].isAllowCellularPlay;
		_bShouldShowFlowTipWhenLoadVideo = YES;
		_bShouldShowFlowTipWhenVideoShare = YES;
	}
	else if(status == AFNetworkReachabilityStatusReachableViaWiFi)
	{
		//网络变化后，wifi情况下不需要进行提示
		_bShouldShowFlowTip = NO;
		_bShouldShowFlowTipWhenLoadVideo = NO;
		_bShouldShowFlowTipWhenVideoShare = NO;
		[self dissmissAlert:YES];
	}
	else if(status == AFNetworkReachabilityStatusNotReachable && firstLaunched == YES)
	{

        [[NSNotificationCenter defaultCenter] postNotificationName:@"LCNotificationWifiNoAvailableNetWork" object:@""];
		[self dissmissAlert:YES];
	}
	
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LCNetWorkTipHaveLaunched"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"LCNotificationWifiNetWorkChange" object:@""];
}

- (LCNetworkReachabilityStatus)lcNetworkStatus {
    
    switch (_emNetworkStatus) {
        case AFNetworkReachabilityStatusNotReachable:
            return LCNetworkReachabilityStatusNotReachable;
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            return LCNetworkReachabilityStatusReachableViaWWAN;
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            return LCNetworkReachabilityStatusReachableViaWiFi;
            break;
        default:
            return LCNetworkReachabilityStatusUnknown;
    }
    
}

#pragma mark - 检查当前网络状态下，是否允许播放视频

- (BOOL)networkAllowPlayVideo {
    return _emNetworkStatus == AFNetworkReachabilityStatusReachableViaWiFi;
}

- (BOOL)isPermittedToPlayVideoWithTip:(NSString *)tip
{
	BOOL permittedToPlay = YES;
	if ([LCNetWorkHelper sharedInstance].bShouldShowFlowTip &&
		[LCNetWorkHelper sharedInstance].emNetworkStatus == AFNetworkReachabilityStatusReachableViaWWAN)
	{
		permittedToPlay = NO;
	}
	else if ([LCNetWorkHelper sharedInstance].emNetworkStatus == AFNetworkReachabilityStatusReachableViaWWAN)
	{
		permittedToPlay = YES;
		if (tip.length) {
			[LCProgressHUD showMsg:tip];
		}
		
		[self dissmissAlert:YES];
	}
	
	return permittedToPlay;
}

- (BOOL)showPermittedToVC:(UIViewController *)vc playVideoAlert:(dispatch_block_t)confirmAction withTip:(NSString *)tip
{
	if ([LCNetWorkHelper sharedInstance].bShouldShowFlowTip &&
		[LCNetWorkHelper sharedInstance].emNetworkStatus == AFNetworkReachabilityStatusReachableViaWWAN)
	{
		//【*】已经在vc上面显示了弹框，则不需要再显示4g弹框了
		//【*】4g，且没有点击确认播放 【已经有4g弹框的情况下，先隐藏再显示出来】
		if ([vc.presentedViewController isKindOfClass:[UIAlertController class]]) {
			return NO;
		}
		
		[self dissmissAlert:NO];
		_alertVc = [LCAlertController showInViewController:vc
													 title:@"mobile_common_play_on_cellular_data".lc_T
												   message:@"mobile_common_allow_play_on_cellular_data".lc_T
										 cancelButtonTitle:@"common_cancel".lc_T
										 otherButtonTitles: @[@"mobile_common_always".lc_T, @"mobile_common_once".lc_T]
												   handler:^(NSInteger index)
					{
						if (index == 1) {
							[LCNetWorkHelper sharedInstance].bShouldShowFlowTip = NO;
							[LCUserManager shareInstance].isAllowCellularPlay = YES;
							//确定后，下次不再提示
							if (confirmAction) {
								confirmAction();
							}
						}
						else if(index == 2)
						{
							//确定后，下次继续提示
							if (confirmAction) {
								confirmAction();
							}
						}
						
						[self dissmissAlert:YES];
					}];
		
		return NO;
	}
	else if ([LCNetWorkHelper sharedInstance].emNetworkStatus == AFNetworkReachabilityStatusReachableViaWWAN &&
			 tip.length && [MBProgressHUD HUDForView:LC_KEY_WINDOW] == nil)
	{
		//4g，已经点击过确认播放
		[LCProgressHUD showMsg:tip];
		[self dissmissAlert:YES];
	}
	
	return YES;
}

- (BOOL)showPermittedToPlayVideoAlert:(dispatch_block_t)confirmAction withTip:(NSString *)tip
{
	if ([LCNetWorkHelper sharedInstance].bShouldShowFlowTip &&
		[LCNetWorkHelper sharedInstance].emNetworkStatus == AFNetworkReachabilityStatusReachableViaWWAN)
	{
		//【*】已经在模态框上面显示了弹框，则不需要再显示4g弹框了
		UIViewController *topVc = [LCAlertController topPresentOrRootController];
		if ([topVc.presentedViewController isKindOfClass:[UIAlertController class]]) {
			return NO;
		}
		
		//4g，且没有点击确认播放
		[self dissmissAlert:NO];
		_alertVc = [LCAlertController showWithTitle:@"mobile_common_play_on_cellular_data".lc_T
											message:@"mobile_common_allow_play_on_cellular_data".lc_T
								  cancelButtonTitle:@"common_cancel".lc_T
								  otherButtonTitles:@[@"mobile_common_always".lc_T,@"mobile_common_once".lc_T]
											handler:^(NSInteger index)
					{
						if (index == 1) {
							[LCNetWorkHelper sharedInstance].bShouldShowFlowTip = NO;
							[LCUserManager shareInstance].isAllowCellularPlay = YES;
							
							//确定后，下次不再提示
							if (confirmAction) {
								confirmAction();
							}
						}
						else if(index == 2)
						{
							//确定后，下次继续提示
							if (confirmAction) {
								confirmAction();
							}
						}
						
						[self dissmissAlert:YES];
					}];
		return NO;
	}
	else if ([LCNetWorkHelper sharedInstance].emNetworkStatus == AFNetworkReachabilityStatusReachableViaWWAN &&
			 tip.length && [MBProgressHUD HUDForView:([UIApplication sharedApplication].delegate).window] == nil)
	{
		//4g，已经点击过确认播放
		[LCProgressHUD showMsg:tip];
		[self dissmissAlert:YES];
	}
	
	return YES;
}


- (void)showPermittedToDownloadAlert:(dispatch_block_t)confirmAction withTip:(NSString *)tip
{
	if ([LCNetWorkHelper sharedInstance].bShouldShowFlowTip &&
		[LCNetWorkHelper sharedInstance].emNetworkStatus == AFNetworkReachabilityStatusReachableViaWWAN)
	{
		//从4g播放切换到下载，弹框可能展示不一样
		[self dissmissAlert:NO];
		_alertVc = [LCAlertController showWithTitle:@"mobile_common_play_on_cellular_data".lc_T
											message:@"mobile_common_allow_play_on_cellular_data".lc_T
								  cancelButtonTitle:@"common_cancel".lc_T
								  otherButtonTitles:@[@"mobile_common_always".lc_T,@"mobile_common_once".lc_T]
											handler:^(NSInteger index)
					{
						if (index == 1) {
							[LCNetWorkHelper sharedInstance].bShouldShowFlowTip = NO;
							[LCUserManager shareInstance].isAllowCellularPlay = YES;
							
							//确定后，下次不再提示
							if (confirmAction) {
								confirmAction();
							}
						}
						else if(index == 2)
						{
							//确定后，下次继续提示
							if (confirmAction) {
								confirmAction();
							}
						}
						
						[self dissmissAlert:YES];
					}];
	}
	else if ([LCNetWorkHelper sharedInstance].emNetworkStatus == AFNetworkReachabilityStatusReachableViaWWAN &&
			 tip.length && [MBProgressHUD HUDForView:LC_KEY_WINDOW] == nil)
	{
		//4g，已经点击过确认播放
		[LCProgressHUD showMsg:tip];
		[self dissmissAlert:YES];
	}
}


- (void)dissmissAlert:(BOOL)animated
{
	if (_alertVc) {
		[_alertVc dismissViewControllerAnimated:animated completion:nil];
		_alertVc = nil;
	}
}

- (void)dissmissAlert {
	[self dissmissAlert:YES];
}

@end
