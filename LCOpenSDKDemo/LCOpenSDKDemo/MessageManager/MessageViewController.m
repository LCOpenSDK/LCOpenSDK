//
//  HintViewController.m
//  LCOpenSDKDemo
//
//  Created by chenjian on 16/7/11.
//  Copyright (c) 2016年 lechange. All rights reserved.
//

#import "LCOpenSDK_Prefix.h"
#import "MessageViewController.h"
#import <Foundation/Foundation.h>
@interface MessageViewController () {
    NSInteger m_msgCellNumber;
    UIAlertView* m_alertDelView;
    UIAlertView* m_alertDelFailView;
    UIButton* m_btnDetelte;
    UIButton* m_right;
}
@end

@implementation MessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINavigationItem* item = [[UINavigationItem alloc] initWithTitle:NSLocalizedString(MESSAGE_TITLE_TXT, nil)];

    m_right = [UIButton buttonWithType:UIButtonTypeCustom];
    [m_right setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 5 - 40, 0, 50, 30)];
    UIImage* img = [UIImage leChangeImageNamed:Search_Icon_Png];

    [m_right setBackgroundImage:img forState:UIControlStateNormal];
    [m_right addTarget:self action:@selector(onSearch:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc] initWithCustomView:m_right];
    [item setRightBarButtonItem:rightBtn animated:NO];
    super.m_navigationBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

    UIButton* left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(0, 0, 50, 30)];
    UIImage* imgLeft = [UIImage leChangeImageNamed:Back_Btn_Png];

    [left setBackgroundImage:imgLeft forState:UIControlStateNormal];
    [left addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc] initWithCustomView:left];
    [item setLeftBarButtonItem:leftBtn animated:NO];
    [super.m_navigationBar pushNavigationItem:item animated:NO];

    [self.view addSubview:super.m_navigationBar];

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

    m_messageList = [[UITableView alloc] initWithFrame:CGRectMake(0, super.m_yOffset, self.view.frame.size.width, self.view.frame.size.height - super.m_yOffset)];
    m_messageList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:m_messageList];
    m_messageList.delegate = self;
    m_messageList.dataSource = self;

    m_messageList.backgroundColor = [UIColor clearColor];
    m_messageList.separatorColor = [UIColor colorWithRed:217.0 / 255.0 green:217.0 / 255.0 blue:217.0 / 255.0 alpha:1.0];
    m_messageList.allowsSelection = YES;

    m_wholePic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.width * 9 / 16)];
    m_wholePic.center = self.view.center;
    [self.view addSubview:m_wholePic];
    m_wholePic.hidden = YES;
    [m_wholePic setUserInteractionEnabled:YES];
    [m_wholePic addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick:)]];

    [self.view bringSubviewToFront:self.m_queryView];
    [self.view bringSubviewToFront:m_progressInd];
    self.m_queryView.hidden = YES;
    [self.m_MessageNull setImage:[UIImage leChangeImageNamed:Message_None_Png]];
    self.m_MessageNull.hidden = YES;
    m_seleceDate = [NSDate date];
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd"];
    m_strSelectDate = [fmt stringFromDate:m_seleceDate];

    m_msgInfoArray = [[NSMutableArray alloc] init];
    m_util = [[LCOpenSDK_Utils alloc] init];

    for (int i = 0; i < MESSAGE_NUM_MAX; i++) {
        m_downloadPicture[i] = [[DownloadPicture alloc] init];
    }

    m_downStatusLock = [[NSLock alloc] init];
    m_messageListLock = [[NSLock alloc] init];
    m_looping = YES;
    m_conn = nil;

    dispatch_queue_t downQueue = dispatch_queue_create("alarmPicDown", nil);
    dispatch_async(downQueue, ^{
        [self downloadThread];
    });

    m_msgCellNumber = -1;
    [self refreshList];
}

