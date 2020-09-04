//
//  LocalRecordViewController.m
//  lechangeDemo
//
//  Created by mac318340418 on 16/7/11.
//  Copyright © 2016年 dh-Test. All rights reserved.
//

#import "LCOpenSDK_Prefix.h"
#import "DownloadPicture.h"
#import "RecordPlayViewController.h"
#import "RecordViewController.h"
#import "RestApiService.h"
#import "LocalPlayViewController.h"

#import "PHAsset+Lechange.h"

#define RECORD_NUM_MAX 10

@interface RecordViewController () {
    LCOpenSDK_Utils* m_util;
    LCOpenSDK_Download* m_download;
    NSString* m_downloadPath;
    int64_t m_totalDataSize[RECORD_NUM_MAX];
    int64_t m_receiveDataSize[RECORD_NUM_MAX];
    BOOL m_isCloudDownload[RECORD_NUM_MAX];
    NSInteger m_index; /**Ch:正在下载的index，用于限制下载数目为1 En:The index being downloaded, used to limit the number of downloads to 1.*/

    CGFloat m_cellWidth;
    CGFloat m_cellHeight;
    CGFloat m_separatorHeight;
    NSMutableArray* m_recInfo;
    DownloadPicture* m_downloadPicture[RECORD_NUM_MAX];
    NSString* m_dateSelected;
    NSLock* m_listViewLock;
    UITableView* m_listView;
    BOOL m_isStarting;

    NSLock* m_recInfoLock;
    NSLock* m_downStatusLock;
    BOOL m_looping;
    NSInteger m_iPos;
    NSInteger m_downloadingPos;

    NSURL* m_httpUrl;
    NSMutableURLRequest* m_req;
    NSURLConnection* m_conn;

    NSInteger m_interval;
    NSTimer* m_timer;
    NSMutableSet* m_downloadSet;

    UIButton* m_right;
}

@end

