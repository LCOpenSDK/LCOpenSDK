//
//  LCDownloadCloudImageInfo.h
//  LCMediaComponents
//
//  Created by lei on 2023/9/15.
//

#import <Foundation/Foundation.h>
#import "LCMediaDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface LCCloudImageInfo : NSObject

@property(nonatomic, copy, nullable)NSString *pid;

@property(nonatomic, copy)NSString *did;

@property(nonatomic, copy)NSString *cid;

@property(nonatomic, assign)NSInteger index;

@property(nonatomic, copy)NSString *recordId;

@property(nonatomic, assign)NSInteger recordType;

@property(nonatomic, copy)NSString *region;

@property(nonatomic, copy)NSString *recordPath;

@end

NS_ASSUME_NONNULL_END
