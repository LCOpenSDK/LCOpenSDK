//
//  Copyright (c) 2015年 Anson. All rights reserved.
//

#import "LCUDIDTool.h"

#define LAUDIDKEY_EXTENTION_FLAG @"LAUDID-KEY"
@interface LCUDIDTool()
{
    NSString *_udid;
}
@end

@implementation LCUDIDTool

static LCUDIDTool *oneInstance;
+ (instancetype)shareInstance
{
    @synchronized(self) {
        
        if (oneInstance == nil) {
            oneInstance = [[self alloc]init];
        }
    }
    return oneInstance;
}

//储存keyChain
- (void)saveKey:(NSString *)service value:(NSString *)value {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          (__bridge_transfer id)kSecClassGenericPassword,(__bridge_transfer id)kSecClass,
                                          service, (__bridge_transfer id)kSecAttrService,
                                          service, (__bridge_transfer id)kSecAttrAccount,
                                          (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,(__bridge_transfer id)kSecAttrAccessible,
                                          nil];
    CFDictionaryRef keychainQueryRef = (__bridge_retained CFDictionaryRef)keychainQuery;
    
    //Delete old item before add new item
    SecItemDelete(keychainQueryRef);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:value] forKey:(__bridge_transfer id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd(keychainQueryRef, NULL);
    CFRelease(keychainQueryRef);
    
}

//获取keyChain
- (NSString *)getWithKey:(NSString *)service {
    NSString *ret = nil;
    NSMutableDictionary *keychainQuery = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          (__bridge_transfer id)kSecClassGenericPassword,(__bridge_transfer id)kSecClass,
                                          service, (__bridge_transfer id)kSecAttrService,
                                          service, (__bridge_transfer id)kSecAttrAccount,
                                          (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,(__bridge_transfer id)kSecAttrAccessible,
                                          nil];
    //Configure the search setting
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    return ret;
}


#pragma mark -
#pragma mark UUIDString
- (NSString *)UDIDString
{
    if(_udid!=nil)
    {
        return _udid;
    }
    
    //根据bundleID 生产一个UDID_KEY
    //从keychain中取出对应UDID_KEY的值 如果没有那么生产一个随机的UUID 写入keychain 并返回
    
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSString *UDID_KEY = [NSString stringWithFormat:@"%@-%@",LAUDIDKEY_EXTENTION_FLAG, bundleID];

    NSString *uuidString ;
    
    @try
    {
        uuidString = [self getWithKey:UDID_KEY];
    }
    @catch (NSException *exception)
    {
        return nil;
    }
    @finally
    {
        
    }
    
    if(uuidString && [uuidString length])
    {
        _udid = uuidString;
        NSLog(@"-%@", uuidString);
        return uuidString;
    }
    
    
    @try
    {
        CFUUIDRef uuidRef = CFUUIDCreate(nil);
        CFStringRef stringRef = CFUUIDCreateString(nil, uuidRef);
        uuidString = (NSString *)CFBridgingRelease(CFStringCreateCopy(nil, stringRef));
        CFRelease(uuidRef);
        CFRelease(stringRef);
        
        [self saveKey:UDID_KEY value:uuidString];
        _udid = uuidString;
        return uuidString ;
    }
    @catch (NSException *exception)
    {
        return nil;
    }

}
@end