@implementation RecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initWindow];
    [self initDatePicker];

    UINavigationItem* item;
    if (m_recordType == DeviceRecord) {
        item = [[UINavigationItem alloc] initWithTitle:NSLocalizedString(LOCAL_RECORD_TITLE_TXT, nil)];
    }
    else if (m_recordType == CloudRecord) {
        item = [[UINavigationItem alloc] initWithTitle:NSLocalizedString(NET_RECORD_TITLE_TXT, nil)];
    }

    UIButton* left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(0, 0, 50, 30)];

    [left setBackgroundImage:[UIImage leChangeImageNamed:Back_Btn_Png] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc] initWithCustomView:left];
    [item setLeftBarButtonItem:leftBtn animated:NO];

    m_right = [UIButton buttonWithType:UIButtonTypeCustom];
    [m_right setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 5 - 40, 0, 50, 30)];

    [m_right setBackgroundImage:[UIImage leChangeImageNamed:Search_Icon_Png] forState:UIControlStateNormal];
    [m_right addTarget:self action:@selector(onSearch) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc] initWithCustomView:m_right];
    [item setRightBarButtonItem:rightBtn animated:NO];

    [super.m_navigationBar pushNavigationItem:item animated:NO];

    [self.view addSubview:super.m_navigationBar];
    
    [self.m_dateCancelBtn setTitle:NSLocalizedString(DATE_CANCEL_TXT, nil) forState:UIControlStateNormal];
    [self.m_dateSelectBtn setTitle:NSLocalizedString(DATE_QUERY_TXT, nil) forState:UIControlStateNormal];
    [self.m_dateLab setText:NSLocalizedString(DATE_TIP_TXT, nil)];
  
    m_listView = [[UITableView alloc] initWithFrame:CGRectMake(0, super.m_yOffset, self.view.frame.size.width,
                                                        self.view.frame.size.height - super.m_yOffset)];
    m_listView.delegate = (id<UITableViewDelegate>)self;
    m_listView.dataSource = (id<UITableViewDataSource>)self;
    m_listView.backgroundColor = [UIColor clearColor];
    m_listView.separatorColor = [UIColor clearColor];
    m_listView.allowsSelection = YES;
    [self.view addSubview:m_listView];

    m_progressInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    m_progressInd.transform = CGAffineTransformMakeScale(2.0, 2.0);
    m_progressInd.center = CGPointMake(self.view.center.x, self.view.center.y);
    [self.view addSubview:m_progressInd];

    m_toastLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    m_toastLab.center = self.view.center;
    m_toastLab.backgroundColor = [UIColor whiteColor];
    m_toastLab.textAlignment = NSTextAlignmentCenter;
    m_toastLab.hidden = YES;
    [self.view addSubview:m_toastLab];

    m_recInfo = [[NSMutableArray alloc] init];
    m_util = [[LCOpenSDK_Utils alloc] init];

    [self.view bringSubviewToFront:self.m_viewDateBar];
    [self.view bringSubviewToFront:m_toastLab];
    [self.view bringSubviewToFront:m_progressInd];

    [self.m_ImgRecordNull setImage:[UIImage leChangeImageNamed:Video_None_Png]];
    for (int i = 0; i < RECORD_NUM_MAX; i++) {
        m_downloadPicture[i] = [[DownloadPicture alloc] init];
    }
    m_index = -1;
    m_iPos = 0;
    m_downloadingPos = -1;

    m_listViewLock = [[NSLock alloc] init];
    m_downStatusLock = [[NSLock alloc] init];
    m_recInfoLock = [[NSLock alloc] init];
    m_looping = YES;
    m_conn = nil;
    m_downloadSet = [[NSMutableSet alloc] init];
    m_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onSmsTimer:) userInfo:nil repeats:YES];

    m_download = [LCOpenSDK_Download shareMyInstance];
    [m_download setListener:(id<LCOpenSDK_DownloadListener>)self];

    [self getRecords];

    dispatch_queue_t downQueue = dispatch_queue_create("cloudThumbnailDown", nil);
    dispatch_async(downQueue, ^{
        [self downloadThread];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setInfo:(NSString*)token playToken:(NSString *)playToken Dev:(NSString*)deviceId Key:(NSString*)key Chn:(NSInteger)chn Type:(RecordType)type  accessType:(NSString*)accessType;
{
    m_accessToken = [token mutableCopy];
    m_strDevSelected = [deviceId mutableCopy];
    m_encryptKey = [key mutableCopy];
    m_devChnSelected = chn;
    m_recordType = type;
    m_playToken = [playToken copy];
    m_accessType = [accessType copy];
}

- (NSString*)timeTransformFormatter:(NSString*)time
{
    NSString* regex = @"[1-9]\\d{3}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}";
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![pred evaluateWithObject:time]) {
        NSLog(@"Time format error:%@", time);
        return nil;
    }
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date = [formatter dateFromString:time];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString* retTime = [formatter stringFromDate:date];
    return [retTime substringFromIndex:2];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    self.m_ImgRecordNull.hidden = (0 == m_recInfo.count && m_isStarting) ? NO : YES;

    NSInteger iCount = 0;
    [m_recInfoLock lock];
    iCount = m_recInfo.count;
    [m_recInfoLock unlock];
    return iCount;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return m_cellHeight;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellIdentifier = @"Cell";

    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    [m_recInfoLock lock];
    if ([indexPath row] >= m_recInfo.count) {
        NSLog(@"RecordViewController cellForRowAtIndexPath not valid,row[%ld],count[%lu]", (long)[indexPath row], (unsigned long)m_recInfo.count);
        [m_recInfoLock unlock];
        return cell;
    }
    NSString* beginTime = ((RecordInfo*)[m_recInfo objectAtIndex:[indexPath row]])->beginTime;
    NSString* endTime = ((RecordInfo*)[m_recInfo objectAtIndex:[indexPath row]])->endTime;
    [m_recInfoLock unlock];

    UIImage* imgPic = nil;

    if (nil != m_downloadPicture[[indexPath row]].picData) {
        imgPic = [UIImage imageWithData:m_downloadPicture[[indexPath row]].picData];
        NSLog(@"cell[%ld] decrypt imgPic %@", (long)[indexPath row], (imgPic ? @"successfully" : @"failed"));
        if (!imgPic) {
             imgPic = [UIImage leChangeImageNamed:DefaultCover_Png];
        }
    }
    else {
        imgPic = [UIImage leChangeImageNamed:DefaultCover_Png];
        NSLog(@"cell[%ld] default imgPic", (long)[indexPath row]);
    }
    UIImageView* imgPicView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (m_cellHeight)*16.0 / 9, m_cellHeight)];
    [imgPicView setImage:imgPic];
    [cell addSubview:imgPicView];

    UIImageView* mImgBar = [[UIImageView alloc] initWithImage:
                            [UIImage leChangeImageNamed:Toast_Png]];
    mImgBar.frame = CGRectMake(-50, m_cellHeight - m_separatorHeight - 30, m_cellWidth + 100, 30);
    [mImgBar setContentMode:UIViewContentModeScaleAspectFill];
    mImgBar.clipsToBounds = YES;
    [cell addSubview:mImgBar];
    UILabel* dateLab = [[UILabel alloc] initWithFrame:CGRectMake(10, m_cellHeight - m_separatorHeight - 30, m_cellWidth - 10 - 2 * 30, 30)];
    dateLab.text = [NSString stringWithFormat:@"%@—%@", [self timeTransformFormatter:beginTime], [self timeTransformFormatter:endTime]];
    dateLab.backgroundColor = [UIColor clearColor];
    dateLab.textColor = [UIColor whiteColor];
    [dateLab setFont:[UIFont systemFontOfSize:13.0f]];
    [cell addSubview:dateLab];

    UIView* additionalSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, m_cellHeight - m_separatorHeight, m_cellWidth, m_separatorHeight)];
    additionalSeparator.backgroundColor = [UIColor whiteColor];
    [cell addSubview:additionalSeparator];
    if (m_totalDataSize[[indexPath row]] != 0) {
        double rate = 1.0 * m_receiveDataSize[[indexPath row]] / m_totalDataSize[[indexPath row]];
        rate = rate > 1.0 ? 1.0 : rate;
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(m_cellWidth - 60, m_cellHeight - m_separatorHeight - 30 + 2.5, rate * 2 * (30 - 5), 30 - 5)];
        label.backgroundColor = [UIColor greenColor];
        [cell addSubview:label];
    }
    UIButton* downloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(m_cellWidth - 60, m_cellHeight - m_separatorHeight - 30 + 2.5, 2 * (30 - 5), 30 - 5)];
    if (m_isCloudDownload[[indexPath row]]) {
        [downloadBtn setBackgroundImage:[UIImage leChangeImageNamed:Video_Download_Cancel_Png] forState:UIControlStateNormal];
    }
    else {
        [downloadBtn setBackgroundImage:[UIImage leChangeImageNamed:Video_Download_Png] forState:UIControlStateNormal];
    }
    downloadBtn.tag = [indexPath row];
    [downloadBtn addTarget:self action:@selector(onDownload:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:downloadBtn];
    [cell bringSubviewToFront:downloadBtn];
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [m_recInfoLock lock];
    if ([indexPath row] >= m_recInfo.count) {
        NSLog(@"tableView indexPath[%ld],m_recInfo[%lu]", (long)[indexPath row], (unsigned long)m_recInfo.count);
        [m_recInfoLock unlock];
        return;
    }
    if (m_recordType == DeviceRecord)

    {
        m_strRecSelected = ((RecordInfo*)[m_recInfo objectAtIndex:[indexPath row]])->name;
    }
    else if (m_recordType == CloudRecord) {
        /**
         Ch:处于下载状态，不允许播放云录像
         En:It is in the downloading state, and cloud recording is not allowed.
         */
        if (-1 != m_index) {
            [m_recInfoLock unlock];
            [self showDownloadToast:DOWNLOADING];
            return;
        }
        m_strRecSelected = ((RecordInfo*)[m_recInfo objectAtIndex:[indexPath row]])->recId;
    }
    m_strRecRegSelected = ((RecordInfo*)[m_recInfo objectAtIndex:[indexPath row]])->recRegId;
    m_beginTimeSelected = ((RecordInfo*)[m_recInfo objectAtIndex:[indexPath row]])->beginTime;
    m_endTimeSelected = ((RecordInfo*)[m_recInfo objectAtIndex:[indexPath row]])->endTime;
    m_imgPicSelected = [UIImage imageWithData:m_downloadPicture[[indexPath row]].picData];

    [m_recInfoLock unlock];
    UIStoryboard* currentBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RecordPlayViewController* recordPlayView = [currentBoard instantiateViewControllerWithIdentifier:@"RecordPlay"];
    [recordPlayView setInfo:m_accessToken PlayToken:m_playToken Dev:m_strDevSelected Key:m_encryptKey Chn:m_devChnSelected Type:m_recordType accessType:m_accessType];
    [recordPlayView setRecInfo:m_strRecSelected RecReg:m_strRecRegSelected Begin:m_beginTimeSelected End:m_endTimeSelected Img:m_imgPicSelected];
    [self.navigationController pushViewController:recordPlayView animated:NO];
}

