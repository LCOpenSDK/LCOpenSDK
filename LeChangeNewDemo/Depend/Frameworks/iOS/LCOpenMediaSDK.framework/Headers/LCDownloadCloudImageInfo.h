//
//  LCDownloadCloudImageInfo.h
//  LCMediaComponents
//
//  Created by lei on 2023/9/15.
//

#import <Foundation/Foundation.h>
#import "LCMediaDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCDownloadCloudImageInfo : NSObject

@property(nonatomic, copy, nullable)NSString *pid;

@property(nonatomic, copy)NSString *did;

@property(nonatomic, copy)NSString *cid;

@property(nonatomic, assign)NSInteger index;

@property(nonatomic, copy)NSString *recordId;

@property(nonatomic, assign)E_CLOUD_RECORD_TYPE recordType;

@property(nonatomic, assign)NSInteger encryptMode;

@property(nonatomic, copy)NSString *psk;

@property(nonatomic, copy)NSString *region;

@property(nonatomic, copy)NSString *recordPath;

@property(nonatomic, copy)NSString *username;

@property(nonatomic, copy)NSString *password;

@property(nonatomic, copy)NSString *filepath; //录像文件本地保存目录

@property(nonatomic, assign)NSInteger frameRate;

@end

NS_ASSUME_NONNULL_END
