//
//  Copyright © 2019 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCClientEventLogHelper : NSObject

+ (LCClientEventLogHelper *)shareInstance;



/**
 获取该次请求的requestid

 @return requestid
 */
- (NSString *)getRequestId;

/**
 *   获取当期时间的时间戳  毫秒级别
 */
- (NSString *)getCurrentSystemTimeMillis;

/**
 上报打点事件

 @param name 事件名称
 @param contentDic 需要携带的内容
 */
- (void)addClientEventLog:(NSString *)name conent:(nullable NSDictionary *)contentDic;


/**
 上传组件，流媒体，p2p打点日志

 @param json 日志内容
 */
- (void)addClientEventLogForJson:(NSString *)json;


/**
 上传本地缓存的日志
 */
- (void)uploadCacheLog;

@end

NS_ASSUME_NONNULL_END
