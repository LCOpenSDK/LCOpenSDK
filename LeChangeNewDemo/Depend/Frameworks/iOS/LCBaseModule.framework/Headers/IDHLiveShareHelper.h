//
//  Copyright © 2018年 jm. All rights reserved.
//	直播分享类的服务/协议

#ifndef IDHLiveShareHelper_h
#define IDHLiveShareHelper_h
#import "DHModule.h"

@protocol IDHLiveShareHelper;

#pragma mark - DHLiveShareHelperDelegate
@protocol DHLiveShareHelperDelegate <NSObject>
@optional

/*!
 *  @author peng_kongan, 15-12-16 16:12:04
 *
 *  @brief  分享流程完成后的回调
 *
 *  @param liveShareHelper 自身类
 *  @param shareState      完成后的分享状态
 */
- (void)liveShareHelper:(id<IDHLiveShareHelper>)liveShareHelper changeState:(BOOL)shareState;

/*!
 *  @author peng_kongan, 15-12-16 16:12:39
 *
 *  @brief  开始分享的回调
 *
 *  @param liveShareHelper 自身类
 */
- (void)startLiveShareHelper:(id<IDHLiveShareHelper>)liveShareHelper;

/*!
 *  @author peng_kongan, 15-12-16 17:12:47
 *
 *  @brief  取消（点击取消按钮或者背景）
 *
 *  @param liveShareHelper 自身类
 */
- (void)cancelLiveShareHelper:(id<IDHLiveShareHelper>)liveShareHelper;

@end


#pragma mark - IDHLiveShareHelper
@protocol IDHLiveShareHelper<DHServiceProtocol>

/// 关闭密码框提示block
@property (nonatomic, copy) void(^closePwdAlertBlock)(void);

/// 必须：通道id
@property (nonatomic, copy) NSString *channelId;

/// 必须：设备id
@property (nonatomic, copy) NSString *deviceId;

/// 必须：是否自定义加密了
@property (nonatomic, assign) BOOL isCustomEncrypted;

/// 必须：是否是PaaS设备
@property (nonatomic, assign) BOOL isPaaS;

/**
 开始直播分享操作

 @param delegate 委托回调
 */
- (void)liveShareWithDelegate:(id<DHLiveShareHelperDelegate>)delegate;

@end

#endif /* IDHLiveShareHelper_h */
