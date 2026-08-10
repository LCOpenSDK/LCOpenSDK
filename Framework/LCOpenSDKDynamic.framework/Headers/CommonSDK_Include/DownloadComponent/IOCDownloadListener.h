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
 * 图片帧数据回调：一次回调只返回一张图片
 * index 下载任务的编号
 * data  图片数据
 * info  json格式的图片信息：
 *      {"frameTime":"20240129T120807", "frameID":"xxx", "frameType":123}  
 *      frameTime - 帧时间  
 *      frameID   - 图片ID
 *      frameType - 图片类型
 *      
 */
- (void) onRecvImageFrame:(NSInteger)index Data:(NSData*)data Info:(NSString*)info;

@end
