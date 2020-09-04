//
//  HintViewController.m
//  LCOpenSDKDemo
//
//  Created by chenjian on 16/7/11.
//  Copyright (c) 2016年 lechange. All rights reserved.
//
#import "LCOpenSDK_Prefix.h"
#import "DeviceViewController.h"
#import "AddDeviceViewController.h"
#import "SoftAPConnectViewController.h"
#import <Foundation/Foundation.h>
#import <SystemConfiguration/CaptiveNetwork.h>

typedef NS_ENUM(NSInteger, DeviceListState) {
    Normal = 0,
    HasChanged,
};

@interface AddDeviceViewController () {
    LCOpenSDK_ConfigWIfi* m_configWifi;
    id info;

    id devView;
    DeviceListState deviceListState;
    LCOpenSDK_SoftAP* m_SoftAP;
    SoftAPConnectViewController* m_softAPView;
    NSString *m_deviceId;
    NSString *m_deviceKey;
    NSString *m_wifiPassword;
}
@end

@implementation AddDeviceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    [self.m_btnWifi setImage:[UIImage leChangeImageNamed:AddDevice_Wifi_Png] forState:UIControlStateNormal];
    [self.m_btnWired setImage:[UIImage leChangeImageNamed:AddDevice_Wired_Png] forState:UIControlStateNormal];
    [self.m_btnSoftAP setImage:[UIImage leChangeImageNamed:AddDevice_SoftAp_Png] forState:UIControlStateNormal];
    deviceListState = Normal;
    self.m_lblHint.layer.masksToBounds = YES;
    self.m_lblHint.numberOfLines = 0;
    
    self.m_lblDeviceSN.text = NSLocalizedString(DEVICE_ID_TXT, nil);
    self.m_lblDeviceKey.text = NSLocalizedString(DEVICE_SCCODE_TXT, nil);
    self.m_lblSsid.text = NSLocalizedString(WIFI_PASSWORD_TIP_TXT, nil);
    
    self.m_textSerial.text = NSLocalizedString(DEVICE_ID_TIP_TXT, nil);
    self.m_textSerial.delegate = self;
    self.m_textSerial.clearButtonMode = UITextFieldViewModeWhileEditing;
    

    self.m_textDeviceKey.text = NSLocalizedString(DEVICE_KEY_TIP_TXT, nil);
    self.m_textDeviceKey.delegate = self;
    self.m_textDeviceKey.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.m_textPasswd.text = NSLocalizedString(WIFI_PASSWORD_TIP_TXT, nil);
    self.m_textPasswd.delegate = self;
    self.m_textPasswd.clearButtonMode = UITextFieldViewModeWhileEditing;
    

    CFArrayRef __nullable interface = CNCopySupportedInterfaces();
    for (NSString* interf in (__bridge id)interface) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interf));
        if (info && [info count]) {
            break;
        }
    }
    

    NSString* sID = @"SSID:";
    if (nil == info[@"SSID"] || 0 == [info[@"SSID"] length]) {
        return;
    }
    self.m_lblSsid.text = [sID stringByAppendingString:info[@"SSID"]];

    m_configWifi = [[LCOpenSDK_ConfigWIfi alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)onBack:(id)sender
{
    [m_configWifi configWifiStop];
    if (HasChanged == deviceListState) {
        [(DeviceViewController*)devView getDevList];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - 设置变量(En:Set variable)
- (void)setInfo:(LCOpenSDK_Api*)hc token:(NSString*)token devView:(id)view
{
    m_hc = hc;
    m_strAccessToken = [token mutableCopy];
    devView = view;
}

#pragma mark - Wifi配网(En:Wifi distribution network)
- (void)onWifi:(id)sender
{
    [_m_textSerial resignFirstResponder];
    [_m_textDeviceKey resignFirstResponder];
    [_m_textPasswd resignFirstResponder];
    NSLog(@"[%@][%@][%@]", m_deviceId, info[@"SSID"], m_wifiPassword);
    if (nil == m_deviceId || 0 == m_deviceId || [m_deviceId isEqualToString:NSLocalizedString(DEVICE_ID_TIP_TXT, nil)]) {
        self.m_lblHint.text = NSLocalizedString(DEVICE_ID_TIP_TXT, nil);
        return;
    }
    
    /**
     Ch:配网前检查设备是否被绑定过，以免配好网后才知道设备被绑定过.
     En:Check whether the device is bound before network configuration, so as not to know that the device is bound after the network is configured.
     */
    RestApiService* restApiService = [RestApiService shareMyInstance];
    __block NSString* errMsg;
    
    self.m_lblHint.text = @"check device bind or not...";
    [restApiService checkDeviceBindOrNot:m_deviceId Msg:&errMsg];
    if (![errMsg isEqualToString:[MSG_DEVICE_NOT_BIND mutableCopy]]) {
        if([NSLocalizedString(LANGUAGE_TXT, nil) isEqualToString:@"zh"]){
            self.m_lblHint.text = errMsg;
        }
        else{
            self.m_lblHint.text = @"device has been bound by others";
        }
        return;
    }
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(INSTRUCTION_TIP_TXT, nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action) {
        self.m_lblHint.text = @"smartconfig...";
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSInteger iRet = [m_configWifi configWifiStart:m_deviceId
                                                      ssid:info[@"SSID"]
                                                  password:m_wifiPassword
                                                    secure:m_deviceKey ?: @""
                                                 voiceFreq:11000];
            if (iRet < 0) {
                NSLog(@"smartconfig failed\n");
                return;
            }
            
            __block NSString *theMac = nil;
            __block NSString *theIp = nil;
            __block int thePort = 0;
            __block int theInitStatus = 0;
            LCOpenSDK_DeviceInit *deviceInit = [[LCOpenSDK_DeviceInit alloc] init];
            [deviceInit searchDeviceInitInfo:m_deviceId timeOut:60000*2 success:^(LCOPENSDK_DEVICE_INIT_INFO info) {
                theMac = [NSString stringWithUTF8String:info.mac];
                theIp = [NSString stringWithUTF8String:info.ip];
                thePort = info.port;
                theInitStatus = info.status;
            }];
            [m_configWifi configWifiStop];
            if (!theMac || !theIp) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.m_lblHint.text = @"smartconfig timeout!";
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.m_lblHint.text = @"smartconfig succeed!";
                });
                [self initDevice:10000];
            }
        });
    }];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 设备绑定(En:Device binding)
