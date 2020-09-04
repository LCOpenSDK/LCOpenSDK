//
//  HintViewController.h
//  LCOpenSDKDemo
//
//  Created by chenjian on 16/7/11.
//  Copyright (c) 2016年 lechange. All rights reserved.
//
#ifndef LCOpenSDKDemo_DeviceViewController_h
#define LCOpenSDKDemo_DeviceViewController_h
#import "DownloadPicture.h"
#import "MyViewController.h"
#import "RestApiService.h"
#import <UIKit/UIKit.h>

#define DEV_BEGIN 1
#define DEV_END 10
#define DEV_NUM_MAX 20
#define DEV_CHANNEL_MAX 16
#define Device_Cell_Width ([[UIScreen mainScreen] bounds].size.width)
#define Device_Cell_Separate 40
#define Device_Cell_Height (Device_Cell_Width * 9 / 16 + Device_Cell_Separate)

@interface DeviceViewController : MyViewController <UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    NSString* m_strSvr;
    NSInteger m_iPort;
    NSInteger m_iProtocol;
    NSString* m_strAppId;
    NSString* m_strAppSecret;
    NSMutableArray* m_devList;
    NSLock* m_devLock;
    UITableView* m_devListView;
    DownloadPicture* m_downloadPicture[DEV_CHANNEL_MAX * DEV_NUM_MAX];
    UIAlertView* alertDelView;
    UIAlertView* alertDecryptView;
    UIActivityIndicatorView* m_progressInd;
    UILabel* m_toastLab;

    NSLock* m_downStatusLock;
    BOOL m_looping;
    NSInteger m_iPos;
    NSInteger m_downloadingPos;

    NSURL* m_httpUrl;
    NSMutableURLRequest* m_req;
    NSURLConnection* m_conn;
}
@property LCOpenSDK_Api* m_hc;
@property NSString* m_accessToken;
@property NSString* m_strDevSelected;
@property NSString* m_encryptKey;
@property NSInteger m_devChnSelected;
@property UIImage* m_imgPicSelected;
@property NSString* m_devAbilitySelected;
@property NSString* m_chnAbilitySelected;
@property NSString* m_playToken;
@property NSString* m_accessType;
@property NSString* m_catalog;

@property (weak, nonatomic) IBOutlet UIImageView* m_imgDeviceNULL;

- (void)setAdminInfo:(NSString*)token protocol:(NSInteger)protocol address:(NSString*)addr port:(NSInteger)port;

- (NSInteger)locateDevKeyIndex:(NSInteger)index;
- (NSInteger)locateDevChannelKeyIndex:(NSInteger)index;
- (void)onBack:(id)sender;
- (void)onLive:(id)sender;
- (void)onCloud:(id)sender;
- (void)onMessage:(id)sender;
- (void)onSetting:(id)sender;
- (void)onVideo:(id)sender;
- (void)onDelete:(id)sender;
- (void)onAddDevice:(id)sender;

- (void)getDevList;

- (void)downloadThread;
- (void)destroyThread;

@end
#endif
