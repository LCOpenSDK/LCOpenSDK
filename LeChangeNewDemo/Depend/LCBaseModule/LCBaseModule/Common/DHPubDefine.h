//
//  Copyright © 2017 dahua. All rights reserved.
//

#ifndef DHPubDefine_h
#define DHPubDefine_h

// 整型索引
typedef NSInteger Index;

// 长整型索引
typedef int64_t LongIndex;

/// Http类型
typedef NS_ENUM(NSInteger,DHServerPortType)
{
    DHServerPortTypeHttp = 80,       //http 交互方式
    DHServerPortTypeHttps = 443      //https 交互方式
};

//Mark::NVR,增加通道
typedef NS_ENUM(NSInteger, DeviceCatalog)
{
    DeviceCatalogCamera,     //摄像头
    DeviceCatalogBox,        //盒子
    DeviceCatalogBoxPart,    //盒子配件
    DeviceCatalogNVR,        //NVR设备
    DeviceCatalogNVRChannel, //NVR设备通道
    DeviceCatalogG1,         //报警网关
    DeviceCatalogG1Part      //报警网关配件
};

typedef NS_ENUM(NSInteger, DHChannelListType)
{
    DHChannelListTypeCoverFlow,
    DHChannelListTypeList,
    DHChannelListTypeRecord
} ;

typedef NS_ENUM(NSInteger, SDCardStatus)
{
    SDCardStatusException  = 0,//  sd卡异常
    SDCardStatusNormal     = 1,//  sd卡正常
    SDCardStatusNoCard     = 2,//  没有sd卡
    SDCardStatusFormatting = 3,//  正在初始化
    SDCardStatusError      = 4 //  不存在
};

//针对公有云消息
typedef NS_ENUM(NSInteger, HlsStatus)
{
    HlsStatusDownloadFail,	 //下载失败
    HlsStatusDownloadBegin,  //开始下载
    HlsStatusDownloadEnd,    //下载结束
    HlsStatusSeekSuccess,    //定位成功
    HlsStatusSeekFail,       //定位失败
    HlsStatusAbortDone,      //
    HlsStatusResumeDone,     //
    HlsStatusKeyError = 11,  //密码不匹配
};

// 加载状态
typedef NS_ENUM(NSInteger, DHLoadingStatus)
{
	DHLoadingStatusUnknown,	 // 未知
	DHLoadingStatusLoading,	 // 加载中
	DHLoadingStatusSuccess,	 // 加载成功
	DHLoadingStatusFail,	 // 加载失败
};

#pragma mark- 公用宏

#define SCREEN_WIDTH        [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT       [[UIScreen mainScreen] bounds].size.height

// 屏幕宽度
#define DH_SCREEN_SIZE_WIDTH     MIN([[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)
// 屏幕高度
#define DH_SCREEN_SIZE_HEIGHT    MAX([[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)

// 状态栏高度
#define DH_StatusBarHeight  ([UIApplication  sharedApplication].statusBarFrame.size.height)

// 导航栏高度
#define DHL_NavigationBarHeight  44.f

// Tabbar高度
#define DH_TabbarHeight    (DH_IS_IPHONEX ? (49.f+34.f) : 49.f)

// 导航栏加状态栏高度
#define DH_StatusBarAndNavigationBarHeight  (44.f + [UIApplication  sharedApplication].statusBarFrame.size.height)

// 安全区域间隔
#define DH_ViewSafeAreInsets(view) ({UIEdgeInsets insets; if(@available(iOS 11.f, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})

// 底部安全距离
#define DH_BottomSafeMargin (DH_IS_IPHONEX ? 34.f : 0.f)
// 顶部安全距离
#define DH_TopSafeMargin (DH_IS_IPHONEX ? 24.f : 0.f)
// 横屏左右的安全距离
#define DH_LandscapeSafeMargin (DH_IS_IPHONEX ? 44.f : 0.f)
// 横屏左右的视频安全距离
#define DH_LandscapeVideoSafeMargin (DH_IS_IPHONEX ? 64.f : 0.f)
// 导航栏加状态栏高度
#define DH_NavViewHeight (DH_IS_IPHONEX ? 84.f : 64.f)
// 屏幕安全高度
#define DH_ScreenSafeHeight (DH_IS_IPHONEX ? (DH_SCREEN_SIZE_HEIGHT - 58.f) : DH_SCREEN_SIZE_HEIGHT)

#define DH_SIZE_SCALE            (1.f / [UIScreen mainScreen].scale)
// 默认动画时间
#define DH_AnimationDuration 0.4f

#define DH_LEGAL_PASSWORD_REGEX @"^[A-Za-z0-9!#%,<=>@_~`\\-\\.\\/\\(\\)\\*\\+\\?\\$\\[\\]\\\\\\^\\{\\}\\|]$"
// 对象释放打印
#define DH_LOG_DEALLOCED   {NSLog(@" 💔💔💔 %@ dealloced 💔💔💔", NSStringFromClass(self.class));}
// 图片快捷方式
#define DH_IMAGENAMED(imageName)  [UIImage imageNamed:imageName]

