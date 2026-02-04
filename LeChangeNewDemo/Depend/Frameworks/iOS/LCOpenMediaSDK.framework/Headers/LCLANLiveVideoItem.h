//
//  LCLANLiveVideoItem.h
//  LCMediaComponents
//
//  Created by lei on 2023/2/8.
//

#import <LCOpenMediaSDK/LCOpenMediaSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCLANLiveVideoItem : LCMediaBaseVideoItem

@property(nonatomic, copy)NSString *deviceIP; //设备在局域网中的IP

@property(nonatomic, assign)NSInteger rtspPort; //rtsp媒体端口，不填默认为554

@property(nonatomic, assign)NSInteger privatePort; //私有协议端口，不填默认为8086

@property(nonatomic, assign)LCVideoStreamType streamType; // 码流类型

@property(nonatomic, assign)BOOL isTls; //是否使用tls链接

@property(nonatomic, assign)BOOL isPrivate; //私有协议

-(BOOL)isValid; //验证参数是否有效

@end

NS_ASSUME_NONNULL_END
