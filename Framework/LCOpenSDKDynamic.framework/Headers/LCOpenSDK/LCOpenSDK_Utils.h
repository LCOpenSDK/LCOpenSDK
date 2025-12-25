//
//  LCOpenSDK_Utils.h
//  LCOpenSDK
//
//  Created by chenjian on 16/7/14.
//  Copyright (c) 2016年 lechange. All rights reserved.
//

#ifndef LCOpenSDK_LCOpenSDK_Utils_h
#define LCOpenSDK_LCOpenSDK_Utils_h
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LC_ENCRYPT_CODE)
{
    //Indicates successful decryption
    ENCRYPT_SUCCESS = 0,       // 表示解密成功
    //Indicates that integrity verification failed
    ENCRYPT_CHECK_FAIL,        // 表示完整性校验失败
    //Indicates that the key is incorrect
    ENCRYPT_KEY_ERROR,         // 表示密钥错误
    //Unsupported encryption mode
    ENCRTPT_NONE,              // 不支持的加密方式
    //Insufficient buffer length
    ENCRYPT_BUFFER_LACK,       // 缓冲区长度不够
    //device key error
    ENCRYPT_Device_Key,       // 设备密码错误
    //Internal Error
    ENCRYPT_INSIDE_ERROR = 99  // 内部错误
};

@interface LCOpenSDK_Utils: NSObject

///Data decryption    zh:数据解密
/// @param pSrcBufIn Data content to be decrypted    zh:待解密数据内容
/// @param deviceID device ID
/// @param key decryption key    zh:解密密钥
/// @param pDestBufOut decrypted data content    zh:解密后数据内容
/// @return Decryption result    zh:解密结果
/// 0.indicating successful decryption    zh:0, 表示解密成功
/// 1.It indicates that integrity verification failed    zh:1, 表示完整性校验失败
/// 2.It indicates that the key is incorrect    zh:2, 表示密钥错误
/// 3.indicating that the picture is not encrypted    zh:3, 表示图片非加密
/// 4.Unsupported encryption method    zh:4, 不支持的加密方式
/// 5.Insufficient buffer length    zh:5, 缓冲区长度不够
/// 6.device key error   zh:5, 设备密码错误
/// 99.internal error    zh:99,内部错误
- (NSInteger)decryptPic:(NSData *)pSrcBufIn deviceID:(NSString*)deviceID key:(NSString*)key bufOut:(NSData**)pDestBufOut;

///Data decryption TCM device    zh:数据解密TCM设备
/// @param pSrcBufIn Data content to be decrypted    zh:待解密数据内容
/// @param deviceID Device ID    zh:设备ID
/// @param productId Product ID    zh:产品ID
/// @param key decryption key    zh:解密密钥
/// @param token token
/// @param pDestBufOut decrypted data content    zh:解密后数据内容
/// @return Decryption result    zh:解密结果
/// 0.indicating successful decryption    zh:0, 表示解密成功
/// 1.It indicates that integrity verification failed    zh:1, 表示完整性校验失败
/// 2.It indicates that the key is incorrect    zh:2, 表示密钥错误
/// 3.indicating that the picture is not encrypted    zh:3, 表示图片非加密
/// 4.Unsupported encryption method    zh:4, 不支持的加密方式
/// 5.Insufficient buffer length    zh:5, 缓冲区长度不够
/// 6.device key error   zh:5, 设备密码错误
/// 99.internal error    zh:99,内部错误
- (NSInteger)decryptPic:(NSData *)pSrcBufIn deviceID:(NSString*)deviceID productId:(NSString *)productId key:(NSString*)key token:(NSString *)token bufOut:(NSData**)pDestBufOut;

///Data decryption TCM device    zh:数据解密TCM设备
/// @param pSrcBufIn Data content to be decrypted    zh:待解密数据内容
/// @param deviceID Device ID    zh:设备ID
/// @param productId Product ID    zh:产品ID
/// @param key decryption key    zh:解密密钥
/// @param accessToken accessToken
/// @param playtoken playtoken
/// @param pDestBufOut decrypted data content    zh:解密后数据内容
/// @return Decryption result    zh:解密结果
/// 0.indicating successful decryption    zh:0, 表示解密成功
/// 1.It indicates that integrity verification failed    zh:1, 表示完整性校验失败
/// 2.It indicates that the key is incorrect    zh:2, 表示密钥错误
/// 3.indicating that the picture is not encrypted    zh:3, 表示图片非加密
/// 4.Unsupported encryption method    zh:4, 不支持的加密方式
/// 5.Insufficient buffer length    zh:5, 缓冲区长度不够
/// 6.device key error   zh:5, 设备密码错误
/// 99.internal error    zh:99,内部错误
- (NSInteger)decryptPic:(NSData *)pSrcBufIn deviceID:(NSString*)deviceID productId:(NSString *)productId key:(NSString*)key accessToken:(NSString *)accessToken playtoken:(NSString *)playtoken bufOut:(NSData**)pDestBufOut;

/// mts streaming establishes a long connection in advance to increase the streaming speed    zh:mts拉流提前建立长连接，提高拉流速度
/// @param deviceDatas device data that needs to establish a long connection    zh:需要建立长连接的设备数据
/// @param token user token
+ (void)mtsPreKeepalive:(NSArray *)deviceDatas token:(NSString *)token;

@end

#endif

