//
//  LCMediaLoginManager.h
//  LCMediaComponents
//
//  Created by lei on 2021/1/27.
//

#import <Foundation/Foundation.h>
#import <LCOpenMediaSDK/LCVideoPlayerDefines.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LCMediaLoginManagerListener <NSObject>

/**
 netsdk   断线
 @param deviceSn 序列号
 */
- (void)onNetSDKDisconnect:(NSString *)deviceSn;

/**
 login result
 @param type 1 :初始化 2:预打洞 3:预登录 --参考枚举 OC_LOGIN_STATE
 @param deviceSn 序列号 初始化时为空字符串
 @param code 错误码
 */
- (void)onLoginResult:(NSInteger)type DeviceSn:(NSString*)deviceSn Code:(NSInteger)code;

- (void)onP2PLogInfo:(NSString*)logMessage;

- (void)onP2PICELogInfo:(NSString*)logMessage;

/**
 * 已获取设备用于p2p打洞的信事件
 * @param info json格式信息：{"p2pVer":[String]设备p2p版本, "p2pSalt":[String]设备p2p随机盐值}
 */
- (void)onGetDevP2PInfo:(NSString*)info;

/// netSDK埋点
/// @param eType 类型
/// @param info 埋点数据
- (void)onNetSDKEventTrackInfo:(NSInteger)eType Info:(NSString*)info;

@end

@interface LCMediaLoginManager : NSObject

@property(nonatomic, assign)LCMediaComponentsMode mediaMode;

@property(nonatomic, assign)LCMediaComponentsNetProtocolType networkProtocol;
//媒体支持的功能
@property(nonatomic, assign)LCMediaFunctionSupport functionSupport;

/**
 *  获取单例实例
 *
 *  @return 单例实例
 */
+ (instancetype)shareInstance;

#pragma mark - 初始化接口
/**
 * 初始化网络相关模块（curl、ssl、NetFrameWork、NetSDK）
 * @note: 此接口为无阻塞同步接口，需保证在主线程调用，时机需在启动后立即调用
 */
- (void)initNetWorkComponent;

/**
 *将初始化媒体组件
 *
 *@param mediaMode 媒体组件模式(默认为国内模式)
 */
- (void)initMediaService:(LCMediaComponentsMode)mediaMode;

/**
 * 初始化安恒加密服务
 * @param deviceIdentity   终端设备唯一标识
 * @param svrAddr                   安恒密盾服务地址
 * @note: 此接口为同步接口，在用户账号下有设备开通了安恒加密套餐时才需要调用
 */
- (void)initAHService:(NSString*)deviceIdentity SvrAddr:(NSString*)svrAddr;


/// 配置支持的功能
/// @param functionSupport 支持的功能
- (void)configFunctionSupport:(LCMediaFunctionSupport)functionSupport;

/**
* 获取安恒服务初始化状态
*/
- (NSInteger)getAHServiceState;

/**
 *  rest获取登陆组件和统计组件服务器信息并初始化
 *
 *  @param userName p2p服务器登录用户名
 *  @param passWord p2p服务器登录密码
 */
- (NSInteger)initComponentWithP2pUserName:(NSString*)userName passWord:(NSString*)passWord;
- (void)unInit;

/**
 *将初始化接口拆成两步，initSDK(同步)+initP2PServerAfterSDK(异步)
 *
 *@param needNetworkObserver 是否需要监听网络变化重置长链接(若业务层已做了网络变化重置长链接,传NO;否则传YES)
 *@param saasSvrIP 登录域名
 */
- (BOOL)initSDK:(BOOL)needNetworkObserver saasSvrIP:(NSString *)saasSvrIP;

- (NSInteger)initP2PServerAfterSDK:(NSString*)p2pSerIP p2pSerPort:(NSInteger)p2pSerPort userName:(NSString*)userName pwd:(NSString*)pwd isRelay:(BOOL)isRelay;

/**
 *  初始化预打洞, 预登录流程, 支持域名解析缓存
 *
 *  @param p2pSvrAddr    P2P服务域名
 *  @param p2pSvrIpv4    P2P服务IP(v4)
 *  @param p2pSvrIpv6    P2P服务IP(v6)
 *  @param userName      P2P鉴权全局ak, 一机一密鉴权时传空字符串
 *  @param pwd           P2P鉴权全局sk, 一机一密鉴权时传空字符串
 *  @param isRelay       是否开启Relay
 *  @return  成功:0, 失败: 非0
 */
