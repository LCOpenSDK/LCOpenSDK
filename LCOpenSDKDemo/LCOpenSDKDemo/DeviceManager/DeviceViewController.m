//
//  HintViewController.m
//  LCOpenSDKDemo
//
//  Created by chenjian on 16/7/11.
//  Copyright (c) 2016年 lechange. All rights reserved.
//

#import "openApiService.h"
#import "LCOpenSDK_Prefix.h"
#import "AddDeviceViewController.h"
#import "DeviceOperationViewController.h"
#import "DeviceViewController.h"
#import "LiveVideoViewController.h"
#import "MessageViewController.h"
#import "RecordViewController.h"
#import <Foundation/Foundation.h>
#import "OpenApiInfo.h"
#import "MJExtension.h"


@interface DeviceViewController ()
{
    NSInteger m_devKeyIndex;
    NSInteger m_chnKeyIndex;
    LCOpenSDK_Utils* m_util;
    OpenApiService* m_openApi;
}

@end

@implementation DeviceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    m_util = [[LCOpenSDK_Utils alloc] init];
    m_openApi = [[OpenApiService alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
    UINavigationItem* item = [[UINavigationItem alloc] initWithTitle:NSLocalizedString(DEVICE_TITLE_TXT, nil)];
    super.m_navigationBar.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

    UIButton* right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 5 - 40, 0, 50, 30)];
    [right setBackgroundImage:[UIImage leChangeImageNamed:AddDevice_Png] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(onAddDevice:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc] initWithCustomView:right];
    [item setRightBarButtonItem:rightBtn animated:NO];
    //[bar pushNavigationItem:item animated:NO];

    UIButton* left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(0, 0, 50, 30)];
    UIImage* imgLeft = [UIImage leChangeImageNamed:Back_Btn_Png];

    [left setBackgroundImage:imgLeft forState:UIControlStateNormal];
    [left addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc] initWithCustomView:left];
    [item setLeftBarButtonItem:leftBtn animated:NO];
    [super.m_navigationBar pushNavigationItem:item animated:NO];

    [self.view addSubview:super.m_navigationBar];
    m_devListView = [[UITableView alloc] initWithFrame:CGRectMake(0, super.m_yOffset, self.view.frame.size.width, self.view.frame.size.height - super.m_yOffset - 10)];
    m_devListView.estimatedRowHeight = 0;
    m_devListView.estimatedSectionHeaderHeight = 0;
    m_devListView.estimatedSectionFooterHeight = 0;

    [self.view addSubview:m_devListView];
    m_devListView.delegate = self;
    m_devListView.dataSource = self;

    m_devListView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    m_devListView.separatorColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    m_devListView.allowsSelection = YES;

    m_progressInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    m_progressInd.transform = CGAffineTransformMakeScale(2.0, 2.0);
    m_progressInd.center = CGPointMake(self.view.center.x, self.view.center.y);
    [self.view addSubview:m_progressInd];

    m_toastLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    m_toastLab.center = self.view.center;
    m_toastLab.backgroundColor = [UIColor whiteColor];
    m_toastLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:m_toastLab];

    [self.view bringSubviewToFront:m_toastLab];
    [self.view bringSubviewToFront:m_progressInd];

    LCOpenSDK_ApiParam * apiParam = [[LCOpenSDK_ApiParam alloc] init];
    apiParam.procotol = 80 == m_iPort ? PROCOTOL_TYPE_HTTP : PROCOTOL_TYPE_HTTPS;
    apiParam.addr = m_strSvr;
    apiParam.port = m_iPort;
    apiParam.token = _m_accessToken;
    
    self.m_hc = [[LCOpenSDK_Api shareMyInstance] initOpenApi:apiParam];

    RestApiService* restApiService = [RestApiService shareMyInstance];
    m_devList = [[NSMutableArray alloc] init];
    if (nil != self.m_hc && nil != self.m_accessToken) {
        [restApiService initComponent:self.m_hc Token:self.m_accessToken];
    }
    else {
        NSLog(@"DeviceViewController, m_hc or m_accessToken is nil");
    }

    for (int i = 0; i < DEV_CHANNEL_MAX * DEV_NUM_MAX; i++) {
        m_downloadPicture[i] = [[DownloadPicture alloc] init];
    }

    m_iPos = 0;
    m_downloadingPos = -1;

    m_downStatusLock = [[NSLock alloc] init];
    m_devLock = [[NSLock alloc] init];
    m_looping = YES;
    m_conn = nil;
    self.m_imgDeviceNULL.hidden = YES;
    m_toastLab.hidden = YES;

    [self showLoading];
    [self getDevList];

    dispatch_queue_t downQueue = dispatch_queue_create("thumbnailDown", nil);
    dispatch_async(downQueue, ^{
        [self downloadThread];
    });
}

