//
//  Copyright © 2020 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LCBaseModule/LCBaseModule.h>
#import <LCNetWorkModule/LCNetWorkModule.h>

typedef enum : NSUInteger {
    LCDeviceSettingStyleVersionUp,//设定版本升级  Setting the Version Upgrade
    LCDeviceSettingStyleDeploy,//设定布防详情  Set deployment details
    LCDeviceSettingStyleDeviceDetailInfo,//设备详细信息  Device Details
    LCDeviceSettingStyleDeviceNameEdit,//名称设定  The name of the set
    LCDeviceSettingStyleDeviceSnap,//缩略图设定  Thumbnail Settings
    CDeviceSettingStyleCameraNameEdit//镜头名称设定  The camera name of the set
} LCDeviceSettingStyle;

@interface LCDeviceSettingPersenter : NSObject<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic)LCDeviceSettingStyle style;

@property (nonatomic)BOOL needReload;

@property (nonatomic) BOOL endEdit;

@property (strong, nonatomic) LCDeviceVersionInfo *versionInfo;

@property (strong, nonatomic) LCDeviceInfo *deviceInfo;

@property (strong, nonatomic) LCChannelInfo *channelInfo;

@property (weak, nonatomic) UIViewController *viewController;

- (instancetype)initDeviceInfo:(LCDeviceInfo *)deviceInfo channelId:(NSString *)channelId;

/**
 更改设备名称
 Changing the Device Name
 */
- (void)modifyDevice;

/// 删除设备
/// Remove equipment
- (void)deleteDevice;

/// 停止刷新
/// Stop the refresh
- (void)stopCheckUpdate;

@end
