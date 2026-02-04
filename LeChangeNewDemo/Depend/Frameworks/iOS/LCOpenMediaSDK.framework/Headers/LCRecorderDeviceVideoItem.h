//
//  LCRecorderDeviceVideoItem.h
//  LCMediaComponents
//
//  Created by lei on 2024/8/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCRecorderDeviceVideoItem : NSObject

@property(nonatomic, copy)NSString *url;

@property(nonatomic, assign)CGFloat speed;

-(BOOL)isValid; //验证参数是否有效

@end

NS_ASSUME_NONNULL_END
