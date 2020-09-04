//
//  HintViewController.h
//  LCOpenSDKDemo
//
//  Created by chenjian on 16/7/11.
//  Copyright (c) 2016年 lechange. All rights reserved.
//
#ifndef LCOpenSDKDemo_AddDeviceViewController_h
#define LCOpenSDKDemo_AddDeviceViewController_h

#import "MyViewController.h"
#import "RestApiService.h"
#import <UIKit/UIKit.h>

@interface AddDeviceViewController : MyViewController <UITextFieldDelegate> {
    LCOpenSDK_Api* m_hc;

    NSString* m_strAccessToken;
}
@property (weak, nonatomic) IBOutlet UITextField *m_textSerial;
@property (weak, nonatomic) IBOutlet UITextField *m_textDeviceKey;
@property (weak, nonatomic) IBOutlet UITextField *m_textPasswd;
@property (weak, nonatomic) IBOutlet UILabel *m_lblDeviceSN;
@property (weak, nonatomic) IBOutlet UILabel *m_lblDeviceKey;
@property (weak, nonatomic) IBOutlet UILabel *m_lblSsid;
@property (weak, nonatomic) IBOutlet UILabel *m_lblHint;
@property (weak, nonatomic) IBOutlet UIButton *m_btnWifi;
@property (weak, nonatomic) IBOutlet UIButton *m_btnWired;
@property (weak, nonatomic) IBOutlet UIButton *m_btnSoftAP;

- (void)onBack:(id)sender;
- (void)setInfo:(LCOpenSDK_Api*)hc token:(NSString*)token devView:(id)view;

- (IBAction)onWifi:(id)sender;
- (IBAction)onWired:(id)sender;
- (IBAction)onSoftAP:(id)sender;
- (void)notify:(NSInteger)event;
- (void)initDevice:(int)timeout;

- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField;
- (BOOL)textFieldShouldEndEditing:(UITextField*)textField;
- (BOOL)textFieldShouldReturn:(UITextField*)textField;
@end
#endif
