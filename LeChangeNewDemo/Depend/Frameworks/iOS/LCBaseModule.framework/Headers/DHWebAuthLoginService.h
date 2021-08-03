//
//  Copyright © 2017年 dahua. All rights reserved.
//  用于商城免登录处理

#import <Foundation/Foundation.h>


@protocol DHWebAuthLoginService <DHServiceProtocol>

//拼接免登陆 url
- (NSString *)getSignUrlWithSrcUrl:(NSString *)url;

@end