// 主窗口
#define DH_KEY_WINDOW ([UIApplication sharedApplication].delegate).window

#define DH_IOS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue]) //iOS版本号

#define DH_CLIENT_OS_VERSION ([NSString stringWithFormat:@"iOS%@", [[UIDevice currentDevice] systemVersion]]) //iOS系统版本号

#define DH_iOS11_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)
#define DH_iOS10_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)


// 判断是否为iPhone 5/5s
#define DH_IS_IPHONE5 (DH_SCREEN_SIZE_WIDTH == 320.0f && DH_SCREEN_SIZE_HEIGHT == 568.0f)

// 判断是否为iPhone 6/6s/7/8
#define DH_IS_IPHONE6_6s (DH_SCREEN_SIZE_WIDTH == 375.0f && DH_SCREEN_SIZE_HEIGHT == 667.0f)

// 判断是否为iPhone X
#define DH_IS_IPHONEX ((DH_SCREEN_SIZE_WIDTH == 375.0f && DH_SCREEN_SIZE_HEIGHT == 812.0f) || ((DH_SCREEN_SIZE_WIDTH == 414 && DH_SCREEN_SIZE_HEIGHT == 896)))

// 判断是否为iPhone 6Plus/6sPlus/7Plus/8Plus
#define DH_IS_IPHONE6Plus_6sPlus (DH_SCREEN_SIZE_WIDTH == 414.0f && DH_SCREEN_SIZE_HEIGHT == 736.0f)

#pragma mark - Convinience RETURN Macro
#define DH_RETURN_IF_TRUE(checkVal) {if(checkVal) \
{NSLog(@"🍎🍎🍎####:%s,Check value true,return...", __FUNCTION__);return;}}   //判断为真返回

#define DH_RETURN_IF_FALSE(checkVal) {if(!(checkVal)) \
{ NSLog(@"🍎🍎🍎####:%s,Check value false,return...", __FUNCTION__); return;}} //判断为假返回

#define DH_RETURN_NIL_IF_TRUE(checkVal) {if(checkVal) \
{NSLog(@" 🍎🍎🍎####:%s,Check value true,return...", __FUNCTION__);return nil;}}   //判断为真返回空值

#define DH_RETURN_NIL_IF_FALSE(checkVal) {if(!(checkVal)) \
{ NSLog(@" 🍎🍎🍎####:%s,Check value false,return...", __FUNCTION__); return nil;}} //判断为假返回空值

#define kAutoHideBarTime    (4.0f)  //悬浮条自动隐藏时间

#define kPictureHideBarTime    (5.0f)  //抓图录制图片自动隐藏时间

#pragma mark - 日期格式
//日期格式
#define kFormatTimeLocal        (@"yyyyMMdd'T'HHmmss")

#define DEVICE_NAME_MAX_LIMIT     32
#define CHANNEL_NAME_MAX_LIMIT    32

#pragma mark - Text

//密码允许的字符(由于3.0.5版本引入安全基线需求，需要兼容旧的密码规则）
#define DH_LEGAL_PASSWORD_OLD   @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890~`!@#$%^&*()-_+={[]}|\\:;'\"<,>.?/ "
#define DH_LEGAL_PASSWORD       @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!#$%()*+,-./<=>?@[\\]^_`{|}~"
#define DH_LEGAL_ACCOUNT        @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890@_-."
#define DH_LEGAL_ACCOUNT_WITHOUT_LIMIT       @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!#$%()*+,-./<=>?@[\\]^_`{|}~&'"
#define DH_LEGAL_NUMBER         @"1234567890"
#define DH_LEGAL_NUMBERnABC     @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"

#define DH_PASSWORD_MIN_LENGTH      8   //密码最小长度
#define DH_PASSWORD_MAX_LENGTH      32  //密码最大长度
#define DH_USERNAME_MAX_LENGTH      11  //登录名最大长度

#define DH_LOG_FUN    NSLog(@"FUNCTION____%s____line%d____",__FUNCTION__,__LINE__);

// 定义单例
#pragma mark Singleton

#define SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(__CLASSNAME__)    \
\
+ (__CLASSNAME__*) sharedInstance;    \

#define SYNTHESIZE_SINGLETON_FOR_CLASS(__CLASSNAME__) \
\
+ (__CLASSNAME__ *)sharedInstance { \
static __CLASSNAME__ *shared##__CLASSNAME__ = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##__CLASSNAME__ = [[self alloc] init]; \
}); \
return shared##__CLASSNAME__; \
}

///MARK: Fix Category Bug
#define TT_FIX_CATEGORY_BUG(name) @interface TT_FIX_CATEGORY_BUG_##name:NSObject @end \
@implementation TT_FIX_CATEGORY_BUG_##name @end

#endif /* DHPubDefine_h */
