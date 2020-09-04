//
//  DeviceOperationViewController.m
//  LCOpenSDKDemo
//
//  Created by mac318340418 on 16/7/18.
//  Copyright © 2016年 lechange. All rights reserved.
//

#import "DeviceOperationViewController.h"
#import "LCOpenSDK_Prefix.h"
#import "RestApiService.h"
#import "OpenApiService.h"

typedef NS_ENUM(NSInteger, Upgrade_Status)
{
    Complete = 0,
    Download,
    Update,
    Reboot,
};

@interface DeviceOperationViewController ()
{
    NSTimer* mTimer;
    Upgrade_Status mDeviceUpgradeProcess;
    OpenApiService* openApi;
}

@end

@implementation DeviceOperationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initWindowView];
    openApi = [[OpenApiService alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getChnStatus];
}

- (void)initWindowView
{

    UINavigationItem* item = [[UINavigationItem alloc] initWithTitle:NSLocalizedString(DEVICE_OPERATE_TITLE_TXT, nil)];
    super.m_navigationBar.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

    UIButton* left = [UIButton buttonWithType:UIButtonTypeCustom];
    //left.backgroundColor = [UIColor whiteColor];
    [left setFrame:CGRectMake(0, 0, 50, 30)];
    UIImage* img = [UIImage leChangeImageNamed:Back_Btn_Png];

    [left setBackgroundImage:img forState:UIControlStateNormal];
    [left addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc] initWithCustomView:left];
    [item setLeftBarButtonItem:leftBtn animated:NO];
    [super.m_navigationBar pushNavigationItem:item animated:NO];

    [self.view addSubview:super.m_navigationBar];
    [self.m_alarmLab setText:NSLocalizedString(ALARM_PLAN_TXT, nil)];
    [self.m_cloudStorageLab setText:NSLocalizedString(CLOUD_STORAGE_TXT, nil)];
    //[self.m_passwordLab setText:NSLocalizedString(PASSWORD_TXT, nil)];
    self.m_passwordLab.hidden = YES;
    [self.m_upgradeLab setText:NSLocalizedString(DEVICE_PROGRAME_TXT, nil)];
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
    self.m_viewAlarm.hidden = YES;
    self.m_viewCloudStroge.hidden = YES;
    self.m_viewPassword.hidden = YES;
    self.m_viewUpgrade.hidden = YES;
    m_toastLab.hidden = YES;
    self.m_alarmActivity.hidden = YES;
    [self.m_alarmActivity startAnimating];
    self.m_cloudStorageActivity.hidden = YES;
    [self.m_cloudStorageActivity startAnimating];
    self.m_passwordActivity.hidden = YES;
    [self.m_passwordActivity startAnimating];
    self.m_upgradeActivity.hidden = YES;
    [self.m_upgradeActivity startAnimating];

    //[self.m_passwordBtn setTitle:NSLocalizedString(MODIFY_TXT, nil) forState:UIControlStateNormal];
    self.m_passwordBtn.hidden = YES;
    [self.m_upgradeBtn setTitle:NSLocalizedString(UPGRADE_TXT, nil) forState:UIControlStateNormal];
    mDeviceUpgradeProcess = Complete;
    mTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onSmsTimer:) userInfo:nil repeats:YES];
}

- (void)onSmsTimer:(NSInteger)index
{
    if (mDeviceUpgradeProcess != Complete) {
        RestApiService *restApiService = [RestApiService shareMyInstance];
        DeviceUpgradeProcess *upgradeProcess = [[DeviceUpgradeProcess alloc] init];
        /**
        Ch:显示查询到的设备升级状态，并修改升级状态
        En:Display the queried device upgrade status, and modify the upgrade status.
        */
        [restApiService upgradeProcessDevice:m_strDevSelected Msg:nil InfoOut:upgradeProcess];
    }
}

- (void)setInfo:(LCOpenSDK_Api*)hc Token:(NSString*)token Dev:(NSString*)deviceId Chn:(NSInteger)chn
{
    m_hc = hc;
    m_accessToken = [token mutableCopy];
    m_strDevSelected = [deviceId mutableCopy];
    m_devChnSelected = chn;
}

