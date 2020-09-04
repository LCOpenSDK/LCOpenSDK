//
//  LocalPlayViewController.h
//  LCOpenSDKDemo
//
//  Created by 韩燕瑞 on 2020/7/2.
//  Copyright © 2020 lechange. All rights reserved.
//

#import <LCOpenSDKDynamic.h>
#import "MyViewController.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocalPlayViewController : MyViewController<LCOpenSDK_EventListener>

@property (copy, nonatomic) NSString *filepath;

@end

NS_ASSUME_NONNULL_END
