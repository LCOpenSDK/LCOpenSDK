/***************************************************
 ** 版权保留(C), 2001-2014, 浙江大华技术股份有限公司.
 ** 版权所有.
 **
 ** $Id$
 **
 ** 功能描述   : 登录组件
 **
 ** 修改历史   : 2016年10月8日 32217 Modification
****************************************************/
#ifndef __DAHUA_LCCommon_LOGINCOMPONENT_OCLOGINMANAGER_H__
#define __DAHUA_LCCommon_LOGINCOMPONENT_OCLOGINMANAGER_H__
#import <Foundation/Foundation.h>

#pragma mark - OCLoginListener
@protocol OCLoginListener <NSObject>

- (void)onNetSDKDisconnect:(NSString*)deviceSn;
/**
 login result
 @param type 1 :初始化 2:预打洞 3:预登录
 @param deviceSn 序列号 初始化时为空字符串
 @param code 错误码
 */
- (void)onLoginResult:(NSInteger)type DeviceSn:(NSString*)deviceSn Code:(NSInteger)code;

/**
 * P2P全埋点回调
*/
- (void)onP2PLogInfo:(NSString*)logMessage;

/**
 * commonsdk透传埋点回调
*/
- (void)onP2PICELogInfo:(NSString*)logMessage;

/**
 * P2P DeviceInfo缓存回调
*/
- (void)onGetDevP2PInfo:(NSString*)info;

/**
 * netsdk埋点回调
*/
- (void)onNetSDKEventTrackInfo:(NSInteger) eType Info:(NSString*)info;

@end

#pragma mark - OCNetSDKLogin
@protocol OCNetSDKLogin <NSObject>

- (NSString*)netSDKLoginSyn:(NSInteger)p2pPort DeviceSn:(NSString*)deviceSn;

/**
 login result
 @param p2pPort P2P代理端口号
 @param deviceSn 序列号 初始化时为空字符串
 */
- (NSInteger)netSDKLoginAsyn:(NSInteger)p2pPort DeviceSn:(NSString*)deviceSn;

@end

#pragma mark - OCLoginManager
@interface OCLoginManager : NSObject
+ (OCLoginManager*)shareInstance;
/**
 *  初始化P2P服务器, 已废弃
 *
 *  @param p2pSvrIP    P2P服务器ip
 *  @param p2pSvrPort  P2P服务器端端口
 *  @param p2pSvrUsername  登陆P2P服务器的鉴权用户名
 *  @param p2pSvrPwd       登陆P2P服务器的鉴权密钥
 *  @return 成功true, 失败false
 */
- (BOOL)initP2pSvr:(NSString*)p2pSvrIP p2pSvrPort:(NSUInteger)p2pSvrPort p2pSvrUsername:(NSString*)p2pSvrUsername p2pSvrPwd:(NSString*)p2pSvrPwd isRelay:(BOOL)isRelay;

/**
 *  初始化CommonSDK依赖库, 包含NetSDK, 已废弃
 */
- (BOOL)initSDK:(NSString*)SaaSSvrIP;

/**
 *  初始化CommonSDK依赖库, 不包含NetSDK, 与initNetSDK()配套使用
 */
- (BOOL)initSDK2:(NSString*)SaaSSvrIP;

/**
 *  初始化NetSDK, 与initSDK2配套使用
 */
- (BOOL)initNetSDK;

/**
 *  初始化预打洞, 预登录流程, 含同步域名解析, 已废弃
 *
 *  @param p2pServerIP   P2P服务域名
 *  @param userName      P2P鉴权全局ak, 一机一密鉴权时传空字符串
 *  @param pwd           P2P鉴权全局sk, 一机一密鉴权时传空字符串
 *  @param isRelay       是否开启Relay
 *  @return  成功:true, 失败: false
 */
- (BOOL)initP2PServerAfterSDK:(NSString*)p2pServerIP p2pSerPort:(NSInteger)p2pSerPort userName:(NSString*)userName pwd:(NSString*)pwd isRelay:(BOOL)isRelay;