- (IBAction)onAlarmPlan:(UISwitch*)sender
{
    self.m_alarmActivity.hidden = NO;
    RestApiService* restApiService = [RestApiService shareMyInstance];
    if (ALARM_ON == m_alarmStatus) {
        m_alarmStatus = ALARM_OFF;
        dispatch_queue_t alarmPlanTrue = dispatch_queue_create("alarmPlanFalse", nil);
        dispatch_async(alarmPlanTrue, ^{
            NSString* errMsg;
            [restApiService modifyDeviceAlarmStatus:m_strDevSelected Chnl:m_devChnSelected Enable:false Msg:&errMsg];
            if (![errMsg isEqualToString:[MSG_SUCCESS mutableCopy]]) {
                m_alarmStatus = ALARM_ON;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.m_alarmActivity.hidden = YES;
                [self setAlarmSwitch:m_alarmStatus];
            });
        });
    } else if (ALARM_OFF == m_alarmStatus) {
        m_alarmStatus = ALARM_ON;
        dispatch_queue_t alarmPlanTrue = dispatch_queue_create("alarmPlanTrue", nil);
        dispatch_async(alarmPlanTrue, ^{
            NSString* errMsg;
            [restApiService modifyDeviceAlarmStatus:m_strDevSelected Chnl:m_devChnSelected Enable:true Msg:&errMsg];
            if (![errMsg isEqualToString:[MSG_SUCCESS mutableCopy]]) {
                m_alarmStatus = ALARM_OFF;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.m_alarmActivity.hidden = YES;
                [self setAlarmSwitch:m_alarmStatus];
            });
        });
    }
}

- (IBAction)onStorageStrategy:(UISwitch*)sender
{
    self.m_cloudStorageActivity.hidden = NO;
    RestApiService* restApiService = [RestApiService shareMyInstance];
    if (STORAGE_ON == m_cldStrgStatus) {
        m_cldStrgStatus = STORAGE_BREAK_OFF;
        dispatch_queue_t downQueue = dispatch_queue_create("storageStrategyOff", nil);
        dispatch_async(downQueue, ^{
            NSString* errMsg;
            [restApiService setStorageStrategy:m_strDevSelected Chnl:m_devChnSelected Enable:@"off" Msg:&errMsg];
            if (![errMsg isEqualToString:[MSG_SUCCESS mutableCopy]]) {
                m_cldStrgStatus = STORAGE_ON;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.m_cloudStorageActivity.hidden = YES;
                [self setCloudStorageSwitch:m_cldStrgStatus];
            });
        });
    } else if (STORAGE_NOT_OPEN == m_cldStrgStatus || STORAGE_USELESS == m_cldStrgStatus || STORAGE_BREAK_OFF == m_cldStrgStatus) {
        m_cldStrgStatus = STORAGE_ON;
        dispatch_queue_t storageStrategyOn = dispatch_queue_create("storageStrategyOn", nil);
        dispatch_async(storageStrategyOn, ^{
            NSString* errMsg;
            [restApiService setStorageStrategy:m_strDevSelected Chnl:m_devChnSelected Enable:@"on" Msg:&errMsg];
            if (![errMsg isEqualToString:[MSG_SUCCESS mutableCopy]]) {
                m_cldStrgStatus = STORAGE_BREAK_OFF;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.m_cloudStorageActivity.hidden = YES;
                [self setCloudStorageSwitch:m_cldStrgStatus];
            });
        });
    }
}
- (IBAction)onModifyPassword:(id)sender
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"modify device password" message:@"confirm to modify?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField* _Nonnull textField) {
        textField.placeholder = @"old password";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField* _Nonnull textField) {
        textField.placeholder = @"new password";
    }];
    UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action) {

        NSString* oldPassword = alert.textFields[0].text;
        NSString* newPassword = alert.textFields[1].text;
        RestApiService* apiService = [RestApiService shareMyInstance];
        NSLog(@"old password: %@", oldPassword);
        NSLog(@"new password: %@", newPassword);
        if (!oldPassword || 0 == oldPassword.length || !newPassword || 0 == newPassword.length) {
            m_toastLab.text = @"check password valid";
            m_toastLab.hidden = NO;
            [self performSelector:@selector(hideToastDelay) withObject:nil afterDelay:3.0f];
            return;
        }
        self.m_passwordActivity.hidden = NO;
        dispatch_queue_t modifyDevicePwdQueue = dispatch_queue_create("modifyDevicePwd", nil);
        dispatch_async(modifyDevicePwdQueue, ^{
            NSString* errMsg;
            [apiService modifyDevicePwd:m_strDevSelected oldPwd:oldPassword newPwd:newPassword Msg:&errMsg];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([errMsg isEqualToString:[MSG_SUCCESS mutableCopy]]) {
                    m_toastLab.text = @"modify password successfully";
                } else {
                    m_toastLab.text = @"modify password failed";
                }
                m_toastLab.hidden = NO;
                self.m_passwordActivity.hidden = YES;
                [self performSelector:@selector(hideToastDelay) withObject:nil afterDelay:3.0f];
            });
        });
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:confirmAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)onUpgradeDevice:(id)sender {
    self.m_upgradeActivity.hidden = NO;
    RestApiService* apiService = [RestApiService shareMyInstance];
    dispatch_queue_t upgradeDeviceQueue = dispatch_queue_create("upgradeDevice", nil);
    dispatch_async(upgradeDeviceQueue, ^{
        NSString* errMsg;
        [apiService upgradeDevice:m_strDevSelected Msg:&errMsg];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([errMsg isEqualToString:[MSG_SUCCESS mutableCopy]]) {
                m_toastLab.text = @"upgrade successfully";
            } else {
                m_toastLab.text = @"upgrade failed";
            }
            m_toastLab.hidden = NO;
            self.m_upgradeActivity.hidden = YES;
            [self performSelector:@selector(hideToastDelay) withObject:nil afterDelay:3.0f];
        });
    });
}

