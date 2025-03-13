//
//  LCOpenTalkPlugin.h
//  LCMediaComponents
//
//  Created by lei on 2021/10/12.
//

#import <Foundation/Foundation.h>
#import <LCOpenMediaSDK/LCOpenTalkSource.h>
#import <LCOpenMediaSDK/LCVideoPlayerDefines.h>

NS_ASSUME_NONNULL_BEGIN

@class LCOpenTalkPlugin;

@protocol LCOpenTalkPluginDelegate <NSObject>

/// 开启对讲成功
/// - Parameter source: 对讲参数
- (void)onTalkSuccess:(LCOpenTalkSource *)source;

/// 开始进入对讲加载过程
/// - Parameter source: 对讲参数
- (void)onTalkLoading:(LCOpenTalkSource *)source;

/// 停止对讲
/// - Parameter source: 对讲参数
- (void)onTalkStop:(LCOpenTalkSource *)source;

/// 对讲失败
/// - Parameters:
///   - source: 对讲参数
///   - talkError: 对讲失败错误码
///   - type：错误类型
- (void)onTalkFailure:(LCOpenTalkSource *)source talkError:(NSString *)error type:(int)type;

@optional

/// 对讲声音分贝
/// - Parameter soundDb: 分贝
- (void)onSaveSoundDb:(int)soundDb;

@end

@protocol LCTalkbackLogReportDelegate <NSObject>

- (void)talkbackPlayerOnDataAnalysis:(LCOpenTalkPlugin *)player streamData:(NSString *)data;

- (void)talkbackPlayerTalkStreamLogInfo:(LCOpenTalkPlugin *)player streamMessage:(NSString *)message;

- (void)talkbackPlayerOnProgressStatus:(LCOpenTalkPlugin *)player request:(NSString *)request status:(NSString *)status time:(NSString *)time;

- (void)talkbackPlayerOnDataLength:(LCOpenTalkPlugin *)player size:(NSInteger)size;

@end

@interface LCOpenTalkPlugin : NSObject

@property(nonatomic, weak)id<LCOpenTalkPluginDelegate> delegate;

@property(nonatomic, weak)id<LCTalkbackLogReportDelegate> logReporter;

@property(nonatomic, strong) LCOpenTalkSource *talkSource;

@property(nonatomic, assign)LCTalkbackStatus talkStatus;

//可视对讲分辨率信息及是否采集
//@property(nonatomic, assign)BOOL isSampleVideo;
//@property(nonatomic, assign)NSInteger videoSampleWidth;
//@property(nonatomic, assign)NSInteger videoSampleHeight;

+ (instancetype) shareInstance;

/// 开启对讲
/// @param source 对讲信息源
-(void)playTalk:(LCOpenTalkSource *)source;

/// 停止对讲
-(void)stopTalk;

/// 开启变声对讲
/// @param speechMode 要改变的声音模式
-(void)changeSpeechMode:(LCTalkbackSpeechMode)speechMode;

/// 开启音频采集
-(void)startSampleAudio;

/// 关闭音频采集
-(void)stopSampleAudio;

/// 开启声音
-(void)playSound;

/// 关闭声音
-(void)stopSound;

///获取对讲流模式
-(LCVideoStreamMode)currentStreamMode;

@end

NS_ASSUME_NONNULL_END
