//
//  LCCloudVideoItem.h
//  LCMediaModule
//
//  Created by lei on 2021/1/14.
//

#import <LCOpenMediaSDK/LCMediaBaseVideoItem.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCCloudVideoItem : LCMediaBaseVideoItem

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
/*云录像优化接口新字段*/
@property(nonatomic, copy)NSString *streamAddr;  //下载文件的地址

@property(nonatomic, copy)NSString *ak;  //鉴权相关AK

@property(nonatomic, copy)NSString *fileToken;  //文件鉴权token

@property (nonatomic, copy) NSString *uid; // uid为用户id

@property (nonatomic, copy) NSString *expireTime; // 过期时间，录像查询时平台返回的字段

@property (nonatomic, copy, nullable) NSString *m3uLocalPath; // m3u本地文件路径

@end

NS_ASSUME_NONNULL_END
