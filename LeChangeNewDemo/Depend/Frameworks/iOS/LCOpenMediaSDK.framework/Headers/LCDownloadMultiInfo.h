//
//  LCDownloadMultiInfo.h
//  LCMediaComponents
//
//  Created by lei on 2023/2/14.
//

#import <Foundation/Foundation.h>
#import <LCOpenMediaSDK/LCVideoPlayerDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCDownloadMultiInfo : NSObject

@property(nonatomic, assign)NSInteger index;

@property(nonatomic, copy)NSString *filepath; //录像文件本地保存目录

@property(nonatomic, copy)NSString *devIP; //局域网内的设备IP

@property(nonatomic, assign)NSInteger rtspPort; //rtsp媒体端口 默认554，以实际为准

@property(nonatomic, assign)NSInteger httpPrivatePort; //私有协议端口 默认8086 ，以实际为准

@property(nonatomic, copy)NSString *userName; //设备用户名

@property(nonatomic, copy)NSString *password; //设备密码

@property(nonatomic, assign)NSInteger channel; //通道号

@property(nonatomic, assign)LCVideoStreamType streamType; // 码流类型

@property(nonatomic, copy)NSString *recordId; //按录像文件下载时，该文件位于设备上的**绝对路径**

@property(nonatomic, assign)BOOL isTls; //是否使用tls链接

@end

NS_ASSUME_NONNULL_END
