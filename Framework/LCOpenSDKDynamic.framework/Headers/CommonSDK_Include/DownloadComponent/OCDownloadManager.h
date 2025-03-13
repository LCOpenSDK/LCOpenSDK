//
//  OCLCObtainerManager.h
//  DownloadComponent
//
//  Created by mac318340418 on 16/5/21.
//  Copyright © 2016年 dh-Test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOCDownloadListener.h"

@interface OCDownloadManager : NSObject

+ (OCDownloadManager *) shareMyInstance;

- (bool) startDownload:(NSInteger)index
              filepath:(NSString *)filepath
                   Url:(NSString *)m3u8Url
                Prefix:(NSString *)slicePrefix
             ProtoType:(NSInteger)iProtoType
               Decrypt:(NSInteger)bNeedDecrypt
            Decryptkey:(NSString *)decryptkey
                  Type:(NSInteger)recorderType
               Timeout:(NSInteger)timeout
             ExtraInfo:(NSString *)extraInfo
                 Token:(NSString *)token
              DeviceSn:(NSString *)deviceSn
              UserName:(NSString *)userName
              PassWord:(NSString *)passWord;

- (bool) startDownload:(NSInteger)index
              Filepath:(NSString *)filepath
               RtspUrl:(NSString *)rtspUrl
               Decrypt:(NSInteger)bNeedDecrypt
            Decryptkey:(NSString *)decryptkey
         StartMillSecs:(NSInteger)startMillSecs
          RecorderType:(NSInteger)recorderType
                 Speed:(float)speed;

- (bool) startDownLoadRtsp:(NSInteger)index
                  FilePath:(NSString *)filePath
                   RtspUrl:(NSString *)rtspURL
                  UserName:(NSString *)userName
                  PassWord:(NSString *)passWord
               EncryptMode:(NSInteger)encryptMode
                EncryptKey:(NSString *)encryptKey
               StartOffset:(NSInteger)startOffset
                RecordType:(NSInteger)recordType
                  DeviceSn:(NSString *)deviceSn
                     IsTls:(BOOL)isTls
                     Speed:(float)speed;
/**
 支持断点续传接口
 */
- (bool) startDownLoadRtsp:(NSInteger)index
                  FilePath:(NSString *)filePath
                   RtspUrl:(NSString *)rtspURL
                  UserName:(NSString *)userName
                  PassWord:(NSString *)passWord
               EncryptMode:(NSInteger)encryptMode
                EncryptKey:(NSString *)encryptKey
               StartOffset:(NSInteger)startOffset
                RecordType:(NSInteger)recordType
                  DeviceSn:(NSString *)deviceSn
                     IsTls:(BOOL)isTls
                     Speed:(float)speed
                IsUseCache:(BOOL)isUsecache;


- (bool) startDownLoadHttp:(NSInteger)index
                  FilePath:(NSString *)filePath
                   HttpUrl:(NSString *)httpURL
                  UserName:(NSString *)userName
                  PassWord:(NSString *)passWord
                  DeviceSn:(NSString *)deviceSn
               EncryptMode:(NSInteger)encryptMode
                EncryptKey:(NSString *)encryptKey
               StartOffset:(NSInteger)startOffset
                RecordType:(NSInteger)recordType
                     IsTls:(BOOL)isTls
                     Speed:(float)speed
                   isLocal:(BOOL)isLocal;

/**
支持断点续传接口
*/
- (bool) startDownLoadHttp:(NSInteger)index
                  FilePath:(NSString *)filePath
                   HttpUrl:(NSString *)httpURL
                   QuicUrl:(NSString *)quicURL
                  UserName:(NSString *)userName
                  PassWord:(NSString *)passWord
                  DeviceSn:(NSString *)deviceSn
               EncryptMode:(NSInteger)encryptMode
                EncryptKey:(NSString *)encryptKey
               StartOffset:(NSInteger)startOffset
                RecordType:(NSInteger)recordType
                     IsTls:(BOOL)isTls
                     Speed:(float)speed
                IsUseCache:(BOOL)isUseCache
                   isLocal:(BOOL)isLocal;

/**
 局域网本地录像下载
 */
-(bool)startDownloadDHDevRecordFile:(NSInteger)index
                           FilePath:(NSString *)filePath
                        loginhandle:(NSString *)netSdkHandle
                          channelId:(NSInteger)channelId
                         streamType:(NSInteger)streamType
                          startTime:(NSInteger)startTime
                            endTime:(NSInteger)endTime
                         recordType:(NSInteger)recordType
                       downloadType:(NSInteger)downLoadType;



/**
支持多种协议并发拉流下载
*/
- (bool) startDownLoadEx:(NSInteger)index
                  FilePath:(NSString *)filePath
                  Devip:(NSString *)devip
                  RtspPort:(NSInteger)rtspPort
                  HttpPrivatePort:(NSInteger)httpPrivatePort
                  UserName:(NSString *)userName
                  Password:(NSString *)password
                  Wsse:(NSString *)wsse
                  Channel:(NSInteger)channel
                  Subtype:(NSInteger)subtype
                  RecordType:(NSInteger)recordType
                  FileID:(NSString *)fileID
                  IsTls:(BOOL)isTls;

