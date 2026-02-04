//
//  LCOpenMediaNetManager.h
//  Categories
//
//  Created by lei on 2025/6/16.
//

#import <Foundation/Foundation.h>
#import "LCMediaNetProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCOpenMediaNetManager : NSObject<LCMediaNetProtocol>

+ (instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END
