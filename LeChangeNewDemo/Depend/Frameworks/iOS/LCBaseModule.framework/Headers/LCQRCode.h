//
//  Copyright © 2016年 dahua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCQRCode : NSObject

@property (nonatomic, copy)     NSString    *deviceSN;
@property (nonatomic, copy)     NSString    *deviceType;
@property (nonatomic, copy)     NSString    *identifyingCode;
@property (nonatomic, copy)     NSString    *scCode; /**< SC码 */
@property (nonatomic, copy)     NSString    *ncCode; /**< Net Connect: 00/空，旧的声波库； 01新声波+SmartCofig; 02 软AP （暂定); 03 蓝牙BT（暂定） */
@property (nonatomic, copy)     NSString    *imeiCode; /**< IMEI码 */

- (void)pharseQRCode:(NSString *)qrCode;
	
@end
