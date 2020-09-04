//
//  DownloadPicture.h
//  LCOpenSDKDemo
//
//  Created by mac318340418 on 16/10/12.
//  Copyright © 2016年 lechange. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DownStatus) {
    NONE = 0,
    DOWNLOADING = 1,
    DOWNLOAD_FINISHED = 2,
    DOWNLOAD_SUCCESS = 3,
    DOWNLOAD_FAILED = 4,
    SAVE_FAILED = 5
};
@interface DownloadPicture : NSObject
@property NSData* picData;
@property DownStatus downStatus;

- (void)setData:(NSData*)data status:(DownStatus)status;
- (void)clearData;
@end
