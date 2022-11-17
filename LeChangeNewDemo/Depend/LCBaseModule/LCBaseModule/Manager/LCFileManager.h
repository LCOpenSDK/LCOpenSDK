//
//  Copyright © 2017 Imou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LCFileRenameSuccessBlock)(NSString *filepath, NSString *thumbnailPah, NSString *fileName);

@interface LCFileManager : NSObject

/// 沙盒Library/Support/{userID}/captures
+ (NSString *)capturesFolder;

/**
 设备封面设置 /Library/{userId}/thumbs
 */
+ (NSString *)userthumbsFolderPath;

/// 取沙盒Library/Support/{userID}/thumbs/{deviceId}/{channelId}.png
+ (NSString *)thumbFilePathWithChannel:(NSString *)deviceId channelId:(NSString *)channelId;

/// 用户和服务器配置文件路径 /Library/Support/userandserviceconfigfile.plist
+ (NSString *)userAndServiceConfigFilePath;

/// 配置文件路径 /Library/Support/config.plist
+ (NSString *)configFilePath;

/// 用户文件路径 /Library/Support/{userId}/
+ (NSString *)userFolder;

/// 用户配置文件路径 /沙盒Library/Support/{userId}/userConfigFile
+ (NSString *)userConfigFilePath;

/// 用户引导管理文件路径 /沙盒Library/Support/{userId}/userGuideConfig.plist
+ (NSString *)userGuideFilePath;

/// 手动抓图文件路径 ⚠️category重写，区分乐橙和Easy4ip
+ (NSString *)screenshotFilePath:(NSString*)devcieId;

/// 手动抓图封面图文件路径 ⚠️category重写，区分乐橙和Easy4ip
+ (NSString *)screenshotThumbFilePath:(NSString*)devcieId;

/// 手动录像文件路径 ⚠️category重写，区分乐橙和Easy4ip
+ (NSString *)videotapeFilePath:(NSString*)devcieId;

/// 手动录像封面图文件路径 ⚠️category重写，区分乐橙和Easy4ip
+ (NSString *)videotapeThumbFilePath:(NSString*)devcieId;

/// 收藏点缩略图缓存文件
+ (NSString *)collectionThumbFilePath;

/// 取沙盒Library/Support目录
+ (NSString *)supportFolder;

+ (NSString *)myFileImageDir;

//录像文件夹
+ (NSString *)myFileVideoDir;

//MARK: - Video/File Name
+ (NSString *)videoNameWithPath:(NSString *)filepath;

#pragma mark - 缓存相关

/**
 所有自动抓图的目录路径

 @return 路径集合
 */
+ (NSArray *)thumbFolderPaths;

/**
 清除缓存，目录包括：所有的抓图路径
 */
+ (void)clearCache;

+ (BOOL)removeFileAtPath:(NSString *)path;


@end
