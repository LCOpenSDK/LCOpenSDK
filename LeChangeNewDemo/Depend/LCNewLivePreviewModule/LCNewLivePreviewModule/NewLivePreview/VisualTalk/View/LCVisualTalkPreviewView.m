//
//  LCVisualTalkPreviewView.m
//  LCNewLivePreviewModule
//
//  Created by dahua on 2024/3/19.
//

#import "LCVisualTalkPreviewView.h"

@implementation LCVisualTalkPreviewView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialView];
    }
    return self;
}
- (instancetype)init {
    if (self = [super initWithFrame:CGRectZero]) {
        [self initialView];
    }
    return self;
}
- (void)addPreviewLayer:(CALayer *)previewLayer {
    [self.layer addSublayer:previewLayer];
    previewLayer.frame = self.bounds;
    self.previewLayer = previewLayer;
}

-(void) initialView {
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.previewLayer.frame = self.bounds;
}
@end
