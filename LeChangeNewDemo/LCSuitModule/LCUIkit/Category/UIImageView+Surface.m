//
//  Copyright © 2020 dahua. All rights reserved.
//

#import "UIImageView+Surface.h"
#import <SDWebImage/SDWebImage.h>

@implementation UIImageView (Surface)

- (void)lc_setThumbImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder DeviceId:(NSString *)deviceId ChannelId:(NSString *)chanelId {

    [self setImage:placeholder];
    SDImageCache* cache = [SDImageCache sharedImageCache];
    NSString* key_temp = [NSString stringWithFormat:@"thumbimg_%@_%@",deviceId,chanelId];
    if ([cache diskImageDataExistsWithKey:key_temp]) {
         [self setImage:[cache imageFromDiskCacheForKey:key_temp]];
    } else if (url.length > 0) {
        //DTS001654812 未显示封面图
        [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder];
    }
}

- (void)lc_storeImage:(UIImage *)image ForDeviceId:(NSString *)deviceId ChannelId:(NSString *)chanelId {
    if (!image || !deviceId || [deviceId isEqualToString:@""] || !chanelId || [chanelId isEqualToString:@""]) {
        NSLog(@"参数错误");
        return;
    }
    SDImageCache* cache = [SDImageCache sharedImageCache];
    NSString* key_temp = [NSString stringWithFormat:@"thumbimg_%@_%@",deviceId,chanelId];
    [cache storeImage:image forKey:key_temp toDisk:YES completion:^{
        NSLog(@"储存本地封面图成功");
    }];
}

+ (BOOL)lc_deskCacheIsExistThumbImageForDeviceId:(NSString *)deviceId ChannelId:(NSString *)chanelId {
    SDImageCache* cache = [SDImageCache sharedImageCache];
    NSString* key_temp = [NSString stringWithFormat:@"thumbimg_%@_%@",deviceId,chanelId];
    return [cache diskImageDataExistsWithKey:key_temp];
}

+ (void)lc_deleteThumbImageWithDeviceId:(NSString *)deviceId ChannelId:(NSString *)chanelId {
    if ([self lc_deskCacheIsExistThumbImageForDeviceId:deviceId ChannelId:chanelId]) {
        SDImageCache* cache = [SDImageCache sharedImageCache];
        NSString* key_temp = [NSString stringWithFormat:@"thumbimg_%@_%@",deviceId,chanelId];
        [cache removeImageForKey:key_temp withCompletion:^{
            NSLog(@"本地图片缓存删除成功");
        }];
    }
}

@end