/**
 *  初始化预打洞, 预登录流程, 支持域名解析缓存
 *
 *  @param p2pSvrAddr    P2P服务域名
 *  @param p2pSvrIpv4    P2P服务IP(v4)
 *  @param p2pSvrIpv6    P2P服务IP(v6)
 *  @param userName      P2P鉴权全局ak, 一机一密鉴权时传空字符串
 *  @param pwd           P2P鉴权全局sk, 一机一密鉴权时传空字符串
 *  @param isRelay       是否开启Relay
 *  @return  成功:true, 失败: false
 */
- (BOOL)initP2PServerAfterSDKEx:(NSString*)p2pSvrAddr p2pSvrIpv4:(NSString*)p2pSvrIpv4 p2pSvrIpv6:(NSString*)p2pSvrIpv6 p2pSerPort:(NSInteger)p2pSerPort userName:(NSString*)userName pwd:(NSString*)pwd isRelay:(BOOL)isRelay;

/**
 *  更新P2P服务器的鉴权用户名和密钥, 使用一机一密不再需要
 *
 *  @param username  登陆P2P服务器的鉴权用户名
 *  @param pwd       登陆P2P服务器的鉴权密钥
 *  @return 成功:true, 失败: false
 */
- (BOOL)updateP2PUsernamePwd:(NSString*)username pwd:(NSString*)pwd;

/**
 *  去初始化
 */
- (void)unInit;

/**
 *  设置监听者
 *
 *  @param listener 监听者
 */
- (void)setListener:(id<OCLoginListener>)listener;

/**
 *  设置最大关注设备数量
 *
 *  @param maxDeviceNum    设备数量
 */
- (void)setMaxDeviceNum:(NSUInteger)maxDeviceNum;

/**
 *  添加设备
 *
 *  @param devicesJsonStr    设备信息，json结构，例如[{"Sn":string, "Pid":string, "Type":UINT,"Port":UINT,"User":string, "Pwd":string,"extP2PInfo":[{"dstPort":UINT},...]},{},...]
 *  Type的值中 0表示大华P2P设备，1表示乐橙设备
 *  @return
 *  - True     添加成功
 *  - False    添加失败
 */
- (BOOL)addDevices:(NSString*)devicesJsonStr;

/**
 *  删除设备
 *
 *  @param devicesJsonStr    设备信息，序列号的字符串
 *  @return
 *  - True     删除成功
 *  - False    删除失败
 */
- (BOOL)delDevices:(NSString*)devicesJsonStr;

/**
 * 删除所有设备
 * @return
 * - True   成功
 * - False  失败
 */
- (BOOL)delAllDevices;

- (BOOL)reConnectDevices:(NSString*)devicesJsonStr;

/**
 *  断开所有设备的连接
 */
- (BOOL)disConnectAll;

/**
 * 重新建立所有设备的连接
 */
- (BOOL)reConnectAll;

/**
 *  获取某台设备的P2P映射端口--针对乐橙设备, 已废弃
 *
 *  @param deviceJsonStr    设备信息，json结构，例如{"Sn":"123456", "Pid":"xxx", "Type":1, "Port":554, "User":"1636633666", "Pwd":"secret"}
 *                          Type的值中 0表示大华P2P设备，1表示乐橙设备
 *  @param timeout          超时时间  单位：毫秒
 *
 *  @return
 *  - >0 P2P映射端口
 *  - 0  映射失败
 *  @note  本接口为阻塞接口，由参数timeout控制超时时间
 */
- (NSUInteger)getP2PPort:(NSString*)deviceJsonStr timeout:(NSUInteger)timeout;

/**
 *  获取某台设备的P2P映射端口
 *
 *  @param deviceJsonStr    设备信息，json结构，例如{"Sn":"123456", "Pid":"xxx", "Type":1, "Port":554, "User":"1636633666", "Pwd":"secret"}
 *                          Type的值中 0表示大华P2P设备，1表示乐橙设备
 *  @param p2pState         设备p2p连接状态
 *  @param timeout          超时时间  单位：毫秒
 *
 *  @return
 *  - >0 P2P映射端口
 *  - 0  映射失败
 *  @note  本接口为阻塞接口，由参数timeout控制超时时间
 */
