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
/*
*   解密结果
*   0, 表示解密成功
*   1, 表示完整性校验失败
*   2, 表示密钥错误
*   3, 表示图片非加密
*   4, 不支持的加密方式
*   5, 缓冲区长度不够
*   99,内部错误
*/
typedef NS_ENUM(NSInteger, LC_ENCRYPT_CODE)
{
    ENCRYPT_SUCCESS = 0,
    ENCRYPT_CHECK_FAIL,
    ENCRYPT_KEY_ERROR,
    ENCRTPT_NONE,
    ENCRYPT_BUFFER_LACK,
    ENCRYPT_INSIDE_ERROR = 99
};

@interface LCOpenSDK_Utils: NSObject

/**
*数据解密
*
*@param pSrcBufIn     [in]  待解密数据内容
*@param devKeyIn      [in]  解密密钥
*@param devIDIn       [in]  设备序列号
*@param pDestBufOut   [out] 解密后数据内容
*
*@return 解密结果
*   0, 表示解密成功
*   1, 表示完整性校验失败
*   2, 表示密钥错误
*   3, 表示图片非加密
*   4, 不支持的加密方式
*   5, 缓冲区长度不够
*   99,内部错误
*/

-(NSInteger) decryptPic:(NSData *)pSrcBufIn deviceID:(NSString*)deviceID key:(NSString*)key bufOut:(NSData**)pDestBufOut;


/**
 *数据解密TCM设备
 *
 *@param pSrcBufIn     [in]  待解密数据内容
 *@param devKeyIn      [in]  解密密钥
 *@param devIDIn       [in]  设备序列号
 *@param tokenIn       [in]  token
 *@param pDestBufOut   [out] 解密后数据内容
 *
 *@return 解密结果
 *   0, 表示解密成功
 *   1, 表示完整性校验失败
 *   2, 表示密钥错误
 *   3, 表示图片非加密
 *   4, 不支持的加密方式
 *   5, 缓冲区长度不够
 *   99,内部错误
 */
-(NSInteger) decryptPic:(NSData *)pSrcBufIn deviceID:(NSString*)deviceID key:(NSString*)key token:(NSString *)token bufOut:(NSData**)pDestBufOut;
@end

#endif
