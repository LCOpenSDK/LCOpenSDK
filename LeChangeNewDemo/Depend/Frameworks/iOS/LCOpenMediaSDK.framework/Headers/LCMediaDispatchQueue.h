//
//  LCMediaDispatchQueue.h
//  LCMediaComponents
//
//  Created by lei on 2025/4/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCMediaDispatchQueue : NSObject
//切换至主线程(若当前已在主线程,不会执行切换操作)
+(void)mainAsync:(void(^)(void))block;

@end

NS_ASSUME_NONNULL_END
