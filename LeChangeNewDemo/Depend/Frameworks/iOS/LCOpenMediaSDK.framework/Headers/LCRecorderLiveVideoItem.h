//
//  LCRecorderLiveVideoItem.h
//  LCMediaComponents
//
//  Created by lei on 2024/8/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCRecorderLiveVideoItem : NSObject

//拉流地址(Ex: rtsp://192.72.1.1/liveRTSP/av4)
@property(nonatomic, copy)NSString *url;

// 0（overTCP）、1（RTP_overUDP）、3（RTP_overTCP） 4（CONN_DH_RTP_OVER_TCP）标准RTSP协议如行车记录仪 值为“1”，大华设备RTSP可不填该字段或者默认为 “4”
@property(nonatomic, assign)NSInteger connType;

-(BOOL)isValid; //验证参数是否有效

@end

NS_ASSUME_NONNULL_END
