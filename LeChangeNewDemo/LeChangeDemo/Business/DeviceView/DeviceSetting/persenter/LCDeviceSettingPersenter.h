//
//  Copyright © 2020 dahua. All rights reserved.
//


#import "LCDeviceVideoManager.h"
#import "LCUIKit.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    LCDeviceSettingStyleMainPage,//设定主页
    LCDeviceSettingStyleVersionUp,//设定版本升级
    LCDeviceSettingStyleDeploy,//设定布防详情
    LCDeviceSettingStyleDeviceDetailInfo,//设备详细信息
    LCDeviceSettingStyleDeviceNameEdit,//名称设定
    LCDeviceSettingStyleDeviceSnap//缩略图设定
} LCDeviceSettingStyle;

@interface LCDeviceSettingPersenter : LCBasicPresenter<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic)LCDeviceSettingStyle style;

@property (nonatomic)BOOL needReload;

@property (strong, nonatomic) LCDeviceVideoManager *manager;

@property (strong, nonatomic) NSString *deviceName;

@property (nonatomic) BOOL endEdit;

/**
 更改设备名称
 */
- (void)modifyDevice;

/// 删除设备
- (void)deleteDevice;

/// 获取最新的设备信息
- (void)reloadDeviceInfo;

/// 停止刷新
- (void)stopCheckUpdate;



@end

NS_ASSUME_NONNULL_END
