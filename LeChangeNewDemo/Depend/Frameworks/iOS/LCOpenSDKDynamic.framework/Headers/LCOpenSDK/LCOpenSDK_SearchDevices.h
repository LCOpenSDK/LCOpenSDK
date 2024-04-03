//
//  LCOpenSDK_SearchDevice.h
//  LeChangeDemo
//
//  Created by macopen on 2021/12/16.
//

#import <Foundation/Foundation.h>
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_Define.h>

@interface LCOpenSDK_SearchDeviceInfo : NSObject

// Search sequence number     zh:搜索的序号，用来标记是属于哪次搜索
@property (nonatomic, assign) NSInteger searchSequence;
// ip
@property (nonatomic, copy) NSString *ip;
// 4 for IPV4, 6 for IPV6
@property (nonatomic, assign) int ipVersion;
// tcp port
@property (nonatomic, assign) int port;
// Subnet mask    zh:子网掩码 IPV6无子网掩码
@property (nonatomic, copy) NSString *submask;
// mac
@property (nonatomic, copy) NSString *mac;
// gateway
@property (nonatomic, copy) NSString *gateway;
// device type
@property (nonatomic, copy) NSString *deviceType;
// 1 HG, 2SD    zh:1-标清 2-高清
@property (nonatomic, assign) NSUInteger definition;
//目标设备的生产厂商 具体参考NETSDK中EM_IPC_TYPE类
@property (nonatomic, assign) NSInteger manuFactory;
//Dhcp使能状态, true-开, false-关
@property (nonatomic, assign) BOOL dhcpEn;
//字节对齐
@property (nonatomic, assign) int reserved1;
// 验数据 通过异步搜索回调获取(在修改设备IP时会用此信息进行校验)
@property (nonatomic, copy) NSString *verifyData;
// 序列号
@property (nonatomic, copy) NSString *serialNo;
// 设备软件版本号
@property (nonatomic, copy) NSString *devSoftVersion;
// 设备型号
@property (nonatomic, copy) NSString *detailType;
// OEM客户类型
@property (nonatomic, copy) NSString *vendor;
//设备名称
@property (nonatomic, copy) NSString *devName;
// 登陆设备用户名
@property (nonatomic, copy) NSString *userName;
// 登陆设备密码
@property (nonatomic, copy) NSString *passWord;
// HTTP服务端口号
@property (nonatomic, assign) NSUInteger httpPort;
// 视频输入通道数
@property (nonatomic, assign) NSUInteger videoInputCh;
// 远程视频输入通道数
@property (nonatomic, assign) NSUInteger remoteVideoInputCh;
// 视频输出通道数
@property (nonatomic, assign) NSUInteger videoOutputCh;
// 报警输入通道数
@property (nonatomic, assign) NSUInteger alarmInputCh;
// 报警输出通道数
@property (nonatomic, assign) NSUInteger alarmOutputCh;
//使用新字段密码
@property (nonatomic, assign) BOOL newWordLen;
//登录设备密码
@property (nonatomic, copy) NSString *nowPassWord;
//设备初始化状态，按位确定初始化状态
// bit0~1：0-老设备，没有初始化功能 1-未初始化账号 2-已初始化账户
// bit2~3：0-老设备，保留 1-公网接入未使能 2-公网接入已使能
// bit4~5：0-老设备，保留 1-手机直连未使能 2-手机直连使能
// bit6~7: 0- 未知 1-不支持密码重置 2-支持密码重置
@property (nonatomic, assign) NSInteger initStatus;
//支持密码重置方式：按位确定密码重置方式，只在设备有初始化账号时有意义: bit0-支持预置手机号 bit1-支持预置邮箱 bit2-支持文件导出 bit3-支持国内注册手机号
@property (nonatomic, assign) NSInteger byPWDResetWay;
//设备初始化能力，按高八位确定初始化能力
//bit0-是否支持2D Code修改IP: 0 不支持 1 支持
//bit1-是否支持PN制:0 不支持 1支持
//bit2-3(3.7新设备程序能力)-设备的IP地址是否DHCP分配:0-不支持 1-未分配 2-已分配3-DHCP使能关闭
@property (nonatomic, assign) NSInteger specialAbility;
//设备型号
@property (nonatomic, copy) NSString *nowDetailType;
//TRUE表示使用新用户名(szNewUserName)字段
@property (nonatomic, assign) BOOL bNowUserName;
// 登陆设备用户名（在修改设备IP时需要填写）
@property (nonatomic, copy) NSString *nowUserName;

// 登陆设备用户名（在修改设备IP时需要填写）
@property (nonatomic, assign, readonly) LCDeviceInitStatus deviceInitStatus;

- (LCDeviceInitType)deviceInitType;

@end

@interface LCOpenSDK_SearchDevices : NSObject

+ (instancetype)shareSearchDevices;

/// search devices
/// @param deviceId device id
/// @param timeOut time out
/// @param searchDeviceCallBack callback
- (void)startSearchDevicesWithDeviceId:(NSString *)deviceId timeOut:(int)timeOut callback:(void (^)(LCOpenSDK_SearchDeviceInfo *deviceInfo))searchDeviceCallBack;

/// stop search devices
/// @param handle handle description
- (void)stopSearchDevices;

/// get last error
+ (unsigned int)getLastError;

@end
