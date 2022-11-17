//
//  Copyright © 2019 Imou. All rights reserved.
//  文本有效性验证

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Verify)

/**
 检查空串

 @return 有效性
 */
- (BOOL)isNull;

/**
 检查是否有效手机号

 @return 有效返回YES
 */
- (BOOL)isVaildPhone;

/**
 获取有效设备名称

 @return 有效的设备名称
 */
-(NSString *)vaildDeviceName;

 /**
是否6位安全码
*/
-(BOOL)isSafeCode;

/**
是否10-32 位数字加字母的有效序列号
*/
-(BOOL)isVaildSNCode;

/**
是否全是数字
*/
-(BOOL)isFullNumber;

/**
是否全是字母
*/
-(BOOL)isFullChar;

/**
是否为有效的设备密码位数
*/
-(BOOL)isVaildPasswordBit;

/**
是否存在空格
*/
-(BOOL)isExistBlankSpace;

/**
是否有效海外序列号
*/
-(BOOL)isVaildOverseaSNCode;

/**
是否为有效的URL
*/
-(BOOL)isVaildURL;
/**
是否为汉字
*/
-(BOOL)isCharactor;

/**
是否为有效邮箱
*/
- (BOOL)isVaildEmail;

/**
是否为有效的设备名称
*/
-(BOOL)isVaildDeviceName;

//根据正则，过滤特殊字符
- (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr;

@end

NS_ASSUME_NONNULL_END
