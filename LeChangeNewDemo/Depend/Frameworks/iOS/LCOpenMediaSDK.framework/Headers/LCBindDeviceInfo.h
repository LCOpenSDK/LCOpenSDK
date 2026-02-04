//
//  LCBindDeviceInfo.h
//  LCMediaComponents
//
//  Created by lei on 2025/3/28.
//

#import <Foundation/Foundation.h>
#import "LCVideoPlayerDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCBindDeviceInfo : NSObject<NSCopying>

@property(nonatomic, nullable, copy)NSString *bindPid;
@property(nonatomic, nullable, copy)NSString *bindDid;
@property(nonatomic, assign)NSInteger bindCid;
//绑定类型
@property(nonatomic, assign)LCMediaBindDeviceType bindType;

@end

NS_ASSUME_NONNULL_END
