//
//  LCOpenSDK_DeviceInit.h
//  LCOpenSDK
//
//  Created by bzy on 17/7/21.
//  Copyright © 2017年 lechange. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    char        mac[64];    //设备Mac地址
    char        ip[64];     //设备在局域网内的ip
    int         port;       //大华私有协议端口
    int         status;     //0:不支持设备初始化  1:支持设备初始化且未初始化   2:支持设备初始化且已初始化
}LCOPENSDK_DEVICE_INIT_INFO;

@interface LCOpenSDK_DeviceInit : NSObject

/**
 *  搜索设备初始化信息
 *
 *  @param deviceID 设备ID
 *  @param timeOut  超时时间
 *  @param info     搜索到的设备初始化信息
 */
- (void)searchDeviceInitInfo:(NSString*)deviceID timeOut:(int)timeOut
                     success:(void (^)(LCOPENSDK_DEVICE_INIT_INFO info))success;

- (int)initDevice:(NSString*)mac password:(NSString*)password;

- (int)initDevice:(NSString*)mac password:(NSString*)password ip:(NSString*)ip;

- (int)checkPwdValidity:(NSString*)deviceID ip:(NSString*)ip port:(NSInteger)port password:(NSString*)password;

@end
