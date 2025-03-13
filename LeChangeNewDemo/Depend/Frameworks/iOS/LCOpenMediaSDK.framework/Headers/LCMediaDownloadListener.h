//
//  LCMediaDownloadListener.h
//  LCSDK
//
//  Created by zhou_yuepeng on 16/9/5.
//  Copyright © 2016年 com.lechange.lcsdk. All rights reserved.
//

#ifndef LCMedia_DownloadListener_h
#define LCMedia_DownloadListener_h

#import <Foundation/Foundation.h>

@protocol LCMediaDownloadListener <NSObject>
/**
 *  下载数据大小回调
 *
 *  @param index   下载索引号
 *  @param datalen 每次下载数据大小(可累加该数值计算当前下载百分比)
 */
- (void) onDownloadReceiveData:(NSInteger)index datalen:(NSInteger)datalen;

/**
 *  下载状态回调
 *
 *  @param index 下载索引号
 *  @param code  状态码(参考OC_HLS_STATE枚举)
 *  @param type  业务类型(参考OC_PROTO_TYPE枚举)
 */
- (void) onDownloadState:(NSInteger)index code:(NSString *)code type:(NSInteger)type;

/// 密码找回成功回调
/// @param deviceId 设备序列号
/// @param productId 产品Id
/// @param password 设备密码
- (void) onDownloadGetPasswordBackSuccess:(NSString *)deviceId productId:(NSString * __nullable)productId password:(NSString *)password;

@optional
/// 下载卡录像封面回调
/// @param index 下载索引号
/// @param data 回调数据
/// @param info 回调信息
- (void) onRecvImageFrame:(NSInteger)index Data:(NSData*)data Info:(NSString*)info;

@end

#endif /* LCSDK_DownloadListener_h */
