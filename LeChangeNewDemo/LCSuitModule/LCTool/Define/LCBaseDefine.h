//
//  Copyright © 2019 dahua. All rights reserved.
//

#ifndef LCBaseDefine_h
#define LCBaseDefine_h

//设备相关参数
#define SCREEN_BOUNDS       [UIScreen mainScreen].bounds
#define SCREEN_WIDTH        [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT       [[UIScreen mainScreen] bounds].size.height
#define MAINSCREEN_WIDTH    MIN(SCREEN_WIDTH,SCREEN_HEIGHT)
#define MAINSCREEN_HEIGHT   MAX(SCREEN_WIDTH,SCREEN_HEIGHT)
#define IOSVERSION7         ([[UIDevice currentDevice].systemVersion floatValue] > 6.9)
#define IOSVERSION8         ([[UIDevice currentDevice].systemVersion floatValue] > 7.9)
#define IOSVERSION9         ([[UIDevice currentDevice].systemVersion floatValue] > 8.9)
#define IOSVERSION10         ([[UIDevice currentDevice].systemVersion floatValue] > 9.9)
#define IOSVERSION11         ([[UIDevice currentDevice].systemVersion floatValue] > 10.9)
#define IPHONE5             (MAINSCREEN_HEIGHT > 480)
#define IPHONE6             (MAINSCREEN_HEIGHT > 570)

//add by yuqian
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define weakSelf(type)  __weak typeof(type) weak##type = type;
#define strongSelf(type)  __strong typeof(type) type = weak##type;

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && MAINSCREEN_HEIGHT < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && MAINSCREEN_HEIGHT == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && MAINSCREEN_HEIGHT == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && MAINSCREEN_HEIGHT == 736.0)

#define PAGE_CONTENT_HEIGHT (MAINSCREEN_HEIGHT - 64)

#define IMAGE_CROP_SIZE CGSizeMake(125.0, 125.0)

#define kIs_iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kIs_iPhoneX SCREEN_HEIGHT >=375.0f && SCREEN_HEIGHT >=812.0f&& kIs_iphone

#define kWidthRatio      (SCREEN_WIDTH / 375.0)
#define kHeightRatio     (SCREEN_HEIGHT / 667.0)

// 主窗口
#define LC_KEY_WINDOW ([UIApplication sharedApplication].delegate).window
// 图片快捷方式
#define LC_IMAGENAMED(imageName)  [UIImage imageNamed:imageName]
// 图片长宽比(长/宽)
#define LC_IMAGERATIO(image)  (image.size.height/image.size.width)

/*状态栏高度*/
#define kStatusBarHeight (CGFloat)(kIs_iPhoneX?(44.0):(20.0))
/*导航栏高度*/
#define kNavBarHeight (44)
/*状态栏和导航栏总高度*/
#define kNavBarAndStatusBarHeight (CGFloat)(kIs_iPhoneX?(88.0):(64.0))
/*TabBar高度*/
#define kTabBarHeight (CGFloat)(kIs_iPhoneX?(49.0 + 34.0):(49.0))
/*顶部安全区域远离高度*/
#define kTopBarSafeHeight (CGFloat)(kIs_iPhoneX?(44.0):(0))
/*底部安全区域远离高度*/
#define kBottomSafeHeight (CGFloat)(kIs_iPhoneX?(34.0):(0))
/*iPhoneX的状态栏高度差值*/
#define kTopBarDifHeight (CGFloat)(kIs_iPhoneX?(24.0):(0))
/*导航条和Tabbar总高度*/
#define kNavAndTabHeight (kNavBarAndStatusBarHeight + kTabBarHeight)

//字符串
#define LC_LEGAL_DEVICENAME       @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!#$%()*+,-./<=>?@[\\]^_`{|}~"

#ifdef DEBUG
# define DLog(tag,fmt, ...) NSLog((@"【DEBUG LOG】%@,[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt),tag, __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define DLog(...);
#endif

#ifdef DEBUG
# define ILog(tag,fmt, ...) NSLog((@"【INFO LOG】%@,[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt),tag, __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define ILog(...);
#endif

#ifdef DEBUG
# define ELog(tag,fmt, ...) NSLog((@"【ERROR LOG】%@,[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt),tag, __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define ELog(...);
#endif

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)



#endif /* LCBaseDefine_h */
