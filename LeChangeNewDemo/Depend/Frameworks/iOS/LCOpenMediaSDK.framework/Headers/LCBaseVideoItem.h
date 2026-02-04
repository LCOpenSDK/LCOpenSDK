//
//  LCBaseVideoItem.h
//  LCMediaComponents
//
//  Created by lei on 2021/1/29.
//

#import <Foundation/Foundation.h>
#import <LCOpenMediaSDK/LCVideoPlayerDefines.h>
#import "LCBindDeviceInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCBaseVideoItem : NSObject<NSCopying>

@property(nonatomic, nullable, copy)NSString *pid; //产品ID

@property(nonatomic, copy)NSString *did;   //设备序列号

@property(nonatomic, assign)NSInteger cid;  //通道号

@property(nonatomic, copy)NSString *authName;  //设备名称(未加密)

@property(nonatomic, copy, nullable)NSString *authPassword;  //设备密码

@property (nonatomic, strong, nullable)NSArray<LCBaseVideoItem *> *associcatChannels; //多目关联

@property(nonatomic, assign)LCMediaPlayNoiseAbility noiseLevel;

//目标pid
-(NSString *__nullable)targetPid;

//目标did
-(NSString *__nullable)targetDid;

//目标通道号
-(NSInteger)targetCid;

@end

NS_ASSUME_NONNULL_END