- (void)restApiBind:(NSString*)devId deviceKey:(NSString*)devKey
{
    RestApiService* restApiService = [RestApiService shareMyInstance];
    __block NSString* errMsg;
    
    dispatch_async(dispatch_get_main_queue(), ^{
         self.m_lblHint.text = @"check device bind or not...";
    });
   
    [restApiService checkDeviceBindOrNot:devId Msg:&errMsg];
    if (![errMsg isEqualToString:[MSG_DEVICE_NOT_BIND mutableCopy]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.m_lblHint.text = errMsg;
        });
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.m_lblHint.text = @"check device online or not...";
    });
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
            dispatch_async(dispatch_get_main_queue(), ^{
                self.m_lblHint.text = hintLabelText;
            });
            usleep(5 * 1000 * 1000);
            time(&lCur);
            continue;
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.m_lblHint.text = errMsg;
            });
            return;
        }
    }
    if (NO == bOnline) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.m_lblHint.text = NSLocalizedString(DEVICE_OFFLINE_TXT, nil);
        });
        return;
    }
    
    // China
    if ([NSLocalizedString(LANGUAGE_TXT, nil) isEqualToString:@"zh"]) {
        NSString* devAbility = nil;
        [restApiService unBindDeviceInfo:devId Ability:&devAbility Msg:&errMsg];
        if (![errMsg isEqualToString:[MSG_SUCCESS mutableCopy]]) {
            self.m_lblHint.text = errMsg;
            return;
        }
        
        if ([devAbility rangeOfString:@"Auth"].location != NSNotFound) {
            [restApiService bindDevice:devId Code:devKey Msg:&errMsg];
            if (![errMsg isEqualToString:[MSG_SUCCESS mutableCopy]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.m_lblHint.text = errMsg;
                });
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.m_lblHint.text = NSLocalizedString(BIND_SUCCESS_TXT, nil);
            });
            deviceListState = HasChanged;
        }
        else if ([devAbility rangeOfString:@"RegCode"].location != NSNotFound)
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Please Input Device Safe Code" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:nil];
            UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action) {
                NSString* devCode = alert.textFields[0].text;
                [restApiService bindDevice:devId Code:devCode Msg:&errMsg];
                if (![errMsg isEqualToString:[MSG_SUCCESS mutableCopy]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.m_lblHint.text = errMsg;
                    });
                    return;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.m_lblHint.text = NSLocalizedString(BIND_SUCCESS_TXT, nil);
                });
                
                deviceListState = HasChanged;
            }];
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:confirmAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            [restApiService bindDevice:devId Code:@"" Msg:&errMsg];
            if (![errMsg isEqualToString:[MSG_SUCCESS mutableCopy]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.m_lblHint.text = errMsg;
                });
            
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.m_lblHint.text = NSLocalizedString(BIND_SUCCESS_TXT, nil);
            });
           
            deviceListState = HasChanged;
        }
    }
    // overseas
    else
    {
        [restApiService bindDevice:devId Code:devKey Msg:&errMsg];
        if (![errMsg isEqualToString:[MSG_SUCCESS mutableCopy]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.m_lblHint.text = errMsg;
            });
        
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.m_lblHint.text = NSLocalizedString(BIND_SUCCESS_TXT, nil);
        });
        deviceListState = HasChanged;
    }
}
#pragma mark - 设备初始化(En:Device initialization)
- (void)initDevice:(int)timeout
{

    NSLog(@"LCOpen_SoftAP deviceID[%s]\n", [m_deviceId UTF8String]);
    if (!m_deviceId || 0 == m_deviceId.length || [m_deviceId isEqualToString:NSLocalizedString(DEVICE_ID_TIP_TXT, nil)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.m_lblHint.text = NSLocalizedString(DEVICE_ID_TIP_TXT, nil);
        });
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
    [deviceInit searchDeviceInitInfo:m_deviceId timeOut:timeout success:^(LCOPENSDK_DEVICE_INIT_INFO info) {
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
    
    /**
     Ch:以下为支持SC码设备
     En:The following are devices that support SC code.
     */
    NSString* scCode = m_deviceKey;
    NSLog(@"LCOpen_SoftAP scCode[%s]\n", [scCode UTF8String]);
    if(scCode.length == 8)
    {
        [self restApiBind:m_deviceId deviceKey:scCode];
        return;
    }
    
    if (0 == theInitStatus && [NSLocalizedString(LANGUAGE_TXT, nil) isEqualToString:@"zh"]) {
        /**
         Ch:基于“不支持设备初始化的设备肯定也不支持Auth能力集”的断定
         En:Based on the conclusion that "devices that do not support device initialization certainly do not support the Auth capability set"
         */
        dispatch_async(dispatch_get_main_queue(), ^{
            self.m_lblHint.text = @"Bind device...";
            [self restApiBind:m_deviceId deviceKey:nil];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString* alertControllerTitle = nil;
            if (1 == theInitStatus) {
                alertControllerTitle = @"Please Input Device Init Key";
            }
            else {
                alertControllerTitle = @"Please Input Device Key";
            }
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:alertControllerTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:nil];
            UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action) {
                NSString* deviceKey = alert.textFields[0].text;
                
                if (1 == theInitStatus) {
                    self.m_lblHint.text = @"try multicast init device...";
                    int ret = [deviceInit initDevice:theMac password:deviceKey];
                    if (-2 == ret) {
                        self.m_lblHint.text = @"try unicast init device...";
                        
                        /**
                         Ch:为了解决可能出现的第二次才回调正确IP, 单播初始化前再做一次设备搜索
                         En:In order to solve the possible second time to call back the correct IP, do a device search before unicast initialization.
                         */
                        theMac = nil;
                        theIp = nil;
                        thePort = 0;
                        theInitStatus = 0;
                        [deviceInit searchDeviceInitInfo:m_deviceId timeOut:timeout success:^(LCOPENSDK_DEVICE_INIT_INFO info) {
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
                        
                        int ret = [deviceInit initDevice:theMac password:deviceKey ip:theIp];
                        if (-2 == ret) {
                            self.m_lblHint.text = @"Init device failed!";
                            return;
                        }
                        else
                        {
                            self.m_lblHint.text = @"unicast init device succeed!";
                        }
                    }
                    else
                    {
                        self.m_lblHint.text = @"multicast init device succeed!";
                    }
                }
                else if ((0 == theInitStatus || 2 == theInitStatus) && [NSLocalizedString(LANGUAGE_TXT, nil) isEqualToString:@"en"]) {
                    if (!deviceKey || 0 == deviceKey.length || [deviceKey isEqualToString:NSLocalizedString(DEVICE_KEY_TIP_TXT, nil)]) {
                        self.m_lblHint.text = NSLocalizedString(DEVICE_KEY_TIP_TXT, nil);
                        return;
                    }
                    self.m_lblHint.text = @"Check device password...";
                    int ret = [deviceInit checkPwdValidity:m_deviceId ip:theIp port:thePort password:deviceKey];
                    if (0 != ret) {
                        self.m_lblHint.text = @"Check device password failed!";
                        return;
                    }
                    else
                    {
                        self.m_lblHint.text = @"Check device password succeed!";
                    }
                }
                
                [self restApiBind:m_deviceId deviceKey:deviceKey];
            }];
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:confirmAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        });
    }
}
#pragma mark - 有线配网(En:Wired distribution network)
- (void)onWired:(id)sender
{
    [_m_textSerial resignFirstResponder];
    [_m_textDeviceKey resignFirstResponder];
    [_m_textPasswd resignFirstResponder];
    /**
    Ch:配网前检查设备是否被绑定过，以免配好网后才知道设备被绑定过.
    En:Check whether the device is bound before network configuration, so as not to know that the device is bound after the network is configured.
    */
    NSLog(@"LCOpen_SoftAP deviceID[%s]\n", [m_deviceId UTF8String]);
    if (!m_deviceId || 0 == m_deviceId.length || [m_deviceId isEqualToString:NSLocalizedString(DEVICE_ID_TIP_TXT, nil)]) {
        self.m_lblHint.text = NSLocalizedString(DEVICE_ID_TIP_TXT, nil);
        return;
    }
    RestApiService* restApiService = [RestApiService shareMyInstance];
    __block NSString* errMsg;
    
    self.m_lblHint.text = @"check device bind or not...";
    [restApiService checkDeviceBindOrNot:m_deviceId Msg:&errMsg];
    if (![errMsg isEqualToString:[MSG_DEVICE_NOT_BIND mutableCopy]]) {
        self.m_lblHint.text = errMsg;
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self initDevice:10000];
    });
}

