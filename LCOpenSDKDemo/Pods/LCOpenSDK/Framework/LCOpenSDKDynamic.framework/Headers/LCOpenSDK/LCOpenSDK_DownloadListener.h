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
/**
 *  云录像下载回调监听事件
 */
@protocol LCOpenSDK_DownloadListener <NSObject>

@optional
/**
 *  云录像下载数据长度回调
 *  
 *  @param index   下载索引值
 *  @param datalen 数据长度
 */
- (void) onDownloadReceiveData:(NSInteger)index datalen:(NSInteger)datalen;
/**
 *  云录像下载状态回调
 *
 *  @param index 下载索引值
 *  @param code  0, 下载失败(type = 1)
 *               1, 开始下载(type = 1)
 *               2, 下载结束(type = 1)
 *               3, 取消下载(type = 1)
 *               7, 下载超时(type = 1)
 *
 *  @param type  1, HLS
 *              99, OPENAPI
 */
- (void) onDownloadState:(NSInteger)index code:(NSString *)code type:(NSInteger)type;

@end

#endif /* LCOpenSDK_DownloadListener_h */
