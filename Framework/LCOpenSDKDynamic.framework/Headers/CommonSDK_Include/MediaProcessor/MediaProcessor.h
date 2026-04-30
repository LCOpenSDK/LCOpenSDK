//
//  MediaProcessor.h
//  MediaProcessor
//
//  Created by 李圣培 on 2023/5/10.
//

#import <Foundation/Foundation.h>

@interface MediaProcessor : NSObject

/**
 * 初始化媒体处理
 *
 * @param filePath: 本地媒体文件路径
 * @param partSize: 分片大小
 * @param startOffset: 开始的偏移
 * @param key: 加密秘钥因子，如userid
 * @param remoteStoragePath: 远端云存路径，如：7_record/6L0D407YAZF78C7_record/0_20230425095717758_613e01ea9ad449e3925f9d05791fa09c_20230425095721812sf0-1086560.dav
 * @return 返回初始化是否成功
 * - 0  成功
 * - -1 失败
 */
- (instancetype)initProcessorComponent:(NSString*)filePath PartSize:(NSInteger)partSize StartOffset:(NSInteger)startOffset EncryptKey:(NSString*)key RemoteStoragePath:(NSString*)remoteStoragePath;

/**
 * 获取加密后的帧数据
 *
 * @param key1: 加密秘钥因子1，如userid
 * @param key2: 加密秘钥因子2，如did
 * @param outData: 返回的加密数据
 * @return 返回初始化是否成功
 * - 0  成功
 * - -1 失败
 */
- (NSInteger)getEncryptedFramesWithData:(NSData**)outData;

/**
 * 生成录像m3u索引文件并返回其内容
 *
 * @param outData: 返回的加密数据
 * @return 返回初始化是否成功
 * - 0  成功
 * - -1 失败
 */
- (NSInteger)generateM3uWithMediaFile:(NSData**)outData;

/**
 * 获取录像信息
 *
 * @param startTime: 开始时间
 * @param endTime: 结束时间
 * @param fileSize: 文件大小
 * @return 返回初始化是否成功
 * - 0  成功
 * - -1 失败
 */
- (NSInteger)getMediaFileBasicInfo:(NSInteger*)startTime endTime:(NSInteger*)endTime FileSize:(NSInteger*)fileSize;

/**
 * 加密单帧图片（如jpg）
 *
 * @param inData: 输入的图片数据
 * @param outData: 输出的加密图片数据
 * @return 返回初始化是否成功
 * - 0  成功
 * - -1 失败
 */
- (NSInteger)encryptImageFrameData:(NSData*)inData OutData:(NSData**)outData;

/**
 * 加密单帧图片（如jpg）
 *
 * @param outData: 输出的加密图片数据
 * @return 返回初始化是否成功
 * - 0  成功
 * - -1 失败
 */
- (NSInteger)getImageEncryptedData:(NSData**)outData;

@end
