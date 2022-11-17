//
//  Copyright © 2015 Imou. All rights reserved.
//

#import <LCBaseModule/LCImageLoaderManager.h>
#import <SDWebImage/SDWebImage.h>
#import <LCBaseModule/UIImage+LCGIF.h>

#define PATH_TO_STORE_IMAGE [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@implementation LCImageLoaderManager

+ (UIImage *)getImageFromCache:(NSString *)path {
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [UIImage imageWithData:data];
}

+ (NSString *)getImageCachePath:(NSString *)name {
    NSMutableString *key = [NSMutableString string];
    
    NSArray *array1 = [name componentsSeparatedByString:@"?"];
    NSString *substring = [array1 firstObject];
    
    NSArray *array2 = [substring componentsSeparatedByString:@":"];
    NSString *newName = [[array2 lastObject] stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    [key appendFormat:@"cache_%@",newName];
    
    NSString *path = [PATH_TO_STORE_IMAGE stringByAppendingPathComponent:key];
    return path;
}

+ (NSString *)getImageCacheKey:(NSString *)url
{
    NSMutableString *key = [NSMutableString string];
    
    NSArray *array1 = [url componentsSeparatedByString:@"?"];
    NSString *tempUrl = [array1 firstObject];
    
    NSArray *array2 = [tempUrl componentsSeparatedByString:@":"];
    NSString *newName = [[array2 lastObject] stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    [key appendFormat:@"cache_%@",newName];
    
    return key;
}

+ (void)saveDataToFile:(NSString *)path data:(NSData*)data{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    }
    
    @try {
        [data writeToFile:path atomically:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"image fail to save");
    }
}

@end