- (NSUInteger)getP2PPort:(NSString*)deviceJsonStr p2pState:(unsigned int *)p2pState p2pNattCt:(int*)nattCt timeout:(NSUInteger)timeout lastTraversalCost:(int*)lastTraversalCost;

/**
 获取某台设备的P2P映射端口(需指定设备监听端口号), 已废弃

 @param deviceSN 设备序列号
 @param port 设备监听端口号
 @param timeout 超时时间(单位毫秒)
 @return
    - >0 P2P映射端口
    - 0  映射失败
 @note  本接口为阻塞接口，由参数timeout控制超时时间
 */
- (NSUInteger)getP2PPort:(NSString*)deviceSN devicePort:(NSUInteger)port timeout:(NSUInteger)timeout;

/**
 * 获取P2P打洞状态
*/
- (NSUInteger) getP2PState:(NSString*)deviceSN;

/**
 *  获取某台设备的NetSDK登陆句柄--针对大华P2P设备
 *
 *  @param deviceJsonStr    设备信息，json结构，例如{"Sn":"123456", "Type":1, "Port":554, "User":"1636633666", "Pwd":"secret"}
 *                          Type的值中 0表示大华P2P设备，1表示乐橙设备
 *  @param timeout          超时时间  单位：毫秒
 *
 *  @return
 *  - >0     有效的NetSDK登陆句柄
 *  - NULL   获取失败
 *  @note  本接口为阻塞接口，由参数timeout控制超时时间
 */
- (void*)getNetSDKHandler:(NSString*)deviceJsonStr timeout:(NSUInteger)timeout isUseCached:(BOOL)isUseCached;

/**
*  尝试netsdkld登录
*  @param deviceJsonStr    设备信息，json结构，例如{"Sn":"123456", "Type":1, "Port":554, "User":"1636633666", "Pwd":"secret"}
*                          Type的值中 0表示大华P2P设备，1表示乐橙设备
*  @param timeout          超时时间  单位：毫秒
*
*  @return
*  - >0     尝试成功
*  - NULL   尝试失败
*  @note  本接口为阻塞接口，由参数timeout控制超时时间
*/
- (void*)tryNetSDKConnect:(NSString*)deviceJsonStr timeout:(NSUInteger)timeout isUseCached:(BOOL)isUseCached ErrorCode:(int*)error;

/**
 设置P2P库日志等级

 @param level 日志等级(同日志组件中定义)
 @note 该接口必须在ini接口前调用才有效
 */
- (void)setLogLevel:(NSInteger)level;

/**
 接口调用失败后获取错误码

 @param deviceSN 设备信息 json格式: {“Did”:”xxx”, “Pid”:”xxx”}
 @param desc     错误码描述
 	-对于不同的错误码，代表不同的含义
    -目前仅支持netsdk密码错误，desc表示剩余登陆次数（超过此次数会被锁定)
 @return 登陆错误码
    -小于0: 查询失败
    -其他:( p2p错误码偏移100， NetSDK错误码偏200)
     P2P错误码 = 错误码 - 100
        error = 0   打洞失败(目前p2p没有打洞失败的错误原因)
     NetSDK错误码 = 错误码 - 200
        error = 1   密码不正确
        error = 2   用户名不存在
        error = 3   登录超时
        error = 4   重复登录
        error = 5   帐号被锁定
        error = 6   帐号被列入黑名单
        error = 7   系统忙,资源不足
        error = 8   子连接失败
        error = 9   主连接失败
        error = 10  超过最大连接数
        error = 11  只支持3代协议
        error = 12  设备未插入U盾或U盾信息错误
        error = 13  客户端IP地址没有登录权限
        error = 17  老设备使用(同1、2)
 */
- (NSInteger)getErrNo:(NSString*)deviceSN desc:(NSString**)desc;

/**
 查询设备P2P在线状态

 @param deviceSN 设备信息 json格式: {“Did”:”xxx”, “Pid”:”xxx”}
 @return 设备是否在线
     - 在线    0
     - 不在线  1
     - 其他    其他
 */
