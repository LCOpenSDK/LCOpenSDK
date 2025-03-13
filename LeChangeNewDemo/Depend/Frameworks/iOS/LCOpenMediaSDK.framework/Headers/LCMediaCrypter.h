//
//  LCMediaCrypter.h
//  LCSDK
//
//  Created by zhou_yuepeng on 2017/7/21.
//  Copyright © 2017年 www.dahuatech.com. All rights reserved.
//

#ifndef LCSDK_LCSDK_Crypter_h
#define LCSDK_LCSDK_Crypter_h
#import <Foundation/Foundation.h>
#import "LCMediaDefine.h"

@interface LCMediaCrypter : NSObject

- (instancetype)initWithRuleVersion:(E_RULE_VERSION)rule;
- (instancetype)init __attribute__((unavailable("Disabled!Use initWithRuleVersion instead.")));

#pragma mark - Encrypt
/**
 使用key加密数据
 
 @param in 待加密数据
 @param key 秘钥(明文MD532位小写)
 @param encryptPos 需要加密的数据起始点
 @param encryptLen 需要加密的数据长度
 @param out 加密后输出数据
 @return 加密结果(参考E_ENCRYPT_RESULT)
 */
- (E_ENCRYPT_RESULT)encryptData:(NSData*)in key:(NSString*)key encryptPos:(NSUInteger)encryptPos encryptLen:(NSUInteger)encryptLen out:(NSData**)out;

/**
 AES秘钥计算
 
 @param key 加密用key
 @param in 待加密串
 @param out 加密后串
 @return 加密结果(参考E_ENCRYPT_RESULT)
 */
- (E_ENCRYPT_RESULT)verifyCrypt:(NSString*)key in:(NSString*)in out:(NSString**)out;

#pragma mark - Decrypt
/**
 解密大华帧数据,保留头部域及尾部
 
 @param in 待解密数据
 @param key 解密秘钥(明文MD532位小写)
 @param sDevId 设备序列号,只有新的0XB5加解密需要序列号计算KDF密钥,老的0X95的解密方式可以传""
 @param sDevPwd 设备密码,只有新的0XB5加解密需要设备密码计算KDF密钥,老的0X95的解密方式可以传""
 @param out 解密后输出数据
 @return 解密结果(参考E_DECRYPT_RESULT)
 */
- (E_DECRYPT_RESULT)decryptDataWithHead:(NSData*)in key:(NSString*)key deviceID:(NSString*)sDevId devicePwd:(NSString*)sDevPwd out:(NSData**)out;

/**
 解密大华帧数据,去除头部域和尾部
 
 @param in 待解密数据
 @param key 解密秘钥(明文MD532位小写)
 @param sDevId 设备序列号,只有新的0XB5加解密需要序列号计算KDF密钥,老的0X95的解密方式可以传""
 @param sDevPwd 设备密码,只有新的0XB5加解密需要设备密码计算KDF密钥,老的0X95的解密方式可以传""
 @param out 解密后输出数据
 @return 解密结果(参考E_DECRYPT_RESULT)
 */
- (E_DECRYPT_RESULT)decryptDataWithoutHead:(NSData*)in key:(NSString*)key deviceID:(NSString*)sDevId devicePwd:(NSString*)sDevPwd out:(NSData**)out;

/**
 解密大华帧数据,去除头部域和尾部（如果内部是i帧将转为jpg）
 
 @param in 待解密数据
 @param key 解密秘钥明文MD5值(32位小写)
 @param sDevId 设备序列号,只有新的0XB5加解密需要序列号计算KDF密钥,老的0X95的解密方式可以传""
 @param sDevPwd 设备密码,只有新的0XB5加解密需要设备密码计算KDF密钥,老的0X95的解密方式可以传""
 @param out 解密后输出数据
 @return 解密结果(see E_DECRYPT_RESULT)
 */
- (E_DECRYPT_RESULT)decryptDataWithoutHeadEx:(NSData*)in key:(NSString*)key deviceID:(NSString*)sDevId devicePwd:(NSString*)sDevPwd out:(NSData**)out;

/**
 @brief 校验码流加解密信息：目前暂只针对云录像
 @param deviceSN      [in] 设备序列号
 @param keyFactor    [in] 码流加密密钥因子，TCM设备为设备密码，非TCM设备为自定义密钥或者默认密钥
 @param verifyInfo  [in] 待校验的信息
 @return true: 校验一致  false: 校验不一致
 */
+ (BOOL)verifyEncryptInfo:(NSString*)deviceSN KeyFactor:(NSString*)keyFactor VerifyInfo:(NSString*)verifyInfo;

/**
 @brief 生成密钥摘要：目前暂只针对云录像
 @param deviceSN      [in] 设备序列号
 @param keyFactor    [in] 码流加密密钥因子，TCM设备为设备密码，非TCM设备为自定义密钥或者默认密钥
 @return 密钥摘要
 */
+ (NSString*)getVerfier:(NSString*)deviceSN KeyFactor:(NSString*)keyFactor;

@end


#endif /* LCSDK_LCSDK_Crypter_h */
