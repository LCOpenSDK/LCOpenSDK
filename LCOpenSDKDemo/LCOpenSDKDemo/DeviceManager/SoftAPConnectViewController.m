//
//  testView.m
//  LCOpenSDKDemo
//
//  Created by Fizz on 2019/5/31.
//  Copyright © 2019 lechange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SoftAPConnectViewController.h"
#import "UIAlertController+supportedInterfaceOrientations.h"
#import "LCOpenSDK_Prefix.h"
#import "AddDeviceViewController.h"

typedef void(^ApConfigCallBack)();

typedef NS_ENUM(NSInteger, DeviceListState) {
    Normal = 0,
    HasChanged,
};

@interface SoftAPConnectViewController()
{
    LCOpenSDK_SoftAP* m_softAP;
    LCOpenSDK_DeviceInit* m_deviceInit;
    DeviceListState deviceListState;
    NSString        *m_initKey;
}
@end

@implementation SoftAPConnectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UINavigationItem* item = [[UINavigationItem alloc] initWithTitle:NSLocalizedString(ADD_DEVICE_TITLE_TXT, nil)];

    UIButton* left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(0, 0, 50, 30)];
    UIImage* imgLeft = [UIImage leChangeImageNamed:Back_Btn_Png];

    [left setBackgroundImage:imgLeft forState:UIControlStateNormal];
    [left addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc] initWithCustomView:left];
    [item setLeftBarButtonItem:leftBtn animated:NO];
    [super.m_navigationBar pushNavigationItem:item animated:NO];
    
    [self.view addSubview:super.m_navigationBar];
    
    self.m_lblHint.layer.masksToBounds = YES;
    self.m_lblHint.numberOfLines = 0;
    self.m_lblHint.textAlignment = NSTextAlignmentCenter;
    
    [self.m_softAPConnect setTitle:NSLocalizedString(SOFTAP_CONNECT_TXT, nil) forState:UIControlStateNormal];
    [self.m_bindDevice setTitle:NSLocalizedString(BIND_DEVICE_TXT, nil) forState:UIControlStateNormal];
    
    self.m_SoftAPInstructLab1.text = NSLocalizedString(OPEN_DEVICE_HOTSPOT_TXT, nil);
    self.m_SoftAPInstructLab2.text = NSLocalizedString(CONNECT_DEVICE_HOTSPOT_TXT, nil);
    self.m_SoftAPInstructLab3.text = NSLocalizedString(START_SOFTAP_CONNECT_TXT, nil);
    self.m_SoftAPInstructLab4.text = NSLocalizedString(INPUT_POPWIN_INFO_TXT, nil);
    self.m_SoftAPInstructLab5.text = NSLocalizedString(CHANGE_WIFI_TXT, nil);
    self.m_SoftAPInstructLab6.text = NSLocalizedString(START_BIND_DEVICE_TXT, nil);

}

