//
//  CryptComponent.h
//  CryptComponent
//
//  Created by zhou_yuepeng on 2017/4/10.
//  Copyright © 2017年 www.dahuatech.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ENCRYPT_RESULT)
{
    OC_EncSuccess = 0,          //encrypt success
    OC_EncNotWhole,             //not a whole frame
    OC_EncEncrypted,            //already encrypted
    OC_EncBufNotEnough,         //buf not enough
    OC_EncInternalError = 99,   //internal error
};

typedef NS_ENUM(NSInteger, DECRYPT_RESULT)
{
    OC_DecSuccess = 0,          //decrypt success
    OC_DecNotWhole,             //dada not whole
    OC_DecKeyError,             //decrypt key error
    OC_DecUnEncrypt,            //unencrypt
    OC_DecUnsupportEncryption,  //unsupport encryption
    OC_DecBufNotEnough,         //buf not enough
    OC_DecDeviceKeyError,       //device key error（设备密码错误）
    OC_DecInternalError = 99,   //internal error
};

typedef NS_ENUM(NSInteger, RULE_VERSION)
{
    OC_RULE_EASY4IP = 0,        //Base64(MD5_LOWER("HS:"+MD5_LOWER(keyseed))+"EASY4IP"), 取前16位
    OC_RULE_LECHANGE,           //Base64(MD5_LOWER("HS:"+MD5_LOWER(keyseed))), 取前16位
    OC_RULE_DAHUAPASS,          //Base64(MD5_UPPER("HS:"+MD5_UPPER(keyseed))), 取前16位
};

@interface CryptComponent : NSObject

- (instancetype)initWithRuleVersion:(RULE_VERSION)rule;
- (instancetype)init __attribute__((unavailable("Disabled!Use initWithRuleVersion instead.")));

#pragma mark - Encrypt
/**
 使用key加密数据

 @param in 待加密数据
 @param key 秘钥
 @param encryptPos 需要加密的数据起始点
 @param encryptLen 需要加密的数据长度
 @param out 加密后输出数据
 @return 加密结果(see ENCRYPT_RESULT)
 */
- (ENCRYPT_RESULT)encryptData:(NSData*)in key:(NSString*)key encryptPos:(NSUInteger)encryptPos encryptLen:(NSUInteger)encryptLen out:(NSData**)out;

/**
 AES秘钥计算

 @param key 加密用key
 @param in 待加密串
 @param out 加密后串
 @return 加密结果(see ENCRYPT_RESULT)
 */
- (ENCRYPT_RESULT)verifyCrypt:(NSString*)key in:(NSString*)in out:(NSString**)out;

/**
 计算秘钥

 @param keySeedMD5 秘钥明文MD5值(32位小写)
 @return 计算后的秘钥
 */
- (NSString*)computeSecretKey:(NSString*)keySeedMD5;

#pragma mark - Decrypt
/**
 解密大华帧数据,保留头部域及尾部

 @param in 待解密数据
 @param key 解密秘钥
 @param sDevId[in] 设备序列号,只有新的0XB5加解密需要序列号计算KDF密钥,老的0X95的解密方式可以传""
 @param sDevPwd[in] 设备密码,只有新的0XB5加解密需要设备密码计算KDF密钥,老的0X95的解密方式可以传""
 @param out 解密后输出数据
 @return 解密结果(see DECRYPT_RESULT)
 */
- (DECRYPT_RESULT)decryptDataWithHead:(NSData*)in key:(NSString*)key deviceID:(NSString*)sDevId devicePwd:(NSString*)sDevPwd out:(NSData**)out;

/**
 解密大华帧数据,去除头部域和尾部
 
 @param in 待解密数据
 @param key 解密秘钥明文MD5值(32位小写)
 @param sDevId[in] 设备序列号,只有新的0XB5加解密需要序列号计算KDF密钥,老的0X95的解密方式可以传""
 @param sDevPwd[in] 设备密码,只有新的0XB5加解密需要设备密码计算KDF密钥,老的0X95的解密方式可以传""
 @param out 解密后输出数据
 @return 解密结果(see DECRYPT_RESULT)
 */
- (DECRYPT_RESULT)decryptDataWithoutHead:(NSData*)in key:(NSString*)key deviceID:(NSString*)sDevId devicePwd:(NSString*)sDevPwd out:(NSData**)out;

/**
 解密大华帧数据,去除头部域和尾部（如果内部是i帧将转为jpg）
 
 @param in 待解密数据
 @param key 解密秘钥明文MD5值(32位小写)
 @param sDevId[in] 设备序列号,只有新的0XB5加解密需要序列号计算KDF密钥,老的0X95的解密方式可以传""
 @param sDevPwd[in] 设备密码,只有新的0XB5加解密需要设备密码计算KDF密钥,老的0X95的解密方式可以传""
 @param out 解密后输出数据
 @return 解密结果(see DECRYPT_RESULT)
 */
- (DECRYPT_RESULT)decryptDataWithoutHeadEx:(NSData*)in key:(NSString*)key deviceID:(NSString*)sDevId devicePwd:(NSString*)sDevPwd out:(NSData**)out;

/**
解密设备信息播放数据

@param source 待解密数据
@param sDevId[in] 设备序列号
@param sPlayCode[in] 设备播放码解密密钥
@param out 解密后输出数据
@return 解密结果(see DECRYPT_RESULT)
*/
- (DECRYPT_RESULT)decryptDeviceInfoData:(NSString *)source deviceID:(NSString *)sDevId sPlayCode:(NSString*)sPlayCode out:(NSString**)out;

/**
 @brief  计算码流加解密校验信息：目前暂只针对云录像
 @param  [in] deviceSN   设备序列号
 @param  [in] key  码流明文密钥因子
 @param  [in] verifyInfo  待校验的字串信息
 @return true: 校验一致  false: 不一致
 */
+ (BOOL)verifyEncryptInfo:(NSString*)deviceSN Key:(NSString*)key verifyInfo:(NSString*)verifyInfo;

+ (NSString*)getVerfier:(NSString*)deviceSN Key:(NSString*)key;

@end
