//
//  LCOpenLiveSource.h
//  LCMediaComponents
//
//  Created by lei on 2024/10/9.
//

#import <LCOpenMediaSDK/LCOpenMediaSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCOpenLiveSource : LCBaseVideoItem

//播放token,包含拉流相关参数和能力
@property(nonatomic, copy)NSString *playToken;
//playToken解析秘钥
@property(nonatomic, copy)NSString *playTokenKey;
//管理员token
@property(nonatomic, copy)NSString *accessToken;
//流解密秘钥
@property(nonatomic, copy)NSString *psk;
//是否使用tls链接
@property(nonatomic, assign)BOOL isTls;
// 码流类型
@property(nonatomic, assign)BOOL isMainStream;
// 码流分辨率
@property (nonatomic, assign) NSInteger        imageSize;
// 是否辅助帧默认关闭
@property (nonatomic, assign) BOOL        isAssistFrame;

@property(nonatomic, assign)BOOL forceMts;

//降噪等级
@property(nonatomic, assign)LCPlayNoiseAbility noiseLevel;

@end

NS_ASSUME_NONNULL_END