- (void)initWindow
{
    m_separatorHeight = 5;
    m_cellWidth = [UIScreen mainScreen].bounds.size.width;
    m_cellHeight = m_cellWidth * 9 / 16 + m_separatorHeight;
    self.m_viewDateBar.hidden = YES;
    m_isStarting = NO;
}

- (void)initDatePicker
{
    
    self.m_datePicker.locale = [NSLocale localeWithLocaleIdentifier:NSLocalizedString(LANGUAGE_TXT, nil)];
    self.m_datePicker.datePickerMode = UIDatePickerModeDate;
    [self.m_datePicker addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
}

- (void)valueChange:(UIDatePicker*)datePicker
{
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString* dateStr = [fmt stringFromDate:datePicker.date];
    m_dateSelected = dateStr;
}

- (void)cancelBtn:(id)sender
{
    self.m_viewDateBar.hidden = YES;
}

- (void)inquireBtn:(id)sender
{
    for (NSString* obj in m_downloadSet) {
        NSInteger index = [obj intValue];
        [m_download stopDownload:index];
        m_isCloudDownload[index] = NO;
        m_receiveDataSize[index] = 0;
        [m_downloadSet removeObject:[NSString stringWithFormat:@"%ld", (long)index]];
        m_index = -1;
    }
    [m_downStatusLock lock];
    for (int i = 0; i < RECORD_NUM_MAX; i++) {
        [m_downloadPicture[i] clearData];
    }
    m_iPos = 0;
    m_downloadingPos = -1;
    m_conn = nil;
    [m_downStatusLock unlock];

    self.m_viewDateBar.hidden = YES;
    [m_listViewLock lock];
    m_listView.hidden = YES;
    self.m_ImgRecordNull.hidden = YES;
    [m_listViewLock unlock];

    [self getRecords];
}

- (void)onSearch
{
    self.m_viewDateBar.hidden = NO;
}

- (void)onDownload:(UIButton*)sender
{
    NSLog(@"RecordPlayViewController onDownload");
    /**
     *  管理标志符(En:Management identifier)
     *  m_index == -1, 下载任务未开始(En:Download task did not start)
     *  m_index != -1, 下载任务已开启，不再开启下载任务(En:Download task has been opened, download task is no longer open)
     */
    if (m_index != -1 && m_index != sender.tag) {
        [self showDownloadToast:DOWNLOADING];
        return;
    }
    m_index = sender.tag;
    if (m_index < 0) {
        NSLog(@"RecordPlayViewController onDownload[%ld] Wrong!", (long)m_index);
        m_index = -1;
        return;
    }
    /**
     Ch:取消下载任务
     En:Cancel download task
     */
    if (m_isCloudDownload[m_index]) {
        [m_download stopDownload:m_index];
        m_isCloudDownload[m_index] = NO;
        m_receiveDataSize[m_index] = 0;
        [m_listViewLock lock];
        [self reloadCell:m_listView Section:0 Row:m_index];
        [m_listViewLock unlock];
        [m_downloadSet removeObject:[NSString stringWithFormat:@"%ld", (long)m_index]];
        [self showDownloadToast:NONE];
        m_index = -1;
        return;
    }

    /**
    Ch:开始下载任务
    En:Start download task
    */
    m_isCloudDownload[m_index] = YES;
    [m_downloadSet addObject:[NSString stringWithFormat:@"%ld", (long)m_index]];
    NSString *recId = nil;
    NSString *recordRegionId = nil;
    NSString *recName = nil;
    if (m_recordType == CloudRecord) {
        recId = ((RecordInfo*)[m_recInfo objectAtIndex:m_index])->recId;
        recordRegionId = ((RecordInfo*)[m_recInfo objectAtIndex:m_index])->recRegId;
    } else {
        recName = ((RecordInfo*)[m_recInfo objectAtIndex:m_index])->name;
    }
    
    NSString* beginTime = ((RecordInfo*)[m_recInfo objectAtIndex:m_index])->beginTime;
    NSString* time;

    NSString* regex = @"[1-9]\\d{3}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}"; //正常字符范围
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex]; //比较处理

    if ([pred evaluateWithObject:beginTime]) {
        NSArray* array = [beginTime componentsSeparatedByString:@" "];
        NSArray* arrayDate = [array[0] componentsSeparatedByString:@"-"];
        NSArray* arrayTime = [array[1] componentsSeparatedByString:@":"];
        time = [arrayDate[0] stringByAppendingFormat:@"%@%@%@%@%@", arrayDate[1], arrayDate[2], arrayTime[0], arrayTime[1], arrayTime[2]];
    }

    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString* libraryDirectory = [paths objectAtIndex:0];

    NSString* myDirectory = [libraryDirectory stringByAppendingPathComponent:@"lechange"];
    NSString* downloadDirectory = [myDirectory stringByAppendingPathComponent:@"download"];

    NSString* infoPath = [downloadDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_download_%@", time, (m_recordType == CloudRecord) ? @"cloud_record" : @"device_record"]];
    
    m_downloadPath = [infoPath stringByAppendingString:@".mp4"];
    NSFileManager* fileManage = [NSFileManager defaultManager];
    NSError* pErr;
    BOOL isDir;
    if (NO == [fileManage fileExistsAtPath:myDirectory isDirectory:&isDir]) {
        [fileManage createDirectoryAtPath:myDirectory withIntermediateDirectories:YES attributes:nil error:&pErr];
    }
    if (NO == [fileManage fileExistsAtPath:downloadDirectory isDirectory:&isDir]) {
        [fileManage createDirectoryAtPath:downloadDirectory withIntermediateDirectories:YES attributes:nil error:&pErr];
    }
    NSLog(@"RecordPlayViewController[m_downloadPath] = %@", m_downloadPath);
    [m_listViewLock lock];
    [self reloadCell:m_listView Section:0 Row:m_index];
    [m_listViewLock unlock];
    if (m_recordType == CloudRecord) {
        [m_download startDownload:m_index filepath:m_downloadPath token:m_accessToken devID:m_strDevSelected channelID:m_devChnSelected psk:m_encryptKey recordRegionId:recordRegionId Type:1000 Timeout:10];
    }
    else {
        [m_download startDownload:m_index filepath:m_downloadPath token:m_accessToken devID:m_strDevSelected decryptKey:m_encryptKey fileID:recName speed:16];
    }
}

- (void)onDownloadReceiveData:(NSInteger)index datalen:(NSInteger)datalen
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (index < 0 || index >= RECORD_NUM_MAX) {
            NSLog(@"RecordViewController, index Wrong!");
            return;
        }
        m_receiveDataSize[index] = m_receiveDataSize[index] + datalen;
    });
}

