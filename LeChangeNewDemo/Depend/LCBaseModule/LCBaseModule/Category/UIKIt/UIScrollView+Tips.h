//
//  Copyright (c) 2015年 Imou. All rights reserved.
//
//  UIView扩展，用于界面添加提示图片和文字。提示展示方式主要是界面中间有一张图片和一段文字。

#import <UIKit/UIKit.h>

/**
 枚举：提示类型
 */
typedef NS_ENUM(NSInteger,TipsType) {
    TipsTypeNone,               //无提示
    TipsTypeDeviceShareNone,    //无设备共享
    TipsTypeMessageNone,        //无消息
    TipsTypeDeviceNone,         //无设备
    TipsTypeDeviceAPNone,       //无配件
    TipsTypeAlarmNone,          //无报警
    TipsTypeWifiNone,           //无Wifi
    TipsTypeCloudNone,          //无云存储套餐
    TipsTypeDeviceOffline,      //设备离线
    TipsTypeLiveListNone,       //无直播列表
    TipsTypeCommentListNone,    //无评论列表
    TipsTypeFail,               //获取失败
    TipsTypeNetError,           //网络异常
    TipsTypeUpdate,             //点击刷新
    TipsTypeNoVideoMsg,         //暂无留言
	TipsTypeNoVideotape,        //暂无录像
	TipsTypeNoAuthority,        //暂无权限
	TipsTypeNoSdCard,           //暂无SD卡
    TipsTypeNoCollection,       //暂无收藏点
    TipsTypeNoOneDayVideo,      //暂无精彩一天浓缩视频
    TipsTypeNoFriendMsg,        //暂无申请
    TipsTypeNoSearchResult,     //未搜索到设备
    TipsTypeVideoMsgNone,       //无视频留言
    TipsTypeDefault,
};


@interface UIScrollView(Tips)

/**
 *  给空视图页面做响应事件穿透按钮用
 */
@property (strong, nonatomic) UIButton *tapBtn;
@property (strong, nonatomic) UIImageView *tapImageView;

/**
 *  根据提示类型，添加提示界面
 *
 *  @param type 提示类型
 *
 *  @return UIView 提示界面
 */
- (void)lc_addTipsView:(TipsType)type;


/**
 *  移除提示界面
 */
- (void)lc_clearTipsView;

/**
 *  获取空白页提示图片
 *
 *  @param type 提示类型
 *
 *   @return 空白页
 */
- (UIView *)lc_getTipsView:(TipsType)type;

/**
 *  获取空白页提示图片
 *
 *  @param type 提示类型
 *
 *   @return 空白页,在原来空白页上调整了空白页图片的位置，防止遮挡
 */
- (void)lc_addTipsViewModifyFrame;

/*!
 *  @author peng_kongan, 16-02-19 13:02:54
 *
 *  @brief 在LeChange 中使用 根据UI标注 实现提示图片上下边距1:2 （Masonry）
 *
 *  @param imageName   图片名称
 *  @param description 提示信心
 */
- (void)lc_setEmyptImageName:(NSString *)imageName andDescription:(id )description;

/**
 整体显示如上,可进行整体界面点击,并回调
 */
- (void)lc_setEmyptImageName:(NSString *)imageName andDescription:(id )description ClickedBlock:(void(^)(void))block;


///在提示字符下面有按钮可以点击
- (void)lc_setEmyptImageName:(NSString *)imageName andDescription:(id )description andButtonTitle:(NSString *)buttonTitle withButtonClickedBlock:(void(^)(void))block;

/*!
*  @author lv_tongsheng, 20-04-09
*
*  @brief 根据UI标注 提示文字分为 title 和 description
*
*  @param imageName   图片名称
*  @param title 提示主文字
*  @param description 提示描述
*/
- (void)lc_setEmyptImageName:(NSString *)imageName emptyTitle:(NSString *)title emptyDescription:(NSString *)description;

/*!
*  @author jia_fangzhou, 20-04-16
*
*  @brief 设置空值图片，下方存在自定义view
*
*  @param imageName   图片名称
*  @param title 提示主文字
*  @param description 提示描述
*/
- (void)lc_setEmyptImageName:(NSString *)imageName emptyDescription:(NSString *)description customView:(UIView *)customView;

/**
 设置空值图片

 @param image 图片
 @param description 描述
 */
- (void)lc_setEmptyImage:(UIImage *)image description:(id)description;

- (void)lc_setEmyptImageName:(NSString *)imageName andDescription:(id )description userInteractionEnabled:(BOOL)enable;

@end