- (void)restApiBind:(NSString*)devId deviceKey:(NSString*)devKey
{
    RestApiService* restApiService = [RestApiService shareMyInstance];
    __block NSString* errMsg;
    
    self.m_lblHint.text = @"check device bind or not...";
    [restApiService checkDeviceBindOrNot:devId Msg:&errMsg];
    if (![errMsg isEqualToString:[MSG_DEVICE_NOT_BIND mutableCopy]]) {
        self.m_lblHint.text = errMsg;
        return;
    }
    
    self.m_lblHint.text = @"check device online or not...";
    time_t lBegin, lCur;
    NSInteger lTimeout = 60;
    time(&lBegin);
    lCur = lBegin;
    BOOL bOnline = NO;
    while (lCur >= lBegin && lCur - lBegin < lTimeout) {
        [restApiService checkDeviceOnline:devId Msg:&errMsg];
        if ([errMsg isEqualToString:[MSG_DEVICE_ONLINE mutableCopy]]) {
            bOnline = YES;
            break;
        }
        else if ([errMsg isEqualToString:[MSG_DEVICE_OFFLINE mutableCopy]]) {
            NSString* hintLabelText = [NSLocalizedString(WAIT_TIME_TXT, nil) stringByAppendingFormat:@"%ld", lCur - lBegin];
            hintLabelText = [hintLabelText stringByAppendingString:NSLocalizedString(SECOND_TXT, nil)];
            self.m_lblHint.text = hintLabelText;
            usleep(5 * 1000 * 1000);
            time(&lCur);
            continue;
        }
        else {
            self.m_lblHint.text = errMsg;
            return;
        }
    }
    if (NO == bOnline) {
        self.m_lblHint.text = NSLocalizedString(DEVICE_OFFLINE_TXT, nil);
        return;
    }
    
    // China
    NSString* devAbility = nil;
    [restApiService unBindDeviceInfo:devId Ability:&devAbility Msg:&errMsg];
    if ([NSLocalizedString(LANGUAGE_TXT, nil) isEqualToString:@"zh"]) {
        if (![errMsg isEqualToString:[MSG_SUCCESS mutableCopy]]) {
            self.m_lblHint.text = errMsg;
            return;
        }
        if ([devAbility rangeOfString:@"SCCode"].location != NSNotFound) {
            [restApiService bindDevice:devId Code:_m_deviceKey Msg:&errMsg];
            if (![errMsg isEqualToString:[MSG_SUCCESS mutableCopy]]) {
                self.m_lblHint.text = errMsg;
                return;
            }
            self.m_lblHint.text = NSLocalizedString(BIND_SUCCESS_TXT, nil);
            deviceListState = HasChanged;
        }
        else if ([devAbility rangeOfString:@"Auth"].location != NSNotFound) {
            [restApiService bindDevice:devId Code:devKey Msg:&errMsg];
            if (![errMsg isEqualToString:[MSG_SUCCESS mutableCopy]]) {
                self.m_lblHint.text = errMsg;
                return;
            }
            self.m_lblHint.text = NSLocalizedString(BIND_SUCCESS_TXT, nil);
            deviceListState = HasChanged;
        }
        else if ([devAbility rangeOfString:@"RegCode"].location != NSNotFound) {
            [self alertToSetDeviceKeyTitle:@"Please Input Device ID" apConfigCallBack:^{
                [restApiService bindDevice:devId Code:_m_deviceKey Msg:&errMsg];
                if (![errMsg isEqualToString:[MSG_SUCCESS mutableCopy]]) {
                    self.m_lblHint.text = errMsg;
                    return;
                }
                self.m_lblHint.text = NSLocalizedString(BIND_SUCCESS_TXT, nil);
                deviceListState = HasChanged;
            }];
        }
        else
        {
            [restApiService bindDevice:devId Code:@"" Msg:&errMsg];
            if (![errMsg isEqualToString:[MSG_SUCCESS mutableCopy]]) {
                self.m_lblHint.text = errMsg;
                return;
            }
            self.m_lblHint.text = NSLocalizedString(BIND_SUCCESS_TXT, nil);
            deviceListState = HasChanged;
        }
    }
    // oversea
    else
    {
        if ([devAbility rangeOfString:@"SCCode"].location != NSNotFound) {
              [restApiService bindDevice:devId Code:_m_deviceKey Msg:&errMsg];
        }
        else {
              [restApiService bindDevice:devId Code:devKey Msg:&errMsg];
        }
        if (![errMsg isEqualToString:[MSG_SUCCESS mutableCopy]]) {
            self.m_lblHint.text = errMsg;
            return;
        }
        self.m_lblHint.text = NSLocalizedString(BIND_SUCCESS_TXT, nil);
        deviceListState = HasChanged;
    }
}