- (NSInteger)initP2PServerAfterSDKEx:(NSString*)p2pSvrAddr p2pSvrIpv4:(NSString*)p2pSvrIpv4 p2pSvrIpv6:(NSString*)p2pSvrIpv6 p2pSerPort:(NSInteger)p2pSerPort userName:(NSString*)userName pwd:(NSString*)pwd isRelay:(BOOL)isRelay;

/**
 *  初始化P2P服务
 *
 *  @param svrHost  p2p服务器地址
 *  @param svrPort  p2p服务器端口
 *  @param username p2p服务器登录用户名
 *  @param password p2p服务器登录密码
 *  @param isRelay  p2p relay开关
 *
 *  @return 0/非0 成功/失败
 */
- (NSInteger)initP2pSvrWithHost:(NSString*)svrHost svrPort:(ushort)svrPort username:(NSString*)username password:(NSString*)password isRelay:(BOOL)isRelay;
/**
 *  初始化统计(pss)服务
 *
 *  @param svrHost      统计服务器地址
 *  @param svrPort      统计服务器端口
 *  @param protocolType 统计服务协议类型
 - 0 HTTP
 - 1 HTTPS
 *  @param timeout      统计服务信令交互超时
 *
 *  @return 0/非0 成功/失败
 */
- (NSInteger)initReporterSvrWithHost:(NSString*)svrHost svrPort:(ushort)svrPort protocolType:(NSUInteger)protocolType timeout:(NSUInteger)timeout;
/**
 *  更新P2P服务器的鉴权用户名和密钥
 *
 *  @param username  登陆P2P服务器的鉴权用户名
 *  @param pwd       登陆P2P服务器的鉴权密钥
 *  @return result
 */
- (BOOL)updateP2PUsernamePwd:(NSString*)username pwd:(NSString*)pwd;

#pragma mark - 预登陆相关接口
/**
 *  设置预打洞设备数量最大值
 *
 *  @param maxDeviceNum 预打洞设备数量最大值
 */
- (void)setMaxDeviceNum:(NSUInteger)maxDeviceNum;

/**
 *  添加设备信息
 *
 *  @param devicesJsonStr 设备信息字符串(Json格式)
 *         eg:[{"Sn":string, "Type":UINT,"Port":UINT,"User":string, "Pwd":string},{},...]
 *         Type:(0:大华P2P设备 1:乐橙设备)
 *
 *  @return YES/NO 成功/失败
 */
- (BOOL)addDevices:(NSString*)devicesJsonStr;
/**
 *  删除设备信息
 *
 *  @param devicesJsonStr 设备信息字符串(Json格式)
 *         eg:[{"Sn":string, "Type":UINT,"Port":UINT,"User":string, "Pwd":string},{},...]
 *         Type:(0:大华P2P设备 1:乐橙设备)
 *
 *  @return YES/NO 成功/失败
 */
- (BOOL)delDevices:(NSString*)devicesJsonStr;
/**
 *  删除所有设备信息
 *
 *  @return YES/NO 成功/失败
 */
- (BOOL)delAllDevices;

/**
 *  重新建立设备的p2p连接
 *
 *  @param devicesJsonStr 设备信息字符串(Json格式)
 *         eg:[{"Sn":string}, {}, ...]
 *
 *  @return YES/NO 成功/失败
 */
- (BOOL)reConnectDevices:(NSString*)devicesJsonStr;

/**
 *  断开所有P2P链接
 *
 *  @return YES/NO 成功/失败
 *
 *  @note   网络断开(或者切换)时需要调用该接口
 */
- (BOOL)disConnectAll;
/**
 *  重连所有P2P链接
 *
 *  @return YES/NO 成功/失败
 *
 *  @note   网络重新连接时需要调用该接口
 */
- (BOOL)reConnectAll;

/**
 *  获取大华P2P设备NetSdk登陆句柄
 *
 *  @param deviceJsonStr 设备信息字符串(Json格式)
 *         eg:[{"Sn":string, "Type":UINT,"Port":UINT,"User":string, "Pwd":string},{},...]
 *         Type:(0:大华P2P设备 1:乐橙设备)
 *  @param timeout  接口超时时间(单位:毫秒)
 *
 *  @return 非nil/nil 成功/失败
 *
 *  @note   该接口为阻塞接口，阻塞时间为timeout
 */
- (void*)getNetSDKHandler:(NSString*)deviceJsonStr timeout:(NSUInteger)timeout isUseCached:(BOOL)isUseCached;

- (void*)tryNetSDKConnect:(NSString*)deviceJsonStr timeout:(NSUInteger)timeout isUseCached:(BOOL)isUseCached ErrorCode:(int*)error;

