//
//  LCOCPlayerManagerProtocol.h
//  Pods
//
//  Created by lei on 2025/6/19.
//

#import <Foundation/Foundation.h>
#import "LCVideoPlayerDefines.h"
#ifdef LECHANGE_MEDIA
#import "CommonSDKoc/LCCommonSDK/PlayerComponent/OCPlayerManager.h"
#else
#import <LCOpenSDKDynamic/CommonSDK_Include/PlayerComponent/OCPlayerManager.h>
#endif

@protocol LCOCPlayerManagerProtocol <NSObject>

/*
* @desc 设置鱼眼模式
* @param mode 模式枚举值
* @return true-成功  false-失败
*/
- (BOOL)setFishEyeModeInfo:(OCPlayerManager *)mOCPlayerManager mode:(LCMediaFishEyeWindowShowMode)mode;

/*
* @desc 设置VR虚拟云台
* @param posX 横坐标x位置
* @param posY 纵坐标y位置
* @return true-成功  false-失败
*/
- (BOOL)setfishEyeEptzPos:(OCPlayerManager *)mOCPlayerManager posX:(long)posX PosY:(long)posY;

//卡录像seek能力
- (BOOL)getCorssFileSeekAbility:(OCPlayerManager *)mOCPlayerManager;

/*
* @desc seek播放优化接口，支持跨文件seek
* @param starttime 开始时间 秒级
* @param endtime 结束时间  秒级
* @return true-成功  false-失败
*/
- (BOOL)corssfileSeekPlay:(OCPlayerManager *)mOCPlayerManager starttime:(NSString *)starttime endtime:(NSString *)endtime;

@end
