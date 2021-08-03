//
//  Copyright (c) 2015年 浙江大华. All rights reserved.
// 乐橙项目颜色定义

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor(LeChange)

#pragma mark 设备融合新增规范色值

//MARK: - SMB

/// c0品牌色/线条文字颜色 #F18D00，用于强调性文字、图标等非大面积色块
+ (UIColor *)dhcolor_c0;

/// c1大色块/按钮色 #4570FE，用于按钮,较大面积色块铺色
+ (UIColor *)dhcolor_c1;

/// c2标题/主文字色 #13203E
+ (UIColor *)dhcolor_c2;

///c3 Toolbar font/普通按钮背景 C8D1E6
+ (UIColor *)dhcolor_c3;

///c4 点缀色 F39902
+ (UIColor *)dhcolor_c4;

/// c5普通文字/引导/次要字色 #888888
+ (UIColor *)dhcolor_c5;

/// c6置灰/输入提示 #CCCCCC
+ (UIColor *)dhcolor_c6;

/// c7客户端底色/卡片描边 #F7F7F7
+ (UIColor *)dhcolor_c7;

/// c8分割线 #F2F2F2
+ (UIColor *)dhcolor_c8;

/// c9全局遮罩 #10000000
+ (UIColor *)dhcolor_c9;

/// c10反白 #FFFFFF
+ (UIColor *)dhcolor_c10;

/// c11成功 #13C69A
+ (UIColor *)dhcolor_c11;

/// c12警示/错误 #EF6545
+ (UIColor *)dhcolor_c12;

/// c13其他 #59ABFF
+ (UIColor *)dhcolor_c13;

/// c15强调按钮 disable
+ (UIColor *)dhcolor_c15;

/// c16输入框背景色 e8eef8
+ (UIColor *)dhcolor_c16;

//MARK: - Imou

/**
 * @透明色c00 "00FFFFFF"
 *
 * @实际色值: "00FFFFFF"
 * @场景：移动端透明背景颜色等
 */
+ (UIColor *)dhcolor_c00;

/**
 * @辅色调c20 #7FF18D00
 *
 * @实际色值：#7FF18D00
 * @使用场景:按钮触发颜色
 */
+ (UIColor *)dhcolor_c20;

/**
 * @辅色调c21 #B2F18D00
 *
 * @实际色值：#B2F18D00
 * @使用场景:登录水波纹
 */
+ (UIColor *)dhcolor_c21;

/**
 * @辅色调c22 #33F18D00
 *
 * @实际色值：#33F18D00
 * @使用场景:登录水波纹2
 */
+ (UIColor *)dhcolor_c22;

/**
 * @文字颜色c30 FF4F4F
 *
 * @实际色值：#FF4F4F
 * @使用场景:错误 警示色
 */
+ (UIColor *)dhcolor_c30;

/**
 * @文字颜色c31 #10AA6E
 *
 * @实际色值：#10AA6E
 * @使用场景:成功、警示色
 */
+ (UIColor *)dhcolor_c31;

/**
 * @文字颜色c32 4F78FF
 *
 * @实际色值：#4F78FF
 * @使用场景:暗提示色
 */
+ (UIColor *)dhcolor_c32;

/**
 * @文字颜色c33 FFA904
 *
 * @实际色值：#FFA904
 * @使用场景:分贝档位色值（70db）
 */
+ (UIColor *)dhcolor_c33;

/**
 * @文字颜色c34 #FFCC00
 *
 * @实际色值：#FFCC00
 * @使用场景:分贝档位色值（60db）
 */
+ (UIColor *)dhcolor_c34;

/**
 * @文字颜色c35 #D40041
 *
 * @实际色值：#D40041
 * @使用场景:分贝档位色值（90db）
 */
+ (UIColor *)dhcolor_c35;

/**
 * @控件颜色c40 #2C2C2C
 *
 * @实际色值：#2C2C2C
 * @使用场景:主标题字色
 */
+ (UIColor *)dhcolor_c40;

/**
 * @控件颜色c41 #8F8F8F
 *
 * @实际色值：#8F8F8F
 * @使用场景:次要信息字色
 */
