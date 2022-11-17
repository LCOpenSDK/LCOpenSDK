//
//  Copyright © 2020 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (LCPicDecrypt)


/**
 解密图片缩略图

 @param url 图片URL
 @param placeholder 默认图片
 @param deviceId 设备Id
 @param key 解密密钥
 */
-(void)lc_setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder DeviceId:(NSString *)deviceId ProductId:(NSString *)productId Key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
