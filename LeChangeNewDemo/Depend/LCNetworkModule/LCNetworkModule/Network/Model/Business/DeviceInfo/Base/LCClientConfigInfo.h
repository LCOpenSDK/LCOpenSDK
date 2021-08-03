//
//  Copyright © 2018年 dahua. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 设备OMS信息
@interface DHOMSDeviceModelItem: NSObject<NSCopying, NSCoding>
@property (nonatomic, copy) NSString *deviceModelName; /**< String 必须 市场型号  */
@property (nonatomic, copy) NSString *deviceImageURI; /**< String 必须 设备正视图（图片尺寸参考UI）的URI  */
@end


@interface DHOMSDeviceType: NSObject
@property (nonatomic, copy) NSString *deviceType ; /**< 分类名称，摄像机Camera, 门锁DoorBell, 报警器AlarmDevice, 网关Gateway, 硬盘录像机DV  */
@property (nonatomic, strong) NSMutableArray<DHOMSDeviceModelItem *> *modelItems; /**< 设备数组 */

@end



/// OMS图片引导信息
@interface DHOMSIntroductionImageItem: NSObject<NSCopying, NSCoding>
@property (nonatomic, copy) NSString *imageName ; /**< String 必须 图片名称，app自定义，用于区分，统计好后发给平台录入   */
@property (nonatomic, copy) NSString *imageURI ; /**< 图片下载地址uri，oms提供上传图片服务，保存uri  */
@end


/// OMS引导项
@interface DHOMSIntroductionContentItem: NSObject<NSCopying, NSCoding>
@property (nonatomic, copy) NSString *introductionName; /**< String 必须 引导提示名称，app自定义，用于区分，统计好后发给平台录入 */
@property (nonatomic, copy) NSString *introductionContent; /**< String 必须 引导提示内容 */
@end

/// OMS引导信息
@interface DHOMSIntroductionInfo: NSObject<NSCopying, NSCoding>
@property (nonatomic, copy) NSString *updateTime ; /**< String 必须 配置的更新时间，oms更新修改时记录 */
@property (nonatomic, strong) NSMutableArray<DHOMSIntroductionImageItem *> *images; /**< 图片引导数组 */
@property (nonatomic, strong) NSMutableArray<DHOMSIntroductionContentItem *> *contens; /**< 引导提示数组 */
@end

/// tabbar图片信息
@interface DHTabbarIconInfo: NSObject<NSCopying, NSCoding>

@property (nonatomic, copy) NSString *iconNameDefault ;//图标名称位置
@property (nonatomic, copy) NSString *iconName ; //图标名称
@property (nonatomic, copy) NSString *iconPic;  //未选中
@property (nonatomic, copy) NSString *iconPicSelected ; //选中
@end
