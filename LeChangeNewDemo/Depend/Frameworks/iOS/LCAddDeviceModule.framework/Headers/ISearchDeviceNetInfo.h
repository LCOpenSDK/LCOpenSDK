//
//  Copyright © 2018年 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LCOpenSDKDynamic/LCOpenSDKDynamic.h>


@protocol ISearchDeviceNetInfo <NSObject>
@property (nonatomic, assign) NSInteger searchSequence; /**< 搜索的序号，用来标记是属于哪次搜索 */
@property (nonatomic, assign) BOOL isVaild;//是否有效  非NETSDK返回数据  用于上层标记在一个周期内有没有收到该设备数据
@property (nonatomic, copy, readonly)NSString *deviceSN; // 序列号
@property (nonatomic, copy, readonly)NSString *deviceIP; // 设备IP
@property (nonatomic, copy, readonly)NSString *deviceMac;// mac地址
@property (nonatomic, assign) int port; // tcp端口
@property (nonatomic, assign, readonly) LCDevicePasswordResetType devicePwdResetWay;         //密码重置方式
@property (nonatomic, readonly) LCIPType ipType; // 设备IP
@property (nonatomic, readonly) LCDeviceInitType deviceInitType; // 设备初始化方式  由netsdk搜索到的设备IP状态决定
@property (nonatomic) LCDeviceInitStatus deviceInitStatus; // 设备初始化状态(枚举)
@property (nonatomic, readonly) BOOL isSupportPWDReset; // 是否支持密码重置
@end



