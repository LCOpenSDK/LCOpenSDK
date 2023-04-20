//
//  Copyright © 2018年 Imou. All rights reserved.
//

#import "LCNetSDKSearchManager.h"
#import "LCNetSDKInterface.h"
#import "LCDeviceNetInfo.h"
#import <LCBaseModule/UIDevice+LeChange.h>
#import <LCBaseModule/LCNetWorkHelper.h>
#import <LCBaseModule/LCModuleConfig.h>
#import <LCBaseModule/LCFileManager.h>
#import <LCBaseModule/LCMobileInfo.h>
#import <LCAddDeviceModule/LCAddDeviceModule-Swift.h>

@interface LCNetSDKSearchManager()

@property (nonatomic, strong) NSMutableDictionary<NSString *, LCDeviceNetInfo*> *netInfoDic;
@property (nonatomic, copy) dispatch_queue_t queue;
@property (nonatomic, copy) NSString *lastSSID;//上次连接的wifi的ssid，用于网络环境变化重新搜索设备

@end

@implementation LCNetSDKSearchManager

#pragma mark - circle life

- (instancetype)init
{
    if(self = [super init])
    {
        [self initNetSdk];
        _netInfoDic = @{}.mutableCopy;
		_queue = dispatch_queue_create("syncOperation", DISPATCH_QUEUE_CONCURRENT);
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
	
    NSLog(@"FUNCTION____%s____line%d____",__FUNCTION__,__LINE__);
    [[LCNetSDKInterface sharedInstance] stopSearchDevices];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
	if(self.isSearching)
	{
		[self startSearch];
	}
}

- (void)networkDidChanged:(NSNotificationCenter *)notification {
	// DTS000583328 偶现崩溃 [LCMobileInfo sharedInstance].WIFISSID
	if (!self.isSearching) {
		return;
	}
	
    //针对软ap添加的bug
    NSString *wifiSSID = [[LCMobileInfo sharedInstance].WIFISSID uppercaseString];
    if (![wifiSSID isEqualToString:self.lastSSID] && wifiSSID.length) {
        self.lastSSID = wifiSSID;
        [self.netInfoDic removeAllObjects];
        if(self.isSearching) {
            [self startSearch];
        }
    }
}

#pragma mark - interface

- (void)startSearch {
    
    self.isSearching = true;
    
	//添加通知
	[self addObservers];
    
    // 开始搜索设备
    [[LCNetSDKInterface sharedInstance] startSearchDevices:^(LCDeviceNetInfo *netInfo) {
        dispatch_barrier_async(self.queue, ^{
            if (self.showDebugLog) {
                NSLog(@"LCNetSDKSearchManager::-find device: %@ - %@，搜索序号：%ld, Init type:%lu, status: %lu",
                      netInfo.deviceType, netInfo.serialNo, (long)netInfo.searchSequence, (unsigned long)netInfo.deviceInitType, (unsigned long)netInfo.deviceInitStatus);
            }

            //避免找到deviceId为空的情况
            if (netInfo.serialNo.length > 0) {
                LCNetSDKSearchManager.sharedInstance.netInfoDic[netInfo.serialNo] = netInfo;
            }
        });
    }];
}

- (void)stopSearch {
    self.isSearching = false;
	//停止通知
	[self removeObservers];
	
	dispatch_barrier_async(self.queue, ^{
		[self.netInfoDic removeAllObjects];
	});
	
    [[LCNetSDKInterface sharedInstance] stopSearchDevices];
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
			LCDeviceNetInfo *device = self.netInfoDic[key];
			if(!device.isVaild)
			{
				NSLog(@"%@ 在这次搜索中被移除", key);
				[self.netInfoDic removeObjectForKey:key];
			}
		}
	});
}

#pragma mark - private method


-(void)initNetSdk
{
	[LCNetSDKInterface initSDK];
	
#if DEBUG
	NSString *path = [[LCFileManager supportFolder] stringByAppendingPathComponent:@"cache"];
	[LCNetSDKInterface logOpen: path];
#endif
}

#pragma mark - singleton
static LCNetSDKSearchManager *_instance = nil;
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