#pragma mark - 获取当前连接的WIFI名称(En:Get the name of the currently connected WIFI)
- (NSString*) getCurrentWifiName
{
    id info = nil;
    /**
     Ch:获取所有的支持接口
     En:Get all supported interfaces.
     */
    NSArray* ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for(NSString* ifnam in ifs)
    {
        /**
         Ch:找到当前网络信息
         En:Find current network information.
         */
        NSLog(@"sqtest1 ifnam %s", [ifnam UTF8String]);
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        /**
         Ch:通过SSID来获取当前网络名
         En:Get the current network name by SSID.
         */
        NSString* str = info[@"SSID"];
        if(str){
            return str;
        }
    }
    return @"";
}

#pragma mark - 软AP配网(En:Soft AP distribution network)
- (IBAction)onSoftAP:(id)sender
{
    [_m_textSerial resignFirstResponder];
    [_m_textDeviceKey resignFirstResponder];
    [_m_textPasswd resignFirstResponder];
    NSLog(@"sqtest1 [%@][%@][%@]", m_deviceId, info[@"SSID"], m_wifiPassword);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

    if(!m_softAPView){
        /* 获取storyboard */
        UIStoryboard* currentBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        /* 获取view */
        m_softAPView = [currentBoard instantiateViewControllerWithIdentifier:@"SoftAPConnectView"];
    }
    
    NSLog(@"sqtest2 [%@][%@][%@]", m_deviceId, info[@"SSID"], m_wifiPassword);
    m_softAPView.m_wifiName = info[@"SSID"];
    m_softAPView.m_wifiPwd = m_wifiPassword;
    m_softAPView.m_deviceId = m_deviceId;
    m_softAPView.m_deviceKey = m_deviceKey;

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:m_softAPView animated:NO];
    });
    });
}

