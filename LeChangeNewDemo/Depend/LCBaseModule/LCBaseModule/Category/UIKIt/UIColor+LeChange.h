
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor(LeChange)

#pragma mark 设备融合新增规范色值

//MARK: - SMB

/// c0品牌色/线条文字颜色 #F18D00，用于强调性文字、图标等非大面积色块
+ (UIColor *)lccolor_c0;

/// c1大色块/按钮色 #4570FE，用于按钮,较大面积色块铺色
+ (UIColor *)lccolor_c1;

/// c2标题/主文字色 #13203E
+ (UIColor *)lccolor_c2;

///c3 Toolbar font/普通按钮背景 C8D1E6
+ (UIColor *)lccolor_c3;

///c4 点缀色 F39902
+ (UIColor *)lccolor_c4;

/// c5普通文字/引导/次要字色 #888888
+ (UIColor *)lccolor_c5;

/// c6置灰/输入提示 #CCCCCC
+ (UIColor *)lccolor_c6;

/// c7客户端底色/卡片描边 #F7F7F7
+ (UIColor *)lccolor_c7;

/// c8分割线 #F2F2F2
+ (UIColor *)lccolor_c8;

/// c9全局遮罩 #10000000
+ (UIColor *)lccolor_c9;

/// c10反白 #FFFFFF
+ (UIColor *)lccolor_c10;

/// c11成功 #13C69A
+ (UIColor *)lccolor_c11;

/// c12警示/错误 #EF6545
+ (UIColor *)lccolor_c12;

/// c13其他 #59ABFF
+ (UIColor *)lccolor_c13;

/// c15强调按钮 disable
+ (UIColor *)lccolor_c15;

/// c16输入框背景色 e8eef8
+ (UIColor *)lccolor_c16;

//MARK: - Imou

/**
 * @透明色c00 "00FFFFFF"
 *
 * @实际色值: "00FFFFFF"
 * @场景：移动端透明背景颜色等
 */
+ (UIColor *)lccolor_c00;

/**
 * @辅色调c20 #7FF18D00
 *
 * @实际色值：#7FF18D00
 * @使用场景:按钮触发颜色
 */
+ (UIColor *)lccolor_c20;

/**
 * @辅色调c21 #B2F18D00
 *
 * @实际色值：#B2F18D00
 * @使用场景:登录水波纹
 */
+ (UIColor *)lccolor_c21;

/**
 * @辅色调c22 #33F18D00
 *
 * @实际色值：#33F18D00
 * @使用场景:登录水波纹2
 */
+ (UIColor *)lccolor_c22;

/**
 * @文字颜色c30 FF4F4F
 *
 * @实际色值：#FF4F4F
 * @使用场景:错误 警示色
 */
+ (UIColor *)lccolor_c30;

/**
 * @文字颜色c31 #10AA6E
 *
 * @实际色值：#10AA6E
 * @使用场景:成功、警示色
 */
+ (UIColor *)lccolor_c31;

/**
 * @文字颜色c32 4F78FF
 *
 * @实际色值：#4F78FF
 * @使用场景:暗提示色
 */
+ (UIColor *)lccolor_c32;

/**
 * @文字颜色c33 FFA904
 *
 * @实际色值：#FFA904
 * @使用场景:分贝档位色值（70db）
 */
+ (UIColor *)lccolor_c33;

/**
 * @文字颜色c34 #FFCC00
 *
 * @实际色值：#FFCC00
 * @使用场景:分贝档位色值（60db）
 */
+ (UIColor *)lccolor_c34;

/**
 * @文字颜色c35 #D40041
 *
 * @实际色值：#D40041
 * @使用场景:分贝档位色值（90db）
 */
+ (UIColor *)lccolor_c35;

/**
 * @控件颜色c40 #2C2C2C
 *
 * @实际色值：#2C2C2C
 * @使用场景:主标题字色
 */
+ (UIColor *)lccolor_c40;

/**
 * @控件颜色c41 #8F8F8F
 *
 * @实际色值：#8F8F8F
 * @使用场景:次要信息字色
 */
