//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "UIImage+Compress.h"

@implementation UIImage (Compress)

- (UIImage *)lc_thumbnailWithImageWithSize:(CGSize)asize {
    UIImage *newimage;
    if (nil == self) {
        newimage = nil;
    }
    else{
        CGSize oldsize = self.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        
        UIGraphicsImageRendererFormat *format = [[UIGraphicsImageRendererFormat alloc] init];
        format.opaque = NO;
        format.scale = 1.0;
        UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:asize format:format];
        newimage = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
            CGContextRef context = rendererContext.CGContext;
            CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
            UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
            [self drawInRect:rect];
        }];
    }
    
    return newimage;
}

@end
