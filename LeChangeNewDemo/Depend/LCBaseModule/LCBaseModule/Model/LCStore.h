//
//  Copyright © 2016年 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LCStore : NSObject

@property (nonatomic, strong, readonly) NSDictionary *dicStore;

- (instancetype)initWithLocalPath:(NSString *)path;

- (id)getObjByKey:(const NSString *)key;

- (void)saveObj:(id)value withKey:(const NSString *)key;

/**
 追加写入

 @param dictionary 需要追加写入的字段
 */
- (void)saveAppended:(NSDictionary *)dictionary;

////储存密码到钥匙串
//+(void)lc_KC_StorePassword:(NSString *)password forService:(NSString *)serviceName account:(NSString *)account;
//
////获取密码从钥匙串
//+(NSString *)lc_KC_PasswordForService:(NSString *)serviceName account:(NSString *)account;
//
////储存密码到userdefault
//+(void)lc_UD_StoreValue:(NSString *)value forKey:(NSString *)key;
//
////获取值从userdefault
//+(id)lc_UD_ValueForKey:(NSString *)key;

@end
