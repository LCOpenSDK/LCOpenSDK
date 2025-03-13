//
//  NSString+Data.h
//  LCMediaComponents
//
//  Created by lei on 2021/3/23.
//

#import <Foundation/Foundation.h>

#ifdef LECHANGE_MEDIA
#import <CommonSDKoc/LCCommonSDK/CryptComponent/CryptComponent.h>
#else
#import <LCOpenSDKDynamic/CommonSDK_Include/CryptComponent/CryptComponent.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Data)

- (NSString *)lc_MD5String;

- (NSString *)hlsDecodeWith:(RULE_VERSION)ruleVersion;

+ (NSString*)transformTimeFromLong:(long)time;

@end

NS_ASSUME_NONNULL_END