- (void)initDevice:(int)timeout
{
    NSString *deviceID = _m_deviceId;
    NSLog(@"LCOpen_SoftAP deviceID[%s]\n", [deviceID UTF8String]);
    if (!deviceID || 0 == deviceID.length || [deviceID isEqualToString:NSLocalizedString(DEVICE_ID_TIP_TXT, nil)]) {
        self.m_lblHint.text = NSLocalizedString(DEVICE_ID_TIP_TXT, nil);
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.m_lblHint.text = @"Searching device...";
    });
    __block NSString *theMac = nil;
    __block NSString *theIp = nil;
    __block int thePort = 0;
    __block int theInitStatus = 0;
    __block LCOpenSDK_DeviceInit *deviceInit = [[LCOpenSDK_DeviceInit alloc] init];
    [deviceInit searchDeviceInitInfo:deviceID timeOut:timeout success:^(LCOPENSDK_DEVICE_INIT_INFO info) {
        theMac = [NSString stringWithUTF8String:info.mac];
        theIp = [NSString stringWithUTF8String:info.ip];
        thePort = info.port;
        theInitStatus = info.status;
    }];
    if (!theMac || !theIp) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.m_lblHint.text = @"Search device init info failed!";
        });
        return;
    }
    
    if (0 == theInitStatus && [NSLocalizedString(LANGUAGE_TXT, nil) isEqualToString:@"zh"]) {
        /**
        Ch:基于“不支持设备初始化的设备肯定也不支持Auth能力集”的断定
        En:Based on the conclusion that "devices that do not support device initialization certainly do not support the Auth capability set"
        */
        dispatch_async(dispatch_get_main_queue(), ^{
            self.m_lblHint.text = @"Bind device...";
            [self restApiBind:deviceID deviceKey:nil];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            //NSString* alertControllerTitle = nil;
            /*if (1 == theInitStatus) {
                alertControllerTitle = @"Please Input Device Init Key";
            }
            else {
                alertControllerTitle = @"Please Input Device Key";
            }
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:alertControllerTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:nil];
            UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action) {
                NSString* deviceKey = alert.textFields[0].text;*/
            
                NSString* deviceKey = _m_deviceKey;
            
                if (1 == theInitStatus) {
                    self.m_lblHint.text = @"try multicast init device...";
                    int ret = [deviceInit initDevice:theMac password:deviceKey];
                    if (-2 == ret) {
                        self.m_lblHint.text = @"try unicast init device...";
                        int ret = [deviceInit initDevice:theMac password:deviceKey ip:theIp];
                        if (-2 == ret) {
                            self.m_lblHint.text = @"Init device failed!";
                            return;
                        }
                        else{
                            self.m_lblHint.text = @"unicast init device succeed!";
                        }
                    }
                    else{
                        self.m_lblHint.text = @"multicast init device succeed!";
                    }
                } else if ((0 == theInitStatus || 2 == theInitStatus) && [NSLocalizedString(LANGUAGE_TXT, nil) isEqualToString:@"en"]) {
                    if (!deviceKey || 0 == deviceKey.length || [deviceKey isEqualToString:NSLocalizedString(DEVICE_KEY_TIP_TXT, nil)]) {
                        self.m_lblHint.text = NSLocalizedString(DEVICE_KEY_TIP_TXT, nil);
                        return;
                    }
                    self.m_lblHint.text = @"Check device password...";
                    int ret = [deviceInit checkPwdValidity:deviceID ip:theIp port:thePort password:deviceKey];
                    if (0 != ret) {
                        self.m_lblHint.text = @"Check device password failed!";
                        return;
                    }
                    else{
                        self.m_lblHint.text = @"Check device password succeed!";
                    }
                }
                
                [self restApiBind:deviceID deviceKey:deviceKey];
           // }];
            /*UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:confirmAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];*/
        });
    }
}

