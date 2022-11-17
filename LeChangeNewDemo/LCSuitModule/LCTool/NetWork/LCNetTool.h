//
//  Copyright © 2020 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocationManager.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    LCNetStatusOFFLine,
    LCNetStatusWWAN,
    LCNetStatusWiFi
} LCNetStatus;

@interface LCNetTool : NSObject<CLLocationManagerDelegate>

+(instancetype)shareManager;

/// 获取当前WiFI名
-(void)lc_CurrentWiFiName:(void(^)(NSString * ssid))block;

/// 获取当前网络状态
+(LCNetStatus)lc_CurrentNetStatus;

/// 监听网络状态
/// @param netStatus 网络状态改变时返回回调
+ (void)lc_ObserveNetStatus:(void (^)(LCNetStatus status))netStatus;


@end

NS_ASSUME_NONNULL_END
