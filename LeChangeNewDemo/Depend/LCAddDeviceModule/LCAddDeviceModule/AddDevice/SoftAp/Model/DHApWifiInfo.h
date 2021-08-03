//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHApWifiInfo : NSObject
@property (nonatomic, assign) BOOL autoConnect;
@property (nonatomic, assign) NSInteger encryptionAuthority;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) NSInteger linkQuality;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *netcardName; /**< 网卡名称，软AP连接WIFI时使用 */

@end