- (NSInteger)getDevState:(NSString*)deviceSN;

/**
 返回设备状态(对于NetSDK有效)

 @param deviceSN 设备序列号
 @return 返回设备状态信息的json字符串
     - 成功:json格式如下
         {
         "InPortNum":,     // DVR报警输入个数
         "OutPortNum":0,     // DVR报警输出个数
         "DiskNum":0,        // DVR硬盘个数
         "DVRType":0,        // DVR类型,见枚举NET_DEVICE_TYPE
         "ChanNum":0,        // DVR通道个数
         "LimitLoginTime":0, // 在线超时时间,为0表示不限制登陆,非0表示限制的分钟数
         "LeftLogTimes":0,   // 当登陆失败原因为密码错误时,通过此参数通知用户,剩余登陆次数,为0时表示此参数无效
         "LockLeftTime":0,   // 当登陆失败,用户解锁剩余时间（秒数）, -1表示设备未设置该参数
         }
     - 失败：空
 */
- (NSString*)getDevLogInfo:(NSString*)deviceSN;

/**
 获取初始化时Relay的状态

 @return 是否开启Relay
 - OPEN   YES
 - CLOSE  NO
 - 其他    其他
 */
- (BOOL)isRelayOpen;

/**
 设置netsdk登录接口
 */
- (void)setNetSDKLogin:(id<OCNetSDKLogin>)netsdkLogin;

/**
 通知netsdk登录结果
 */
- (void)notifyLoginResult:(NSString*)LoginResult;

/**
 * 获取p2p穿透类型
 * @param deviceSN 设备序列号
 * @param pid 设备product id
 * 0:局域网; 1:p2p; 2:Relay
 */
- (int)getP2PLinkType:(NSString*)deviceSN Pid:(NSString*)pid;

- (BOOL)setSessionInfo:(NSInteger)localPort IP:(NSString*)ip Port:(NSInteger)port ReuqestId:(NSString*)requestId DeviceSn:(NSString*)deviceSn;

/**
 * 配置CPacketManager内存大小
*/
- (void)configPacket;

/**
 * 清理资源
 * @note 典型情况是退出app时调用以主动清理资源
 */
- (void)cleanUp;

/**
 * 初始化网络相关模块（curl、ssl、NetFrameWork）
 */
- (void)initNetWorkComponent;

/**
 * 初始化安恒加解密服务, 已废弃
 * @param terminalId 终端唯一id
 * @param svrAddr 安恒服务地址
 * @param configPath 配置写入的文件路径
 */
- (BOOL)initAHEncryptService:(NSString*)terminalId SvrAddr:(NSString*)svrAddr ConfigPath:(NSString*)configPath;

/**
 * 设置埋点日志开头
*/
- (void)setLogReportConfig:(NSInteger)type Flag:(NSInteger)flag;

/**
 * 获取网络类型
 * return 1: ipv4    2: ipv6
 */
- (int)getNetIPType;

/*
* 获取打洞埋点上报数据
* json 格式：
* {"p2pNatState":int, "traversalCost":int, "p2pInfo_statCode":string, "p2pInfo_nattCt":string}
*/
- (NSString*)getP2PTraversalReportData:(NSString*)deviceSN Pid:(NSString*)pid;

/**
 域名解析

 @param domain 域名
 @return 返回域名解析的json字符串
     - 成功:json格式如下
         {
         "IPv4":"xxx",     // IPv4地址
         "IPv6":"xxx"     // IPv6地址
         }
     - 失败：{}
 */
- (NSString*)address2IpEx:(NSString*)domain;

/**
 * 设置App启动时间
 */
- (void)setApplicationStartTime;

/**
 * 获取公共组件初始化ID
 * @return 初始化ID字符串
 */
- (NSString*)getInitId;

/**
 * 重置云录像长连接
 * @note PlayerManager非单例, 在未创建播放的时候无法调用到, 故放到这里
 */
- (void)resetHlsLongConn;

@end

#endif //__DAHUA_LCCommon_LOGINCOMPONENT_OCLOGINMANAGER_H__