- (void)onBack:(id)sender
{
    [self destroyThread];
    [m_openApi cancelRequest];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    [m_devLock lock];
    int iChCount = 0;
    for (Device* dev in m_devList) {
        if (nil == dev.deviceId) {
            break;
        }
        iChCount += dev.channels.count;
    }
    [m_devLock unlock];
    return iChCount;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellIdentifier = @"Cell";
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

    [m_devLock lock];
    NSInteger devKeyIndex = [self locateDevKeyIndex:[indexPath row]];
    NSInteger chnKeyIndex = [self locateDevChannelKeyIndex:[indexPath row]];
    if (devKeyIndex < 0 || chnKeyIndex < 0) {
        NSLog(@"cellForRowAtIndexPath devKeyIndex[%ld],chnKeyIndex[%ld]", (long)devKeyIndex, (long)chnKeyIndex);
        [m_devLock unlock];
        return cell;
    }

    UIImage* imgPic = nil;
    if (nil != m_downloadPicture[[indexPath row]].picData) {
        imgPic = [UIImage imageWithData:m_downloadPicture[[indexPath row]].picData];
    }
    else {
        NSLog(@"test cell image default");
        imgPic = [UIImage leChangeImageNamed:DefaultCover_Png];
    }

    UIImageView* imgPicView = [[UIImageView alloc] initWithFrame:CGRectMake(0, Device_Cell_Separate, Device_Cell_Width, Device_Cell_Height - Device_Cell_Separate)];
    [imgPicView setImage:imgPic];
    [cell addSubview:imgPicView];

    UILabel* lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Device_Cell_Width, Device_Cell_Separate)];
    Channel *channel = ((Device*)[m_devList objectAtIndex:devKeyIndex]).channels[chnKeyIndex];
    
    lblTitle.text = channel.channelName;
    [lblTitle setFont:[UIFont systemFontOfSize:14.0f]];
    lblTitle.textColor = [UIColor colorWithRed:159.0 / 255 green:159.0 / 255 blue:166 / 255 alpha:1];
    lblTitle.backgroundColor = [UIColor whiteColor];
    [cell addSubview:lblTitle];

    UIButton* btnDelDev = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDelDev.frame = CGRectMake(Device_Cell_Width - 40 - 5, 0, 40, Device_Cell_Separate);
    UIImage* imgDelDev = [UIImage leChangeImageNamed:Trash_Png];
    [btnDelDev setImage:imgDelDev forState:UIControlStateNormal];
    [cell addSubview:btnDelDev];
    btnDelDev.tag = [indexPath row];
    [btnDelDev addTarget:self action:@selector(onDelete:) forControlEvents:UIControlEventTouchUpInside];

    UIImage* imgBottom = [UIImage leChangeImageNamed:Toast_Png];
    UIImageView* imgBottomView = [[UIImageView alloc] initWithFrame:CGRectMake(-50, Device_Cell_Height - 60, Device_Cell_Width + 100, 60)];
    imgBottomView.layer.masksToBounds = YES;
    imgBottomView.contentMode = UIViewContentModeScaleAspectFill;

    [imgBottomView setImage:imgBottom];
    [cell addSubview:imgBottomView];

    UIImage* imgLive = [UIImage leChangeImageNamed:LiveVideo_Png];
    UIButton* btnLive = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLive.frame = CGRectMake(5, Device_Cell_Height - 50, 50, 40);
    CGFloat step = (Device_Cell_Width - 2 * 5 - 5 * 50) / 4;
    [btnLive setImage:imgLive forState:UIControlStateNormal];
    [cell addSubview:btnLive];
    btnLive.tag = [indexPath row];
    [btnLive addTarget:self action:@selector(onLive:) forControlEvents:UIControlEventTouchUpInside];

    UIImage* imgVideo = [UIImage leChangeImageNamed:Video_Png];
    UIButton* btnVideo = [UIButton buttonWithType:UIButtonTypeCustom];
    btnVideo.frame = CGRectMake(btnLive.frame.origin.x + btnLive.frame.size.width + step, Device_Cell_Height - 50, 50, 40);
    [btnVideo setImage:imgVideo forState:UIControlStateNormal];
    [cell addSubview:btnVideo];
    btnVideo.tag = [indexPath row];
    [btnVideo addTarget:self action:@selector(onVideo:) forControlEvents:UIControlEventTouchUpInside];

    UIImage* imgCloud = [UIImage leChangeImageNamed:CloudVideo_Png];
    UIButton* btnCloud = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCloud.frame = CGRectMake(btnVideo.frame.origin.x + btnVideo.frame.size.width + step, Device_Cell_Height - 50, 50, 40);
    [btnCloud setImage:imgCloud forState:UIControlStateNormal];
    [cell addSubview:btnCloud];
    btnCloud.tag = [indexPath row];
    [btnCloud addTarget:self action:@selector(onCloud:) forControlEvents:UIControlEventTouchUpInside];

    UIImage* imgMessage = [UIImage leChangeImageNamed:Message_Png];
    UIButton* btnMessage = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMessage.frame = CGRectMake(btnCloud.frame.origin.x + btnCloud.frame.size.width + step, Device_Cell_Height - 50, 50, 40);
    [btnMessage setImage:imgMessage forState:UIControlStateNormal];
    [cell addSubview:btnMessage];
    btnMessage.tag = [indexPath row];
    [btnMessage addTarget:self action:@selector(onMessage:) forControlEvents:UIControlEventTouchUpInside];

    UIImage* imgSetting = [UIImage leChangeImageNamed:Setting_Png];
    UIButton* btnSetting = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSetting.frame = CGRectMake(btnMessage.frame.origin.x + btnMessage.frame.size.width + step, Device_Cell_Height - 50, 50, 40);
    [btnSetting setImage:imgSetting forState:UIControlStateNormal];
    [cell addSubview:btnSetting];
    btnSetting.tag = [indexPath row];
    [btnSetting addTarget:self action:@selector(onSetting:) forControlEvents:UIControlEventTouchUpInside];
    if ([NSLocalizedString(LANGUAGE_TXT, nil) isEqualToString:@"en"]) {
    //    btnSetting.enabled = NO;
    }
    
    if (((Device*)[m_devList objectAtIndex:devKeyIndex]).channels.count > 1){
       /**
        Ch:NVR设备逐个通道展示区分是否离线
        En:NVR devices are displayed channel by channel to distinguish whether they are offline.
        */
        Channel *chnnel = ((Device *)[m_devList objectAtIndex:devKeyIndex]).channels[chnKeyIndex];
        if( [chnnel.status isEqualToString:@"offline"]){
            UIImage* imgOffline = [UIImage leChangeImageNamed:Offline_Png];
            UIImageView* imgOfflineView = [[UIImageView alloc] initWithFrame:CGRectMake(Device_Cell_Width / 2 - 50, (Device_Cell_Height - Device_Cell_Separate) / 2 + Device_Cell_Separate - 50, 100, 100)];
            [imgOfflineView setImage:imgOffline];
            
            UILabel* lblCover = [[UILabel alloc] initWithFrame:CGRectMake(0, Device_Cell_Separate, Device_Cell_Width, Device_Cell_Height - Device_Cell_Separate)];
            lblCover.text = @"";
            lblCover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            [cell addSubview:lblCover];
            [cell addSubview:imgOfflineView];
            
            btnLive.enabled = NO;
            btnCloud.enabled = NO;
            btnMessage.enabled = NO;
            btnSetting.enabled = NO;
            btnVideo.enabled = NO;;
        }
    }
    else if( ([((Device*)[m_devList objectAtIndex:devKeyIndex]).status  isEqualToString:@"offline"])
        &&  (((Device*)[m_devList objectAtIndex:devKeyIndex]).channels.count <= 1) ){
        /**
         Ch:非NVR设备按devOnline字段区分是否离线
         En:Non-NVR devices are offline according to the devOnline field.
         */
        UIImage* imgOffline = [UIImage leChangeImageNamed:Offline_Png];
        UIImageView* imgOfflineView = [[UIImageView alloc] initWithFrame:CGRectMake(Device_Cell_Width / 2 - 50, (Device_Cell_Height - Device_Cell_Separate) / 2 + Device_Cell_Separate - 50, 100, 100)];
        [imgOfflineView setImage:imgOffline];
        
        UILabel* lblCover = [[UILabel alloc] initWithFrame:CGRectMake(0, Device_Cell_Separate, Device_Cell_Width, Device_Cell_Height - Device_Cell_Separate)];
        lblCover.text = @"";
        lblCover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [cell addSubview:lblCover];
        [cell addSubview:imgOfflineView];
        
        btnLive.enabled = NO;
        btnCloud.enabled = NO;
        btnMessage.enabled = NO;
        btnSetting.enabled = NO;
        btnVideo.enabled = NO;
    }
    else if ((1 == ((Device*)[m_devList objectAtIndex:devKeyIndex]).encryptMode) && ![((Device*)[m_devList objectAtIndex:devKeyIndex]).ability containsString:@"TCM"]) {
          Channel *chnnel = ((Device *)[m_devList objectAtIndex:devKeyIndex]).channels[chnKeyIndex];
        if(chnnel.encryptKey.length == 0) {
            UILabel* lblCover = [[UILabel alloc] initWithFrame:CGRectMake(0, Device_Cell_Separate, Device_Cell_Width, Device_Cell_Height - Device_Cell_Separate)];
                  lblCover.text = NSLocalizedString(ENTER_ENCRYPTED_KEY_TXT, nil);
                  [lblCover setFont:[UIFont systemFontOfSize:24.0f]];
                  [lblCover setTextColor:[UIColor whiteColor]];
                  lblCover.textAlignment = NSTextAlignmentCenter;
                  lblCover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                  [cell addSubview:lblCover];
                  
                  btnLive.enabled = NO;
                  btnCloud.enabled = NO;
                  btnMessage.enabled = NO;
                  btnSetting.enabled = NO;
                  btnVideo.enabled = NO;
        }
    }

    cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    [m_devLock unlock];
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [m_devLock lock];
    NSInteger devKeyIndex = [self locateDevKeyIndex:[indexPath row]];
    NSInteger chnKeyIndex = [self locateDevChannelKeyIndex:[indexPath row]];
    if ([((Device*)[m_devList objectAtIndex:devKeyIndex]).status isEqualToString:@"offline"])
    {
        [m_devLock unlock];
        return;
    }
    Channel *channel = ((Device *)[m_devList objectAtIndex:devKeyIndex]).channels[chnKeyIndex];
    if (0 != channel.encryptKey.length) {
        [m_devLock unlock];
        return;
    }
    if (1 == ((Device*)[m_devList objectAtIndex:devKeyIndex]).encryptMode && ![((Device*)[m_devList objectAtIndex:devKeyIndex]).ability containsString:@"TCM"]) {
        alertDecryptView = [[UIAlertView alloc] initWithTitle:@"Encrypt Key" message:@"please input correct key" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        alertDecryptView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alertDecryptView show];
        m_devKeyIndex = devKeyIndex;
        m_chnKeyIndex = chnKeyIndex;
        [m_devLock unlock];
    }
    [m_devLock unlock];

}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return Device_Cell_Height;
}
#pragma mark - 查询设备通道(En:Query device channel)
- (NSInteger)locateDevKeyIndex:(NSInteger)index
{
    int iChCount = 0;
    int i = 0;
    for (Device* dev in m_devList) {
        if (nil == dev.deviceId) {
            break;
        }
        iChCount += dev.channels.count;
        if (iChCount >= index + 1) {
            break;
        }
        i++;
    }
     /**
      CH:返回当前的通道所在的NVR是第几个设备
      En:Return which NVR is the current channel.
      */
    return (iChCount >= index + 1) ? i : -1;
}

