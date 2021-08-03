//
//  Copyright © 2016年 dahua. All rights reserved.
//

#import <LCBaseModule/DHNetWorkHelper.h>
#import <LCBaseModule/DHAlertController.h>
#import <LCBaseModule/DHPubDefine.h>
#import <LCBaseModule/LCProgressHUD.h>
#import <LCBaseModule/NSString+Dahua.h>
#import <LCBaseModule/DHUserManager.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@interface DHNetWorkHelper()
@property (nonatomic, strong) DHAlertController	*alertVc;
@end

@implementation DHNetWorkHelper

+ (instancetype)sharedInstance {
	static dispatch_once_t once;
	static DHNetWorkHelper *sharedInstance;
	
	dispatch_once(&once, ^ {
		sharedInstance = [[self alloc] init];
	});
	
	return sharedInstance;
}

- (instancetype)init
{
	if (self = [super init])
	{
		_bShouldShowFlowTip = ![DHUserManager shareInstance].isAllowCellularPlay; //默认需要提示4g改变
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

- (NSString *)networkType {
    if (_emNetworkStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
        return @"WiFi";
    }else if (_emNetworkStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
        return @"WWAN";
    }
    return @"Unknown";
}

static NSString *dh_lastWifiName = nil;
void systemNetworkChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	dispatch_queue_t queue = DHNetWorkHelper.sharedInstance.interfaceQueue;
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
		
		NSLog(@"28614-*-* systemNetworkChanged wifi name: %@ - %@", dh_lastWifiName, wifiName);
		
		if(wifiName.length && [dh_lastWifiName isEqualToString:wifiName]){
			return;
		}
		
		//通知及网络切换需要放在主线程中处理，内部可能涉及UI
		dispatch_async(dispatch_get_main_queue(), ^{
			NSLog(@"28614-*-* LCNotificationWifiNetWorkChange111111  %ld",[DHNetWorkHelper sharedInstance].emNetworkStatus);
			NSLog(@"28614-*-* SSID  %@",wifiName);
			//WIFI连接
			if (wifiName.length > 0) {
				[[DHNetWorkHelper sharedInstance] configureByStatus:AFNetworkReachabilityStatusReachableViaWiFi];
			}
			
			[[NSNotificationCenter defaultCenter] postNotificationName:@"LCNotificationWifiNetWorkDidSwitch" object:wifiName];
		});
		
		dh_lastWifiName = wifiName;
	});
}

