//
//  LCLANDeviceFileVideoItem.h
//  LCMediaComponents
//
//  Created by lei on 2023/2/13.
//

#import <LCOpenMediaSDK/LCOpenMediaSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCLANDeviceFileVideoItem : LCMediaBaseVideoItem

@property(nonatomic, copy)NSString *deviceIP; //设备在局域网中的IP

@property(nonatomic, assign)NSInteger rtspPort; //rtsp媒体端口，不填默认为554

@property(nonatomic, assign)NSInteger privatePort; //私有协议端口，不填默认为8086

@property(nonatomic, assign)LCVideoStreamType streamType; // 码流类型

@property(nonatomic, assign)NSTimeInterval startTime; //按时间回放必传参数

@property(nonatomic, copy)NSString *playbackFile; //按文件回放必传参数

@property(nonatomic, assign)CGFloat speed; //倍速

@property(nonatomic, assign)BOOL isPrivate; //私有协议

@property(nonatomic, assign)BOOL isTls; //是否使用tls链接

-(BOOL)isValid; //验证参数是否有效

@end

NS_ASSUME_NONNULL_END
