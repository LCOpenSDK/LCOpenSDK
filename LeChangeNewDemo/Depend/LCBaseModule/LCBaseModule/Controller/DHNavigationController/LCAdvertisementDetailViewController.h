//
//  LCAdvertisementDetailViewController.h
//  LCIphone
//  Owned by peng_qitao on 16/09/20.
//  Created by zhangyp on 16/6/21.
//  Copyright © 2016年 dahua. All rights reserved.
//

#import <DHBaseModule/LCWebViewController.h>
#import <LCSheetView/LCSheetView.h>
#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>

@class LCAdvertisementDetailViewController;
@protocol LCAdvertisementDetailViewControllerDelegate <NSObject>
- (void)dismissAdvertisementDetailViewController:(LCAdvertisementDetailViewController *)vc;
@end

@interface LCAdvertisementDetailViewController : LCWebViewController

@property (nonatomic, strong) NSString *curDeviceID;
@property (nonatomic, strong) NSString *curChannelID;
@property (nonatomic, strong) NSString *curApID;
@property (nonatomic, assign) BOOL isShowShareButton;
@property (nonatomic, copy) NSString *animationTypeStr;                 //动画样式
@property (weak, nonatomic)id<LCAdvertisementDetailViewControllerDelegate> delegate;
//@property (nonatomic, copy) NSString * shareTitle;//广告标题
@property (nonatomic, strong) NSString *templateParam;

/// 是否禁用锁屏
@property (nonatomic, assign) BOOL  disableLockScreen;
//是否通过openPage打开
@property (nonatomic, assign) BOOL isOpenPage;
@end
