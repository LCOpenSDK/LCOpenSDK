//
//  Copyright (c) 2015年 Anson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCUDIDTool : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, readonly, strong) NSString *UDIDString;
@end
