//
//  Copyright © 2018年 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 设备OMS信息
@interface LCOMSDeviceModelItem: NSObject<NSCopying, NSCoding>
@property (nonatomic, copy) NSString *deviceModelName; /**< String 必须 市场型号  */
@property (nonatomic, copy) NSString *deviceImageURI; /**< String 必须 设备正视图（图片尺寸参考UI）的URI  */
@end


@interface LCOMSDeviceType: NSObject
@property (nonatomic, copy) NSString *deviceType ; /**< 分类名称，摄像机Camera, 门锁DoorBell, 报警器AlarmDevice, 网关Gateway, 硬盘录像机DV  */
@property (nonatomic, strong) NSMutableArray<LCOMSDeviceModelItem *> *modelItems; /**< 设备数组 */

@end



/// OMS图片引导信息
@interface LCOMSIntroductionImageItem: NSObject<NSCopying, NSCoding>
@property (nonatomic, copy) NSString *imageName ; /**< String 必须 图片名称，app自定义，用于区分，统计好后发给平台录入   */
@property (nonatomic, copy) NSString *imageURI ; /**< 图片下载地址uri，oms提供上传图片服务，保存uri  */
@end


/// OMS引导项
@interface LCOMSIntroductionContentItem: NSObject<NSCopying, NSCoding>
@property (nonatomic, copy) NSString *introductionName; /**< String 必须 引导提示名称，app自定义，用于区分，统计好后发给平台录入 */
@property (nonatomic, copy) NSString *introductionContent; /**< String 必须 引导提示内容 */
@end

/// OMS引导信息
@interface LCOMSIntroductionInfo: NSObject<NSCopying, NSCoding>
@property (nonatomic, copy) NSString *updateTime ; /**< String 必须 配置的更新时间，oms更新修改时记录 */
@property (nonatomic, strong) NSMutableArray<LCOMSIntroductionImageItem *> *images; /**< 图片引导数组 */
@property (nonatomic, strong) NSMutableArray<LCOMSIntroductionContentItem *> *contens; /**< 引导提示数组 */
@end

/// iot设备添加引导信息
@interface LCIotDeviceAddGuideInfo: NSObject
@property (nonatomic, copy) NSString *stepTitle ; /**< 标题 */
@property (nonatomic, strong) NSString *stepOperate; /**< 内容提示 */
@property (nonatomic, strong) NSMutableArray<NSString *> *stepIcon; /**< 引导图数组 */
@end

/// tabbar图片信息
@interface LCTabbarIconInfo: NSObject<NSCopying, NSCoding>

@property (nonatomic, copy) NSString *iconNameDefault ;//图标名称位置
@property (nonatomic, copy) NSString *iconName ; //图标名称
@property (nonatomic, copy) NSString *iconPic;  //未选中
@property (nonatomic, copy) NSString *iconPicSelected ; //选中
@end