- (void)onBack:(id)sender
{
    [self destroyThread];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)onSearch:(id)sender
{
    self.m_queryView.hidden = NO;
}
- (void)onClick:(id)sender
{
    m_wholePic.hidden = YES;
    [m_wholePic setImage:nil];
    m_messageList.hidden = NO;
    super.m_navigationBar.hidden = NO;
}
- (void)onDelete:(id)sender
{
    m_btnDetelte = (UIButton*)sender;

    m_alertDelView = [[UIAlertView alloc] initWithTitle:@"alarm" message:@"confirm to delete?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [m_alertDelView show];
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == m_alertDelView) {
        if (0 == buttonIndex) {
            NSLog(@"cancel delete the %ld alarmMessage!", (long)m_btnDetelte.tag);
            return;
        }
        else if (1 == buttonIndex) {
            [self showLoading];
            dispatch_queue_t delete_alarm_msg = dispatch_queue_create("delete_alarm_msg", nil);
            dispatch_async(delete_alarm_msg, ^{
                NSString *errMsg;
                RestApiService* restApiService = [RestApiService shareMyInstance];
                [restApiService deleteAlarmMsg:((AlarmMessageInfo*)[m_msgInfoArray objectAtIndex:m_btnDetelte.tag])->alarmId Msg:&errMsg];
                if (![errMsg isEqualToString:[MSG_SUCCESS mutableCopy]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self hideLoading];
                        NSLog(@"delete msg failed");
                        m_alertDelFailView = [[UIAlertView alloc] initWithTitle:@"alarm" message:@"delete failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [m_alertDelFailView show];
                    });
                    return;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideLoading];
                    [self refreshList];
                });
            });
        }
    }
}

- (void)setInfo:(NSString*)token Dev:(NSString*)deviceId Key:(NSString*)key Chn:(NSInteger)chn
{
    m_accessToken = [token mutableCopy];
    m_strDevSelected = [deviceId mutableCopy];
    m_encryptKey = [key mutableCopy];
    m_devChnSelected = chn;
}

- (void)onCancel:(id)sender
{
    self.m_queryView.hidden = YES;
}
- (void)onQuery:(id)sender
{
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd"];
    m_strSelectDate = [fmt stringFromDate:self.m_datePicker.date];

    self.m_queryView.hidden = YES;

    [self refreshList];
}

- (void)onValueChange:(id)sender
{
}

