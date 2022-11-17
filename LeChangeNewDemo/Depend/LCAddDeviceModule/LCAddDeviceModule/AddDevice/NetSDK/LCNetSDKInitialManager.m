//
//  Copyright © 2018年 Imou. All rights reserved.
//

#import "LCNetSDKInitialManager.h"
#import "LCDeviceNetInfo.h"
#import "LCNetSDKInterface.h"
#import <LCAddDeviceModule/LCAddDeviceModule-Swift.h>

@interface LCNetSDKInitialManager()

@property (nonatomic,copy) NSString *pwdString;

@end

@implementation LCNetSDKInitialManager

#pragma mark - circle life

- (instancetype)init {
    if(self = [super init]) {

    }
    return self;
}

#pragma mark - singleton

static LCNetSDKInitialManager *_instance = nil;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

#pragma mark - interface

- (void)initialDeviceWithPassWord:(NSString *)pwdString
						 isSoftAp:(BOOL)isSoftAp
				  withInitialType:(LCDeviceInitType)initialType
				 withSuccessBlock:(InitialSuccessHandle)success
				 withFailureBlock:(InitialFailHandle)fail {
	if (isSoftAp) {
		[self initialApDeviceWithPassword:pwdString withInitialType:initialType withSuccessBlock:success withFailureBlock:fail];
	} else {
		[self initialCommonDeviceWithPassWord:pwdString withInitialType:initialType withSuccessBlock:success withFailureBlock:fail];
	}
}

-(void)initialCommonDeviceWithPassWord:(NSString *)pwdString
					   withInitialType:(LCDeviceInitType)initialType
					  withSuccessBlock:(InitialSuccessHandle)success
					  withFailureBlock:(InitialFailHandle)fail {
	/*
	 **初始化逻辑**
	 新设备程序在配网成功的情况下，可以根据搜索得到的设备信息中的specialAbility的bit2-3位判断IP是否有效(老设备程序无此能力，但可以根据此字段确定是否新老程序)，所以初始化逻辑重要有以下三种：
	 1、老设备程序：specialAbility的bit2-3位为0，此时走老的组播单播初始化逻辑
	 2、IP有效：直接走单播初始化逻辑，节省了组播初始化时间
	 3、IP无效：则需要等待DHCP分配IP成功才可以进行初始化。SearchManager在后台持续搜索，当DHCP分配成功，设备会重新发广播上报，SearchManager能够更新搜索到的设备信息，因此在IP无效的情况下，InitialManager(本类)只需要每隔0.5秒从SearchManager更新一次搜索结果，等待DHCP分配成功，根据获取到的有效IP进行单播初始化，20次以后DHCP未分配成功则初始化失败。
	 */
	
	NSLog(@"LCNetSDKInitialManager::Initial common device with type:%lu", (unsigned long)initialType);
	self.pwdString = pwdString;
	
	switch (initialType) {
			//老设备程序
		case LCDeviceInitTypeOldDevice:
			[self multicastWithPassWord:pwdString withInitialType:initialType withSuccessBlock:success withFailureBlock:fail];
			break;
			
			//IP有效初始化
		case LCDeviceInitTypeIPEnable:
			[self unicastWithPassWord:pwdString withInitialType:initialType withSuccessBlock:success withFailureBlock:fail];
			break;
			
			//IP无效
		case LCDeviceInitTypeIPUnable:
		{
			//计数器
			__block int count = 0;
			//计数最大值
			int maxCount = 20;
			//定时器对象
			__block dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
			//从现在开始，每0.5秒执行一次
			dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC), 0);
			//定时器回调
			dispatch_source_set_event_handler(timer, ^{
				
				NSLog(@"CGD定时器-----%@",[NSThread currentThread]);
				count++;
				if (count == maxCount) { // 执行20次(10秒后),释放定时器
					dispatch_async(dispatch_get_main_queue(), ^{
						//fail();
						
						//超时失败后，走老的初始化
						[self initialCommonDeviceWithPassWord:pwdString withInitialType:LCDeviceInitTypeOldDevice withSuccessBlock:success withFailureBlock:fail];
					});

					dispatch_cancel(timer);
					timer = nil;
				}else{
					//更新设备信息，获取IP
					LCDeviceNetInfo *deviceNetInfo = [self updateDeviceSearchInfo];
					if (deviceNetInfo.deviceInitType == LCDeviceInitTypeIPEnable){
						//最新IP有效
						if ([self unicastIpWithDeviceInfo:deviceNetInfo isMulticast:NO]) {
							//单播初始化成功
							dispatch_async(dispatch_get_main_queue(), ^{
								success();
							});
						}else{
							//单播初始化失败
							dispatch_async(dispatch_get_main_queue(), ^{
								fail();
							});
						}
						dispatch_cancel(timer);
						timer = nil;
					}
					
				}
			});
			//启动定时器
			dispatch_resume(timer);
		}
			break;
			
		default:
			break;
	}
}