/**
 * 下载卡录像封面图
 * index          任务编号
 * HttpUrl        下载地址：按时间方式的下载地址
 * QuicUrl        Quic下载地址（可选）
 * UserName       设备账户名
 * PassWord       设备密码
 * DeviceSn       设备序列号
 * EncryptMode    加密模式
 * EncryptKey     解密密钥
 * IsTls          是否使用TLS
 * Speed          下载速度
 * IsUseCache     是否断点，保留用参数：暂写死传false
 * fileID         文件ID
*/
- (bool) DownLoadDeviceRecordThumbs:(NSInteger)index
                  HttpUrl:(NSString *)httpURL
                  QuicUrl:(NSString *)quicURL
                  UserName:(NSString *)userName
                  PassWord:(NSString *)passWord
                  DeviceSn:(NSString *)deviceSn
               EncryptMode:(NSInteger)encryptMode
                EncryptKey:(NSString *)encryptKey
                     IsTls:(BOOL)isTls
                     Speed:(float)speed
                IsUseCache:(BOOL)isUseCache
                  FileID:(NSString *)fileID;
				  
/** 取消下载 */
- (bool) stopDownload:(NSInteger)index;

/** 完成下载 */
- (bool) finishDownload:(NSInteger)index;

/** 暂停下载，当使用断点续传下载时有效，不使用断点续传下载，相当于stopDownload接口 */
- (void) pauseDownload:(NSInteger)index;

//注册回调函数
- (void) setListener:(id<IOCDownloadListener>)listener;

/* 获取码流文件大小（按有效帧数据大小计算） */
- (int) getLocalStreamFileSize:(NSString*)filePath;

/* 设置首图存储路径 */
- (bool) setFirstFrameStoragePath:(NSInteger)index Path:(NSString*)path;

/**
 * 设置录像下载的结束位置
 * @param index     下载任务编号
 * @param posType   位置类型：1-按帧号定位（用于后续扩展，目前写死1即可）
 * @param endPos    结束位置
 */
- (bool) setDownloadEndPos:(NSInteger)index PosType:(NSInteger)posType EndPos:(NSInteger)endPos;

/* 获取码流文播放时长 */
- (int) getLocalStreamFileDuration:(NSString*)filePath;

/* 获取最后中断下载的录像id */
- (NSString*) getPausedFileID:(NSString*)filePath;

/**
 * 获取云图地址信息（同步接口）
 * @param index         任务编号
 * @param m3u8Url       m3u地址
 * @param slicePrefix   地址前缀
 * @param protoType     m3u协议类型
 * @param extraInfo     补充信息
 * @param token         token
 * @param timeout       下载m3u的超时时间
 * 
 * @return json数组格式信息：{{"url":string, "id":string, "size":int}, {...}}
 *         对应字段含义：    url: dav完整地址  id: dav对应id  size: dav字节大小 
*/
- (NSString*) getCloudImageUrl:(NSInteger)index 
                              M3uUrl:(NSString*)m3u8Url 
                              SlicePrefix:(NSString*)slicePrefix
                              ProtoType:(NSInteger)protoType 
                              ExtraInfo:(NSString*)extraInfo
                              Token:(NSString*)token
                              TimeOut:(NSInteger)timeout;

/**
 * 下载云图
 * @param index         任务编号
 * @param filepath       文件路径
 * @param m3u8Url       m3u地址
 * @param slicePrefix   地址前缀
 * @param protoType     m3u协议类型
 * @param bNeedDecrypt  加密方式
 * @param decryptkey   解密密钥
 * @param recorderType 下载后的格式
 * @param timeout       下载m3u的超时时间
 * @param extraInfo     补充信息
 * @param token         token
 * @param deviceSn  设备sn
 * @param userName  设备用户名
 * @param passWord  设备密码
 * @param frameRate 帧率
*/
- (bool) startDownloadCloudImages:(NSInteger)index
              filepath:(NSString *)filepath
                   Url:(NSString *)m3u8Url
                Prefix:(NSString *)slicePrefix
             ProtoType:(NSInteger)protoType
               Decrypt:(NSInteger)bNeedDecrypt
            Decryptkey:(NSString *)decryptkey
                  Type:(NSInteger)recorderType
               Timeout:(NSInteger)timeout
             ExtraInfo:(NSString *)extraInfo
                 Token:(NSString *)token
              DeviceSn:(NSString *)deviceSn
              UserName:(NSString *)userName
              PassWord:(NSString *)passWord
             FrameRate:(NSInteger)frameRate;

/**
 * 标准HTTP协议下载
 * @param index                     [in] 索引
 * @param filepath              文件路径
 * @param recorderType     文件格式 MP4/dav
 * @param HttpUrl                下载地址：文件方式的下载地址
 * @param isUseCache          是否断点，保留用参数：暂写死传false
 */
- (bool) startStdHttpDownload:(NSInteger)index
                    Filepath:(NSString*)filepath
                RecorderType:(NSInteger)recorderType
                     HttpUrl:(NSString*)httpUrl
                  IsUseCache:(BOOL)isUseCache;

@end
