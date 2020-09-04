//
//  DownloadPicture.m
//  LCOpenSDKDemo
//
//  Created by mac318340418 on 16/10/12.
//  Copyright © 2016年 lechange. All rights reserved.
//

#import "DownloadPicture.h"

@implementation DownloadPicture
- (instancetype)init
{
    self = [super init];
    if (self) {
        _picData = nil;
        _downStatus = NONE;
    }
    return self;
}
- (void)setData:(NSData*)data status:(DownStatus)status
{
    _picData = data;
    _downStatus = status;
}
- (void)clearData
{
    _picData = nil;
    _downStatus = NONE;
}
@end
