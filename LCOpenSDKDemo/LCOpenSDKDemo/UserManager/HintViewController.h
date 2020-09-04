//
//  HintViewController.h
//  LCOpenSDKDemo
//
//  Created by chenjian on 16/7/11.
//  Copyright (c) 2016年 lechange. All rights reserved.
//
#import "MyViewController.h"
#import <UIKit/UIKit.h>

#ifndef LCOpenSDKDemo_HintViewController_h
#define LCOpenSDKDemo_HintViewController_h
@interface HintViewController : MyViewController {
    UILabel* m_lblHint;
}
@property NSString* m_appId;
@property NSString* m_appSecret;
@property NSString* m_hint;
@property IBOutlet UIImageView *m_bgImg;
@property IBOutlet UILabel* m_lblAppId;
@property IBOutlet UILabel* m_lblAppSecret;
- (void)setInfo:(NSString*)appId appSecret:(NSString*)appSecret info:(NSString*)info;
- (void)onback:(id)sender;
@end
#endif
