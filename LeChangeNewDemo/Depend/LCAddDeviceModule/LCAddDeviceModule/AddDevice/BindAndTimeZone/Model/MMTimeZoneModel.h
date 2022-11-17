//
//  Copyright © 2017年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMTimeZoneModel : NSObject

@property (nonatomic, assign) int areaIndex;
@property (nonatomic, assign) int timeZoneIndex;
@property (nonatomic, copy)   NSString *beginSumTime;
@property (nonatomic, copy)   NSString *endSumTime;

@end
