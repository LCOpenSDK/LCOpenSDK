//
//  ViewController.h
//  LCOpenSDKDemo
//
//  Created by chenjian on 16/7/11.
//  Copyright (c) 2016年 lechange. All rights reserved.
//
#ifndef LCOpenSDKDemo_StartViewController_h
#define LCOpenSDKDemo_StartViewController_h
#import "MyViewController.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface StartViewController : MyViewController <UITextFieldDelegate>

@property IBOutlet UIImageView* m_imgBG;
@property IBOutlet UIButton* m_btnUser;
@property IBOutlet UIButton* m_btnMan;
@property IBOutlet UITextField* m_textAppId;
@property IBOutlet UITextField* m_textAppSecret;
@property (nonatomic, strong)CLLocationManager *locationManager;

@property IBOutlet UITextField* m_textServerInfo;
- (IBAction)onManagerMode:(id)sender;
- (IBAction)onUserMode:(id)sender;
- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField;
- (BOOL)textFieldShouldEndEditing:(UITextField*)textField;
- (BOOL)textFieldShouldReturn:(UITextField*)textField;

- (NSString*)parseServerIp:(NSString*)svrInfo;
- (NSInteger)parseServerPort:(NSString*)svrInfo;
@end

#endif