- (void)onDownloadState:(NSInteger)index code:(NSString*)code type:(NSInteger)type
{
    NSLog(@"RecordPlayViewController onDownloadState[index, code, type] = [%ld, %@, %ld]", (long)index, code, (long)type);
    if (99 == type) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"openapi network interaction timeout");
            m_isCloudDownload[index] = NO;
            [m_listViewLock lock];
            [self reloadCell:m_listView Section:0 Row:index];
            [m_listViewLock unlock];
            [m_downloadSet removeObject:[NSString stringWithFormat:@"%ld", (long)index]];
            [self showDownloadToast:DOWNLOAD_FAILED];
            m_index = -1;
        });
    }
    else if (1 == type) {
        if ([HLS_Result_String(HLS_DOWNLOAD_FAILD) isEqualToString:code]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"HLS_DOWNLOAD_FAILD");
                m_isCloudDownload[index] = NO;
                m_receiveDataSize[index] = 0;
                [m_listViewLock lock];
                [self reloadCell:m_listView Section:0 Row:index];
                [m_listViewLock unlock];
                [m_downloadSet removeObject:[NSString stringWithFormat:@"%ld", (long)index]];
                [self showDownloadToast:DOWNLOAD_FAILED];
                m_index = -1;
            });
        }
        else if ([HLS_Result_String(HLS_DOWNLOAD_BEGIN) isEqualToString:code]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"HLS_DOWNLOAD_BEGIN");
            });
        }
        else if ([HLS_Result_String(HLS_DOWNLOAD_END) isEqualToString:code]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                m_isCloudDownload[index] = NO;
                m_receiveDataSize[index] = 0;
                [m_listViewLock lock];
                [self reloadCell:m_listView Section:0 Row:index];
                [m_listViewLock unlock];
                [m_downloadSet removeObject:[NSString stringWithFormat:@"%ld", (long)index]];
                m_index = -1;
            });
            NSURL *dowmloadRUL = [NSURL fileURLWithPath:m_downloadPath];
            [PHAsset deleteFormCameraRoll:dowmloadRUL success:^{
            } failure:^(NSError *error) {
                NSLog(@"Failed to delete:%@", error.description);
            }];
            [PHAsset saveVideoAtURL:dowmloadRUL success:^(void) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"Saved successfully");
                    [self alertToPlayLocalFile:m_downloadPath];
                });
            } failure:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"Save failed:%@", error.description);
                    [self showDownloadToast:SAVE_FAILED];
                });
            }];
        }
        else if ([HLS_Result_String(HLS_SEEK_SUCCESS) isEqualToString:code]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"HLS_SEEK_SUCCESS");
            });
        }
        else if ([HLS_Result_String(HLS_SEEK_FAILD) isEqualToString:code]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"HLS_SEEK_FAILD");
            });
        }
        else if ([HLS_Result_String(HLS_ABORT_DONE) isEqualToString:code]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"HLS_ABORT_DONE");
                m_isCloudDownload[index] = NO;
                m_receiveDataSize[index] = 0;
                [m_listViewLock lock];
                [self reloadCell:m_listView Section:0 Row:index];
                [m_listViewLock unlock];
                [m_downloadSet removeObject:[NSString stringWithFormat:@"%ld", (long)index]];
                [self showDownloadToast:DOWNLOAD_FAILED];
                m_index = -1;
            });
        }
        else if ([HLS_Result_String(HLS_DOWNLOAD_TIMEOUT) isEqualToString:code]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"HLS_DOWNLOAS_TIMEOUT");
                m_isCloudDownload[index] = NO;
                m_receiveDataSize[index] = 0;
                [m_listViewLock lock];
                [self reloadCell:m_listView Section:0 Row:index];
                [m_listViewLock unlock];
                [m_downloadSet removeObject:[NSString stringWithFormat:@"%ld", (long)index]];
                [self showDownloadToast:DOWNLOAD_FAILED];
                m_index = -1;
            });
        }
        else if([HLS_Result_String(HLS_KEY_ERROR) isEqualToString:code]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"HLS_KEY_ERROR");
                m_isCloudDownload[index] = NO;
                m_receiveDataSize[index] = 0;
                [m_listViewLock lock];
                [self reloadCell:m_listView Section:0 Row:index];
                [m_listViewLock unlock];
                [m_downloadSet removeObject:[NSString stringWithFormat:@"%ld", (long)index]];
                [self showDownloadToast:DOWNLOAD_FAILED];
                m_index = -1;
            });
        }
    }
    else if (0 == type)
    {
        if ([code isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"RTSP_DOWNLOAD_FAILD");
                [m_download stopDownload:m_index];
                m_isCloudDownload[index] = NO;
                m_receiveDataSize[index] = 0;
                [m_listViewLock lock];
                [self reloadCell:m_listView Section:0 Row:index];
                [m_listViewLock unlock];
                [m_downloadSet removeObject:[NSString stringWithFormat:@"%ld", (long)index]];
                [self showDownloadToast:DOWNLOAD_FAILED];
                m_index = -1;
            });
        }
        else if ([code isEqualToString:@"4"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"RTSP_DOWNLOAD_BEGIN");
            });
        }
        else if ([code isEqualToString:@"5"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [m_download stopDownload:m_index];
                m_isCloudDownload[index] = NO;
                m_receiveDataSize[index] = 0;
                [m_listViewLock lock];
               [self reloadCell:m_listView Section:0 Row:index];
               [m_listViewLock unlock];
               [m_downloadSet removeObject:[NSString stringWithFormat:@"%ld", (long)index]];
               m_index = -1;
            });
            
           NSURL *dowmloadRUL = [NSURL fileURLWithPath:m_downloadPath];
           [PHAsset deleteFormCameraRoll:dowmloadRUL success:^{
           } failure:^(NSError *error) {
               NSLog(@"Failed to delete:%@", error.description);
           }];
           [PHAsset saveVideoAtURL:dowmloadRUL success:^(void) {
               dispatch_async(dispatch_get_main_queue(), ^{
                   NSLog(@"Saved successfully");
                    [self alertToPlayLocalFile:m_downloadPath];
               });
           } failure:^(NSError *error) {
               dispatch_async(dispatch_get_main_queue(), ^{
                   NSLog(@"Save failed:%@", error.description);
                   [self showDownloadToast:SAVE_FAILED];
               });
           }];
        }
        else if ([code isEqualToString:@"7"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"RTSP_KEY_ERROR");
                [m_download stopDownload:m_index];
                m_isCloudDownload[index] = NO;
                m_receiveDataSize[index] = 0;
                [m_listViewLock lock];
                [self reloadCell:m_listView Section:0 Row:index];
                [m_listViewLock unlock];
                [m_downloadSet removeObject:[NSString stringWithFormat:@"%ld", (long)index]];
                [self showDownloadToast:DOWNLOAD_FAILED];
                m_index = -1;
            });
        }
    }
}

