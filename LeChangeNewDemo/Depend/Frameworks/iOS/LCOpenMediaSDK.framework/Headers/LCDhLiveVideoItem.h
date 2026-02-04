//
//  LCDhLiveVideoItem.h
//  LCMediaComponents
//
//  Created by lei on 2021/9/17.
//

#import <LCOpenMediaSDK/LCOpenMediaSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCDhLiveVideoItem : LCMediaBaseVideoItem

// 码流类型
@property(nonatomic, assign)LCVideoStreamType streamType;

@property(nonatomic, copy, nullable)NSString *devP2PAk;

@property(nonatomic, copy, nullable)NSString *devP2PSk;

@end

NS_ASSUME_NONNULL_END