- (NSInteger)locateDevChannelKeyIndex:(NSInteger)index
{
    int iChCount = 0;
    int i = 0;
    for (Device* dev in m_devList) {

        if (nil == dev.deviceId) {
            break;
        }
        iChCount += dev.channels.count;
        if (iChCount >= index + 1) {
            break;
        }
        i++;
    }
    
    /**
     Ch:返回当前的通道是NVR内的第几个通道
     En:Return the current channel is which channel in the NVR.
     */
    return (iChCount >= index + 1) ? (index - iChCount + ((Device*)[m_devList objectAtIndex:i]).channels.count) : -1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 设置管理员账号信息(En:Set administrator account information)
- (void)setAdminInfo:(NSString*)token protocol:(NSInteger)protocol address:(NSString*)addr port:(NSInteger)port
{
    self.m_accessToken = [token mutableCopy];
    m_strSvr = [addr mutableCopy];
    m_iPort = port;
    m_iProtocol = protocol;
}
#pragma mark - 实时播放(En:Real-time play)
- (void)onLive:(id)sender
{
    UIButton* btnLive = (UIButton*)sender;

    NSInteger devKeyIndex = [self locateDevKeyIndex:btnLive.tag];
    NSInteger chnKeyIndex = [self locateDevChannelKeyIndex:btnLive.tag];

    self.m_strDevSelected = ((Device*)[m_devList objectAtIndex:devKeyIndex]).deviceId;
    self.m_playToken = ((Device*)[m_devList objectAtIndex:devKeyIndex]).playToken;
    self.m_devAbilitySelected = ((Device*)[m_devList objectAtIndex:devKeyIndex]).ability;
    self.m_accessType = ((Device*)[m_devList objectAtIndex:devKeyIndex]).accessType;
    self.m_catalog = ((Device*)[m_devList objectAtIndex:devKeyIndex]).catalog;
    Channel *channel = ((Device*)[m_devList objectAtIndex:devKeyIndex]).channels[chnKeyIndex];
    self.m_devChnSelected = [channel.channelId integerValue];
    self.m_chnAbilitySelected = [channel.ability copy];
    self.m_imgPicSelected = [UIImage imageWithData:m_downloadPicture[btnLive.tag].picData];
    self.m_encryptKey = channel.encryptKey;
    
    
    NSLog(@"onLive device[%@],channel[%ld]", self.m_strDevSelected, (long)self.m_devChnSelected);

    UIStoryboard* currentBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LiveVideoViewController* liveVideoView = [currentBoard instantiateViewControllerWithIdentifier:@"LiveVideo"];
    [self.navigationController pushViewController:liveVideoView animated:NO];
    [liveVideoView setInfo:self.m_accessToken Dev:self.m_strDevSelected Key:self.m_encryptKey Chn:self.m_devChnSelected Img:self.m_imgPicSelected Abl:self.m_devAbilitySelected chnAbl:self.m_chnAbilitySelected  playToken:self.m_playToken  accessType:self.m_accessType catalog:self.m_catalog];
}

- (NSString *)arrayToJSONString:(NSArray *)array {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

#pragma mark - 设备录像(En:Device video)
- (void)onVideo:(id)sender
{
    UIButton* btnVideo = (UIButton*)sender;

    NSInteger devKeyIndex = [self locateDevKeyIndex:btnVideo.tag];
    NSInteger chnKeyIndex = [self locateDevChannelKeyIndex:btnVideo.tag];
    self.m_strDevSelected = ((Device*)[m_devList objectAtIndex:devKeyIndex]).deviceId;
    self.m_playToken = ((Device*)[m_devList objectAtIndex:devKeyIndex]).playToken;
    // TODO
    Channel *channel = ((Device*)[m_devList objectAtIndex:devKeyIndex]).channels[chnKeyIndex];
    self.m_devChnSelected = [channel.channelId integerValue];
    self.m_encryptKey = channel.encryptKey;
    NSString *accessType = ((Device*)[m_devList objectAtIndex:devKeyIndex]).accessType;
    NSLog(@"onLive device[%@],channel[%ld]", self.m_strDevSelected, (long)self.m_devChnSelected);

    UIStoryboard* currentBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RecordViewController* recordView = [currentBoard instantiateViewControllerWithIdentifier:@"Record"];
    [recordView setInfo:self.m_accessToken playToken:_m_playToken Dev:self.m_strDevSelected Key:self.m_encryptKey Chn:self.m_devChnSelected Type:DeviceRecord accessType:accessType];
    [self.navigationController pushViewController:recordView animated:NO];
}
#pragma mark - 云录像(En:Cloud video)
- (void)onCloud:(id)sender
{
    UIButton* btnCloudVideo = (UIButton*)sender;

    NSInteger devKeyIndex = [self locateDevKeyIndex:btnCloudVideo.tag];
    NSInteger chnKeyIndex = [self locateDevChannelKeyIndex:btnCloudVideo.tag];
    self.m_strDevSelected = ((Device*)[m_devList objectAtIndex:devKeyIndex]).deviceId;
    Channel *channel = ((Device*)[m_devList objectAtIndex:devKeyIndex]).channels[chnKeyIndex];
    self.m_playToken = ((Device*)[m_devList objectAtIndex:devKeyIndex]).playToken;
    self.m_devChnSelected = [channel.channelId integerValue];
    self.m_encryptKey = channel.encryptKey;
    NSString *accessType = ((Device*)[m_devList objectAtIndex:devKeyIndex]).accessType;
    NSLog(@"onCloud device[%@],channel[%ld]", self.m_strDevSelected, (long)self.m_devChnSelected);

    UIStoryboard* currentBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RecordViewController* recordView = [currentBoard instantiateViewControllerWithIdentifier:@"Record"];
    [recordView setInfo:self.m_accessToken playToken:_m_playToken Dev:self.m_strDevSelected Key:self.m_encryptKey Chn:self.m_devChnSelected Type:CloudRecord accessType:accessType];
    [self.navigationController pushViewController:recordView animated:NO];
}
#pragma mark - 报警消息(En:Alarm message)
- (void)onMessage:(id)sender
{
    UIButton* btnMessage = (UIButton*)sender;

    NSInteger devKeyIndex = [self locateDevKeyIndex:btnMessage.tag];
    NSInteger chnKeyIndex = [self locateDevChannelKeyIndex:btnMessage.tag];
    self.m_strDevSelected = ((Device*)[m_devList objectAtIndex:devKeyIndex]).deviceId;
    Channel *channel = ((Device*)[m_devList objectAtIndex:devKeyIndex]).channels[chnKeyIndex];
    self.m_devChnSelected = [channel.channelId integerValue];
    self.m_encryptKey = channel.encryptKey;
    UIStoryboard* currentBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    MessageViewController* msgView = [currentBoard instantiateViewControllerWithIdentifier:@"MessageView"];
    [self.navigationController pushViewController:msgView animated:NO];
    [msgView setInfo:self.m_accessToken Dev:self.m_strDevSelected Key:self.m_encryptKey Chn:self.m_devChnSelected];
}
#pragma mark - 设备设置(En:Device settings)
- (void)onSetting:(id)sender
{
    UIButton* btnSetting = (UIButton*)sender;
    NSInteger devKeyIndex = [self locateDevKeyIndex:btnSetting.tag];
    NSInteger chnKeyIndex = [self locateDevChannelKeyIndex:btnSetting.tag];
    self.m_strDevSelected = ((Device*)[m_devList objectAtIndex:devKeyIndex]).deviceId;
    Channel *channel = ((Device*)[m_devList objectAtIndex:devKeyIndex]).channels[chnKeyIndex];
    self.m_devChnSelected = [channel.channelId integerValue];
    
    UIStoryboard* currentBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DeviceOperationViewController* deviceOperationView = [currentBoard instantiateViewControllerWithIdentifier:@"DeviceOperation"];
    [deviceOperationView setInfo:self.m_hc Token:self.m_accessToken Dev:self.m_strDevSelected Chn:self.m_devChnSelected];
    [self.navigationController pushViewController:deviceOperationView animated:NO];
}
#pragma mark - 删除设备(En:Delete device)
- (void)onDelete:(id)sender
{
    UIButton* btnDetelte = (UIButton*)sender;

    NSInteger devKeyIndex = [self locateDevKeyIndex:btnDetelte.tag];
    NSInteger chnKeyIndex = [self locateDevChannelKeyIndex:btnDetelte.tag];

    [m_devLock lock];
    self.m_strDevSelected = ((Device*)[m_devList objectAtIndex:devKeyIndex]).deviceId;
    Channel *channel = ((Device*)[m_devList objectAtIndex:devKeyIndex]).channels[chnKeyIndex];
    self.m_devChnSelected = [channel.channelId integerValue];
    [m_devLock unlock];

    alertDelView = [[UIAlertView alloc] initWithTitle:@"alarm" message:@"confirm to delete?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alertDelView show];

    return;
}
#pragma mark - 添加设备(En:Add device)
- (void)onAddDevice:(id)sender
{
    UIStoryboard* currentBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    AddDeviceViewController* addDevView = [currentBoard instantiateViewControllerWithIdentifier:@"AddDeviceView"];
    [self.navigationController pushViewController:addDevView animated:NO];
    [addDevView setInfo:self.m_hc token:self.m_accessToken devView:self];
}

#pragma mark - 获取设备列表(En:Get device list)
- (void)getDevList {
    [m_devLock lock];
    [m_devList removeAllObjects];
    [m_devLock unlock];

    [m_downStatusLock lock];
    m_iPos = 0;
    m_downloadingPos = -1;
    m_conn = nil;
    for (int i = 0; i < DEV_CHANNEL_MAX * DEV_NUM_MAX; i++) {
        [m_downloadPicture[i] clearData];
    }
    [m_downStatusLock unlock];

    [self showLoading];
    m_devListView.hidden = YES;
    m_toastLab.hidden = YES;
    
    dispatch_queue_t get_devList = dispatch_queue_create("get_devList", nil);
    dispatch_async(get_devList, ^{
        NSDictionary *deviceOpenList = [NSDictionary dictionary];
        NSDictionary *deviceBaseList = [NSDictionary dictionary];
        NSDictionary *deviceOpenDetailList = [NSDictionary dictionary];
        NSDictionary *deviceBaseDetailList = [NSDictionary dictionary];
        NSString *err;
        NSString *msg;
        [m_openApi deviceOpenList:_m_accessToken bindId:-1 limit:10 type:@"bindAndShare" needApInfo:@"false" result:&deviceOpenList errcode:&err errmsg:&msg];
        [m_openApi deviceBaseList:_m_accessToken bindId:-1 limit:10 type:@"bindAndShare" needApInfo:@"false" result:&deviceBaseList errcode:&err errmsg:&msg];
        if ([deviceOpenList[@"count"] intValue] > 0) {
            [m_openApi deviceOpenDetailList:_m_accessToken deviceList:[self dealRequestDetailData:deviceOpenList] result:&deviceOpenDetailList errcode:&err errmsg:&msg];
            
        }
        if ([deviceBaseList[@"count"] intValue] > 0) {
            [m_openApi deviceBaseDetailList:_m_accessToken deviceList:[self dealRequestDetailData:deviceBaseList] result:&deviceBaseDetailList errcode:&err errmsg:&msg];
        }
        NSArray *openList =  [Device mj_objectArrayWithKeyValuesArray:deviceOpenDetailList[@"deviceList"]];
        NSArray *baseList  = [Device mj_objectArrayWithKeyValuesArray:deviceBaseDetailList[@"deviceList"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![err isEqualToString:@"0"] && openList.count == 0 && baseList.count == 0) {
                m_toastLab.text = @"GET DEVICE LIST FAILED";
                m_toastLab.hidden = NO;
                [self hideLoading];
                [self.view bringSubviewToFront:m_progressInd];
                return;
            }
            if (openList.count == 0 && baseList.count == 0) {
                m_toastLab.text = @"NO DEVICE";
                m_toastLab.hidden = NO;
                [self hideLoading];
                [self.view bringSubviewToFront:m_progressInd];
                return;
            }
            [m_devList removeAllObjects];
            [m_devList addObjectsFromArray:openList];
            [m_devList addObjectsFromArray:baseList];
            
            m_toastLab.hidden = YES;
            [self hideLoading];
            m_devListView.hidden = NO;
            [m_devListView reloadData];
            [self.view bringSubviewToFront:m_progressInd];
        });
    });
}

#pragma mark - 对话框(En:Dialog box)
- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == alertDelView) {
        if (0 == buttonIndex) {
            NSLog(@"cancel delete[%@]", self.m_strDevSelected);
            return;
        }
        else if (1 == buttonIndex) {
            [self showLoading];
            m_devListView.hidden = YES;
            dispatch_queue_t unbind_device = dispatch_queue_create("unbind_device", nil);
            dispatch_async(unbind_device, ^{
                NSString* errMsg;
                RestApiService* restApiService = [RestApiService shareMyInstance];
                [restApiService unBindDevice:self.m_strDevSelected Msg:&errMsg];
                if (![errMsg isEqualToString:[MSG_SUCCESS mutableCopy]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self hideLoading];
                        m_devListView.hidden = NO;
                        m_toastLab.text = errMsg;
                        m_toastLab.hidden = NO;
                        [self performSelector:@selector(hideToastDelay) withObject:nil afterDelay:2.0f];
                    });
                    return;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getDevList];
                });
            });
        }
    }
    if (alertView == alertDecryptView) {
        if (0 == buttonIndex) {
            return;
        }
        if (1 == buttonIndex) {
            Channel *chanenl = ((Device*)[m_devList objectAtIndex:m_devKeyIndex]).channels[m_chnKeyIndex];
            
            chanenl.encryptKey = [[alertView textFieldAtIndex: 0] text];
            [m_devLock unlock];
            [m_devListView reloadData];
            m_devListView.hidden = NO;
            return;
        }
    }
}

