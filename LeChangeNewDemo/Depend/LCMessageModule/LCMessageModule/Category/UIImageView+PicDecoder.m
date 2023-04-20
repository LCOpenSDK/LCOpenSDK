//
//  UIImageView+PicDecoder.m
//  LCMessageModule
//
//  Created by lei on 2022/10/12.
//

#import "UIImageView+PicDecoder.h"
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_Utils.h>
#import <SDWebImage/SDImageCache.h>
#import <LCNetworkModule/LCApplicationDataManager.h>

@implementation UIImageView (PicDecoder)

- (void)lc_setMessageImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder deviceId:(NSString *)deviceId productId:(NSString *)productId playtoken:(NSString *)playtoken key:(NSString *)key {
    [self setImage:placeholder];
    if (!url || [url isEqualToString:@""]) {
        return;
    }
    SDImageCache* cache = [SDImageCache sharedImageCache];
    NSString* key_temp = [[url componentsSeparatedByString:@"?"] objectAtIndex:0];
    if ([cache diskImageDataExistsWithKey:key_temp]) {
        [self setImage:[cache imageFromDiskCacheForKey:key_temp]];
        return;
    }
    dispatch_queue_t whole_pic_download = dispatch_queue_create("whole_pic_download", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    dispatch_async(whole_pic_download, ^{
        NSURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
        NSHTTPURLResponse* response = nil;
        NSData* picData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:NULL];
        if (response == nil) {
            NSLog(@"download failed");
            return;
        }
        NSData* dataOut = [[NSData alloc] init];
        NSInteger iret = [[LCOpenSDK_Utils new] decryptPic:picData deviceID:deviceId productId:productId key:key playtoken:playtoken bufOut:&dataOut];
        NSLog(@"decrypt iret[%ld]", (long)iret);
        if (0 == iret) {
            UIImage* img = [UIImage imageWithData:[NSData dataWithBytes:[dataOut bytes] length:[dataOut length]]];
            [cache storeImage:img forKey:key_temp toDisk:YES completion:^{

            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setImage:img];
            });
        }
    });
}

@end
