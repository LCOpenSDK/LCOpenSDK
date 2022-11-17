//
//  Copyright © 2019 Imou. All rights reserved.
//。 网络请求，响应数据模型，Http请求统一先解析为该s模型，然后再进行分发

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCResponseResultModel : NSObject

@property (strong, nonatomic) id data;

/// 错误码
@property (strong, nonatomic) NSString *code;

/// 错误信息
@property (strong, nonatomic) NSString *msg;

@end

@interface LCResponseModel : NSObject

/// id
@property (strong, nonatomic) NSString *identifier;

/// 具体返回信息
@property (strong, nonatomic) LCResponseResultModel *result;

@end

NS_ASSUME_NONNULL_END
