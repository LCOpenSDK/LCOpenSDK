//
//  Copyright © 2018年 Imou. All rights reserved.
//

#ifndef ILCApInfo_h
#define ILCApInfo_h

@protocol ILCApBasicInfo <NSObject>
@property(nonatomic, copy) NSString *apId; /**< 必须 报警网关配件ID */
@property(nonatomic, copy) NSString *deviceId; /**< 扩展属性：必须 设备ID */
@property(nonatomic, copy) NSString *apName; /**< apname */
@property(nonatomic, copy) NSString *apType; /**< 扩展属性：必须 设备ID */
//@property(nonatomic, assign) int     belong; /**< 属于*/
@end

/**
 配件详细信息
 */
@protocol ILCApState <NSObject>

@property(nonatomic, copy) NSString *electric; /** [O]电量百分比强度 */
@property(nonatomic, copy) NSString *doorlock; /** [O]门磁开关状态 */
@property(nonatomic, copy) NSString *sigIntensity; /** [O]信号强度 */

@end

@class LCApState;

@protocol ILCApInfo <NSObject>
@property(nonatomic, copy) NSString *apId; /**< 必须 报警网关配件ID */
@property(nonatomic, copy) NSString *apName; /**< 必须 配件名称 */
@property(nonatomic, copy) NSString *apType; /**< 必须 报配件类型 */
@property(nonatomic, copy) NSString *apModel; /**< 可选 海外为配件市场型号，国内为配件上报型号 */
@property(nonatomic, copy) NSString *apModelName; /**< 可选 配件的市场型号 */
@property(nonatomic, copy) NSString *ioType; /**< 必须 配件的io类型 in-输入 out-输出 */
@property(nonatomic, copy) NSString *apVersion; /**< 必须 配件版本号 */
@property(nonatomic, copy) NSString *apStatus; /**< 必须 online-在线 offline-离线 */
@property(nonatomic, copy) NSString *apEnable; /**< 必须 on-使能开启 off-使能关闭 */
@property(nonatomic, copy) NSString *apCapacity; /**< 可选 配件能力集 */
@property(nonatomic, copy) NSString *canBeUpgrade; /**< 必须 是否有新版本可以升级, true：有, false：无 */
@property (nonatomic, copy) NSString *shareStatus; /**< 可选 被分享状态 share-别人分享 auth-别人授权 shareAndAuth-别人分享和授权 */
@property (nonatomic, copy) NSString *shareToOthers; /**< 可选 分享给他人的标志,shareToOthers-已经分享给他人，none-没有分享给他人，默认表示没有分享给别人  */
@property (nonatomic, copy) NSString *shareFunctions; /**< 可选 被分享和授权的权限功能列表（逗号隔开）（saas） */

@property (nonatomic, strong) LCApState *apState;

/// 必须 设备ID
@property(nonatomic, copy) NSString *deviceId; /**< 扩展属性：必须 设备ID */

@end
#endif /* ILCApInfo_h */
