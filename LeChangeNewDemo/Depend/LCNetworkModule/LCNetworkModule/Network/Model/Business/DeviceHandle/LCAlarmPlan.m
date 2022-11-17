//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "LCAlarmPlan.h"

@implementation LCAlarmPlanRule



@end

@implementation LCAlarmPlan

+(NSDictionary *)mj_objectClassInArray{
    return @{ @"rules" : [LCAlarmPlanRule class]};
}

@end
