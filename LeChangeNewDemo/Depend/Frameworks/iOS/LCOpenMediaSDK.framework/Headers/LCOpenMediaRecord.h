//
//  LCOpenMediaRecord.h
//  LCOpenMedia
//
//  Created by bzy on 5/9/17.
//  Copyright © 2017 lechange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCOpenMediaRecord : NSObject
@property (nonatomic, assign) NSString *recordId;
@property (nonatomic, assign) NSString *recordRegionId;
@property (nonatomic, copy) NSString *type; // 1000 报警云录像， 2000 定时云录像
@property (nonatomic, copy)   NSString *fileName;
@property (nonatomic, assign) long beginTime;
@property (nonatomic, assign) long endTime;
@end
