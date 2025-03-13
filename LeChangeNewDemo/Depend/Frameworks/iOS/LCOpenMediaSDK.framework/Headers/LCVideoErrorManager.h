//
//  LCVideoErrorManager.h
//  LCMediaModule
//
//  Created by lei on 2021/1/14.
//

#import <Foundation/Foundation.h>
#import <LCOpenMediaSDK/LCVideoPlayerDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCVideoErrorManager : NSObject

/// 通过组件回调错误码转换成媒体组件层错误
/// @param errorCode 错误码
/// @param type 错误类型
/// @param deviceId 设备序列号
+ (LCVideoPlayError)transformVideoPlayErrorWithErrorCode:(NSInteger)errorCode type:(NSInteger)type deviceId:(NSString *)deviceId;

@end

NS_ASSUME_NONNULL_END
