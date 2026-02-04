//
//  LCOpenCloudSource.h
//  LCMediaComponents
//
//  Created by lei on 2024/10/14.
//

#import <LCOpenMediaSDK/LCOpenMediaBaseVideoItem.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCOpenCloudSource : LCOpenMediaBaseVideoItem

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

/*云录像优化接口新字段*/
@property(nonatomic, copy)NSString *recordPath;  //文件路径

@property(nonatomic, copy)NSString *region;  //区域信息

@property(nonatomic, copy)NSString *streamAddr;  //下载文件的地址

@property(nonatomic, copy)NSString *ak;  //鉴权相关AK

@property(nonatomic, copy)NSString *fileToken;  //文件鉴权token

@property (nonatomic, copy) NSString *uid; // uid为用户id

@property (nonatomic, copy) NSString *expireTime; // 过期时间，录像查询时平台返回的字段

@property (nonatomic, copy, nullable) NSString *m3uLocalPath; // m3u本地文件路径

/*云图播放参数*/
@property(nonatomic, assign)NSInteger playframeRate; //播放码流帧率;云图播放使用(云录像播放可不传)

@property(nonatomic, assign)NSInteger hlsType;  //hls类型(云图播放:6; 云录像播放可不传,默认0)

@end

NS_ASSUME_NONNULL_END
