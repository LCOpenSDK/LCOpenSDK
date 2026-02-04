//
//  LCOpenDeviceFileSource.h
//  LCMediaComponents
//
//  Created by lei on 2024/10/14.
//

#import <LCOpenMediaSDK/LCOpenMediaBaseVideoItem.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCOpenDeviceFileSource : LCOpenMediaBaseVideoItem

/// video name    zh:录像文件名
@property (nonatomic, copy, nonnull) NSString      *fileId;
/// offset time    zh:偏移时间
@property (nonatomic, assign) double               offsetTime;
// 码流类型
@property(nonatomic, assign)BOOL isMainStream;
//是否强制MTS
@property(nonatomic, assign)BOOL forceMts;
/// play double speed    zh:播放倍速
@property(nonatomic, assign)float speed;
/// 录像类型: 0:SD卡录像   1:NVR录像
@property(nonatomic, assign)LCOpenMediaRecordType recordType;

@end

NS_ASSUME_NONNULL_END