- (NSString *)fetchSSIDInfo
{
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
	
	NSLog(@"DHNetWorkHelper::Before Network Sattus:%ld", (long)self.emNetworkStatus);
	
	//【*】网络变化时才处理后续流程
	if (self.emNetworkStatus == status) {
		return;
	}
	
	self.emNetworkStatus = status;
	
	//【*】优化：程序第一次启动时，不弹出无网络的提示框
	BOOL firstLaunched = [[NSUserDefaults standardUserDefaults] boolForKey:@"DHNetWorkTipHaveLaunched"];
	
	NSLog(@"DHNetWorkHelper::Current Network Sattus:%ld", (long)status);
	
	if (status == AFNetworkReachabilityStatusReachableViaWWAN)
	{
		//网络变化后，需要提示4g情况下播放
		_bShouldShowFlowTip = ![DHUserManager shareInstance].isAllowCellularPlay;
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
	
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DHNetWorkTipHaveLaunched"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"LCNotificationWifiNetWorkChange" object:@""];
}

#pragma mark - 检查当前网络状态下，是否允许播放视频
- (BOOL)isPermittedToPlayVideoWithTip:(NSString *)tip
{
	BOOL permittedToPlay = YES;
	if ([DHNetWorkHelper sharedInstance].bShouldShowFlowTip &&
		[DHNetWorkHelper sharedInstance].emNetworkStatus == AFNetworkReachabilityStatusReachableViaWWAN)
	{
		permittedToPlay = NO;
	}
	else if ([DHNetWorkHelper sharedInstance].emNetworkStatus == AFNetworkReachabilityStatusReachableViaWWAN)
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
	if ([DHNetWorkHelper sharedInstance].bShouldShowFlowTip &&
		[DHNetWorkHelper sharedInstance].emNetworkStatus == AFNetworkReachabilityStatusReachableViaWWAN)
	{
		//【*】已经在vc上面显示了弹框，则不需要再显示4g弹框了
		//【*】4g，且没有点击确认播放 【已经有4g弹框的情况下，先隐藏再显示出来】
		if ([vc.presentedViewController isKindOfClass:[UIAlertController class]]) {
			return NO;
		}
		
		[self dissmissAlert:NO];
		_alertVc = [DHAlertController showInViewController:vc
													 title:@"mobile_common_play_on_cellular_data".lc_T
												   message:@"mobile_common_allow_play_on_cellular_data".lc_T
										 cancelButtonTitle:@"common_cancel".lc_T
										 otherButtonTitles: @[@"mobile_common_always".lc_T, @"mobile_common_once".lc_T]
												   handler:^(NSInteger index)
					{
						if (index == 1) {
							[DHNetWorkHelper sharedInstance].bShouldShowFlowTip = NO;
							[DHUserManager shareInstance].isAllowCellularPlay = YES;
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
	else if ([DHNetWorkHelper sharedInstance].emNetworkStatus == AFNetworkReachabilityStatusReachableViaWWAN &&
			 tip.length && [MBProgressHUD HUDForView:DH_KEY_WINDOW] == nil)
	{
		//4g，已经点击过确认播放
		[LCProgressHUD showMsg:tip];
		[self dissmissAlert:YES];
	}
	
	return YES;
}

- (BOOL)showPermittedToPlayVideoAlert:(dispatch_block_t)confirmAction withTip:(NSString *)tip
{
	if ([DHNetWorkHelper sharedInstance].bShouldShowFlowTip &&
		[DHNetWorkHelper sharedInstance].emNetworkStatus == AFNetworkReachabilityStatusReachableViaWWAN)
	{
		//【*】已经在模态框上面显示了弹框，则不需要再显示4g弹框了
		UIViewController *topVc = [DHAlertController topPresentOrRootController];
		if ([topVc.presentedViewController isKindOfClass:[UIAlertController class]]) {
			return NO;
		}
		
		//4g，且没有点击确认播放
		[self dissmissAlert:NO];
		_alertVc = [DHAlertController showWithTitle:@"mobile_common_play_on_cellular_data".lc_T
											message:@"mobile_common_allow_play_on_cellular_data".lc_T
								  cancelButtonTitle:@"common_cancel".lc_T
								  otherButtonTitles:@[@"mobile_common_always".lc_T,@"mobile_common_once".lc_T]
											handler:^(NSInteger index)
					{
						if (index == 1) {
							[DHNetWorkHelper sharedInstance].bShouldShowFlowTip = NO;
							[DHUserManager shareInstance].isAllowCellularPlay = YES;
							
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
	else if ([DHNetWorkHelper sharedInstance].emNetworkStatus == AFNetworkReachabilityStatusReachableViaWWAN &&
			 tip.length && [MBProgressHUD HUDForView:DH_KEY_WINDOW] == nil)
	{
		//4g，已经点击过确认播放
		[LCProgressHUD showMsg:tip];
		[self dissmissAlert:YES];
	}
	
	return YES;
}


- (void)showPermittedToDownloadAlert:(dispatch_block_t)confirmAction withTip:(NSString *)tip
{
	if ([DHNetWorkHelper sharedInstance].bShouldShowFlowTip &&
		[DHNetWorkHelper sharedInstance].emNetworkStatus == AFNetworkReachabilityStatusReachableViaWWAN)
	{
		//从4g播放切换到下载，弹框可能展示不一样
		[self dissmissAlert:NO];
		_alertVc = [DHAlertController showWithTitle:@"mobile_common_play_on_cellular_data".lc_T
											message:@"mobile_common_allow_play_on_cellular_data".lc_T
								  cancelButtonTitle:@"common_cancel".lc_T
								  otherButtonTitles:@[@"mobile_common_always".lc_T,@"mobile_common_once".lc_T]
											handler:^(NSInteger index)
					{
						if (index == 1) {
							[DHNetWorkHelper sharedInstance].bShouldShowFlowTip = NO;
							[DHUserManager shareInstance].isAllowCellularPlay = YES;
							
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
	else if ([DHNetWorkHelper sharedInstance].emNetworkStatus == AFNetworkReachabilityStatusReachableViaWWAN &&
			 tip.length && [MBProgressHUD HUDForView:DH_KEY_WINDOW] == nil)
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
