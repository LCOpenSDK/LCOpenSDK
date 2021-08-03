//
//  Copyright © 2018年 dahua. All rights reserved.
//

#import "DHNetSDKSearchManager.h"
#import "DHNetSDKInterface.h"
#import "DHDeviceNetInfo.h"
#import <LCBaseModule/UIDevice+LeChange.h>
#import <LCBaseModule/DHNetWorkHelper.h>
#import <LCBaseModule/DHModuleConfig.h>
#import <LCBaseModule/DHFileManager.h>
#import <LCBaseModule/DHMobileInfo.h>
#import <LCAddDeviceModule/LCAddDeviceModule-Swift.h>

@interface DHNetSDKSearchManager()

@property (nonatomic, strong) NSMutableDictionary<NSString *, DHDeviceNetInfo*> *netInfoDic;
@property (nonatomic, assign) long searchHandle;
@property (nonatomic, copy) dispatch_queue_t queue;
@property (nonatomic, copy) dispatch_queue_t searchQueue;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger tickCount;
@property (nonatomic, assign) NSTimeInterval lastFindTime; /**< 记录上次NETSDK回调结果的时间 */
@property (nonatomic, assign) NSInteger searchSequence; /**< 搜索的序号 */
@property (nonatomic, copy) NSString *lastSSID;//上次连接的wifi的ssid，用于网络环境变化重新搜索设备

@end

@implementation DHNetSDKSearchManager

#pragma mark - circle life

- (instancetype)init
{
    if(self = [super init])
    {
        [self initNetSdk];
        _netInfoDic = @{}.mutableCopy;
		_queue = dispatch_queue_create("syncOperation", DISPATCH_QUEUE_CONCURRENT);
		_searchQueue = dispatch_queue_create("searchQueue", DISPATCH_QUEUE_SERIAL);
		_tickCount = 0;
		
#if DEBUG
		_showDebugLog = YES;
#else
		_showDebugLog = YES;
#endif
    }
    return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification
- (void)addObservers {
	//防止重复添加
	[self removeObservers];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
												 name:UIApplicationWillResignActiveNotification object:nil]; //监听是否触发home键挂起程序，（把程序放在后台执行其他操作）
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)
												 name:UIApplicationDidBecomeActiveNotification object:nil]; //监听是否重新进入程序程序.（回到程序)
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidChanged:)
												 name:@"LCNotificationWifiNetWorkDidSwitch" object:nil];//从一个wifi网络切换到另外一个wifi网络也要重新获取设备列表
}

- (void)removeObservers {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
	if(self.timer != nil) {
		[self.timer fire];
		[self.timer invalidate];
		self.timer = nil;
	}
	
	DH_LOG_FUN
	
	dispatch_async(self.searchQueue, ^{
		if(self.searchHandle) {
			NSLog(@"DHNetSDKSearchManager::Stop search in resign active:%ld, sequence:%ld", self.searchHandle, (long)self.searchSequence);
			[[DHNetSDKInterface sharedInstance] stopSearchDevices:self.searchHandle];
			self.searchHandle = 0;
		}
	});
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
	if(self.isSearching)
	{
		[self startSearch];
	}
}

- (void)networkDidChanged:(NSNotificationCenter *)notification {
	// DTS000583328 偶现崩溃 [DHMobileInfo sharedInstance].WIFISSID
	if (!self.isSearching) {
		return;
	}
	
    //针对软ap添加的bug
    NSString *wifiSSID = [[DHMobileInfo sharedInstance].WIFISSID uppercaseString];
    if (![wifiSSID isEqualToString:self.lastSSID] && wifiSSID.length) {
        self.lastSSID = wifiSSID;
        [self.netInfoDic removeAllObjects];
        if(self.isSearching) {
            [self startSearch];
        }
    }
}

#pragma mark - interface

- (void)startSearch
{
	if(self.timer != nil) {
		[self.timer fire];
		[self.timer invalidate];
		self.timer = nil;
	}
	
	DH_LOG_FUN
	
	NSInteger tick = 2;
	self.timer = [NSTimer scheduledTimerWithTimeInterval:tick target:self selector:@selector(timeTick) userInfo:nil repeats:YES];
	self.isSearching = YES;
	[self timeTick];
	
	//添加通知
	[self addObservers];
}

