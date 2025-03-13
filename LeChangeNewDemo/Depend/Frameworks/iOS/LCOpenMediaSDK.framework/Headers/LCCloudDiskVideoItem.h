//
//  LCCloudDiskVideoItem.h
//  LCMediaComponents
//
//  Created by lei on 2022/1/19.
//

#import <LCOpenMediaSDK/LCOpenMediaSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCCloudDiskVideoItem : LCBaseVideoItem

@property(nonatomic, assign)int64_t recordId; /**< 录像id */

@property(nonatomic, assign)NSInteger recordType;  //云存储录像类型(参考E_CLOUD_RECORD_TYPE)

@property(nonatomic, assign)NSInteger hlsType;  //hls类型(参考E_HLS_TYPE)

@property(nonatomic, assign)NSInteger startTime;  //起始播放时间(单位秒)

@property(nonatomic, assign)NSInteger timeout;  // 超时时间(单位秒)

@property(nonatomic, assign)NSInteger encryptMode;  //加密方式 0: 不加密  1: 原加密方式  3: 升级加密方式(AES256+0xB5)

@property(nonatomic, copy)NSString *psk;  //秘钥(明文MD5, 32位小写)

@property(nonatomic, copy)NSString *region;  //区域信息

@property(nonatomic, copy)NSString *recordPath;  //文件路径

@property(nonatomic, assign)CGFloat speed;  //录像播放倍数

@end

NS_ASSUME_NONNULL_END
