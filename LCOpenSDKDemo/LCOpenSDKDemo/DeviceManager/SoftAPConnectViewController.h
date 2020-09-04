//
//  testView.h
//  LCOpenSDKDemo
//
//  Created by Fizz on 2019/5/31.
//  Copyright © 2019 lechange. All rights reserved.
//

#ifndef testView_h
#define testView_h
#import "MyViewController.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface SoftAPConnectViewController:MyViewController <UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property(nonatomic) NSString* m_wifiName;
@property(nonatomic) NSString* m_wifiPwd;
@property(nonatomic) NSString* m_deviceId;
@property(nonatomic) NSString* m_deviceKey; 
@property (weak, nonatomic) IBOutlet UILabel *m_lblHint;

@property (weak, nonatomic) IBOutlet UIButton *m_softAPConnect;
@property (weak, nonatomic) IBOutlet UIButton *m_bindDevice;

@property (weak, nonatomic) IBOutlet UILabel *m_SoftAPInstructLab1;
@property (weak, nonatomic) IBOutlet UILabel *m_SoftAPInstructLab2;
@property (weak, nonatomic) IBOutlet UILabel *m_SoftAPInstructLab3;
@property (weak, nonatomic) IBOutlet UILabel *m_SoftAPInstructLab4;
@property (weak, nonatomic) IBOutlet UILabel *m_SoftAPInstructLab5;
@property (weak, nonatomic) IBOutlet UILabel *m_SoftAPInstructLab6;


@property(nonatomic) NSInteger m_initDevStatus;

-(IBAction)onBtn:(id)sender;

-(IBAction)onBack:(UIStoryboardSegue*)sender;

-(IBAction)onBindDeivce:(id)sender;

@end

#endif /* testView_h */
