//
//  Copyright © 2017年 Imou. All rights reserved.
//

#import "NSData+AES.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation NSData (AES)

//加密
- (NSData *)lc_AES256CBCEncryptWithKey:(NSString *)key iv:(NSString *)iv
{
    return [self AES256CBCOperation:kCCEncrypt key:key iv:iv];
}

- (NSData *)lc_AES256CBCDecryptWithKey:(NSString *)key iv:(NSString *)iv
{
    return [self AES256CBCOperation:kCCDecrypt key:key iv:iv];
}


#pragma mark - private method
- (NSData *)AES256CBCOperation:(CCOperation)operation key:(NSString *)key iv:(NSString *)iv
{
    char keyPtr[kCCKeySizeAES256 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:
     sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    // IV
    char ivPtr[kCCBlockSizeAES128 + 1];
    bzero(ivPtr, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    size_t bufferSize = [self length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptorStatus = CCCrypt(operation, kCCAlgorithmAES128, kCCOptionPKCS7Padding, keyPtr, kCCKeySizeAES256, ivPtr, [self bytes], [self length], buffer, bufferSize, &numBytesEncrypted);
    
    if(cryptorStatus == kCCSuccess)
    {
        NSLog(@"AES256operation Success %u", operation);
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }else
    {
        NSLog(@"AES256operation Error  %u", operation);
    }
    free(buffer);
    return nil;
}

@end
