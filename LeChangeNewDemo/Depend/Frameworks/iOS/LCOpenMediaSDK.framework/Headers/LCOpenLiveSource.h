//
//  LCOpenLiveSource.h
//  LCMediaComponents
//
//  Created by lei on 2024/10/9.
//

#import <LCOpenMediaSDK/LCOpenMediaBaseVideoItem.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCOpenLiveSource : LCOpenMediaBaseVideoItem

// 码流类型
@property(nonatomic, assign)BOOL isMainStream;
// 码流分辨率
@property (nonatomic, assign) NSInteger        imageSize;
// 是否辅助帧默认关闭
@property (nonatomic, assign) BOOL        isAssistFrame;

@property(nonatomic, assign)BOOL forceMts;

@end

NS_ASSUME_NONNULL_END
