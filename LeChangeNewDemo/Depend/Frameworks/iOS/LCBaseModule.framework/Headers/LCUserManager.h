//
//  与用户相关的类，如用户信息、配置管理，文件加密保存

#import <Foundation/Foundation.h>

@interface LCUserManager : NSObject

/// 国家信息 （使用iso-3166-1二字母，且 ‘CN’）
@property(nonatomic, copy) NSString *countryCode;

/// 昵称
@property(nonatomic, copy) NSString *nickname;

/// 头像url
@property(nonatomic, copy) NSString *avatarUrl;

/// 头像md5，根据此值更新缓存
@property(nonatomic, copy) NSString *avatarMd5;

/// 微信昵称
@property(nonatomic, copy) NSString *wxNickname;

/// facebook昵称
@property(nonatomic, copy) NSString *fbNickname;

/// 苹果登录
@property(nonatomic, copy) NSString *appleNickname;

/// 手机号
@property(nonatomic, copy) NSString *phone;

/// 最新的系统消息Id
@property(nonatomic, assign) int64_t msgId;

/// 是否支持启动页h广告
@property (nonatomic, assign) BOOL isSupportAd;

/// 邮箱账号
@property(nonatomic, copy) NSString *email;
/// 是否需要弹出邮箱账号绑定
@property(nonatomic, assign) BOOL bAlertBindEmail;

//是否展示引导
@property(nonatomic, assign) BOOL showExperiencePlanGuide;
//该账号是否允许使用蜂窝网络播放
@property(nonatomic, assign) BOOL isAllowCellularPlay;
//是否展示探照灯设置引导
@property(nonatomic, assign) BOOL showSearchLightGuide;

/// 是否打开用户体验计划，国内3.12.01版本添加
@property (nonatomic, assign) BOOL openUserExperience;

/// 是否展示用户体验计划弹框
@property (nonatomic, assign) BOOL isShowUserExperiencePlan;


/// 开启调试模式开关的时间,保存到1970年的时间戳，default = 0 表示未开启
@property (nonatomic, assign) NSTimeInterval openDebugModeTime;
/// 是否开启调试模式
@property (nonatomic, assign, readonly) BOOL openDebugMode;

//消息总开关
@property(nonatomic, assign) BOOL messageState;
@property(nonatomic, copy) NSString * messageTime;

@property(nonatomic, copy) NSString * language;/*语言类型：'zh_CN'；'en_US' etc */
@property(nonatomic, copy) NSString * timeFormat;/*日期格式，如“yyyy-MM-dd HH:mm:SS” */
@property(nonatomic, copy) NSString * sound;/*IOS提示音，填文件名或id */
@property(nonatomic, assign) int timezoneOffset;/*手机所在时区的时间与零时区时间差值，单位为秒，可正负 */

@property(nonatomic, strong) NSMutableArray<NSDictionary *> *mSSIDMutableArray;/**< 保存SSID, SSIDPWD，Dictionary中的键值对为mSSID:@"",mSSIDPWD:@""*/

@property(nonatomic, strong) NSMutableDictionary *deviceVersionDictionary; /** 保存用户账号下设备的版本信息。 键值对为：deviceId: version*/

//时区数据保存
@property(nonatomic, copy) NSString                   * beginSummer;
@property(nonatomic, copy) NSString                   * endSummer;
@property(nonatomic, assign) int                        areaIndex;//时区地名Id
@property(nonatomic, assign) int                        timeZoneIndex;//乐橙时区对应Id
@property(nonatomic, assign) BOOL                       setDefault;//默认时区设置

+ (LCUserManager *)shareInstance;


- (void)getUserConfigFile;

- (void)saveUserConfigFile;

/**
 获取设备是否可以升级

 @param deviceId 设备id
 @param version 设备服务器版本
 @return (YES/NO)
 */
- (BOOL)deviceCanUpdateWithDeviceId:(NSString *)deviceId currentVersion:(NSString *)currentVersion newVersion:(NSString *)newVersion;

/**
 保存设备忽略升级的版本

 @param deviceId 设备id
 @param version 设备版本
 */
- (void)deviceAddIgnoreVersionWithDeviceId:(NSString *)deviceId version:(NSString *)version;

/**
 同步国家信息：用户已经登录情况下，重启程序，若国家信息为空，则需要弹出提示框
 */
- (void)syncUserCountryInfo;

/**
 清除旧的用户头像缓存地址，并传出新头像的CacheKey
 
 @param avatarUrl 新的头像地址
 @param completion 返回新的头像缓存地址
 */
- (void)clearCacheAvatar:(NSString *)avatarUrl completion:(void(^)(NSString *acheKey))completion;

/**
清除旧的用户头像缓存和磁盘缓存，并传出新头像的CacheKey

@param avatarUrl 新的头像地址
@param completion 返回新的头像缓存地址
*/
- (void)clearDiskAndCacheAvatar:(NSString *)avatarUrl completion:(void(^)(NSString *acheKey))completion;

/// 下载头像
- (void)downloadAvatar:(NSString *)avatarUrl;

/// 判断ssid是否已经保存
- (BOOL)ssidIsSaved:(NSString *)ssid;

/// 根据ssid读取保存的密码
- (NSString *)ssidPwdBy:(NSString *)ssid;

- (void)addSSID:(NSString *)ssid ssidPwd:(NSString *)ssidPwd;

- (void)removeSSID:(NSString *)ssid;

- (void)clearCachedSSID;

//清除当前账户数据
-(void)clearData;

/// 清除当前用户缓存的数据，账号注销时，需要调用
- (void)resetMemoryCache;

@end

