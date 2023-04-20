//
//  LCOpenSDK_DownloadListener.h
//  LCOpenSDK
//
//  Created by mac318340418 on 16/9/5.
//  Copyright © 2016年 lechange. All rights reserved.
//

#ifndef LCOpenSDK_DownloadListener_h
#define LCOpenSDK_DownloadListener_h

#import <Foundation/Foundation.h>

///  Cloud video download callback monitoring event    zh:云录像下载回调监听事件
@protocol LCOpenSDK_DownloadListener <NSObject>

@optional

/// Cloud video download data length callback    zh:云录像下载数据长度回调
/// @param index download index value    zh:下载索引值
/// @param datalen data length    zh:数据长度
- (void) onDownloadReceiveData:(NSInteger)index datalen:(NSInteger)datalen;

/// Cloud video download status callback    zh:云录像下载状态回调
/// @param index download index value    zh:下载索引值
/// @param code 0, download failed (type = 1)    zh: 下载失败
/// 1, start downloading (type = 1)    zh:开始下载
/// 2, the download is over (type = 1)    zh:下载结束
/// 3, cancel download (type = 1)    zh:取消下载
/// 7, download timeout (type = 1)    zh:下载超时
/// @param type type 1 HLS, 99 OPENAPI
- (void) onDownloadState:(NSInteger)index code:(NSString *)code type:(NSInteger)type;

@end

#endif /* LCOpenSDK_DownloadListener_h */
