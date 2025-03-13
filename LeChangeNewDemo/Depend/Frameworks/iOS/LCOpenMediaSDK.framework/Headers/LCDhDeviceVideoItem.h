//
//  LCDhDeviceVideoItem.h
//  LCMediaComponents
//
//  Created by lei on 2021/1/28.
//

#import <LCOpenMediaSDK/LCBaseVideoItem.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCDhDeviceVideoItem : LCBaseVideoItem

@property(nonatomic, assign)LCVideoStreamType streamType;

@property(nonatomic, assign)NSInteger beginTime;

@property(nonatomic, assign)NSInteger endTime;

@property(nonatomic, copy, nullable)NSString *devP2PAk;

@property(nonatomic, copy, nullable)NSString *devP2PSk;

@end

NS_ASSUME_NONNULL_END
