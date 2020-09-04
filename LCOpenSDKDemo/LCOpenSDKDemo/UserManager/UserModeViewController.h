//
//  HintViewController.h
//  LCOpenSDKDemo
//
//  Created by chenjian on 16/7/11.
//  Copyright (c) 2016年 lechange. All rights reserved.
//
#ifndef LCOpenSDKDemo_UserModeViewController_h
#define LCOpenSDKDemo_UserModeViewController_h
#import "MyViewController.h"
#import <UIKit/UIKit.h>

@interface UserModeViewController : MyViewController <UITextFieldDelegate> {

    NSString* m_strAppId;
    NSString* m_strAppSecret;
    NSString* m_strSrv;
    NSInteger m_iPort;
    NSString* m_strUserTok;

    UIActivityIndicatorView* m_progressInd;
}
@property IBOutlet UITextField* m_textPhone;
@property IBOutlet UILabel* m_lblHint;
@property IBOutlet UIImageView* m_imgRemind;

- (void)setAppIdAndSecret:(NSString*)appId appSecret:(NSString*)appSecret svr:(NSString*)svr port:(NSInteger)port;
- (void)onBack:(id)sender;
- (IBAction)onBindUser:(id)sender;
- (IBAction)onEnterDevice:(id)sender;
@end
#endif