- (void)refreshList
{
    [self showLoading];
    m_toastLab.hidden = YES;
    m_right.enabled = NO;
    [m_messageListLock lock];
    m_messageList.hidden = YES;
    [m_messageListLock unlock];

    [m_downStatusLock lock];
    for (int i = 0; i < MESSAGE_NUM_MAX; i++) {
        [m_downloadPicture[i] clearData];
    }
    [m_downStatusLock unlock];
    m_conn = nil;
    m_iPos = 0;
    m_downloadingPos = -1;

    dispatch_queue_t getAlarmMsg = dispatch_queue_create("getAlarmMsg", nil);
    dispatch_async(getAlarmMsg, ^{
        [m_msgInfoArray removeAllObjects];
        NSString* strBeginDate = [m_strSelectDate stringByAppendingString:@" 00:00:00"];
        NSString* strEndDate = [m_strSelectDate stringByAppendingString:@" 23:59:59"];
        NSString* errMsg;
        RestApiService* restApiService = [RestApiService shareMyInstance];
        [restApiService getAlarmMsg:m_strDevSelected Chnl:m_devChnSelected Begin:strBeginDate End:strEndDate Info:m_msgInfoArray Count:MESSAGE_NUM_MAX Msg:&errMsg];
        if (![errMsg isEqualToString:[MSG_SUCCESS mutableCopy]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideLoading];
                m_toastLab.text = errMsg;
                m_toastLab.hidden = NO;
                m_right.enabled = YES;
            });
            return;
        }
        
        m_msgCellNumber = m_msgInfoArray.count;
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_messageListLock lock];
            [m_messageList reloadData];
            m_messageList.hidden = NO;
            [m_messageListLock unlock];
            [self hideLoading];
            m_right.enabled = YES;

        });
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    self.m_MessageNull.hidden = m_msgCellNumber == 0 ? NO : YES;
    NSLog(@"message num[%ld]", (long)m_msgCellNumber);
    return m_msgCellNumber <= MESSAGE_NUM_MAX ? m_msgCellNumber : MESSAGE_NUM_MAX;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    static NSString* cellIdentifier = @"Cell";
    UITableViewCell* cell;

    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

    NSLog(@"the row is %ld\n", (long)[indexPath row]);

    UIImage* imgPic = nil;

    if (nil != m_downloadPicture[[indexPath row]].picData) {
        NSLog(@"test cell image thumbnail");
        imgPic = [UIImage imageWithData:m_downloadPicture[[indexPath row]].picData];
        NSLog(@"cell[%ld] decrypt imgPic %@", (long)[indexPath row], (imgPic ? @"successfully" : @"failed"));
        if (!imgPic) {
            imgPic = [UIImage leChangeImageNamed:DefaultCover_Png];
        }
    }
    else {
        NSLog(@"test cell image default");
        imgPic = [UIImage leChangeImageNamed:DefaultCover_Png];
    }

    [m_messageListLock lock];
    if ([indexPath row] >= [m_msgInfoArray count]) {
        NSLog(@"cellForRowAtIndexPath index error ,count[%lu],index[%ld]", (unsigned long)[m_msgInfoArray count], (long)[indexPath row]);
        [m_messageListLock unlock];
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_messageList reloadData];
        });
        return cell;
    }

    UIImageView* imgPicView = [[UIImageView alloc] initWithFrame:CGRectMake(10, Separate_Cell, (Message_Cell_Height - Separate_Cell) * 16.0 / 9, Message_Cell_Height - Separate_Cell)];
    [imgPicView setImage:imgPic];
    [cell addSubview:imgPicView];

    UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake((Message_Cell_Height - Separate_Cell) * 16.0 / 9 + 20, Separate_Cell, 100, (Message_Cell_Height - Separate_Cell) / 2)];
    lbl.text = NSLocalizedString(ALARM_TIME_TXT, nil);
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont boldSystemFontOfSize:15];
    [cell addSubview:lbl];

    UILabel* lblLocal = [[UILabel alloc] initWithFrame:CGRectMake((Message_Cell_Height - Separate_Cell) * 16.0 / 9 + 20, Separate_Cell + (Message_Cell_Height - Separate_Cell) / 2, 200, (Message_Cell_Height - Separate_Cell) / 2)];
    lblLocal.text = ((AlarmMessageInfo*)[m_msgInfoArray objectAtIndex:[indexPath row]])->localDate;
    [lblLocal setTextColor:[UIColor colorWithRed:147 / 255.0 green:147 / 255.0 blue:153 / 255.0 alpha:1.0]];
    lblLocal.font = [UIFont boldSystemFontOfSize:13.0];
    lblLocal.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [cell addSubview:lblLocal];

     if ([NSLocalizedString(LANGUAGE_TXT, nil) isEqualToString:@"ch"]) {
        UIButton* btnDelDev = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDelDev.frame = CGRectMake(Message_Cell_Width - 40 - 5, Separate_Cell, 40, 40);
        UIImage* imgDelDev = [UIImage leChangeImageNamed:Message_Trash_Png];
        [btnDelDev setImage:imgDelDev forState:UIControlStateNormal];
        [cell addSubview:btnDelDev];
        btnDelDev.tag = [indexPath row];
        [btnDelDev addTarget:self action:@selector(onDelete:) forControlEvents:UIControlEventTouchUpInside];
    }

    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [m_messageListLock unlock];

    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (m_messageList == tableView) {
        if (nil != m_downloadPicture[[indexPath row]].picData) {
            [m_wholePic setImage:[UIImage imageWithData:m_downloadPicture[[indexPath row]].picData]];
        }
        else {
            [m_wholePic setImage:[UIImage leChangeImageNamed:DefaultCover_Png]];
        }

        m_wholePic.hidden = NO;
        m_messageList.hidden = YES;
        self.m_queryView.hidden = YES;
        super.m_navigationBar.hidden = YES;
        [self showLoading];
        dispatch_queue_t whole_pic_download = dispatch_queue_create("whole_pic_download", nil);
        dispatch_async(whole_pic_download, ^{
            NSString* picUrl = [((AlarmMessageInfo*)[m_msgInfoArray objectAtIndex:[indexPath row]])->picArray[0] mutableCopy];
            if (!picUrl) {
                NSLog(@"MessageViewController picUrl is nil");
                return;
            }
            NSURL* httpUrl = [NSURL URLWithString:picUrl];

            NSURLRequest* request = [NSMutableURLRequest requestWithURL:httpUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSHTTPURLResponse* response = nil;
                NSData* picData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:NULL];

                if (response == nil) {
                    NSLog(@"download failed");
                }
                else {
                    m_downloadPicture[m_downloadingPos].picData = picData;
                    NSData* dataOut = [[NSData alloc] init];
                    
                    NSInteger iret = [m_util decryptPic:picData deviceID:m_strDevSelected key:m_encryptKey token:m_accessToken bufOut:&dataOut];
                    NSLog(@"decrypt iret[%ld]", (long)iret);
                    if (0 == iret) {
                        UIImage* img = [UIImage imageWithData:[NSData dataWithBytes:[dataOut bytes] length:[dataOut length]]];
                        [m_wholePic setImage:img];
                    }
                }
                [self hideLoading];
            });

        });
    }
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return Message_Cell_Height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

        [m_messageListLock lock];
        [m_downStatusLock lock];
        do {
            picUrl = nil;

            if (m_iPos < 0 || m_iPos >= [m_msgInfoArray count]) {
                bNeedDown = NO;
                m_iPos = (m_iPos + 1) % (MESSAGE_NUM_MAX);
                break;
            }

            for (j = 0; j < MESSAGE_NUM_MAX; j++) {
                if (DOWNLOADING == m_downloadPicture[j].downStatus) {
                    break;
                }
            }
            if (j < MESSAGE_NUM_MAX) {
                bNeedDown = NO;
                break;
            }
            if (NONE != m_downloadPicture[m_iPos].downStatus) {
                bNeedDown = NO;
                m_iPos = (m_iPos + 1) % (MESSAGE_NUM_MAX);
                break;
            }
            /**
             Ch: 缩略图Url:thumbnail
             En: Thumbnail Url:thumbnail
             */
            picUrl = [((AlarmMessageInfo*)[m_msgInfoArray objectAtIndex:m_iPos])->thumbnail mutableCopy];
        } while (0);

        [m_messageListLock unlock];

        if (!bNeedDown || !picUrl || 0 == picUrl.length) {
            [m_downStatusLock unlock];
            usleep(10 * 1000);
            continue;
        }

        //download
        m_httpUrl = [NSURL URLWithString:picUrl];
        m_downloadPicture[m_iPos].downStatus = DOWNLOADING;
        m_downloadingPos = m_iPos;
        m_iPos = (m_iPos + 1) % (MESSAGE_NUM_MAX);

        NSURLRequest* request = [NSMutableURLRequest requestWithURL:m_httpUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
        NSHTTPURLResponse* response = nil;
        NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:NULL];

        if (m_downloadingPos < 0) {
            NSLog(@"m_downloadingPos[%ld]", (long)m_downloadingPos);
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
                    [m_messageList reloadData];
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
    m_conn = nil;
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
    //    NSLog(@"retain count = %ld\n", CFGetRetainCount((__bridge CFTypeRef)(self)));
    //    NSLog(@"MessageViewController dealloc");
}
@end
