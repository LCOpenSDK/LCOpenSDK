//
//  NSString+MessageModule.h
//  LCMessageModule
//
//  Created by lei on 2022/10/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (MessageModule)

/**
 国际化字符串
 */
@property(nonatomic, copy, nonnull, readonly) NSString *lcMessage_T;

@end

NS_ASSUME_NONNULL_END
