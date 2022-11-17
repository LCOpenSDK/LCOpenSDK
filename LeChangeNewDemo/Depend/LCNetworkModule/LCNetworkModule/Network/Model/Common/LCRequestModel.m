//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "LCRequestModel.h"
#import "LCApplicationDataManager.h"

@implementation LCRequestSystemModel

-(instancetype)init{
    if (self = [super init]) {
        //获取nonce随机字符
        self.nonce = [LCApplicationDataManager serial];
        self.time = [LCApplicationDataManager getCurrentTimeStamp];
        self.ver = @"1.0";
        self.appId = [LCApplicationDataManager appId];
        self.sign = [self getSign];
    }
    return self;
}

-(NSString *)getSign{
    NSString * signStr = [NSString stringWithFormat:@"time:%@,nonce:%@,appSecret:%@",self.time,self.nonce,[LCApplicationDataManager appSecret]];
    return [signStr lc_MD5Digest];
}

@end

@implementation LCRequestModel

//MARK: - Public Methods

+(instancetype)lc_WrapperNetworkRequestPackageWithParams:(id)params{
    LCRequestModel * model = [[LCRequestModel alloc] initWithParams:params];
    return model;
}

//MARK: - Private Methods
-(instancetype)initWithParams:(id)params{
    if (self = [super init]) {
        //请求消息ID号，可以传入任意字符串
        self.identifier = [LCApplicationDataManager serial];
        self.system = [LCRequestSystemModel new];
        _params = params;
    }
    return self;
}

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"identifier":@"id"
             };
}






@end