- (void)onSmsTimer:(NSInteger)index
{
    for (NSString* obj in m_downloadSet) {
        [m_listViewLock lock];
        [self reloadCell:m_listView Section:0 Row:[obj intValue]];
        [m_listViewLock unlock];
    }
}

- (void)onBack
{
    for (NSString* obj in m_downloadSet) {
        [m_download stopDownload:[obj intValue]];
    }
    [m_timer invalidate];
    [self destroyThread];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getRecords
{
    m_right.enabled = NO;
    switch (m_recordType) {
    case DeviceRecord:
        [self getLocalRecords];
        break;
    case CloudRecord:
        [self getCloudRecords];
    default:
        break;
    }
}

- (void)getLocalRecords
{
    [self showLoading];
    m_toastLab.hidden = YES;
    dispatch_queue_t get_local_records = dispatch_queue_create("get_local_records", nil);
    dispatch_async(get_local_records, ^{
        NSInteger year, month, day;
        NSInteger hour, minute, second;
        NSString* sBeginTime;
        NSString* sEndTime;
        year = month = day = hour = minute = second = 0;

        if (m_dateSelected == nil) {
            [self getCurrentDate:&year month:&month day:&day hour:&hour minute:&minute second:&second];
        }
        else {
            NSString* regex = @"[1-9]\\d{3}-\\d{2}-\\d{2}";
            NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            if ([pred evaluateWithObject:m_dateSelected]) {
                year = [[m_dateSelected substringWithRange:(NSRange){ 0, 4 }] intValue];
                month = [[m_dateSelected substringWithRange:(NSRange){ 5, 2 }] intValue];
                day = [[m_dateSelected substringWithRange:(NSRange){ 8, 2 }] intValue];
            }
        }
        sBeginTime = [NSString stringWithFormat:@"%04ld-%02ld-%02ld 00:00:00", (long)year, (long)month, (long)day];
        sEndTime = [NSString stringWithFormat:@"%04ld-%02ld-%02ld 23:59:59", (long)year, (long)month, (long)day];

        if (YES == m_isStarting) {
            [m_recInfoLock lock];
        }
        [self freeRecInfo];
        //end.
        NSString* errMsg;
        NSInteger iNum;
        RestApiService* restApiService = [RestApiService shareMyInstance];
        [restApiService getRecordNum:m_strDevSelected Chnl:m_devChnSelected Begin:sBeginTime End:sEndTime Num:&iNum Msg:&errMsg];
        if (![errMsg isEqualToString:[MSG_SUCCESS mutableCopy]]) {
            if (YES == m_isStarting) {
                [m_recInfoLock unlock];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideLoading];
                m_toastLab.text = errMsg;
                m_toastLab.hidden = NO;
                m_right.enabled = YES;
            });
            return;
        }
        if (iNum > 0) {
            NSInteger beginIndex = iNum > 10 ? (iNum - 9) : 1;
            NSString* errMsg;
            [restApiService getRecords:m_strDevSelected Chnl:m_devChnSelected Begin:sBeginTime End:sEndTime IndexBegin:beginIndex IndexEnd:iNum InfoOut:m_recInfo Msg:&errMsg];
            if (![errMsg isEqualToString:[MSG_SUCCESS mutableCopy]]) {
                if (YES == m_isStarting) {
                    [m_recInfoLock unlock];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideLoading];
                    m_toastLab.text = errMsg;
                    m_toastLab.hidden = NO;
                    m_right.enabled = YES;
                });
                return;
            }
            NSInteger count = m_recInfo.count;
            for (NSInteger i = 0; i <= count / 2 - 1; i++) {
                RecordInfo* t_record = [m_recInfo objectAtIndex:i];
                m_recInfo[i] = m_recInfo[count - 1 - i];
                m_recInfo[count - 1 - i] = t_record;
            }
        }
        for (NSInteger i = 0; i < m_recInfo.count; i++) {
            m_totalDataSize[i] = ((RecordInfo*)[m_recInfo objectAtIndex:i])->size;
            m_receiveDataSize[i] = 0;
            m_isCloudDownload[i] = NO;
        }
        if (YES == m_isStarting) {
            [m_recInfoLock unlock];
        }

        m_isStarting = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_listViewLock lock];
            m_listView.hidden = NO;
            [m_listView reloadData];
            [m_listViewLock unlock];
            [self hideLoading];
            m_right.enabled = YES;
        });
    });
}

