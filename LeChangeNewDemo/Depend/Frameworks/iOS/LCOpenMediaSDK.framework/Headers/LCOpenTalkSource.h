//
//  LCOpenTalkSource.h
//  LCMediaComponents
//
//  Created by lei on 2024/10/16.
//

#import <LCOpenMediaSDK/LCBaseTalkbackSource.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCOpenTalkSource : LCBaseTalkbackSource

//播放token,包含拉流相关参数和能力
@property(nonatomic, copy)NSString *playToken;
//playToken解析秘钥
@property(nonatomic, copy)NSString *playTokenKey;
//管理员token
@property(nonatomic, copy)NSString *accessToken;
//流解密秘钥
@property(nonatomic, copy)NSString *psk;
//是否使用tls链接
@property(nonatomic, assign)BOOL isTls;
/// 请求类型，talk对讲，call呼叫，如果不传，默认为talk
@property (nonatomic, copy) NSString *talkType;

@end

NS_ASSUME_NONNULL_END
