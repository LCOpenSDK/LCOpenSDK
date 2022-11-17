//
//  Copyright © 2019 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCModel.h"

@class LCError;

NS_ASSUME_NONNULL_BEGIN

typedef void (^requestSuccessBlock)(id objc);
typedef void (^requestFailBlock)(LCError *error);

@interface LCNetworkRequestManager : NSObject

+ (instancetype)manager;

/// 超时时间
@property (nonatomic) NSTimeInterval timeoutInterval;

/**
 请求接口

 @param URLString 接口地址
 @param parameters 接口所需参数
 @param success 成功回调
 @param failure 失败回调
 */
- (void)lc_POST:(NSString *)URLString parameters:(id)parameters
        success:(requestSuccessBlock)success
        failure:(requestFailBlock)failure;

@end

NS_ASSUME_NONNULL_END
