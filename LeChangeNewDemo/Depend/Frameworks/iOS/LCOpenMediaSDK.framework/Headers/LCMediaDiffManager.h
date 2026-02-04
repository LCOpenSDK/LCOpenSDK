//
//  LCMediaDiffManager.h
//  LCOpenMediaSDK
//
//  Created by lei on 2025/6/18.
//

#import <Foundation/Foundation.h>
#import "LCMediaProcessorProtocol.h"
#import "LCMediaNetProtocol.h"
#import "LCOCPlayerManagerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCMediaDiffManager : NSObject

@property(nonatomic, weak)id<LCMediaProcessorProtocol> processPtl;

@property(nonatomic, weak)id<LCMediaNetProtocol> netPtl;

@property(nonatomic, weak)id<LCOCPlayerManagerProtocol> ocPlayerManagerPtl;

+ (instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END
