//
//  LCOpenCloudSource.h
//  LCMediaComponents
//
//  Created by lei on 2024/10/14.
//

#import <LCOpenMediaSDK/LCOpenMediaSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCOpenCloudSource : LCBaseVideoItem

//播放token,包含拉流相关参数和能力
@property(nonatomic, copy)NSString *playToken;
//playToken解析秘钥
@property(nonatomic, copy)NSString *playTokenKey;
//管理员token
@property(nonatomic, copy)NSString *accessToken;
//设备密钥
@property (nonatomic, copy, nullable)NSString  *psk;
/// record id
@property (nonatomic, copy, nonnull)NSString *recordRegionId;
/// offset time    zh:偏移时间
@property (nonatomic, assign)double offsetTime;
/// record type    zh:录像类型
@property (nonatomic, assign)NSInteger recordType;
/// time out    zh:超时时间
@property (nonatomic, assign)NSInteger timeout;
/// play double speed    zh:播放倍速
@property (nonatomic, assign)float speed;

@end

NS_ASSUME_NONNULL_END
