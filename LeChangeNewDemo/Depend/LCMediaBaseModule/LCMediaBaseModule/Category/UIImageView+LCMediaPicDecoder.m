//
//  UIImageView+LCMediaPicDecoder.m
//  LCMediaBaseModule
//
//  Created by lei on 2022/9/27.
//

#import "UIImageView+LCMediaPicDecoder.h"
#import <LCOpenSDKDynamic/LCOpenSDKDynamic.h>
#import <SDWebImage/SDWebImage.h>
#import <SDWebImage/SDImageCache.h>
#import <LCNetworkModule/LCApplicationDataManager.h>

@implementation UIImageView (LCMediaPicDecoder)

- (void)lcMedia_setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder deviceId:(NSString *)deviceId productId:(NSString *)productId playtoken:(NSString *)playtoken key:(NSString *)key{
    [self setImage:placeholder];
    if (!url || [url isEqualToString:@""]) {
        return;
    }
    SDImageCache* cache = [SDImageCache sharedImageCache];
    NSString* key_temp = [[url componentsSeparatedByString:@"?"] objectAtIndex:0];
    dispatch_queue_t whole_pic_download = dispatch_queue_create("whole_pic_download", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    dispatch_async(whole_pic_download, ^{
        if ([cache diskImageDataExistsWithKey:key_temp]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setImage:[cache imageFromDiskCacheForKey:key_temp]];
            });
            return;
        }
       
        NSURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
        NSHTTPURLResponse* response = nil;
        NSData* picData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:NULL];
        if (response == nil) {
            NSLog(@"download failed");
            return;
        }
        NSData* dataOut = [[NSData alloc] init];
        NSInteger iret = [[LCOpenSDK_Utils new] decryptPic:picData deviceID:deviceId productId:productId key:key accessToken:[LCApplicationDataManager token] playtoken:playtoken bufOut:&dataOut];
        NSLog(@"decrypt iret[%ld]", (long)iret);
        if (0 == iret) {
            UIImage* img = [UIImage imageWithData:[NSData dataWithBytes:[dataOut bytes] length:[dataOut length]]];
            [cache storeImage:img forKey:key_temp toDisk:YES completion:^{

            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setImage:img];
            });
        } else {
            UIImage* img = [UIImage imageWithData:[NSData dataWithBytes:[picData bytes] length:[picData length]]];
            if (img != nil) {
                [cache storeImage:img forKey:key_temp toDisk:YES completion:^{

                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setImage:img];
                });
            }
        }
    });
}

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
        NSLog(@"DeviceDetails:%s参数错误 %@,%@,%@" ,__FUNCTION__ ,image ,deviceId ,chanelId);
        return;
    }
    SDImageCache* cache = [SDImageCache sharedImageCache];
    NSString* key_temp = [NSString stringWithFormat:@"thumbimg_%@_%@",deviceId,chanelId];
    [cache storeImage:image forKey:key_temp toDisk:YES completion:^{
        NSLog(@"DeviceDetails:%s储存本地封面图成功  %@,%@,%@" ,__FUNCTION__ ,image ,deviceId ,chanelId);
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
            NSLog(@"DeleteDevice:%s本地图片缓存删除成功  %@,%@",__FUNCTION__ ,deviceId,chanelId);
        }];
    }
}

@end
