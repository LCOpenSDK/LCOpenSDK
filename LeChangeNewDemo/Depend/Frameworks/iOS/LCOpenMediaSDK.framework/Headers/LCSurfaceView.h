//
//  LCSurfaceView.h
//  LCIphoneAdhocIP
//
//  Created by lei on 2021/1/11.
//  Copyright © 2021 dahua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LCSurfaceView;

@protocol LCSurfaceViewDelegate <NSObject>

- (void)surfaceView:(LCSurfaceView *)surfaceView sizeChanged:(CGSize)size;

@end

@interface LCSurfaceView : UIControl

@property(nonatomic, weak)id<LCSurfaceViewDelegate>delegate;

- (void) setWindowFrame:(CGRect)rect;

- (void) showPlayRender;

- (void) hidePlayRender;

@end

NS_ASSUME_NONNULL_END
