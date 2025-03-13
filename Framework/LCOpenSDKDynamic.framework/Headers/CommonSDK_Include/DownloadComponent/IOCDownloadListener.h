//
//  Header.h
//  DownloadComponent
//
//  Created by mac318340418 on 16/9/1.
//  Copyright © 2016年 dh-Test. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol IOCDownloadListener <NSObject>

@optional

- (void) onDownloadReceiveData:(NSInteger)index datalen:(NSInteger)datalen;

- (void) onDownloadState:(NSInteger)index code:(NSString *)code type:(NSInteger)type;

/**
 * 图片数据回调：注意一次回调只会返回一张图片
 * info: json格式 
*/
- (void) onRecvImageFrame:(NSInteger)index Data:(NSData*)data Info:(NSString*)info;

@end
