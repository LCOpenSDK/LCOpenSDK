//
//  LCOpenDeviceTimeSource.h
//  LCMediaComponents
//
//  Created by lei on 2024/10/14.
//

#import <LCOpenMediaSDK/LCOpenMediaBaseVideoItem.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCOpenDeviceTimeSource : LCOpenMediaBaseVideoItem

/// begin time    zh:开始时间
@property (nonatomic, assign) long             startTime;
/// end time    zh:结束时间
@property (nonatomic, assign) long             endTime;
// 码流类型
@property(nonatomic, assign)BOOL isMainStream;
//是否强制MTS
@property(nonatomic, assign)BOOL forceMts;
/// play double speed    zh:播放倍速
@property (nonatomic, assign)float speed;
/// 录像类型: 0:SD卡录像   1:NVR录像
@property(nonatomic, assign)LCOpenMediaRecordType recordType;

@end

NS_ASSUME_NONNULL_END
