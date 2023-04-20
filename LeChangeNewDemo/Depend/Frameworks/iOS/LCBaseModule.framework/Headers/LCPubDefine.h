//
//  Copyright © 2017 Imou. All rights reserved.
//

#ifndef LCPubDefine_h
#define LCPubDefine_h

// 整型索引
typedef NSInteger Index;

// 长整型索引
typedef int64_t LongIndex;

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

typedef NS_ENUM(NSInteger, SDCardStatus)
{
    SDCardStatusException  = 0,//  sd卡异常
    SDCardStatusNormal     = 1,//  sd卡正常
    SDCardStatusNoCard     = 2,//  没有sd卡
    SDCardStatusFormatting = 3,//  正在初始化
    SDCardStatusError      = 4 //  不存在
};

#pragma mark- 公用宏

#define SCREEN_WIDTH        [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT       [[UIScreen mainScreen] bounds].size.height

// 屏幕宽度
#define LC_SCREEN_SIZE_WIDTH     MIN([[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)
// 屏幕高度
#define LC_SCREEN_SIZE_HEIGHT    MAX([[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)

// 状态栏高度
#define LC_statusBarHeight  ([UIApplication  sharedApplication].statusBarFrame.size.height)

// 底部安全距离
#define LC_bottomSafeMargin (LC_IS_IPHONEX ? 34.f : 0.f)

// 导航栏加状态栏高度
#define LC_navViewHeight (LC_IS_IPHONEX ? 84.f : 64.f)

// 图片快捷方式
#define LC_IMAGENAMED(imageName)  [UIImage imageNamed:imageName]

// 主窗口
#define LC_KEY_WINDOW ([UIApplication sharedApplication].delegate).window

// 判断是否为iPhone X
#define LC_IS_IPHONEX ((LC_SCREEN_SIZE_WIDTH == 375.0f && LC_SCREEN_SIZE_HEIGHT == 812.0f) || ((LC_SCREEN_SIZE_WIDTH == 414 && LC_SCREEN_SIZE_HEIGHT == 896)))

#pragma mark - Convinience RETURN Macro
#define kAutoHideBarTime    (4.0f)  //悬浮条自动隐藏时间

#define kPictureHideBarTime    (5.0f)  //抓图录制图片自动隐藏时间

#define LC_PASSWORD_MIN_LENGTH      8   //密码最小长度
#define LC_PASSWORD_MAX_LENGTH      32  //密码最大长度
#define LC_USERNAME_MAX_LENGTH      11  //登录名最大长度

//日期格式
#define kFormatTimeLocal        (@"yyyyMMdd'T'HHmmss")

#define DEVICE_NAME_MAX_LIMIT     32
#define CHANNEL_NAME_MAX_LIMIT    32

#pragma mark - Text

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

#endif /* LCPubDefine_h */
