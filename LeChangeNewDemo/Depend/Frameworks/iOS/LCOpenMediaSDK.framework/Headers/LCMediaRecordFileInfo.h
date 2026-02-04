//
//  LCMediaRecordFileInfo.h
//  LCMediaComponents
//
//  Created by lei on 2025/2/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCMediaRecordFileInfo : NSObject

@property(nonatomic, nullable, copy)NSString *pid; //产品ID

@property(nonatomic, copy)NSString *did;   //设备序列号

@property(nonatomic, assign)NSInteger cid;  //通道号

@property(nonatomic, copy)NSString *filePath; //文件路径

@property(nonatomic, assign)NSInteger duration; //文件时长 >=0: 获取文件时长， < 0 获取时长出错

@end

NS_ASSUME_NONNULL_END
