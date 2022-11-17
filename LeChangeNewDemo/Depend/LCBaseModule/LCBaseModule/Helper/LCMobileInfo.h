//Define.h>
//  Copyright © 2016年 Imou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LCBaseModule/LCPubDefine.h>
/*!
 *  @author peng_kongan, 16-09-06 15:09:27
 *
 *  @brief 设备信息 例如唯一标识符、剩余容量、CPU使用率等属性、屏幕大小布局等
 */
@interface LCMobileInfo : NSObject

+ (instancetype)sharedInstance;

/*!
 *  @author peng_kongan, 16-09-06 15:09:16
 *
 *  @brief 获取设备WIFI名称
 */
@property (strong, nonatomic) NSString *WIFISSID;

@property (strong, nonatomic) NSString *WIFIBSSID;

/*!
 *  @author peng_kongan, 16-09-06 15:09:18
 *
 *  @brief 设备唯一标识符 APP删除后也不会改变 存放在keychain中
 */
@property (strong, nonatomic) NSString *UUIDString;

/*!
 *  @author peng_kongan, 16-09-06 15:09:54
 *
 *  @brief 屏幕布局  大的为宽 小的为高
 */
@property (nonatomic) CGRect mainScreenRect;
@end
