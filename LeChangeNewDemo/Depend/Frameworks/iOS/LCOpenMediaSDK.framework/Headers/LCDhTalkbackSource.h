//
//  LCDhTalkbackSource.h
//  LCMediaComponents
//
//  Created by lei on 2021/10/11.
//

#import <LCOpenMediaSDK/LCBaseTalkbackSource.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCDhTalkbackSource : LCBaseTalkbackSource

@property(nonatomic, assign)BOOL isChannelTalk;  //是否为通道对讲

@property(nonatomic, assign)BOOL isAutoDecideParam; //是否自动决策参数

@property(nonatomic, copy, nullable)NSString *devP2PAk;

@property(nonatomic, copy, nullable)NSString *devP2PSk;

@end

NS_ASSUME_NONNULL_END
