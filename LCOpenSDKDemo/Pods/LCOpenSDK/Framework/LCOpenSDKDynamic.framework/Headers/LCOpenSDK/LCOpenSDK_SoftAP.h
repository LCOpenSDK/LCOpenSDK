//
//  LCOpenSDK_SoftAP.h
//  LCOpenSDK
//
//  Created by Fizz on 2019/5/20.
//  Copyright © 2019 lechange. All rights reserved.
//

#ifndef LCOpenSDK_SoftAP_h
#define LCOpenSDK_SoftAP_h
#import <Foundation/Foundation.h>

@interface LCOpenSDK_SoftAP : NSObject

-(NSInteger) startSoftAPConfig:(NSString*)wifiName
                       wifiPwd:(NSString*)wifiPwd
                      deviceId:(NSString*)deviceId
                     devicePwd:(NSString*)devicePwd
                          isSC:(BOOL)isSC;
;

@end
#endif /* LCOpenSDK_SoftAP_h */