- (void)timeTick
{
	//wifi连接连接过程中，可能会出现无法识别的情况，不能加此判断
	//只处理ios13以下系统，不是WiFi状态时，不进行检测
	if (DH_IOS_VERSION < 13 &&
		[DHNetWorkHelper sharedInstance].emNetworkStatus != AFNetworkReachabilityStatusReachableViaWiFi) {
		return;
	}
	
	//【*】打印当前的WIFI信息、定位软AP相关问题
	if (self.tickCount % 10 == 0) {
		NSLog(@"DHNetSDKSearchManager::当前WIFI信息 %@, Mask:%@, Router:%@, IP:%@",
			  DHMobileInfo.sharedInstance.WIFISSID,
			  UIDevice.lc_getMaskAddress,
			  [UIDevice lc_getRouterAddress],
			  UIDevice.lc_getIPAddress);
	}
	
	//计时不中断
	self.tickCount++;
	
	NSInteger intervalCheck = 10;
	if(self.tickCount % intervalCheck == 0) {
		[self clearnUnReceiveDevice];
	}
	
	if (self.tickCount % 5 == 0) {
		if (_showDebugLog) {
			dispatch_barrier_async(self.queue, ^{
				NSLog(@"当前搜索到的设备:\n%@",self.netInfoDic.allKeys);
			});
		}
	}
	
	// 距离上次回调时间大于3s，才重新开始重新搜索
	NSTimeInterval currentTime = NSDate.date.timeIntervalSince1970;
	if (fabs(currentTime - self.lastFindTime) < 3) {
		NSLog(@"DHNetSDKSearchManager:: Ignore tick process...");
		return;
	}
	
	// 已经停止了，不需要再重新搜索
	if (self.isSearching == false) {
		NSLog(@"DHNetSDKSearchManager:: Search is stopped, return...");
		return;
	}
	
	dispatch_async(self.searchQueue, ^{
		if(self.searchHandle) {
			NSLog(@"DHNetSDKSearchManager::Stop search in timetick:%ld, sequence:%ld", self.searchHandle, (long)self.searchSequence);
			[[DHNetSDKInterface sharedInstance] stopSearchDevices:self.searchHandle];
			self.searchHandle = 0;
		}
		
		//【*】记录下当前搜索的序号
		//【*】优化：采用传IP+不传IP交替搜索
		NSString *localIp = (self.searchSequence % 2) == 0 ? UIDevice.lc_getIPAddress : nil;
		
		self.searchSequence++;
		NSInteger sequence = self.searchSequence;
		
		self.searchHandle = [[DHNetSDKInterface sharedInstance] startSearchDevices:^(DHDeviceNetInfo *netInfo) {
			dispatch_barrier_async(self.queue, ^{
				netInfo.searchSequence = sequence;
				if (self.showDebugLog) {
					NSLog(@"DHNetSDKSearchManager::-find device: %@ - %@，搜索序号：%ld, Init type:%lu, status: %lu",
						  netInfo.deviceType, netInfo.serialNo, (long)netInfo.searchSequence, (unsigned long)netInfo.deviceInitType, (unsigned long)netInfo.deviceInitStatus);
				}
	
				//避免找到deviceId为空的情况
				if (netInfo.serialNo.length > 0) {
					DHNetSDKSearchManager.sharedInstance.netInfoDic[netInfo.serialNo] = netInfo;
				}
				
				self.lastFindTime = NSDate.date.timeIntervalSince1970;
			});
		} byLocalIp: localIp];
		
		NSLog(@"DHNetSDKSearchManager:: Start search with handle:%ld, search sequence:%ld", self.searchHandle, (long)self.searchSequence);
		
		if(self.searchHandle == 0) {
			unsigned int errorCode = [DHNetSDKInterface getLastError];
			NSLog(@"NetSDKInteface:: Load wifilist failed with errorCode:...0x%x", errorCode);
			NSLog(@"DHNetSDKSearchManager::CLIENT_StartSearchDevices-fail");
			
            DHAddDeviceLogModel *model = [[DHAddDeviceLogModel alloc] init];
            model.method = @"startSearchDevices";
            model.res = model.resFail;
            model.errCode = errorCode;
            [[DHAddDeviceLogManager shareInstance] addDeviceNetSDKLogWithModel:model];
		}
	});
}

- (void)stopSearch {
	//停止通知
	[self removeObservers];
	
	dispatch_barrier_async(self.queue, ^{
		[self.netInfoDic removeAllObjects];
	});
	
	if(self.timer != nil) {
		[self.timer fire];
		[self.timer invalidate];
		self.timer = nil;
	}
	
	dispatch_async(self.searchQueue, ^{
		if(self.searchHandle) {
			NSLog(@"DHNetSDKSearchManager::Stop search in stop:%ld, sequence:%ld", self.searchHandle, (long)self.searchSequence);
			[[DHNetSDKInterface sharedInstance] stopSearchDevices:self.searchHandle];
			self.searchHandle = 0;
		}
	});
	
	self.searchSequence = 0;
	self.lastFindTime = 0;
	self.isSearching = NO;
}

- (id<ISearchDeviceNetInfo>)getNetInfoByID:(NSString *)deviceID;
{
	__block id<ISearchDeviceNetInfo> device;
	dispatch_barrier_sync(self.queue, ^{
		device = self.netInfoDic[deviceID];
	});

    return device;
}

#pragma mark - Custom
- (void)clearnUnReceiveDevice
{
	dispatch_barrier_async(self.queue, ^{
		//把所有未标记的从dic中一出  已标记的变成未标记 等待下一次的搜索
		NSArray<NSString *> *allKeys = [self.netInfoDic allKeys].copy;
		
		for (NSString *key in allKeys)
		{
			DHDeviceNetInfo *device = self.netInfoDic[key];
			if(!device.isVaild)
			{
				NSLog(@"%@ 在这次搜索中被移除", key);
				[self.netInfoDic removeObjectForKey:key];
			}
			else if (device.searchSequence != self.searchSequence)
			{
				//【*】21589：只有当前的搜索结束了，才将缓存中未搜索到的设备有效状态重置
				NSLog(@"DHNetSDKSearchManager:: 重置设备有效状态,设备 %@, 搜索序号： %ld, 当前序号：%ld", device.deviceSN, (long)device.searchSequence, (long)self.searchSequence);
				self.netInfoDic[key].isVaild = NO;
			}
		}
	});
}

#pragma mark - private method


-(void)initNetSdk
{
	[DHNetSDKInterface initSDK];
	
#if DEBUG
	NSString *path = [[DHFileManager supportFolder] stringByAppendingPathComponent:@"cache"];
	[DHNetSDKInterface logOpen: path];
#endif
}

#pragma mark - singleton
static DHNetSDKSearchManager *_instance = nil;
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone{
    return _instance;
}
@end
