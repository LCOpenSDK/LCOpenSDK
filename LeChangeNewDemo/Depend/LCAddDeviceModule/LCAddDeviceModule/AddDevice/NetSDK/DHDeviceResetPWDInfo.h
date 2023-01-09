//
//  Copyright © 2019 dahua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISearchDeviceNetInfo.h"

@interface DHDeviceResetPWDInfo : NSObject

/// 支持的密码重置方式
@property (nonatomic, assign) DHDevicePasswordResetType devicePwdResetWay;

/// 错误类型
@property (nonatomic, assign) DHDevicePasswordResetError errorType;

/// 预置的手机号
@property (nonatomic, copy, nullable) NSString *presetPhone;

/// 预置的邮箱
@property (nonatomic, copy, nullable) NSString *presetEmail;

/// 二维码信息字段	数据用途	厂商标识	密钥编号	Base64(加密数据)	字节数
///				4		2		8		不定长
@property (nonatomic, copy, nullable) NSString *qrCode;

/// 是否为新设备，解析二维码中的厂商标识 A1表示大华 A2表示大华新程序 B1表示中性 B2表示中性新程序
@property (nonatomic, assign, readonly) BOOL isNewVersion;


@end
