//
//  Copyright © 2020 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (Surface)

/**
 获取缩略图（如果远程URL为空则从本地加载，若本地也没有则使用默认图）

 @param url 封面图URL
 @param placeholder 默认图
 @param deviceId 设备ID
 @param chanelId 设备通道ID
 */
-(void)lc_setThumbImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder DeviceId:(NSString *)deviceId ChannelId:(NSString *)chanelId;

/**
 保存封面图到本地

 @param image 封面图
 @param deviceId 设备ID
 @param chanelId 设备通道ID
 */
-(void)lc_storeImage:(UIImage *)image ForDeviceId:(NSString *)deviceId ChannelId:(NSString *)chanelId;

/**
 磁盘中是否存在某设备通道的封面图

 @param deviceId 设备id
 @param chanelId 通道号
 @return 是否存在
 */
+ (BOOL)lc_deskCacheIsExistThumbImageForDeviceId:(NSString *)deviceId ChannelId:(NSString *)chanelId;


/**
 删除本地缩略
 @param deviceId 设备ID
 @param chanelId 设备通道ID
 */
+ (void)lc_deleteThumbImageWithDeviceId:(NSString *)deviceId ChannelId:(NSString *)chanelId;
@end

NS_ASSUME_NONNULL_END
