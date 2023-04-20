//
//  UIImageView+PicDecoder.h
//  LCMessageModule
//
//  Created by lei on 2022/10/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (PicDecoder)

/**
 解密图片缩略图

 @param url 图片URL
 @param placeholder 默认图片
 @param deviceId 设备Id
 @param key 解密密钥
 */
- (void)lc_setMessageImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder deviceId:(NSString *)deviceId productId:(NSString *)productId playtoken:(NSString *)playtoken key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