/**
 *  获取设备P2P映射端口(用于RTSP协议拉流)
 *
 *  @param deviceJsonStr 设备信息字符串(Json格式)
 *         eg:{"Sn":string, "Type":UINT,"Port":UINT,"User":string, "Pwd":string}
 *         Type:(0:大华P2P设备 1:乐橙设备)
 *  @param timeout  接口超时时间(单位:毫秒)
 *
 *  @return 非0/0 成功/失败
 *
 *  @note   该接口为阻塞接口，阻塞时间为timeout
 */
- (NSUInteger)getP2PPort:(NSString*)deviceJsonStr timeout:(NSUInteger)timeout;

/**
 获取某台设备的P2P映射端口(需指定设备监听端口号)

 @param deviceSN 设备序列号
 @param port 设备监听端口号
 @param timeout 超时时间(单位毫秒)
 @return
     - >0 P2P映射端口
     - 0  映射失败
 @note  该接口为阻塞接口，由参数timeout控制超时时间
 */
- (NSUInteger)getP2PPort:(NSString*)deviceSN devicePort:(NSUInteger)port timeout:(NSUInteger)timeout;

/**
 接口调用失败后获取错误码

 @param deviceSN 设备序列号
 @param errDesc 错误码描述
    -对于不同的错误码，代表不同的含义
    -目前仅支持netsdk密码错误，errDesc表示剩余登陆次数（超过此次数会被锁定)
 
 @return 错误码(参考E_LOGIN_ERROR_CODE定义)
 */
- (LCMediaLoginError)getErrNo:(NSString*)deviceSN errDesc:(NSString*_Nullable*_Nullable)errDesc;

/**
 查询设备在线状态

 @param deviceSN 设备序列号
 @return 设备状态(参考E_DEVICE_STATE定义)
 */
- (LCMediaDeviceState)getDevState:(NSString*)deviceSN;

/**
 返回设备状态(对于NetSDK有效)
 
 @param deviceSN 设备序列号
 @return 返回设备状态信息的json字符串
 - 成功:json格式如下
 {
 "InPortNum":,       // DVR报警输入个数
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
 *  设置监听者，用来接收登录状态回调
 *
 *  @param lis 监听者实例(需遵守LCSDK_LoginManagerListener协议)
 */
-(void)setListener:(id<LCMediaLoginManagerListener>) lis;

/**
 通知netsdk登录结果
     json格式如下
     {
         "InPortNum":,     // DVR报警输入个数 [成功]
         "OutPortNum":0,     // DVR报警输出个数 [成功]
         "DiskNum":0,        // DVR硬盘个数 [成功]
         "DVRType":0,        // DVR类型,见枚举NET_DEVICE_TYPE [成功]
         "ChanNum":0,        // DVR通道个数 [成功]
         "LimitLoginTime":0, // 在线超时时间,为0表示不限制登陆,非0表示限制的分钟数 [成功]
         "LeftLogTimes":0,   // 当登陆失败原因为密码错误时,通过此参数通知用户,剩余登陆次数,为0时表示此参数无效 [成功]
         "LockLeftTime":0,   // 当登陆失败,用户解锁剩余时间（秒数）, -1表示设备未设置该参数 [成功]
         "Loginhandle": "" // netsdk 登陆成功时返回的句柄 [成功]
         “error”: int        // netsdk 登录失败时的错误码 成功为 0，失败直接透传netsdk给组件
         "deviceSn": ""      // 设备序列号
     }
 **/
- (void)notifyLoginResult:(NSString*)LoginResult;

/**
 * 获取p2p穿透类型
 * @param deviceSN 设备序列号
 * @param productId 设备产品型号
 * 0:局域网; 1:p2p; 2:Relay
 */
- (NSInteger)getP2PLinkType:(NSString*)deviceSN productId:(NSString *)productId;

- (BOOL)setSessionInfo:(NSInteger)localPort IP:(NSString*)ip Port:(NSInteger)port ReuqestId:(NSString*)requestId DeviceSn:(NSString*)deviceSn;
/**
 * 设置日志上报配置
 * @param type 日志类型：0: p2p   1: p2p ICE
 * @param flag 配置：0: 关闭   1: 开启
 */
- (void)setLogReportConfig:(NSInteger)type Flag:(NSInteger)flag;

/// 设置MTS自动切P2P使能开关
/// @param enable 使能开关
- (void)setMtsToP2pEnable:(BOOL)enable;

/// 配置拉流/对讲是否强制走ipv6
/// @param enable 使能开关
-(void)configForceIpv6:(BOOL)enable;


/// 配置播放SDK灰度pids,格式:"pid1,pid2,pid3"
/// @param pids 产品id
-(void)configCustomPlayPids:(NSString *)pids;

@end

NS_ASSUME_NONNULL_END