+ (UIColor *)lccolor_c41;

/**
 * @控件颜色c42 #C2C2C2
 *
 * @实际色值：#C2C2C2
 * @使用场景:暗提示色
 */
+ (UIColor *)lccolor_c42;

/**
 * @控件颜色c43 #FFFFFF
 *
 * @实际色值：#FFFFFF
 * @使用场景:深色背景下字色
 */
+ (UIColor *)lccolor_c43;

/**
 * @控件颜色c44 #80FFFFFF
 *
 * @实际色值：#80FFFFFF
 * @使用场景:首页设备离线色值
 */
+ (UIColor *)lccolor_c44;

/**
 * @控件颜色c50 #3E3E3E
 *
 * @实际色值：#3E3E3E
 * @使用场景:实时预览操作条背景色
 */
+ (UIColor *)lccolor_c50;

/**
 * @控件颜色c51 #7F000000
 *
 * @实际色值：#7F000000
 * @使用场景:弹出层、弹窗、遮盖蒙版
 */
+ (UIColor *)lccolor_c51;

/**
 * @控件颜色c52 #D9D9D9
 *
 * @实际色值：#D9D9D9
 * @使用场景:按钮置灰颜色
 */
+ (UIColor *)lccolor_c52;

/**
 * @控件颜色c53 #E0E0E0
 *
 * @实际色值：#E0E0E0
 * @使用场景:分割线底色
 */
+ (UIColor *)lccolor_c53;

/**
 * @控件颜色c54 #FAFAFA
 *
 * @实际色值：#FAFAFA
 * @使用场景:客户端底色
 */
+ (UIColor *)lccolor_c54;

/**
 * @控件颜色c54 #4CFFFFFF
 *
 * @实际色值：#4CFFFFFF
 * @使用场景:录像进度条背景色
 */
+ (UIColor *)lccolor_c55;

/**
 * @控件颜色c55 #66FFFFFF

 * @实际色值：#66FFFFFF
 * @使用场景:按钮边框颜色
 */
+ (UIColor *)lccolor_c56;

/**
 * @控件颜色c57 #BDD6F8
 
 * @实际色值：#BDD6F8
 * @使用场景:时间轴普通录像色值
 */
+ ( UIColor *)lccolor_c57;

/**
 * @控件颜色c58 #FFBB99
 
 * @实际色值：#FFBB99
 * @使用场景:时间轴非普通录像色值
 */
+ (UIColor *)lccolor_c58;

/**
 * @控件颜色c59 #F0F0F0
 
 * @实际色值：#F0F0F0
 * @使用场景:NVR通道头背景色
 */
+ (UIColor *)lccolor_c59;


+ (UIColor *)lccolor_c60;

+ (UIColor *)lccolor_c61;

+ (UIColor *)lccolor_c62;

+ (UIColor *)lccolor_c63;

/**
 * @控件颜色c62 #12d574
 
 * @实际色值：#12d574
 * @使用场景:超时页面绿灯文字
 */
+ (UIColor *)lccolor_c64;

/**
 * @控件颜色c62 #ffbc17
 
 * @实际色值：#ffbc17
 * @使用场景:超时页面黄灯
 */
+ (UIColor *)lccolor_c65;


#pragma mark Special Color
/**
 * @确认按钮颜色
 *
 * @实际色值：国内蓝色：c32($4f78ff)、海外橙色：c10(F18D00)
 * @使用场景: 弹框中通用确定按钮的颜色，需要在LCModuleConfig.plist中配置ConfirmButtonColor
 */
+ (UIColor *)lccolor_confirm;

/**
 进度条背景普通颜色 9ECAEF
 
 @return 9ECAEF
 */
+ (UIColor *)lccolor_progressBackgroundNormal;


/**
 进度条背景高亮颜色 5AAFF6
 
 @return 5AAFF6
 */
+ (UIColor *)lccolor_progressBackgroundHilighted;

@end


NS_ASSUME_NONNULL_END
