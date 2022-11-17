//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "UIImageView+Circle.h"
#import <objc/runtime.h>

static const void *UIImageViewCircleImages = @"UIImageViewCircleImages";
static const void *UIImageViewCircleStyle = @"UIImageViewCircleStyle";
static const void *UIImageViewCircleTimer = @"UIImageViewCircleTimer";
static const void *UIImageViewCircleIndex = @"UIImageViewCircleIndex";

@implementation UIImageView (Circle)

- (void)loadGifImageWith:(NSArray <NSString *> *)images TimeInterval:(NSTimeInterval)interval Style:(LCIMGCirclePlayStyle)style {
    self.images = images;
    self.style = style;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timeFire:) userInfo:nil repeats:YES];
    [self setImage:LC_IMAGENAMED(images[0])];
}

- (void)timeFire:(NSTimer *)timer {
    
    if (self.style == LCIMGCirclePlayStyleCircle) {
        self.index+=1;
        if (self.index==self.images.count) {
            self.index = 0;
        }
    }else if (self.style == LCIMGCirclePlayStyleOnce){
        self.index+=1;
        if (self.index==self.images.count) {
            [self releaseImgs];
        }
    }else{
       if (self.index==self.images.count) {
           self.index-=1;
        }
        if (self.index==0) {
            self.index+=1;
        }
    }
    [self setImage:LC_IMAGENAMED(self.images[self.index])];
}

-(void)releaseImgs{
    [self.timer invalidate];
}

- (NSArray<NSString *> *)images {
    return objc_getAssociatedObject(self, UIImageViewCircleImages);
}

- (void)setImages:(NSArray<NSString *> *)images {
    objc_setAssociatedObject(self, UIImageViewCircleImages, images, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LCIMGCirclePlayStyle)style {
    return [objc_getAssociatedObject(self, UIImageViewCircleStyle) integerValue];
}

- (void)setStyle:(LCIMGCirclePlayStyle)style {
    objc_setAssociatedObject(self, UIImageViewCircleStyle, @(style), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimer *)timer {
    return objc_getAssociatedObject(self, UIImageViewCircleTimer);
}

- (void)setTimer:(NSTimer *)timer {
    objc_setAssociatedObject(self, UIImageViewCircleTimer, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger )index {
    return [objc_getAssociatedObject(self, UIImageViewCircleIndex) integerValue];
}

- (void)setIndex:(NSUInteger)index {
    objc_setAssociatedObject(self, UIImageViewCircleIndex, @(index), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