- (void)getCloudRecords
{
    [self showLoading];
    m_toastLab.hidden = YES;
    dispatch_queue_t get_cloud_records = dispatch_queue_create("get_cloud_records", nil);
    dispatch_async(get_cloud_records, ^{
        NSInteger year, month, day;
        NSInteger hour, minute, second;
        NSString* sBeginTime;
        NSString* sEndTime;
        year = month = day = hour = minute = second = 0;
        // TODO
        if (m_dateSelected == nil) {
            [self getCurrentDate:&year month:&month day:&day hour:&hour minute:&minute second:&second];
        }
        else {
            NSString* regex = @"[1-9]\\d{3}-\\d{2}-\\d{2}";
            NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            if ([pred evaluateWithObject:m_dateSelected]) {
                year = [[m_dateSelected substringWithRange:(NSRange){ 0, 4 }] intValue];
                month = [[m_dateSelected substringWithRange:(NSRange){ 5, 2 }] intValue];
                day = [[m_dateSelected substringWithRange:(NSRange){ 8, 2 }] intValue];
            }
        }
        sBeginTime = [NSString stringWithFormat:@"%04ld-%02ld-%02ld 00:00:00", (long)year, (long)month, (long)day];
        sEndTime = [NSString stringWithFormat:@"%04ld-%02ld-%02ld 23:59:59", (long)year, (long)month, (long)day];

        if (YES == m_isStarting) {
            [m_recInfoLock lock];
        }
        [self freeRecInfo];

        NSString* errMsg;
        NSInteger iNum;
        RestApiService* restApiService = [RestApiService shareMyInstance];
        [restApiService getCloudRecordNum:m_strDevSelected Chnl:m_devChnSelected Bengin:sBeginTime End:sEndTime Num:&iNum Msg:&errMsg];
        if (![errMsg isEqualToString:[MSG_SUCCESS mutableCopy]]) {
            if (YES == m_isStarting) {
                [m_recInfoLock unlock];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideLoading];
                m_toastLab.text = errMsg;
                m_toastLab.hidden = NO;
                m_right.enabled = YES;
            });
            return;
        }
        if (iNum > 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                m_toastLab.hidden = YES;
            });
            
            NSString* errMsg;
            NSInteger beginIndex = iNum > 10 ? (iNum - 9) : 1;
            [restApiService getCloudRecords:m_strDevSelected Chnl:m_devChnSelected Begin:sBeginTime End:sEndTime IndexBegin:beginIndex IndexEnd:iNum InfoOut:m_recInfo Msg:&errMsg];
            if (![errMsg isEqualToString:[MSG_SUCCESS mutableCopy]]){
                if (YES == m_isStarting) {
                    [m_recInfoLock unlock];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideLoading];
                    m_toastLab.text = errMsg;
                    m_toastLab.hidden = NO;
                    m_right.enabled = YES;
                });
                return;
            }

            NSInteger count = m_recInfo.count;
            for (NSInteger i = 0; i <= count / 2 - 1; i++) {
                RecordInfo* t_record = [m_recInfo objectAtIndex:i];
                m_recInfo[i] = m_recInfo[count - 1 - i];
                m_recInfo[count - 1 - i] = t_record;
            }
        }
        for (NSInteger i = 0; i < m_recInfo.count; i++) {
            m_totalDataSize[i] = ((RecordInfo*)[m_recInfo objectAtIndex:i])->size;
            m_receiveDataSize[i] = 0;
            m_isCloudDownload[i] = NO;
        }
        if (YES == m_isStarting) {
            [m_recInfoLock unlock];
        }
        m_isStarting = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoading];
            [m_listViewLock lock];
            m_listView.hidden = NO;
            [m_listView reloadData];
            [m_listViewLock unlock];
            m_right.enabled = YES;
        });
    });
}

