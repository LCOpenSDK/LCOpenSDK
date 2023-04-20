//
//  Copyright © 2019 Imou. All rights reserved.
//

#import "UIImage+LCGIF.h"
#import <SDWebImage/SDWebImage.h>

@implementation UIImage (LCGIF)

- (BOOL)lc_writeToFileAtPath:(NSString*)aPath
{
    if ((self == nil) || (aPath == nil) || ([aPath isEqualToString:@""]))
        return NO;

    @try
    {
        NSData *imageData = nil;
        NSString *ext = [aPath pathExtension];
        if ([ext isEqualToString:@"png"])
        {
            imageData = UIImagePNGRepresentation(self);
        }
        else if ([ext isEqualToString:@"gif"])
        {
            imageData = [self sd_imageDataAsFormat:SDImageFormatGIF];
        }
        else
        {
            imageData = UIImageJPEGRepresentation(self, 1);
        }
        
        if ((imageData == nil) || ([imageData length] <= 0))
            return NO;
        
        [imageData writeToFile:aPath atomically:YES];
        
        return YES;
    }
    @catch (NSException *e)
    {
        NSLog(@"create thumbnail exception.");
    }
    
    return NO;
}

+ (UIImage *)lc_imageAutoWithData:(NSData *)data
{
    //判断data是否是gif格式，然后做对应读取data
    SDImageFormat type = [NSData sd_imageFormatForImageData:data];
    if (type == SDImageFormatGIF) {
        return [UIImage sd_imageWithGIFData:data];
    } else {
        return [UIImage imageWithData:data];
    }
}

+ (UIImage *)lc_imageAutoWithPath:(NSString *)path
{
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [self lc_imageAutoWithData:data];
}

+ (BOOL)lc_isGIFFromUrl:(nullable NSString *)url
{
    if (url == nil) {
//#if DEBUG
//        @throw [NSException exceptionWithName:@"崩溃" reason:@"crush's reason：当前url为空" userInfo:nil];
//#else
//        NSLog(@"========== 当前url为空 ==========");
//#endif
        return NO;
    } else {
        //这种转data很耗性能
//        NSURL *curURL = [NSURL URLWithString:url];
//        NSData * data = [NSData dataWithContentsOfURL:curURL];
//        SDImageFormat type = [NSData sd_imageFormatForImageData:data];
//        if (type == SDImageFormatGIF) {
        NSString *typeStr = [[NSURL URLWithString:url] pathExtension];
        if ([typeStr isEqualToString:@"gif"] || [typeStr isEqualToString:@"GIF"]) {
            return YES;
        } else {
            return NO;
        }
    }
}

@end
