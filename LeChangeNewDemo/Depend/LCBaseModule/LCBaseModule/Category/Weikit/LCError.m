//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "LCError.h"

#import "LCErrorCode.h"

@implementation LCError

- (id)init {
    return [self initWithCode:0 errorMessage:@"" errorInfo:[NSMutableDictionary dictionary]];
}

- (id)initWithCode:(NSString *)errorCode errorMessage:(NSString *)errorMessage errorInfo:(NSDictionary *)userInfo {
    self = [super init];

    if (self) {
        _errorCode = errorCode;
        _errorMessage = errorMessage;
        _errorInfo = userInfo;
    }

    return self;
}

+ (instancetype)errorWithCode:(NSString *)errorCode errorMessage:(nullable NSString *)errorMessage errorInfo:(nullable NSDictionary *)userInfo {
    LCError *errObjc = [[LCError alloc] initWithCode:errorCode errorMessage:errorMessage errorInfo:userInfo];
    return errObjc;
}

+ (BOOL)isAuthenticationFailed:(NSInteger)errorCode {
    if (errorCode == EC_HTTP_AUTH) {
        return YES;
    }
    
    return NO;
}

@end
