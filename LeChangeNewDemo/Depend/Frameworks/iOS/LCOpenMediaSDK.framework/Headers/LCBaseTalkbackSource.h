//
//  LCBaseTalkbackSource.h
//  LCMediaComponents
//
//  Created by lei on 2021/10/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCBaseTalkbackSource : NSObject

@property(nonatomic, copy)NSString *pid; //产品ID

@property(nonatomic, copy)NSString *did;   //设备序列号

@property(nonatomic, assign)NSInteger cid;  //通道号

@property(nonatomic, nullable, copy)NSString *bindPid; //绑定设备产品ID

@property(nonatomic, nullable, copy)NSString *bindDid; //绑定设备序列号

@property(nonatomic, assign)NSInteger bindCid; //绑定设备通道号

@property(nonatomic, copy)NSString *authName;  //设备名称(未加密)

@property(nonatomic, copy, nullable)NSString *authPassword;  //设备密码

@end

NS_ASSUME_NONNULL_END