#pragma mark - 配网回调通知(En:Distribution network callback notification)
- (void)notify:(NSInteger)event
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [m_configWifi configWifiStop];
        usleep(100000);
        [self initDevice:60000];
    });
}

- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    if ((textField == _m_textSerial && [_m_textSerial.text isEqualToString:NSLocalizedString(DEVICE_ID_TIP_TXT, nil)]) || (textField == _m_textPasswd && [_m_textPasswd.text isEqualToString:NSLocalizedString(WIFI_PASSWORD_TIP_TXT, nil)])) {
        textField.text = @"";
    }
    textField.textColor = [UIColor blackColor];
    CGFloat offset = self.view.frame.size.height - (textField.frame.origin.y + textField.frame.size.height + 216 + 50);
    if (offset <= 0) {
        [UIView animateWithDuration:0.1 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField*)textField
{
    if (textField == self.m_textSerial) {
           m_deviceId = textField.text;
    }
    else if (textField == self.m_textDeviceKey) {
           m_deviceKey = textField.text;
    }
    else if (textField == self.m_textPasswd) {
           m_wifiPassword = textField.text;
    }
    [UIView animateWithDuration:0.1 animations:^{
        CGRect rect = self.view.frame;
        rect.origin.y = 0;
        self.view.frame = rect;
    }];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];

    return YES;
}

@end
