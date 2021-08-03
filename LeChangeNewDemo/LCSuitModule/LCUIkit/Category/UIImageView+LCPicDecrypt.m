//
//  Copyright © 2020 dahua. All rights reserved.
//

#import "UIImageView+LCPicDecrypt.h"
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_Utils.h>
#import <SDWebImage/SDImageCache.h>


@implementation UIImageView (LCPicDecrypt)

-(void)lc_setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder DeviceId:(NSString *)deviceId Key:(NSString *)key{
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
        dispatch_async(dispatch_get_main_queue(), ^{
            NSHTTPURLResponse* response = nil;
            NSData* picData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:NULL];
            if (response == nil) {
                NSLog(@"download failed");
            }
            else {
                NSData* dataOut = [[NSData alloc] init];
                NSInteger iret = [[LCOpenSDK_Utils new] decryptPic:picData deviceID:deviceId key:key bufOut:&dataOut];
                NSLog(@"decrypt iret[%ld]", (long)iret);
                if (0 == iret) {
                    UIImage* img = [UIImage imageWithData:[NSData dataWithBytes:[dataOut bytes] length:[dataOut length]]];
                    [cache storeImage:img forKey:key_temp toDisk:YES completion:^{
                        
                    }];
                    [self setImage:img];
                }
            }
        });
        
    });
}

@end
