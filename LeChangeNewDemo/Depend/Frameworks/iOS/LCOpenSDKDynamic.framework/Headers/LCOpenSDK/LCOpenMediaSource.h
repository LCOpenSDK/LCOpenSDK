//
//  LCOpenMediaSource.h
//  LCOpenSDKDynamic
//
//  Created by lei on 2024/10/11.
//  Copyright © 2024 Fizz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCOpenMediaSource : NSObject

@property(nonatomic, copy)NSString *pid; //产品ID

@property(nonatomic, copy)NSString *did;   //设备序列号

@property(nonatomic, assign)NSInteger cid;  //通道号

@property(nonatomic, nullable, copy)NSString *bindPid; //绑定设备产品ID

@property(nonatomic, nullable, copy)NSString *bindDid; //绑定设备序列号

@property(nonatomic, assign)NSInteger bindCid; //绑定设备通道号

//播放token,包含拉流相关参数和能力
@property(nonatomic, copy)NSString *playToken;
//playToken解析秘钥
@property(nonatomic, copy)NSString *playTokenKey;
//管理员token/用户token
@property (nonatomic, copy, nonnull)NSString *accessToken;
//流解密秘钥
@property(nonatomic, copy)NSString *psk;
//是否使用tls链接
@property(nonatomic, assign)BOOL isTls;
// 码流类型
@property(nonatomic, assign)BOOL isMainStream;
// 码流分辨率
@property (nonatomic, assign) NSInteger        imageSize;
// 是否辅助帧默认关闭
@property (nonatomic, assign) BOOL        isAssistFrame;

@property(nonatomic, assign)BOOL isOpenAudio;

@property(nonatomic, assign)BOOL forceMts;

@end

NS_ASSUME_NONNULL_END