+ (UIColor *)dhcolor_c41;

/**
 * @控件颜色c42 #C2C2C2
 *
 * @实际色值：#C2C2C2
 * @使用场景:暗提示色
 */
+ (UIColor *)dhcolor_c42;

/**
 * @控件颜色c43 #FFFFFF
 *
 * @实际色值：#FFFFFF
 * @使用场景:深色背景下字色
 */
+ (UIColor *)dhcolor_c43;

/**
 * @控件颜色c44 #80FFFFFF
 *
 * @实际色值：#80FFFFFF
 * @使用场景:首页设备离线色值
 */
+ (UIColor *)dhcolor_c44;

/**
 * @控件颜色c50 #3E3E3E
 *
 * @实际色值：#3E3E3E
 * @使用场景:实时预览操作条背景色
 */
+ (UIColor *)dhcolor_c50;

/**
 * @控件颜色c51 #7F000000
 *
 * @实际色值：#7F000000
 * @使用场景:弹出层、弹窗、遮盖蒙版
 */
+ (UIColor *)dhcolor_c51;

/**
 * @控件颜色c52 #D9D9D9
 *
 * @实际色值：#D9D9D9
 * @使用场景:按钮置灰颜色
 */
+ (UIColor *)dhcolor_c52;

/**
 * @控件颜色c53 #E0E0E0
 *
 * @实际色值：#E0E0E0
 * @使用场景:分割线底色
 */
+ (UIColor *)dhcolor_c53;

/**
 * @控件颜色c54 #FAFAFA
 *
 * @实际色值：#FAFAFA
 * @使用场景:客户端底色
 */
+ (UIColor *)dhcolor_c54;

/**
 * @控件颜色c54 #4CFFFFFF
 *
 * @实际色值：#4CFFFFFF
 * @使用场景:录像进度条背景色
 */
+ (UIColor *)dhcolor_c55;

/**
 * @控件颜色c55 #66FFFFFF

 * @实际色值：#66FFFFFF
 * @使用场景:按钮边框颜色
 */
+ (UIColor *)dhcolor_c56;

/**
 * @控件颜色c57 #BDD6F8
 
 * @实际色值：#BDD6F8
 * @使用场景:时间轴普通录像色值
 */
+ ( UIColor *)dhcolor_c57;

/**
 * @控件颜色c58 #FFBB99
 
 * @实际色值：#FFBB99
 * @使用场景:时间轴非普通录像色值
 */
+ (UIColor *)dhcolor_c58;

/**
 * @控件颜色c59 #F0F0F0
 
 * @实际色值：#F0F0F0
 * @使用场景:NVR通道头背景色
 */
+ (UIColor *)dhcolor_c59;


+ (UIColor *)dhcolor_c60;

+ (UIColor *)dhcolor_c61;

+ (UIColor *)dhcolor_c62;

+ (UIColor *)dhcolor_c63;

/**
 * @控件颜色c62 #12d574
 
 * @实际色值：#12d574
 * @使用场景:超时页面绿灯文字
 */
+ (UIColor *)dhcolor_c64;

/**
 * @控件颜色c62 #ffbc17
 
 * @实际色值：#ffbc17
 * @使用场景:超时页面黄灯
 */
+ (UIColor *)dhcolor_c65;


#pragma mark Special Color
/**
 * @确认按钮颜色
 *
 * @实际色值：国内蓝色：c32($4f78ff)、海外橙色：c10(F18D00)
 * @使用场景: 弹框中通用确定按钮的颜色，需要在DHModuleConfig.plist中配置ConfirmButtonColor
 */
+ (UIColor *)dhcolor_confirm;

/**
 进度条背景普通颜色 9ECAEF
 
 @return 9ECAEF
 */
+ (UIColor *)dhcolor_progressBackgroundNormal;


/**
 进度条背景高亮颜色 5AAFF6
 
 @return 5AAFF6
 */
+ (UIColor *)dhcolor_progressBackgroundHilighted;

@end


NS_ASSUME_NONNULL_END
