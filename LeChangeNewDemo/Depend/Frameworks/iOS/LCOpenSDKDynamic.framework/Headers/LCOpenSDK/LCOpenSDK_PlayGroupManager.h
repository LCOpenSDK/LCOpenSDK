//
//  LCOpenSDK_PlayGroupManager.h
//  LCOpenSDKDynamic
//
//  Created by yyg on 2023/7/17.
//  Copyright © 2023 Fizz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Video sync group    zh:视频同步组
@interface LCOpenSDK_PlayGroupManager : NSObject

+ (instancetype)shareInstance;

/// Create a play group    zh:创建一个播放组
- (long)createPlayGroup;

@end

NS_ASSUME_NONNULL_END
