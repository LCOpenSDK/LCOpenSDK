//
//  Copyright © 2016 LeChange. All rights reserved.
//
//  播放声音帮助类

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface LCAudioHelper : NSObject

/**
 *  获取单例
 *
 *  @return MessageManager 消息管理类
 */
+ (instancetype)sharedInstance;

/**
 *  播放默认铃声
 */
- (void)playDefaultSound;

/**
 *  播放
 */
- (void)play;

/**
 *  停止
 */
- (void)stop;


/**
 设置是否静音：在视频相关页面不需要响铃
 
 @param needMute BOOL
 */
- (void)setNeedMute:(BOOL)needMute;

/**
 *  @param  pushSoundFullName 铃声文件全名
 *  设置App内推送声音
 */
- (void)setPushSoundWithPushSoundFullName:(NSString *)pushSoundFullName;

/**
 音频单次播放测试

 @param playFilename 声音文件名，不带后缀
 */
- (void)playOnceShort:(NSString *)playFilename;

/**
 保存声音配置至本地
 
 @param soundFullname 声音文件全名称
 */
- (void)saveLocalPushSound:(NSString *)soundFullname;

/**
 读取本地已保存的声音配置
 
 @return 声音文件全名称
 */
- (NSString *)localPushSound;

/**
 *  推送通知提醒
 */
- (void)remindNotificationWithDefaultSound:(BOOL)withDefaultSound;


/**
 推送通知提醒，提示专用铃声

 @param customSoundFullName 指定铃声文件名全称
 */
- (void)remindNotificationWithExclusiveSound:(NSString *)exclusiveSoundFullName;

@end
