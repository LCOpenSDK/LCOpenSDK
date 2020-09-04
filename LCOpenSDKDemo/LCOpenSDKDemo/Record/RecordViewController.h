//
//  LocalRecordViewController.h
//  lechangeDemo
//
//  Created by mac318340418 on 16/7/11.
//  Copyright © 2016年 dh-Test. All rights reserved.
//
#import "LCOpenSDK_DownloadListener.h"
#import "DeviceViewController.h"
#import "MyViewController.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RecordType) {
    DeviceRecord = 0,
    CloudRecord = 1
};

@interface RecordViewController : MyViewController<LCOpenSDK_DownloadListener> {
    UIActivityIndicatorView* m_progressInd;
    UILabel* m_toastLab;
    NSString* m_accessToken;
    NSString* m_playToken;
    NSString* m_strDevSelected;
    NSString* m_encryptKey;
    NSString* m_accessType;
    NSInteger m_devChnSelected;
    RecordType m_recordType;
    NSString* m_strRecSelected;
    NSString* m_strRecRegSelected;
    NSString* m_beginTimeSelected;
    NSString* m_endTimeSelected;
    UIImage* m_imgPicSelected;
    
}

@property (weak, nonatomic) IBOutlet UIView* m_viewDateBar;
@property (weak, nonatomic) IBOutlet UIButton *m_dateCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *m_dateSelectBtn;
@property (weak, nonatomic) IBOutlet UILabel *m_dateLab;
@property (weak, nonatomic) IBOutlet UIDatePicker* m_datePicker;
@property (weak, nonatomic) IBOutlet UIImageView* m_ImgRecordNull;

- (void)setInfo:(NSString*)token playToken:(NSString *)playToken Dev:(NSString*)deviceId Key:(NSString*)key Chn:(NSInteger)chn Type:(RecordType)type  accessType:(NSString*)accessType;
- (void)downloadThread;
- (void)destroyThread;
- (void)onDownloadReceiveData:(NSInteger)index datalen:(NSInteger)datalen;
- (void)onDownloadState:(NSInteger)index code:(NSString*)code type:(NSInteger)type;
@end
