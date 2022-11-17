//
//  UIImageView+MediaCircle.m
//  LCMediaBaseModule
//
//  Created by lei on 2022/10/8.
//

#import "UIImageView+MediaCircle.h"
#import <objc/runtime.h>

static const void *UINewImageViewCircleImages = @"UINewImageViewCircleImages";
static const void *UINewImageViewCircleStyle = @"UINewImageViewCircleStyle";
static const void *UINewImageViewCircleTimer = @"UINewImageViewCircleTimer";
static const void *UINewImageViewCircleIndex = @"UINewImageViewCircleIndex";

@implementation UIImageView (MediaCircle)

- (void)loadGifImageWith:(NSArray <NSString *> *)images TimeInterval:(NSTimeInterval)interval Style:(LCMediaIMGCirclePlayStyle)style {
    self.images = images;
    self.style = style;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timeFire:) userInfo:nil repeats:YES];
    [self setImage:[UIImage imageNamed:images[0]]];
}

- (void)timeFire:(NSTimer *)timer {
    
    if (self.style == LCMediaIMGCirclePlayStyleCircle) {
        self.index+=1;
        if (self.index==self.images.count) {
            self.index = 0;
        }
    }else if (self.style == LCMediaIMGCirclePlayStyleOnce){
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
    [self setImage:[UIImage imageNamed:self.images[self.index]]];
}

-(void)releaseImgs{
    [self.timer invalidate];
}

- (NSArray<NSString *> *)images {
    return objc_getAssociatedObject(self, UINewImageViewCircleImages);
}

- (void)setImages:(NSArray<NSString *> *)images {
    objc_setAssociatedObject(self, UINewImageViewCircleImages, images, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LCMediaIMGCirclePlayStyle)style {
    return [objc_getAssociatedObject(self, UINewImageViewCircleStyle) integerValue];
}

- (void)setStyle:(LCMediaIMGCirclePlayStyle)style {
    objc_setAssociatedObject(self, UINewImageViewCircleStyle, @(style), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimer *)timer {
    return objc_getAssociatedObject(self, UINewImageViewCircleTimer);
}

- (void)setTimer:(NSTimer *)timer {
    objc_setAssociatedObject(self, UINewImageViewCircleTimer, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger )index {
    return [objc_getAssociatedObject(self, UINewImageViewCircleIndex) integerValue];
}

- (void)setIndex:(NSUInteger)index {
    objc_setAssociatedObject(self, UINewImageViewCircleIndex, @(index), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
