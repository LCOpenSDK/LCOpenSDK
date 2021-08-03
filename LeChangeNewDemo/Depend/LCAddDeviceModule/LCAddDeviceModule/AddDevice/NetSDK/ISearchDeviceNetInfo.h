//
//  Copyright © 2018年 dahua. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, DHIPType) {
    DHIPTypeV4 = 4 ,
    DHIPTypev6 = 6
};

typedef NS_ENUM(NSUInteger, DHDeviceInitType) {
    DHDeviceInitTypeOldDevice = 0,   /**< 老设备程序初始化方式(老设备无法确认IP是否有效)*/
    DHDeviceInitTypeIPEnable,        /**< 新设备程序IP有效初始化方式*/
    DHDeviceInitTypeIPUnable        /**< 新设备程序IP无效初始化方式*/
};

typedef NS_ENUM(NSUInteger, DHDeviceInitStatus) {
    DHDeviceInitStatusUnInit = 0,   /**未初始化*/
    DHDeviceInitStatusInit,        /**<已初始化*/
    DHDeviceInitStatusNoAbility        /**没有能力集*/
};

/// 设备密码重置类型
typedef NS_ENUM(NSUInteger, DHDevicePasswordResetType) {
	DHDevicePasswordResetUnkown = 0,
	DHDevicePasswordResetPresetPhone, /**< 旧的预置手机号 */
	DHDevicePasswordResetPresetEmail, /**< 旧的预置邮箱 */
	DHDevicePasswordResetLechangePhone, /**< 国内注册手机号 */
};

typedef NS_ENUM(NSUInteger, DHDevicePasswordResetError) {
	DHDevicePasswordResetErrorNone = 0, /**< 无错误 */
	DHDevicePasswordResetErrorGUI, /**< 需要GUI方式重置密码 */
	DHDevicePasswordResetErrorMulti, /**< 需要大华渠道APP、config tool工具重置密码,组播 */
	DHDevicePasswordResetErrorWeb, /**<  需要使用web */
	DHDevicePasswordResetErrorOther , /**< 其他方式 **/
};

@protocol ISearchDeviceNetInfo <NSObject>
@property (nonatomic, assign) NSInteger searchSequence; /**< 搜索的序号，用来标记是属于哪次搜索 */
@property (nonatomic, assign) BOOL isVaild;//是否有效  非NETSDK返回数据  用于上层标记在一个周期内有没有收到该设备数据
@property (nonatomic, copy, readonly)NSString *deviceSN; // 序列号
@property (nonatomic, copy, readonly)NSString *deviceIP; // 设备IP
@property (nonatomic, copy, readonly)NSString *deviceMac;// mac地址
@property (nonatomic, assign) int port; // tcp端口
@property (nonatomic, assign, readonly) DHDevicePasswordResetType devicePwdResetWay;         //密码重置方式
@property (nonatomic, readonly) DHIPType ipType; // 设备IP
@property (nonatomic, readonly) DHDeviceInitType deviceInitType; // 设备初始化方式  由netsdk搜索到的设备IP状态决定
@property (nonatomic) DHDeviceInitStatus deviceInitStatus; // 设备初始化状态(枚举)
@property (nonatomic, readonly) BOOL isSupportPWDReset; // 是否支持密码重置
@end