- (void)getCurrentDate:(NSInteger*)year month:(NSInteger*)month day:(NSInteger*)day hour:(NSInteger*)hour minute:(NSInteger*)minute second:(NSInteger*)second
{
    NSDate* now = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;

    NSDateComponents* dateComponent = [calendar components:unitFlags fromDate:now];
    *year = [dateComponent year];
    *month = [dateComponent month];
    *day = [dateComponent day];
    *hour = [dateComponent hour];
    *minute = [dateComponent minute];
    *second = [dateComponent second];
}

- (void)freeRecInfo
{
    [m_recInfo removeAllObjects];
}

- (void)reloadCell:(UITableView*)tableView Section:(NSInteger)section Row:(NSInteger)row
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:section];

    if ([tableView numberOfRowsInSection:section] > row) {
        
       [UIView performWithoutAnimation:^{
            CGPoint loc = tableView.contentOffset;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            tableView.contentOffset = loc;
        }];
    }
}

- (void)downloadThread
{
    m_iPos = 0;
    m_downloadingPos = -1;
    int j;
    while (m_looping) {
        usleep(20 * 1000);
        BOOL bNeedDown = YES;
        NSString* picUrl;

        [m_recInfoLock lock];
        [m_downStatusLock lock];
        do {
            picUrl = nil;

            if (m_iPos < 0 || m_iPos >= m_recInfo.count) {
                bNeedDown = NO;
                m_iPos = (m_iPos + 1) % (RECORD_NUM_MAX);
                break;
            }

            for (j = 0; j < RECORD_NUM_MAX; j++) {
                if (DOWNLOADING == m_downloadPicture[j].downStatus) {
                    break;
                }
            }
            if (j < RECORD_NUM_MAX) {
                bNeedDown = NO;
                break;
            }
            if (NONE != m_downloadPicture[m_iPos].downStatus) {
                bNeedDown = NO;
                m_iPos = (m_iPos + 1) % (RECORD_NUM_MAX);
                break;
            }
            picUrl = [((RecordInfo*)[m_recInfo objectAtIndex:m_iPos])->thumbUrl mutableCopy];
        } while (0);

        [m_recInfoLock unlock];

        if (!bNeedDown || !picUrl || 0 == picUrl.length) {
            [m_downStatusLock unlock];
            continue;
        }
        //download
        m_httpUrl = [NSURL URLWithString:picUrl];
        m_downloadPicture[m_iPos].downStatus = DOWNLOADING;
        m_downloadingPos = m_iPos;
        m_iPos = (m_iPos + 1) % (RECORD_NUM_MAX);

        NSURLRequest* request = [NSMutableURLRequest requestWithURL:m_httpUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
        NSHTTPURLResponse* response = nil;
        NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:NULL];
        if (m_downloadingPos < 0) {
            NSLog(@"connectionDidFinishLoading m_downloadingPos[%ld]", (long)m_downloadingPos);
            return;
        }
        if (response == nil) {
            NSLog(@"download failed");
            m_downloadPicture[m_downloadingPos].downStatus = DOWNLOAD_FAILED;
        }
        else {
            NSLog(@"connectionDidFinishLoading m_downloadingPos[%ld]", (long)m_downloadingPos);
            m_downloadPicture[m_downloadingPos].picData = data;
            NSData* dataOut = [[NSData alloc] init];
            NSInteger iret = [m_util decryptPic:m_downloadPicture[m_downloadingPos].picData deviceID:m_strDevSelected key:m_encryptKey token:m_accessToken bufOut:&dataOut];

            NSLog(@"decrypt iret[%ld]", (long)iret);
            if (0 == iret) {
                [m_downloadPicture[m_downloadingPos] setData:[NSData dataWithBytes:[dataOut bytes] length:[dataOut length]] status:DOWNLOAD_FINISHED];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [m_listViewLock lock];
                    [m_listView reloadData];
                    [m_listViewLock unlock];
                });
            }
            else {
                [m_downloadPicture[m_downloadingPos] setData:nil status:DOWNLOAD_FAILED];
            }
        }
        [m_downStatusLock unlock];
    }
}
- (void)destroyThread
{
    m_looping = NO;
}

