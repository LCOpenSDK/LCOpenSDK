//
//  Copyright © 2018年 Imou. All rights reserved.
//

#import "NSData+SHA256.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCrypto.h>

@implementation NSData (SHA256)


- (NSData *)lc_SHA256Data
{
    const char *cstr = [self bytes];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
    NSData *result = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    
    return result;
}

- (NSData *)reverseData {
    const char *bytes = [self bytes];
    int idx = (int)[self length] - 1;
    char *reversedBytes = calloc(sizeof(char),[self length]);
    for (int i = 0; i < [self length]; i++) {
        reversedBytes[idx--] = bytes[i];
    }
    NSData *reversedData = [NSData dataWithBytes:reversedBytes length:[self length]];
    free(reversedBytes);
    return reversedData;
}

- (NSString *)data2Str
{
    NSData *data = self;
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;

}

- (NSData *)AES256CBCOperation:(uint32_t)operation keyData:(NSData *)key ivData:(NSData *)iv
{
    char keyPtr[kCCKeySizeAES256 + 1];
    bzero(keyPtr, sizeof(keyPtr));

    const void* tempkey = [key bytes];
    NSLog(@"%ld", strlen(tempkey));
    memcpy(keyPtr,tempkey,kCCKeySizeAES256);

    // IV
    char ivPtr[kCCBlockSizeAES128 + 1];
    bzero(ivPtr, sizeof(ivPtr));
    memcpy(ivPtr,[iv bytes],kCCBlockSizeAES128);
    
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

//将NSString转换成十六进制的字符串则可使用如下方式:
- (NSString *)lc_convertToHexString {
    
    if (self == nil) {
        return nil;
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[self length]];
    
    [self enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

@end