- (void)hideToastDelay
{
    m_toastLab.hidden = YES;
}

- (void)onBack
{
    [mTimer invalidate];
    [openApi cancelRequest];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setAlarmSwitch:(AlarmStatus)status
{
    switch (status) {
    case ALARM_ON:
        [self.m_alarmSwitch setOn:YES];
        break;
    case ALARM_OFF:
        [self.m_alarmSwitch setOn:NO];
        break;
    default:
        break;
    }
}

- (void)setCloudStorageSwitch:(CloudStorageStatus)status
{
    switch (status) {
    case STORAGE_ON:
        [self.m_cloudStorageSwitch setOn:YES];
        break;
    case STORAGE_BREAK_OFF:
    case STORAGE_NOT_OPEN:
    case STORAGE_USELESS:
        [self.m_cloudStorageSwitch setOn:NO];
        break;
    default:
        break;
    }
}

- (void)getChnStatus
{
    [self showLoading];
    dispatch_queue_t get_status = dispatch_queue_create("get_status", nil);
    dispatch_async(get_status, ^{
        int alarmStatus = 0;
        int cloudStatus = 0;
        int updateStatus = 0;
        NSString *err;
        NSString *msg;
        
        do {
            NSInteger ret;
            ret = [openApi alarmStatus:m_accessToken deviceId:m_strDevSelected channelId:[NSString stringWithFormat:@"%@", @(m_devChnSelected)] status:&alarmStatus errcode:&err errmsg:&msg];
            if (![err isEqualToString:@"0"]) {
                break;
            }
            ret = [openApi cloudStatus:m_accessToken deviceId:m_strDevSelected channelId:[NSString stringWithFormat:@"%@", @(m_devChnSelected)] status:&cloudStatus errcode:&err errmsg:&msg];
            if (![err isEqualToString:@"0"]) {
                break;
            }
            ret = [openApi updateStatus:m_accessToken deviceId:m_strDevSelected status:&updateStatus errcode:&err errmsg:&msg];
        } while (0);
        
        if (![err isEqualToString:@"0"]) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self hideLoading];
                m_toastLab.text = msg;
                m_toastLab.hidden = NO;
            });
            return;
        }
        m_alarmStatus = alarmStatus;
        m_cldStrgStatus = cloudStatus;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _m_upgradeBtn.hidden = (updateStatus == 0);
            [self setAlarmSwitch:m_alarmStatus];
            [self setCloudStorageSwitch:m_cldStrgStatus];
            [self hideLoading];
            self.m_viewAlarm.hidden = NO;
            self.m_viewCloudStroge.hidden = NO;
            self.m_viewPassword.hidden = NO;
            self.m_viewUpgrade.hidden = NO;
        });
    });
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
   NSLog(@"DeviceOperationViewController dealloc");
}
@end
