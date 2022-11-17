//
//  Copyright (c) 2015年 Imou. All rights reserved.
//

#import "LCUserInfo.h"

@implementation LCUserAccountOperationInfo

@end

@implementation LCThirdAccountInfo

@end

@implementation LCHistoryLoginInfoItem

@end

@implementation LCShareRecordInfo

@end

@implementation LCUserRecordPublicInfo

@end

@implementation LCUserPushInfo

@end

@implementation LCUserAccessInfo

@end

@implementation LCUserSwitch

@end

@implementation LCUserInfo

@synthesize username, phoneNumber, nickname, pushStatus;

- (id) init
{
    self = [super init];
    
    if (self)
    {
    
    }
    
    return self;
}

@end

@implementation LCBindPhoneUserInfo


@end

@implementation QRCodeInfo

@end

@implementation LCCheckThridBindOrNotInfo

@end

@implementation LCBindThirdpartyWeixinAccountInfo

@end

@implementation LCCheckValidCodeInfo

@end

@implementation LCThirdAccountAuthLoginInfo

@end

@implementation LCCaptchaInfo

@end

@implementation LCFamilyFaceBook

@end

@implementation LCFamilyFaceInfo

@end

@implementation LCFamilyFaceToAdd

@end

@implementation LCCheckCancellationObject

@end

@implementation LCShopCouponInfo

@end


#pragma mark - SaaS Protocol (Push)

@implementation LCSubscribeTimeItem

@end


@implementation LCSubscribeTimeInfo

- (instancetype)init {
    if (self = [super init]) {
        _arrayTime = [NSMutableArray arrayWithCapacity:1];
    }
    
    return self;
}

@end

@implementation LCUserEventLogReport

-(id)copyWithZone:(NSZone *)zone
{
    LCUserEventLogReport *report = [LCUserEventLogReport new];
    report._id = self._id;
    report.object = self.object;
    report.name = self.name;
    report.startTimestamp = self.startTimestamp;
    report.stopTimestamp = self.stopTimestamp;
    report.sslcost = self.sslcost;
    report.apicost = self.apicost;
    report.content = self.content;
    
    return report;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self._id forKey:@"_id"];
    [aCoder encodeObject:self.object forKey:@"object"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeDouble:self.startTimestamp forKey:@"startTimestamp"];
    [aCoder encodeDouble:self.stopTimestamp forKey:@"stopTimestamp"];
    [aCoder encodeObject:self.sslcost forKey:@"sslcost"];
    [aCoder encodeObject:self.apicost forKey:@"apicost"];
    [aCoder encodeObject:self.content forKey:@"content"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self._id = [aDecoder decodeObjectForKey:@"_id"];
        self.object = [aDecoder decodeObjectForKey:@"object"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.startTimestamp = [aDecoder decodeDoubleForKey:@"startTimestamp"];
        self.stopTimestamp = [aDecoder decodeDoubleForKey:@"stopTimestamp"];
        self.sslcost = [aDecoder decodeObjectForKey:@"sslcost"];
        self.apicost = [aDecoder decodeObjectForKey:@"apicost"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
    }
    
    return self;
}

@end
