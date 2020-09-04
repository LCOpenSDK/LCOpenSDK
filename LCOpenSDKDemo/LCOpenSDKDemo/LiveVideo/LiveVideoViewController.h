//
//  LiveVideoViewController.h
//  LCOpenSDKDemo
//
//  Created by mac318340418 on 16/7/13.
//  Copyright © 2016年 lechange. All rights reserved.
//

#import "DeviceViewController.h"
#import "MyViewController.h"
#import <UIKit/UIKit.h>

#define RTSP_Result_String(enum) [@[ @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"99", @"100" ] objectAtIndex:enum]

typedef NS_ENUM(NSInteger, ProgressIndType) {
    VIDEO_PROGRESS_IND = 0,
    TALK_PROGRESS_IND = 1
};

@interface LiveVideoViewController : MyViewController <LCOpenSDK_EventListener> {
    LCOpenSDK_PlayWindow* m_play;
    LCOpenSDK_AudioTalk* m_talker;
    UIImageView* m_screenImg;
    UIButton* m_replayBtn;
    UIView* livePlayBarView;
    UIButton* m_HDBtn;
    UIButton* m_PTZBtn;
    UIButton* m_fullScreenBtn;
    UIButton* m_soundBtn;
    UIButton* m_snapBtn;
    UIButton* m_talkBtn;
    UIButton* m_recordBtn;
    UILabel* m_tipLab;
    CAGradientLayer *m_topLayer;
    CAGradientLayer *m_bottomLayer;
    CAGradientLayer *m_leftLayer;
    CAGradientLayer *m_rightLayer;

    NSString* m_accessToken;
    NSString* m_strDevSelected;
    NSString* m_encryptKey;
    NSInteger m_devChnSelected;
    UIImage* m_imgPicSelected;
    NSString* m_devAbilitySelected;
    NSString* m_chnAbilitySelected;
    NSString* m_playToken;
    NSString* m_accessType;
    NSString* m_catalog;
    

    UIActivityIndicatorView* m_videoProgressInd;
    UIActivityIndicatorView* m_talkProgressInd;
}

- (void)setInfo:(NSString*)token Dev:(NSString*)deviceId Key:(NSString*)key Chn:(NSInteger)chn Img:(UIImage*)img Abl:(NSString*)abl chnAbl:(NSString*)chnAbl playToken:(NSString *)playToken accessType:(NSString *)accessType catalog:(NSString *)catalog;
- (void)onPlayerResult:(NSString*)code Type:(NSInteger)type Index:(NSInteger)index;
- (void)onPlayBegan:(NSInteger)index;
- (void)onReceiveData:(NSInteger)len Index:(NSInteger)index;
- (void)onStreamCallback:(NSData*)data Index:(NSInteger)index;
- (void)onTalkResult:(NSString*)error TYPE:(NSInteger)type;
- (void)onControlClick:(CGFloat)currentX dy:(CGFloat)currentY Index:(NSInteger)index;
- (void)onWindowDBClick:(CGFloat)currentX dy:(CGFloat)currentY Index:(NSInteger)index;
- (void)onWindowLongPressBegin:(Direction)dir dx:(CGFloat)currentX dy:(CGFloat)currentY Index:(NSInteger)index;
- (void)onWindowLongPressEnd:(NSInteger)index;
- (void)onSlipBegin:(Direction)dir dx:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index;
- (void)onSlipping:(Direction)dir preX:(CGFloat)preX preY:(CGFloat)preY dx:(CGFloat)currentX dy:(CGFloat)currentY Index:(NSInteger)index;
- (void)onSlipEnd:(Direction)dir dx:(CGFloat)currentX dy:(CGFloat)currentY Index:(NSInteger)index;
- (void)onZooming:(CGFloat)scale Index:(NSInteger)index;
- (void)onZoomEnd:(ZoomType)zoom Index:(NSInteger)index;

- (void)onActive:(id)sender;
- (void)onResignActive:(id)sender;

@end