- (void)initialApDeviceWithPassword:(NSString *)pwdString
					withInitialType:(LCDeviceInitType)initialType
				   withSuccessBlock:(InitialSuccessHandle)success
				   withFailureBlock:(InitialFailHandle)fail {
	NSLog(@"LCNetSDKInitialManager::Initial ap device with type:%lu", (unsigned long)initialType);
	self.pwdString = pwdString;
	
	switch (initialType) {
			//老设备程序或者IP效，均走老流程
		case LCDeviceInitTypeOldDevice:
		case LCDeviceInitTypeIPUnable:
			[self multicastWithPassWord:pwdString withInitialType:initialType withSuccessBlock:success withFailureBlock:fail];
			break;
			
			//IP有效初始化
		case LCDeviceInitTypeIPEnable:
			[self unicastWithPassWord:pwdString withInitialType:initialType withSuccessBlock:success withFailureBlock:fail];
			break;
			
		default:
			break;
	}
}

- (void)multicastWithPassWord:(NSString *)pwdString
			  withInitialType:(LCDeviceInitType)initialType
			 withSuccessBlock:(InitialSuccessHandle)success
			 withFailureBlock:(InitialFailHandle)fail {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		//组播 前三次发组播包 每次五秒
		LCDeviceNetInfo *deviceNetInfo = [self updateDeviceSearchInfo];
		if(deviceNetInfo==nil)
		{
			dispatch_async(dispatch_get_main_queue(), ^{
				fail();
			});
		}else if ([self multicastWithDeviceInfo:deviceNetInfo isMulticast:YES]) {
			//组播初始化成功
			dispatch_async(dispatch_get_main_queue(), ^{
				success();
			});
		}else{
			//组播初始化失败，获取最新的设备信息进行单播初始化
            deviceNetInfo = [self updateDeviceSearchInfo];
            if(deviceNetInfo==nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    fail();
                });
            }
			else if ([self unicastIpWithDeviceInfo:deviceNetInfo isMulticast:NO]) {
				//单播初始化成功
				dispatch_async(dispatch_get_main_queue(), ^{
					success();
				});
			}
			else {
				//单播初始化失败
				dispatch_async(dispatch_get_main_queue(), ^{
					fail();
				});
			}
		}
	});
}

- (void)unicastWithPassWord:(NSString *)pwdString
			withInitialType:(LCDeviceInitType)initialType
		   withSuccessBlock:(InitialSuccessHandle)success
		   withFailureBlock:(InitialFailHandle)fail {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
		LCDeviceNetInfo *deviceNetInfo = [self updateDeviceSearchInfo];
		if ([self unicastIpWithDeviceInfo:deviceNetInfo isMulticast:NO]) {
			dispatch_async(dispatch_get_main_queue(), ^{
				success();
			});
		}
		else {
			dispatch_async(dispatch_get_main_queue(), ^{
				fail();
			});
		}
	});
}

#pragma mark - private

- (BOOL)unicastIpWithDeviceInfo:(LCDeviceNetInfo *)deviceNetInfo isMulticast:(BOOL)isMulticast {
    LCDeviceInfoLogModel *model = [LCNetSDKInterface initDevAccount:self.pwdString device:deviceNetInfo useIp:YES];
    [self addDeviceNetSDKLog:model.isSuccess];
    [self addDeviceInitLog:deviceNetInfo info:model isMulticast:isMulticast];
    return model.isSuccess;
}

- (BOOL)multicastWithDeviceInfo:(LCDeviceNetInfo *)deviceNetInfo isMulticast:(BOOL)isMulticast {
    LCDeviceInfoLogModel *model = [LCNetSDKInterface initDevAccount:self.pwdString device:deviceNetInfo useIp:NO];
    [self addDeviceNetSDKLog:model.isSuccess];
    [self addDeviceInitLog:deviceNetInfo info:model isMulticast:isMulticast];
    return model.isSuccess;
}

//从LCNetSDKSearchManager获取最新的设备搜索信息
- (LCDeviceNetInfo*)updateDeviceSearchInfo {
    
    NSString *deviceID = [LCAddDeviceManager sharedInstance].deviceId;
    LCDeviceNetInfo *deviceNetInfo = [[LCNetSDKSearchManager sharedInstance] getNetInfoByID:deviceID];
    return deviceNetInfo;
}

- (void)addDeviceNetSDKLog:(BOOL)isSuccess
{
    LCAddDeviceLogModel *model = [[LCAddDeviceLogModel alloc] init];
    model.method = @"initDevAccount";
    model.res = isSuccess ? model.res : model.resFail;
    model.errCode = isSuccess ? model.errCode : [LCNetSDKInterface getLastError];
    [[LCAddDeviceLogManager shareInstance] addDeviceNetSDKLogWithModel:model];
}

- (void)addDeviceInitLog:(LCDeviceNetInfo *)deviceNetInfo info:(LCDeviceInfoLogModel *)info isMulticast:(BOOL)isMulticast
{
    LCAddDeviceLogModel *model = [[LCAddDeviceLogModel alloc] init];
    model.deviceInfo = info;
    model.type = isMulticast ? model.initDev : model.initDev;
    model.res = info.isSuccess ? model.res : model.resFail;
    model.errCode = info.isSuccess ? model.errCode : [LCNetSDKInterface getLastError];
    [[LCAddDeviceLogManager shareInstance] addDeviceInitLogWithModel:model];
}


@end
