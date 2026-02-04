//
//  LCRecorderDeviceDownloadInfo.h
//  LCMediaComponents
//
//  Created by lei on 2024/8/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCRecorderDeviceDownloadInfo : NSObject

@property(nonatomic, assign)NSInteger index; //索引

@property(nonatomic, copy)NSString *filepath; //录像文件本地保存目录

@property(nonatomic, assign)NSInteger recorderType; //文件格式 MP4 (1)

@property(nonatomic, copy)NSString *httpUrl; //下载地址：文件方式的下载地址

@property(nonatomic, assign)NSInteger isUseCache; //是否断点(暂不支持,传false)

@end

NS_ASSUME_NONNULL_END
