//
//  LCMediaServerParameter.h
//  LCMediaComponents
//
//  Created by lei on 2024/10/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCMediaServerParameter : NSObject

@property (nonatomic, copy) NSString  *host;
@property (nonatomic)       NSInteger port;
/* 0: http   1: https */
@property (nonatomic)       NSInteger protocol;
@property (nonatomic)       NSInteger keepAlive;

-(NSString *)streamUrl;

@end

NS_ASSUME_NONNULL_END
