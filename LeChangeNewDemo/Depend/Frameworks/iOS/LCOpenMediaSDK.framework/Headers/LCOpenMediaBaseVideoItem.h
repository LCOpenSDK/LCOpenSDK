//
//  LCOpenMediaBaseVideoItem.h
//  LCOpenMediaSDK
//
//  Created by lei on 2025/9/10.
//

#import <LCOpenMediaSDK/LCBaseVideoItem.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCOpenMediaBaseVideoItem : LCBaseVideoItem

//播放token,包含拉流相关参数和能力
@property(nonatomic, copy)NSString *playToken;
//playToken解析秘钥
@property(nonatomic, copy)NSString *playTokenKey;
//管理员token
@property(nonatomic, copy)NSString *accessToken;
//设备密钥
@property (nonatomic, copy, nullable)NSString  *psk;

@end

NS_ASSUME_NONNULL_END
