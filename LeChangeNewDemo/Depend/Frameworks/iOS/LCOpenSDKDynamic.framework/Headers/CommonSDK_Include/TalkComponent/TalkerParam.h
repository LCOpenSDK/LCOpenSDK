//
//  TalkerParam.h
//  audioTalk
//
//  Created by mac318340418 on 16/7/26.
//  Copyright © 2016年 dahuatech. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark -对讲-反向视频参数
@interface TalkerVideoParam : NSObject
@property (nonatomic) NSInteger width;
@property (nonatomic) NSInteger height;
@property (nonatomic) NSInteger I_frame_interval;
@property (nonatomic) NSInteger encodeType;
@property (nonatomic) NSInteger frameRate;
@property (nonatomic) BOOL cameraStatus;
- (NSDictionary*)toDictionary;
@end

@interface TalkerParam : NSObject
@property (nonatomic) NSInteger talkerType;
@property (nonatomic) NSInteger encodeType;
@property (nonatomic) NSInteger sampleRate;
@property (nonatomic) NSInteger sampleDepth;
@property (nonatomic) NSInteger packType;
@property (nonatomic, copy) NSString *streamSaveDirectory;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *psw;
@property (nonatomic, copy) NSString *requestId;
@property (nonatomic)       bool      videoSampleEnable;
@property (nonatomic,strong) TalkerVideoParam   *videoSampleCfg;


- (TalkerParam *)initWithUrl:(NSString *)url Encrypt:(NSInteger)isEncrypt PSK:(NSString *)psk TLS:(BOOL)isTls DeviceSn:(NSString *)deviceSn userName:(NSString*)userName psw:(NSString*)psw ;

- (TalkerParam *)initWithLoginHandle:(void*)loginHandle TalkWithChannel:(BOOL)isTalkWithChannel Channel:(NSInteger)channel AutoDecideparam:(BOOL)isAutoDecideParam;

- (TalkerParam *)initWithUrl:(NSString *)url UrlV6:(NSString*)urlV6 QuicUrl:(NSString *)quicUrl Encrypt:(NSInteger)isEncrypt PSK:(NSString *)psk DeviceSn:(NSString*) deviceSn ShareMode:(NSInteger) shareMode HandleKey:(NSString*)HandleKey userName:(NSString*)userName psw:(NSString*)psw talkType:(NSString*)talkType TLS:(BOOL)isTls wssekey:(NSString *)wssekey isvideoSampleEnable:(BOOL)isVideoSampleEnable TID:(NSString*)tid;

- (instancetype)setSaveStreamFlag:(BOOL)isOpen;

- (NSString *)toJSONString;
@end


