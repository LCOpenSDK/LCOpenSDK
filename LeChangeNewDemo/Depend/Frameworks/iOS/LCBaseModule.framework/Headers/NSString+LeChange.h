//
//  Copyright (c) 2015年 Imou. All rights reserved.
//  NSString扩展

#import <UIKit/UIKit.h>

typedef enum {
    StringTypeNumber,
    StringTypeLetter,
    StringTypeLetterAndNumber
} StringType;

@interface NSString(LeChange)

@property (nonatomic) BOOL isAbsent; //Defualt is NO.if yes,string is nil or length is 0.

//获取json值
- (id)lc_jsonValue;

//判断字符串类型
- (BOOL)lc_isStringType:(StringType)type;

/**
 字典转Json
 @param dic 字典
 @return 字符串
 */
+ (NSString*)lc_dictionaryToJson:(NSDictionary *)dic;

/**
 *  返回整型数字的字符串形式
 *  @param intNum 整型数字
 *  @return 字符串
 */
+ (NSString *)lc_stringWithInt:(NSInteger)intNum;

/**
 *  返回特定字体的字符串的尺寸
 *  @param font 字体
 *  @param size 限制的尺寸
 *  @return CGSize 尺寸
 */
- (CGSize)lc_sizeWithFont:(UIFont *)font size:(CGSize)size;

/**
 *  返回单行字符串宽度
 *  @param 字体
 *  @return CGFloat 宽度
 */
- (CGFloat)lc_widthWithFont:(UIFont *)font;

/**
 *  @author peng_kongan, 16-01-16 14:01:07
 *
 *  @brief  获取文字所占空间的大小
 *
 *  @param font 文字的字体
 *
 *  @return
 */
- (CGRect)lc_rectWithFont:(UIFont *)font;

/**
 *  判断字符串是否为空
 *
 *  @param content 判断的内容
 *
 *  @return yes表示为空
 */
+ (BOOL)lc_isEmpty:(NSString*)content;

//进行Base64编码
- (NSString *)lc_base64String;

//Base64解码
- (NSString *)lc_decodeBase64;

/**
 *  使用系统的函数，进行aes256加密
 *
 *  @param key 密钥
 *
 *  @return 加密后的字符串
 */
- (NSString *)lc_AES256Encrypt:(NSString *)key;

/**
 *  使用系统的函数，进行aes256解密
 *
 *  @param key 密钥
 *
 *  @return 解密后的字符串
 */
- (NSString *)lc_AES256Decrypt:(NSString *)key;

/**
 *  对手机号进行加密，中间4未隐藏
 *
 *  @return 155****1234
 */
- (NSString *)lc_phoneNumberWithEncrypt;

/**
 *  是否符合正则表达式
 *
 *  @param format 正则表达式
 *
 *  @return 是否符合
 */
- (BOOL)lc_matchTheFormat:(NSString*)format;

/**
 匹配多分割字符串

 @param matchString 需要匹配的字符串
 @param splitString 分割字符串
 @return 是否包含
 */
- (BOOL)lc_strictContainString:(NSString*)matchString split:(NSString*)splitString;

- (BOOL)lc_isValidIphoneNum;

- (BOOL)lc_isValidEmail;

- (BOOL)lc_isAllNum;

+ (NSString *)getGatewayIpForCurrentWiFi;

+ (NSString *)getCurreWiFiSsid;

/**
 返回当前的语言

 @return eg 'zh-CN'
 */
+ (NSString *)lc_currentLanguageCode;

@end
