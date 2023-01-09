//
//  Copyright © 2017年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//  模块配置管理类，读取LCModuleConfig.plist的配置
//  【约定】
//  1、颜色key值xxxxxColor，键值@"RRGGBB"

#import <UIKit/UIKit.h>

@interface LCModuleConfig : NSObject

///LCModuleConfig.plist对应的键值对
@property (nonatomic, strong, readonly) NSMutableDictionary *dicConfigs;

+ (instancetype)shareInstance;
/// 标记是否国内乐橙
@property (nonatomic, assign, readonly) BOOL isChinaMainland;
/// 是否显示全部录像
@property (nonatomic, assign, readonly) BOOL isShowAllRecord;
/// 是否显示收藏点遮罩
@property (nonatomic, assign, readonly) BOOL isShowCollectionMaskView;
/// 是否显示全部录像遮罩
@property (nonatomic, assign, readonly) BOOL isShowAllRecordMaskView;
/// 是否显示全部录像遮罩
@property (nonatomic, assign, readonly) BOOL isShowMoveAreaMaskView;
/// 是否显示全部录像遮罩
@property (nonatomic, assign, readonly) BOOL isShowLinkAgeMaskView;
/// 是否显示全部录像遮罩
@property (nonatomic, assign, readonly) BOOL isShowWeatherMaskView;
/// 是否显示全部录像遮罩
@property (nonatomic, assign, readonly) BOOL isShowDialogMaskView;
/// 是否中性版本
@property (nonatomic, assign, readonly) BOOL isGeneralVersion;

/// 云台操作盘类型，0表示四方向，1表示八方向
@property (nonatomic, assign, readonly) NSInteger ptzPanelStyle;
/// 播放操作盘背景
@property (nonatomic, strong, readonly) UIColor *playOperateBgColor;
/// 云台操作盘类型，0表示四方向，1表示八方向
@property (nonatomic, strong, readonly) UIColor *liveMonitorDateBarColor;

/// 主题色，乐橙是橙色，easy4ip是蓝色
@property (nonatomic, strong, readonly) UIColor *themeColor;
/// 第二主题色，乐橙是橙色，easy4ip是蓝色
@property (nonatomic, strong, readonly) UIColor *themeSecondColor;
/// 导航栏背景颜色
@property (nonatomic, strong, readonly) UIColor *navigationBarColor;
/// 导航栏字体颜色
@property (nonatomic, strong, readonly) UIColor *navigationTextColor;
///消息日历选中颜色
@property (nonatomic, strong, readonly) UIColor *messageCalendarColor;
///变焦Bar颜色
@property (nonatomic, strong, readonly) UIColor *zoomFocusProgressBarColor;
/// 确定按钮颜色
@property (nonatomic, strong, readonly) UIColor *confirmButtonColor;

/**
 LCSheetView的样式
【备注】字典格式如下:
 @{
    @"separateLineColor" : UIColor,
    @"containerBgColor" : UIColor,
    @"buttonBgColor" : UIColor,
    @"cancleTitleColor" : UIColor,
    @"deadlineAttributedColor": UIColor,
    @"paddingBetwennCancleAndOther" : NSNumber,
    @"showButtonBackground": @(Boolen)
 
 }
 @return NSDictonary
 */
- (NSDictionary *)shareSheetType;



/**
 按钮通用配置

 【备注】字典格式如下:
    @{
        @"backgroundColor": UIColor    //背景颜色
        @"conerRadius": NSNumber
        @"height": NSNumber
    }
 @return NSDictionary
 */
- (NSDictionary *)commonButtonConfig;

/**
 将带颜色格式的字段转换成UIColor

 @param dicOrigin 原始配置
 @return 转换后的配置
 */
- (NSDictionary *)generateDictionaryContainColor:(NSDictionary *)dicOrigin;


//MARK: - Extesion
/**
 通用按钮的cornerRadius

 @return CGFloat
 */
- (CGFloat)commonButtonCornerRadius;

/**
 通用按钮颜色

 @return UIColor
 */
- (UIColor *)commonButtonColor;

/**
技术支持电话

@return NSString 
*/
- (NSString *)serviceCall;


@end
