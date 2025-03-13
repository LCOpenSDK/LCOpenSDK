//
//  LCNewLandscapeControlView+Gesture.m
//  LeChangeDemo
//
//  Created by jiangbin on 2021/7/23.
//  Copyright © 2021 Imou. All rights reserved.
//

#import "LCNewLandscapeControlView+Gesture.h"
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_PlayWindow.h>

#define TAG_PTZ_PAN        1687
#define TAG_PTZ_PINCH      1689
#define ANIMATION_DURATION 0.3

@implementation LCNewLandscapeControlView(Gesture)

//- (void)addTheGestureRecognizer {
//    //单击
//    UITapGestureRecognizer *click = [self click];
//    [click addTarget:self action:@selector(doSingleTap:)];
//    [click setNumberOfTapsRequired:1];
//    [self addGestureRecognizer:click];
//    
//    //双击
//    UITapGestureRecognizer *doubleClick = [self doubleClick];
//    [doubleClick addTarget:self action:@selector(doDoubleTap:)];
//    [doubleClick setNumberOfTapsRequired:2];
//    [self addGestureRecognizer:doubleClick];
//    
//    //长按
//    UILongPressGestureRecognizer *longPress = [self longPress];
//    [longPress addTarget:self action:@selector(doLongPress:)];
//    [self addGestureRecognizer:longPress];
//    
//    [click requireGestureRecognizerToFail:doubleClick];
//    
//    //滑动
//    UIPanGestureRecognizer *pan = [self pan];
//    [pan addTarget:self action:@selector(doPan:)];
//    [pan setMinimumNumberOfTouches:1];
//    [pan setMaximumNumberOfTouches:5];
//    
//    //缩放
//    UIPinchGestureRecognizer *pinch = [self pinch];
//    [pinch addTarget:self action:@selector(doPinch:)];
//}
//
//- (void)removeAllGestureRecognizer {
//    for (UIGestureRecognizer *gestureRecognizer in [self gestureRecognizers]) {
//        [self removeGestureRecognizer:gestureRecognizer];
//    }
//}
//
//// 滑动手势
//- (void)setPanEnable:(BOOL)isEnable {
//    UIPanGestureRecognizer *pan = [self pan];
//    
//    if (isEnable) {
//        //恢复电子放大
//        [self endEZoom];
//        [self addGestureRecognizer:pan];
//    } else {
//        [self removeGestureRecognizer:pan];
//    }
//}
//
//// 缩放手势
//- (void)setPinchEnable:(BOOL)isEnable {
//    UIPinchGestureRecognizer *pinch = [self pinch];
//    
//    if (isEnable) {
//        [self addGestureRecognizer:pinch];
//    }else {
//        [self removeGestureRecognizer:pinch];
//    }
//}
//
////单击击手势是否可用
//- (void)setClickEnable:(BOOL)isEnable {
//    
//    UITapGestureRecognizer *click = [self click];
//    
//    if (isEnable) {
//        [self addGestureRecognizer:click];
//    }else {
//        [self removeGestureRecognizer:click];
//    }
//}
//
////双击手势是否可用
//- (void)setDoubleClickEnable:(BOOL)isEnable {
//    
//    UITapGestureRecognizer *doubleClick = [self doubleClick];
//    
//    if (isEnable) {
//        [self addGestureRecognizer:doubleClick];
//    }else {
//        [self removeGestureRecognizer:doubleClick];
//    }
//}
//
////长按手势是否可用
//- (void)setLongPressEnable:(BOOL)isEnable {
//    
//    UILongPressGestureRecognizer *longPress = [self longPress];
//    
//    if (isEnable) {
//        [self addGestureRecognizer:longPress];
//    }else {
//        [self removeGestureRecognizer:longPress];
//    }
//}
//
//
//#pragma mark - 单击
//- (void)doSingleTap:(UITapGestureRecognizer *)recognizer {
////    if (self.presenter.subPlayWindow != nil) {
////        UIView *subPlayView = [self.presenter.subPlayWindow getWindowView];
////        UIView *mainPlayView = [self.presenter.playWindow getWindowView];
////        UIView *responsePlayView = subPlayView;
////        if (subPlayView.frame.size.width > mainPlayView.frame.size.width) {
////            responsePlayView = mainPlayView;
////        }
////        CGPoint point2 = [recognizer locationInView:responsePlayView];
////        if (point2.x >= 0 && point2.x <= responsePlayView.frame.size.width && point2.y >= 0 && point2.y <= responsePlayView.frame.size.height) {
////            if ([[LCNewDeviceVideoManager shareInstance].displayChannelID isEqualToString:@"0"]) {
////                [LCNewDeviceVideoManager shareInstance].displayChannelID = @"1";
////            } else {
////                [LCNewDeviceVideoManager shareInstance].displayChannelID = @"0";
////            }
////            return;
////        }
////    }
//    [self changeAlpha];
//}
//
//#pragma mark - 双击
//
//- (void)doDoubleTap:(UITapGestureRecognizer*)recognizer {
//    if ([self isEZooming]) {
//        //电子放大时，双击结束电子放大
//        [self endEZoom];
//        [self setPanEnable:NO];
//    }
//}
//
//#pragma mark - 长按
//
//- (void)doLongPress:(UILongPressGestureRecognizer*)recognizer {
//    
//}
//
//#pragma mark - 滑动
//- (void)doPan:(UIPanGestureRecognizer*)recognizer {
//
//    if (recognizer.state == UIGestureRecognizerStateChanged) {
//        CGPoint endPoint = [recognizer translationInView:self];
//        
//        CGFloat offX = endPoint.x;
//        CGFloat offY = endPoint.y;
//        
//        LCOpenSDK_PlayWindow *player = [self getThePlayer];
//        [player doTranslateX:offX Y:offY];
//    }
//}
//
//- (CGFloat)absFloat:(CGFloat)value{
//    return value > 0 ? value : - value;
//}
//
//#pragma mark - 缩放
//
//- (void)doPinch:(UIPinchGestureRecognizer*)recognizer {
//    //电子放大
//    [self doPinchEZoomScale:recognizer];
//}
//
//- (void)doPinchEZoomScale:(UIPinchGestureRecognizer*)recognizer {
//    
//    if (recognizer.state == UIGestureRecognizerStateBegan) {
//        
//    }else if (recognizer.state == UIGestureRecognizerStateChanged) {
//        
//        [self onPinchEZoomScale:recognizer.scale];
//        
//    }else if (recognizer.state == UIGestureRecognizerStateEnded) {
//        
//    }
//}
//
//#pragma mark - KVC
//
//- (UITapGestureRecognizer *)click {
//    // todo: kvc
//    UITapGestureRecognizer *click = [self valueForKey:@"clickGesture"];
//    return click;
//}
//
//- (UITapGestureRecognizer *)doubleClick {
//    UITapGestureRecognizer *doubleClick = [self valueForKey:@"doubleClickGesture"];
//    return doubleClick;
//}
//
//- (UILongPressGestureRecognizer *)longPress {
//    UILongPressGestureRecognizer *longPress = [self valueForKey:@"longPressGesture"];
//    longPress.enabled = false;
//    return longPress;
//}
//
//- (UIPanGestureRecognizer *)pan {
//    UIPanGestureRecognizer *pan = [self valueForKey:@"panGesture"];
//    return pan;
//}
//
//- (UIPinchGestureRecognizer *)pinch {
//    UIPinchGestureRecognizer *pinch = [self valueForKey:@"pinchGesture"];
//    return pinch;
//}
//
////MARK: - 电子放大
//- (void)onPinchEZoomScale:(CGFloat)scale;
//{
//    double zoomScale = 1.0;
//    
//    if (scale > 1.1) {
//        zoomScale = 1.03;
//    } else if (scale < 0.9) {
//        zoomScale = 0.97;
//    }
//    
//    LCOpenMediaLivePlugin *player = [self getThePlayer];
////    [player doScale:zoomScale];
//    
//    //电子放大后可以拖动视图
//    [self setPanEZoomEnable:YES];
//}
//
//- (void)setPanEZoomEnable:(BOOL)isEnable {
//    
//    UIPanGestureRecognizer *pan = [self pan];
//    
//    if (isEnable) {
//        [self addGestureRecognizer:pan];
//    }else {
//        [self removeGestureRecognizer:pan];
//    }
//}
//
//
//- (void)endEZoom {
//    [[self getThePlayer] recoverEZooms];
//}
//
//- (BOOL)isEZooming {
//    CGFloat scale = [[self getThePlayer] getEZoomScaleWithCid: [LCNewDeviceVideoManager shareInstance].displayChannelID.intValue];
//    return scale != -1 && scale != 1;
//}
//
//- (LCOpenMediaLivePlugin *)getThePlayer {
//    return self.presenter.livePlugin;
//}
@end

