//
//  Copyright © 2016年 Imou. All rights reserved.
//

#import <LCBaseModule/LCStore.h>
#import <LCBaseModule/LCFileManager.h>

@interface LCStore() {
    NSMutableDictionary *_storeDic;
    
    NSString *_localPath;
}

@end

@implementation LCStore


- (instancetype)initWithLocalPath:(NSString *)path {
    if (self = [super init]) {
        _localPath = path;
        NSLog(@" %@:: Init with local path - %@", NSStringFromClass([self class]), path);
        _storeDic = [NSMutableDictionary dictionaryWithContentsOfFile:_localPath];;
        if (_storeDic == nil) {
            _storeDic = [NSMutableDictionary new];
        }
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        NSString *configfilepath = [LCFileManager configFilePath];
        NSLog(@" %@:: Init with config file path - %@", NSStringFromClass([self class]), configfilepath);
        _storeDic = [NSMutableDictionary dictionaryWithContentsOfFile:configfilepath];;
        if (_storeDic == nil) {
            _storeDic = [NSMutableDictionary new];
        }
    }
    return self;
}

- (NSDictionary *)dicStore {
    return [_storeDic copy];
}

#pragma mark - 数据存储
- (id)getObjByKey:(NSString *)key {
    return _storeDic[key];
}

- (void)saveObj:(id)value withKey:(NSString *)key {
    @synchronized(self)
    {
        if (key == nil) {
            return;
        }
        
        //如果与现在的值一样  没必要再写一次文件
        if (_storeDic[key]!= nil && [value isKindOfClass:[NSNumber class]] && [_storeDic[key] isKindOfClass:[NSNumber class]]) {
            NSNumber *num1 = (NSNumber *)value;
            NSNumber *num2 = (NSNumber *)_storeDic[key];
            if ([num1 isEqualToNumber:num2]) {
                return ;
            }
        }
        
        _storeDic[key] = value;
        [self saveDictionary];
    }
    
}

- (BOOL)saveDictionary {
    return [_storeDic writeToFile:_localPath atomically:YES];
}

- (void)saveAppended:(NSDictionary *)dictionary {
    [_storeDic addEntriesFromDictionary:dictionary];
    
    for (id key in _storeDic.allKeys) {
        [self saveObj:_storeDic[key] withKey:key];
    }
}

//+ (void)lc_KC_StorePassword:(NSString *)password forService:(NSString *)serviceName account:(NSString *)account {
//    [YYKeychain setPassword:password forService:serviceName account:account];
//}
//
////获取密码从钥匙串
//+ (NSString *)lc_KC_PasswordForService:(NSString *)serviceName account:(NSString *)account {
//    NSString *password = [YYKeychain getPasswordForService:serviceName account:account];
//    if (!password) {
//        password = @"";
//    }
//    return password;
//}

////储存密码到userdefault
//+(void)lc_UD_StoreValue:(NSString *)value forKey:(NSString *)key{
//    [[NSUserDefaults standardUserDefaults] set]
//}
//
////获取值从userdefault
//+(id)lc_UD_ValueForKey:(NSString *)key{
//  return [[NSUserDefaults standardUserDefaults] objectForKey:key];
//}


@end
