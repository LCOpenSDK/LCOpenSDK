//
//  Copyright © 2016年 Imou. All rights reserved.
//


@interface LCEncryptValidInfo : NSObject
/**
 *  是否验证成功
 */
@property (nonatomic, assign) BOOL isValid;
/**
 *  账号的AccessToken
 */
@property (nonatomic, copy) NSString *accessToken;
/**
 *  过期时间，单位秒
 */
@property (nonatomic, assign) int64_t expiresTime;

@end



/**
 设备新加密信息
 */
@interface LCContentEncryptInfo : NSObject

/**
 内容加密模式：
 *  none 不加密
 *  Imou: 0x95扩展头加密
 */
@property (nonatomic, copy) NSString *encryptionMode;

/**
 密钥生成算法版本号，仅在encryptMode为"Imou"时有效
 *  easy4ip
 *  lechange
 *  Imoupass
 */
@property (nonatomic, copy) NSString *ruleVerison;

/**
 内容加密密钥种子keySeed的模式
 *  default 序列号
 *  custom  用户自定义的
 */
@property (nonatomic, copy) NSString *keyMode;
@end
