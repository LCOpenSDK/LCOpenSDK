//
//  LCBaseVideoItem.h
//  LCMediaComponents
//
//  Created by lei on 2021/1/29.
//

#import <Foundation/Foundation.h>
#import <LCOpenMediaSDK/LCVideoPlayerDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCBaseVideoItem : NSObject<NSCopying>

@property(nonatomic, copy)NSString *pid; //产品ID

@property(nonatomic, copy)NSString *did;   //设备序列号

@property(nonatomic, assign)NSInteger cid;  //通道号

@property(nonatomic, nullable, copy)NSString *bindPid; //绑定设备产品ID

@property(nonatomic, nullable, copy)NSString *bindDid; //绑定设备序列号

@property(nonatomic, assign)NSInteger bindCid; //绑定设备通道号

@property(nonatomic, copy)NSString *authName;  //设备名称(未加密)

@property(nonatomic, copy, nullable)NSString *authPassword;  //设备密码

@property (nonatomic, assign) NSInteger streamHandler; // 拉流句柄

@property (nonatomic, assign) NSInteger playport; // 播放port句柄

@property (nonatomic, strong, nullable)NSArray<LCBaseVideoItem *> *associcatChannels;

@end

NS_ASSUME_NONNULL_END