- (NSArray *)dealRequestDetailData:(NSDictionary *)dic {
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *deviceList = dic[@"deviceList"];
    if (deviceList.count > 0) {
        for (int i = 0; i < deviceList.count && i < 8; i++) {
            NSArray *channels = deviceList[i][@"channels"];
            NSString *channelList;
            for (int j = 0; j < channels.count; j++) {
                NSString *chnanelId = channels[j][@"channelId"];
                if (j == 0) {
                      channelList = [NSString stringWithFormat:@"%@",  chnanelId];
                }
                else {
                    channelList = [NSString stringWithFormat:@"%@,%@",  channelList, chnanelId];
                }
              
            }
            NSString *deviceId = deviceList[i][@"deviceId"];
            if (channelList.length > 0 ) {
                NSDictionary *resultDic = @{ @"deviceId" : deviceId, @"channelList": channelList};
                [arr addObject: resultDic];
            }
            
        }
    }
    return arr;
}


- (NSString *)dictionaryToJSONString:(NSDictionary *)dictionary

{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

#pragma mark - 延时隐藏toast(En:Delay hiding toast)
- (void)hideToastDelay
{
    m_toastLab.hidden = YES;
}
#pragma mark - 封面图片下载线程(En:Cover image download thread)
- (void)downloadThread
{
    m_iPos = 0;
    m_downloadingPos = -1;
    int j;
    while (m_looping) {
        usleep(20 * 1000);
        BOOL bNeedDown = YES;
        NSString* picUrl;

        [m_devLock lock];
        [m_downStatusLock lock];
        NSInteger iDevKey = [self locateDevKeyIndex:m_iPos];
        NSInteger iChnKey = [self locateDevChannelKeyIndex:m_iPos];
        do {
            picUrl = nil;
            if (iDevKey < 0 || iChnKey < 0) {
                bNeedDown = NO;
                m_iPos = (m_iPos + 1) % (DEV_CHANNEL_MAX * DEV_NUM_MAX);
                break;
            }

            for (j = 0; j < DEV_CHANNEL_MAX * DEV_NUM_MAX; j++) {
                if (DOWNLOADING == m_downloadPicture[j].downStatus) {
                    break;
                }
            }
            if (j < DEV_CHANNEL_MAX * DEV_NUM_MAX) {
                bNeedDown = NO;
                break;
            }
            if (NONE != m_downloadPicture[m_iPos].downStatus) {
                bNeedDown = NO;
                m_iPos = (m_iPos + 1) % (DEV_CHANNEL_MAX * DEV_NUM_MAX);
                break;
            }
            
            if([m_devList count]>0){
                Channel *channel = ((Device*)[m_devList objectAtIndex:iDevKey]).channels[iChnKey];
                picUrl = [channel.picUrl copy];
            }
        } while (0);

        [m_devLock unlock];
        if (!bNeedDown || !picUrl) {
            [m_downStatusLock unlock];
            continue;
        }

        //download
        m_httpUrl = [NSURL URLWithString:picUrl];

        //[m_downStatusLock lock];
        m_downloadPicture[m_iPos].downStatus = DOWNLOADING;
        //[m_downStatusLock unlock];
        m_downloadingPos = m_iPos;
        m_iPos = (m_iPos + 1) % (DEV_CHANNEL_MAX * DEV_NUM_MAX);
        
        [m_devLock unlock];

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
            if([m_devList count]>0){
                if ([((Device*)[m_devList objectAtIndex:iDevKey]).accessType  isEqualToString:@"PaaS"]) {
                    NSData* dataOut = [[NSData alloc] init];
                    Channel *channel = ((Device*)[m_devList objectAtIndex:iDevKey]).channels[iChnKey];
                    NSInteger iret = [m_util decryptPic:data deviceID:((Device*)[m_devList objectAtIndex:iDevKey]).deviceId key:channel.encryptKey token:_m_accessToken  bufOut:&dataOut];
                    if (0 == iret) {
                        [m_downloadPicture[m_downloadingPos] setData:dataOut status:DOWNLOAD_FINISHED];
                    }
                } else {
                    [m_downloadPicture[m_downloadingPos] setData:data status:DOWNLOAD_FINISHED];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [m_devListView reloadData];
            });
        }
        [m_downStatusLock unlock];
    }
}
#pragma mark - 结束图片下载线程(En:End picture download thread)
- (void)destroyThread
{
    m_looping = NO;
}
#pragma mark - 滚动轮指示器(En:Scroll wheel indicator)

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

- (void)dealloc{
      NSLog(@"%@ %s", [self class], __func__);
}

@end
