//
//  LCOpenSDK_ConfigWifi.h
//  LCOpenSDK
//
//  Created by chenjian on 16/5/26.
//  Copyright (c) 2016年 lechange. All rights reserved.
//

#ifndef LCOpenSDK_LCOpenSDK_ConfigWifi_h
#define LCOpenSDK_LCOpenSDK_ConfigWifi_h
#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, LC_ConfigWifi_Event)
{
    LC_ConfigWifi_Event_Success       = 0,    //收到局域网回应
    LC_ConfigWifi_Event_Unkown        = 1,    //未知错误
    LC_ConfigWifi_Event_SockError     = 2,    //Socket错误
    LC_ConfigWifi_Event_AudioError    = 3,    //播放器错误
    LC_ConfigWifi_Event_Timeout       = 4,    //配对错误
};

typedef void (^LCOpenSDK_ConfigWifiCallBack)(LC_ConfigWifi_Event event, void* userData);
@interface LCOpenSDK_ConfigWIfi : NSObject
/**
 *  开始Wifi配网
 *
 *  @param devId    设备ID
 *  @param ssid     Wifi的SSID
 *  @param pwd      Wifi密码
 *  @param security (选填，默认@"")
 *  @param voiceFreq (声波频率，需要根据设备类型区分。例如：普通11000，TP7C 17000)
 *  @param funcPtr  事件回调函数
 *  @param userData 回调时的用户数据
 *  @param timeout  接口调用超时时间
 *
 *  @return  0, 接口调用成功
 *          -1, 接口调用失败
 */
- (NSInteger)configWifiStart:(NSString*)devId ssid:(NSString*)ssid password:(NSString*)pwd secure:(NSString*)security voiceFreq:(NSInteger)voiceFreq;
/**
 *  停止Wifi配网
 *
 *  @return  0, 接口调用成功
 *          -1, 接口调用失败
 */
- (NSInteger)configWifiStop;

@end
#endif