- (void)showDownloadToast:(DownStatus)status
{
    switch (status) {
        case DOWNLOAD_SUCCESS:
            m_toastLab.text = NSLocalizedString(DOWNLOAD_SUCCESS_TXT, nil);
            m_toastLab.hidden = NO;
            [self performSelector:@selector(downloadToastDelay) withObject:nil afterDelay:2.0f];
            break;
        case DOWNLOAD_FAILED:
            m_toastLab.text = NSLocalizedString(DOWNLOAD_FAILED_TXT, nil);
            m_toastLab.hidden = NO;
            [self performSelector:@selector(downloadToastDelay) withObject:nil afterDelay:2.0f];
            break;
        case DOWNLOADING:
            m_toastLab.text = NSLocalizedString(DOWNLOADING_TXT, nil);
            m_toastLab.hidden = NO;
            [self performSelector:@selector(downloadToastDelay) withObject:nil afterDelay:2.0f];
            break;
        case NONE:
            m_toastLab.text = NSLocalizedString(CANCEL_DOWNLOAD_TXT, nil);
            m_toastLab.hidden = NO;
            [self performSelector:@selector(downloadToastDelay) withObject:nil afterDelay:2.0f];
            break;
        case SAVE_FAILED:
            m_toastLab.text = NSLocalizedString(RECORD_SAVE_FAILED, nil);
            m_toastLab.hidden = NO;
            [self performSelector:@selector(downloadToastDelay) withObject:nil afterDelay:2.0f];
            break;
        default:
            break;
    }
}

- (void)alertToPlayLocalFile:(NSString *)filePath {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(PLAY_LOCAL_FILE, nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action){
        LocalPlayViewController *localPlayViewController = [LocalPlayViewController new];
        localPlayViewController.filepath = filePath;
        [self.navigationController pushViewController:localPlayViewController animated:NO];
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:confirmAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)downloadToastDelay
{
    m_toastLab.hidden = YES;
}


- (void)showLoading
{
    [m_progressInd startAnimating];
}

- (void)hideLoading
{
    if ([m_progressInd isAnimating]) {
        [m_progressInd stopAnimating];
    }
}

- (void)dealloc
{
    NSLog(@"RecordViewController, dealloc");
}
@end