-(void)onBtn:(id)sender
{
    /**
     Ch:
     软Ap配网，SC设备平台初始化, 非SC设备需要判断是国内设备或海外设备以及初始化状态：
     1.如果是国内设备，初始化状态为0，那么不需要初始化和鉴权；
     2.如果是国内设备，初始化状态为1 或者 2，那么需要初始化和鉴权；
     3.如果是国外设备，初始化状态为1，需要初始化。
     4.如果是国外设备，不管初始化状态为是什么，都需要鉴权。
     En:Soft Ap distribution network, SC device platform initialization, non-SC device needs to determine whether it is domestic equipment or overseas equipment and the initialization status.
     1.If it is a domestic device and the initialization status is 0, then initialization and authentication are not required.
     2.If it is a domestic device and the initialization status is 1 or 2, then initialization and authentication are required.
     3.If it is a foreign device, the initialization status is 1, and initialization is required.
     4.If it is a foreign device, no matter what the initialization status is, authentication is required.
     */
    
    BOOL isSC = _m_deviceKey.length == 8;
    if (!isSC) {
        if(!m_deviceInit){
            m_deviceInit = [[LCOpenSDK_DeviceInit alloc] init];
        }
        [m_deviceInit searchDeviceInitInfo:_m_deviceId timeOut:10*1000 success:^(LCOPENSDK_DEVICE_INIT_INFO info) {
            _m_initDevStatus = info.status;
            NSLog(@"sqtest _m_initDevStatus[%ld]\n", (long)_m_initDevStatus);
        }];
    }
    if(!m_softAP){
        m_softAP = [[LCOpenSDK_SoftAP alloc] init];
    }
    static NSInteger softAPResult = -1;
    
    if ([NSLocalizedString(LANGUAGE_TXT, nil) isEqualToString:@"zh"]) {
        if (0 == _m_initDevStatus || isSC) {
            /**
             Ch:不需要初始化的密码传admin，目前只有国内K5设备
             En:No need to initialize the password to pass admin, currently only domestic K5 lock.
             */
            softAPResult = [m_softAP startSoftAPConfig:_m_wifiName wifiPwd:_m_wifiPwd deviceId:_m_deviceId devicePwd:@"admin" isSC:isSC];
        }
        else {
            [self alertToSetDeviceKeyTitle:@"Please Input Device Init Key" apConfigCallBack:^{
                softAPResult = [m_softAP startSoftAPConfig:_m_wifiName wifiPwd:_m_wifiPwd deviceId:_m_deviceId devicePwd:m_initKey isSC:isSC];
            }];
        }
    }
    else {
        if (isSC) {
            softAPResult = [m_softAP startSoftAPConfig:_m_wifiName wifiPwd:_m_wifiPwd deviceId:_m_deviceId devicePwd:@"" isSC:isSC];
        }
        else{
            [self alertToSetDeviceKeyTitle:@"Please Input Device Init Key" apConfigCallBack:^{
                softAPResult = [m_softAP startSoftAPConfig:_m_wifiName wifiPwd:_m_wifiPwd deviceId:_m_deviceId devicePwd:m_initKey isSC:isSC];
            }];
        }
    }
    return;
}

- (void)alertToSetDeviceKeyTitle:(NSString *)title  apConfigCallBack:(ApConfigCallBack)apConfigCallBack {
    BOOL isInit = [title containsString:@"Init"];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:nil];
    UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action){
        if (isInit) {
            m_initKey = alert.textFields[0].text;
            if (!m_initKey || 0 == m_initKey.length) {
                NSLog(@"sqtest m_initKey has not been input");
                return;
            }
        }
        else {
            _m_deviceKey = alert.textFields[0].text;
            if (!_m_deviceKey || 0 == _m_deviceKey.length) {
                NSLog(@"sqtest m_deviceKey has not been input");
                return;
            }
        }
        
        apConfigCallBack();
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:confirmAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(IBAction)onBack:(UIStoryboardSegue *)sender
{
    NSLog(@"sqtest onBack");
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
    return;
}

-(IBAction)onBindDeivce:(id)sender
{
    [self restApiBind:_m_deviceId deviceKey:m_initKey ?: @""];
}

@end
