//
//  Copyright © 2019 Imou. All rights reserved.
//

#ifndef LCBaseDefine_h
#define LCBaseDefine_h

//设备相关参数
#define SCREEN_BOUNDS       [UIScreen mainScreen].bounds
#define SCREEN_WIDTH        [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT       [[UIScreen mainScreen] bounds].size.height
#define MAINSCREEN_HEIGHT   MAX(SCREEN_WIDTH,SCREEN_HEIGHT)

//add by yuqian
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define weakSelf(type)  __weak typeof(type) weak##type = type;
#define strongSelf(type)  __strong typeof(type) type = weak##type;

#define kIs_iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kIs_iPhoneX SCREEN_HEIGHT >=375.0f && SCREEN_HEIGHT >=812.0f&& kIs_iphone

// 图片快捷方式
#define LC_IMAGENAMED(imageName)  [UIImage imageNamed:imageName]

/*状态栏高度*/
#define kStatusBarHeight (CGFloat)(kIs_iPhoneX?(44.0):(20.0))

/*状态栏和导航栏总高度*/
#define kNavBarAndStatusBarHeight (CGFloat)(kIs_iPhoneX?(88.0):(64.0))
/*顶部安全区域远离高度*/
#define kTopBarSafeHeight (CGFloat)(kIs_iPhoneX?(44.0):(0))
/*底部安全区域远离高度*/
#define kBottomSafeHeight (CGFloat)(kIs_iPhoneX?(34.0):(0))

#endif /* LCBaseDefine_h */
