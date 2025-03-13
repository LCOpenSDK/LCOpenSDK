//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "LCNewDeviceVideotapePlayManager.h"
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_Download.h>
#import <LCMediaBaseModule/PHAsset+Lechange.h>
#import <LCOpenSDKDynamic/LCOpenSDK/LCOpenSDK_DownloadListener.h>
#import <LCNetworkModule/LCApplicationDataManager.h>
#import <LCMediaBaseModule/NSString+MediaBaseModule.h>
#import <LCBaseModule/LCProgressHUD.h>
//#import "LCUIKit.h"

static LCNewDeviceVideotapePlayManager *manager = nil;

@interface LCNewDeviceVideotapePlayManager ()<LCOpenSDK_DownloadListener>

@property (nonatomic, strong) NSDate *recordTime;

@property (nonatomic, assign) NSInteger recordReceive;

@property (assign, nonatomic) BOOL existSubWindow;

@end

@implementation LCNewDeviceVideotapePlayManager

- (NSInteger)recieve {
    if (self.isMulti) {
        if (self.downloadQueue.allValues.count > 1) {
            LCNewVideotapeDownloadInfo *info1 = self.downloadQueue.allValues[0];
            LCNewVideotapeDownloadInfo *info2 = self.downloadQueue.allValues[1];
            return info1.recieve + info2.recieve;
        }
    } else {
        if (self.downloadQueue.allValues.count > 0) {
            LCNewVideotapeDownloadInfo *info = self.downloadQueue.allValues[0];
            return info.recieve;
        }
    }
    return 0;
}

- (LCVideotapeDownloadState)downloadStates {
    if (self.isMulti) {
        if (self.downloadQueue.allValues.count > 1) {
            LCNewVideotapeDownloadInfo *info1 = self.downloadQueue.allValues[0];
            LCNewVideotapeDownloadInfo *info2 = self.downloadQueue.allValues[1];
            
            if (info1.donwloadStatus == LCVideotapeDownloadStatusEnd && info2.donwloadStatus == LCVideotapeDownloadStatusEnd) {
                return LCVideotapeDownloadStatusEnd;
            }
            
            if (info1.donwloadStatus == LCVideotapeDownloadStatusBegin || info2.donwloadStatus == LCVideotapeDownloadStatusBegin) {
                return LCVideotapeDownloadStatusBegin;
            }
            
            if (info1.donwloadStatus == LCVideotapeDownloadStatusPartDownload || info2.donwloadStatus == LCVideotapeDownloadStatusPartDownload) {
                return LCVideotapeDownloadStatusPartDownload;
            }
            
            if (info1.donwloadStatus == LCVideotapeDownloadStatusKeyError || info2.donwloadStatus == LCVideotapeDownloadStatusKeyError) {
                return LCVideotapeDownloadStatusKeyError;
            }
            
            if (info1.donwloadStatus == LCVideotapeDownloadStatusPasswordError || info2.donwloadStatus == LCVideotapeDownloadStatusPasswordError) {
                return LCVideotapeDownloadStatusPasswordError;
            }
            
            if (info1.donwloadStatus == LCVideotapeDownloadStatusFail && info2.donwloadStatus == LCVideotapeDownloadStatusFail) {
                return LCVideotapeDownloadStatusFail;
            }
            
            if (info1.donwloadStatus == LCVideotapeDownloadStatusCancle && info2.donwloadStatus == LCVideotapeDownloadStatusCancle) {
                return LCVideotapeDownloadStatusCancle;
            }
            
            if (info1.donwloadStatus == LCVideotapeDownloadStatusTimeout && info2.donwloadStatus == LCVideotapeDownloadStatusTimeout) {
                return LCVideotapeDownloadStatusTimeout;
            }
        }
        return LCVideotapeDownloadStatusBegin;
    } else {
        if (self.downloadQueue.allValues.count > 0) {
            LCNewVideotapeDownloadInfo *info = self.downloadQueue.allValues[0];
            return info.donwloadStatus;
        }
        return LCVideotapeDownloadStatusFail;
    }
}

- (void)setCurrentPlayOffest:(NSDate *)currentPlayOffest {
    _currentPlayOffest = currentPlayOffest;
}

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [LCNewDeviceVideotapePlayManager new];
        manager.isPlay = NO;
        manager.pausePlay = NO;
        manager.isSD = YES;
        manager.isSoundOn = YES;
        manager.isFullScreen = NO;
        manager.isOpenRecoding = NO;
        manager.playSpeed = 1;
        manager.downloadQueue = [NSMutableDictionary dictionary];
    });
    return manager;
}

- (BOOL)existSubWindow {
    return [LCNewDeviceVideotapePlayManager shareInstance].isMulti;
}

- (NSString *)currentPsk {
    if (!_currentPsk || _currentPsk.length == 0) {
       return self.currentDevice.deviceId;
    }
    return _currentPsk;
}

- (BOOL)isMulti {
    return self.currentDevice.multiFlag == YES;
}

- (LCDeviceInfo *)currentDevice {
    return [LCNewDeviceVideoManager shareInstance].currentDevice;
}

- (void)setCloudVideotapeInfo:(LCCloudVideotapeInfo *)cloudVideotapeInfo {
    _cloudVideotapeInfo = cloudVideotapeInfo;
    _localVideotapeInfo = nil;
}

- (void)setLocalVideotapeInfo:(LCLocalVideotapeInfo *)localVideotapeInfo {
    _localVideotapeInfo = localVideotapeInfo;
    _cloudVideotapeInfo = nil;
    _subCloudVideotapeInfo = nil;
}

- (void)setSubCloudVideotapeInfo:(LCCloudVideotapeInfo *)subCloudVideotapeInfo {
    _subCloudVideotapeInfo = subCloudVideotapeInfo;
    _localVideotapeInfo = nil;
}

- (LCNewVideotapeDownloadInfo *)getCloudVideotapeDownloadInfo:(LCCloudVideotapeInfo *) cloudInfo {
    LCNewVideotapeDownloadInfo *info = [LCNewVideotapeDownloadInfo new];
    info.recordId = cloudInfo.recordId;
    info.deviceId = self.currentDevice.deviceId;
    info.channelId = cloudInfo.channelId;
    info.localPath = [self _getDownloadPath:info.recordId];
    info.donwloadStatus = LCVideotapeDownloadStatusBegin;
    return info;
}

- (LCNewVideotapeDownloadInfo *)getDeviceVideotapeDownloadInfo:(LCLocalVideotapeInfo *) deviceInfo {
    LCNewVideotapeDownloadInfo *info = [LCNewVideotapeDownloadInfo new];
    info.recordId = deviceInfo.recordId;
    info.deviceId = self.currentDevice.deviceId;
    info.channelId = deviceInfo.channelID;
    info.localPath = [self _getDownloadPath:info.recordId];
    info.donwloadStatus = LCVideotapeDownloadStatusBegin;
    return info;
}

- (void)startDeviceDownload {
    [self.downloadQueue removeAllObjects];
    [[LCOpenSDK_Download shareMyInstance] setListener:self];
    //开始下载进程
    if (self.cloudVideotapeInfo) {
        //开始下载云
            if (self.isMulti) {
                LCNewVideotapeDownloadInfo *mainInfo = [self getCloudVideotapeDownloadInfo:self.cloudVideotapeInfo];
                [self.downloadQueue setObject:mainInfo forKey:[NSString stringWithFormat:@"%ld", (long)mainInfo.index]];
                LCOpenSDK_DownloadByRecordIdParam *mainDownloadRecord = [[LCOpenSDK_DownloadByRecordIdParam alloc] init];
                mainDownloadRecord.index = mainInfo.index;
                mainDownloadRecord.savePath = mainInfo.localPath;
                mainDownloadRecord.accessToken = [LCApplicationDataManager token];
                mainDownloadRecord.deviceId = self.currentDevice.deviceId;
                mainDownloadRecord.psk = self.currentPsk;
                mainDownloadRecord.productId = self.currentDevice.productId;
                mainDownloadRecord.playToken = self.currentDevice.playToken;
                mainDownloadRecord.useTLS = [self currentDevice].tlsEnable;
                mainDownloadRecord.channelId = [mainInfo.channelId intValue];
                mainDownloadRecord.recordRegionId = self.cloudVideotapeInfo.recordRegionId;
                mainDownloadRecord.cloudType = self.cloudVideotapeInfo.type;
                mainDownloadRecord.speed = 1.0;
                NSInteger result = [[LCOpenSDK_Download shareMyInstance] startDownloadCloudRecord:mainDownloadRecord];
                if (result != 0) {
                    NSLog(@"下载云录像返回码：%ld  index:%ld",(long)result, mainInfo.index);
                } else {
                    NSLog(@"下载云录像返信息：%@", mainDownloadRecord.description);
                }
                
                LCNewVideotapeDownloadInfo *subInfo = [self getCloudVideotapeDownloadInfo:self.subCloudVideotapeInfo];
                subInfo.index = subInfo.index+1;
                [self.downloadQueue setObject:subInfo forKey:[NSString stringWithFormat:@"%ld", (long)subInfo.index]];
                LCOpenSDK_DownloadByRecordIdParam *subDownloadRecord = [[LCOpenSDK_DownloadByRecordIdParam alloc] init];
                subDownloadRecord.index = subInfo.index;
                subDownloadRecord.savePath = subInfo.localPath;
                subDownloadRecord.accessToken = [LCApplicationDataManager token];
                subDownloadRecord.deviceId = self.currentDevice.deviceId;
                subDownloadRecord.psk = self.currentPsk;
                subDownloadRecord.productId = self.currentDevice.productId;
                subDownloadRecord.playToken = self.currentDevice.playToken;
                subDownloadRecord.useTLS = [self currentDevice].tlsEnable;
                subDownloadRecord.channelId = [subInfo.channelId intValue];
                subDownloadRecord.recordRegionId = self.subCloudVideotapeInfo.recordRegionId;
                subDownloadRecord.cloudType = self.subCloudVideotapeInfo.type;
                subDownloadRecord.speed = 1.0;
                result = [[LCOpenSDK_Download shareMyInstance] startDownloadCloudRecord:subDownloadRecord];
                if (result != 0) {
                    NSLog(@"下载云录像返回码：%ld  index:%ld",(long)result, subDownloadRecord.index);
                } else {
                    NSLog(@"下载云录像返信息：%@", subDownloadRecord.description);
                }
            } else {
                LCNewVideotapeDownloadInfo *mainInfo = [self getCloudVideotapeDownloadInfo:self.cloudVideotapeInfo];
                [self.downloadQueue setObject:mainInfo forKey:[NSString stringWithFormat:@"%ld", (long)mainInfo.index]];
                NSInteger result = [[LCOpenSDK_Download shareMyInstance] startDownload:mainInfo.index filepath:mainInfo.localPath token:[LCApplicationDataManager token] devID:mainInfo.deviceId channelID:[mainInfo.channelId integerValue] psk:self.currentPsk recordRegionId:self.cloudVideotapeInfo.recordRegionId Type:self.cloudVideotapeInfo.type useTls:[self currentDevice].tlsEnable];
                if (result != 0) {
                    NSLog(@"下载云录像返回码：%ld",(long)result);
                }
            }
    } else {
        //开始下载设备录像
        if ([LCNewDeviceVideotapePlayManager shareInstance].isMulti) {
            // 按照时间下载
            NSDateFormatter * tDataFormatter = [[NSDateFormatter alloc] init];
            tDataFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSTimeInterval beginTime = [[tDataFormatter dateFromString:[LCNewDeviceVideotapePlayManager shareInstance].localVideotapeInfo.beginTime] timeIntervalSince1970];
            NSTimeInterval endTime = [[tDataFormatter dateFromString:[LCNewDeviceVideotapePlayManager shareInstance].localVideotapeInfo.endTime] timeIntervalSince1970];
            LCNewVideotapeDownloadInfo *mainInfo = [self getDeviceVideotapeDownloadInfo:self.localVideotapeInfo];
            [self.downloadQueue setObject:mainInfo forKey:[NSString stringWithFormat:@"%ld", (long)mainInfo.index]];
            LCOpenSDK_DownloadByUTCTimeParam *downloadUTCTime = [[LCOpenSDK_DownloadByUTCTimeParam alloc] init];
            downloadUTCTime.index = mainInfo.index;
            downloadUTCTime.savePath = mainInfo.localPath;
            downloadUTCTime.accessToken = [LCApplicationDataManager token];
            downloadUTCTime.deviceId = self.currentDevice.deviceId;
            downloadUTCTime.psk = self.currentPsk;
            downloadUTCTime.productId = self.currentDevice.productId;
            downloadUTCTime.playToken = self.currentDevice.playToken;
            downloadUTCTime.useTLS = [self currentDevice].tlsEnable;
            downloadUTCTime.channelId = 0;
            downloadUTCTime.beginTime = beginTime;
            downloadUTCTime.endTime = endTime;
            NSInteger result = [[LCOpenSDK_Download shareMyInstance] startDownloadDeviceRecordByUtcTime:downloadUTCTime];
            if (result != 0) {
                NSLog(@"下载设备录像返回码：%ld %@",(long)result, downloadUTCTime.description);
            }
            
            LCNewVideotapeDownloadInfo *subInfo = [self getDeviceVideotapeDownloadInfo:self.localVideotapeInfo];
            subInfo.channelId = @"1";
            subInfo.index = subInfo.index+1;
            [self.downloadQueue setObject:subInfo forKey:[NSString stringWithFormat:@"%ld", (long)subInfo.index]];
            LCOpenSDK_DownloadByUTCTimeParam *subDownloadUTCTime = [[LCOpenSDK_DownloadByUTCTimeParam alloc] init];
            subDownloadUTCTime.index = subInfo.index;
            subDownloadUTCTime.savePath = subInfo.localPath;
            subDownloadUTCTime.accessToken = [LCApplicationDataManager token];
            subDownloadUTCTime.deviceId = self.currentDevice.deviceId;
            subDownloadUTCTime.psk = self.currentPsk;
            subDownloadUTCTime.productId = self.currentDevice.productId;
            subDownloadUTCTime.playToken = self.currentDevice.playToken;
            subDownloadUTCTime.useTLS = [self currentDevice].tlsEnable;
            subDownloadUTCTime.channelId = 1;
            subDownloadUTCTime.beginTime = beginTime;
            subDownloadUTCTime.endTime = endTime;
            result = [[LCOpenSDK_Download shareMyInstance] startDownloadDeviceRecordByUtcTime:subDownloadUTCTime];
            if (result != 0) {
                NSLog(@"下载设备录像返回码：%ld %@",(long)result, subDownloadUTCTime.description);
            }
        } else {
            // 按照ID下载
            LCNewVideotapeDownloadInfo *mainInfo = [self getDeviceVideotapeDownloadInfo:self.localVideotapeInfo];
            [self.downloadQueue setObject:mainInfo forKey:[NSString stringWithFormat:@"%ld", (long)mainInfo.index]];
            LCOpenSDK_DownloadByRecordIdParam *downloadRecordId = [[LCOpenSDK_DownloadByRecordIdParam alloc] init];
            downloadRecordId.index = mainInfo.index;
            downloadRecordId.savePath = mainInfo.localPath;
            downloadRecordId.accessToken = [LCApplicationDataManager token];
            downloadRecordId.deviceId = self.currentDevice.deviceId;
            downloadRecordId.psk = self.currentPsk;
            downloadRecordId.productId = self.currentDevice.productId;
            downloadRecordId.playToken = self.currentDevice.playToken;
            downloadRecordId.useTLS = [self currentDevice].tlsEnable;
            downloadRecordId.channelId = 0;
            downloadRecordId.fileId = mainInfo.recordId;
            downloadRecordId.speed = 2;
            NSInteger result = [[LCOpenSDK_Download shareMyInstance] startDownloadDeviceRecordById:downloadRecordId];
            if (result != 0) {
                NSLog(@"下载设备录像返回码：%ld",(long)result);
            }
        }
    }
}

- (LCNewVideotapeDownloadInfo *)getDownloadInfo:(NSInteger)index {
    for (NSString *key in self.downloadQueue) {
        LCNewVideotapeDownloadInfo *info = [self.downloadQueue objectForKey:key];
        if (info.index == index) {
            return info;
        }
    }
    return nil;
}

- (void)updateDownload:(NSInteger)index Recieve:(NSInteger)recieve Status:(LCVideotapeDownloadState)status {
    if (![self.downloadQueue valueForKey:[NSString stringWithFormat:@"%ld", (long)index]]) {
        return;//如果没有下载池中未保存该状态
    }
    
    NSLog(@"画面当前状态D:%ld status: %ld", index, (long)status);
    [self willChangeValueForKey:@"downloadQueue"];
    //recieve为-1表示更新下载状态，status为-1表示更新接受到的数据
    LCNewVideotapeDownloadInfo *info = [self getDownloadInfo:index];
    if (recieve != -1) {
        info.recieve += recieve;
    }
    if (status != -1) {
        info.donwloadStatus = status;
        if (status == LCVideotapeDownloadStatusEnd) {
            [[LCOpenSDK_Download shareMyInstance] stopDownload:info.index];
            //下载正常结束时，保存到相册
            [self _saveToAlbumWithPath:info.localPath index:index];
        }
    }
    [self didChangeValueForKey:@"downloadQueue"];
}

- (void)_saveToAlbumWithPath:(NSString *)path index:(NSInteger)index {
    /* 延时保存相册，因为下载成功之后stopDownload方法在另一个线程，所以转码可能还不成功*/
    NSLog(@"保存地址:%@  index:%ld", path, index);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            NSURL *dowmloadRUL = [NSURL fileURLWithPath:path];
            [PHAsset deleteFormCameraRoll:dowmloadRUL success:^{
            } failure:^(NSError *error) {
                NSLog(@"删除失败:%@", error.description);
            }];
            [PHAsset saveVideoAtURL:dowmloadRUL success:^(void) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"保存成功");
                    if (self.downloadQueue.allValues.count > 1) {
                        LCNewVideotapeDownloadInfo *info1 = self.downloadQueue.allValues[0];
                        LCNewVideotapeDownloadInfo *info2 = self.downloadQueue.allValues[1];
                        if (info1.donwloadStatus == LCVideotapeDownloadStatusEnd && info2.donwloadStatus == LCVideotapeDownloadStatusEnd ) {
                            [LCProgressHUD showMsg:@"mobile_common_data_download_success".lcMedia_T];
                        }
                    } else {
                        [LCProgressHUD showMsg:@"mobile_common_data_download_success".lcMedia_T];
                    }
                });
            } failure:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"保存失败:%@", error.description);
                    [LCProgressHUD showMsg:@"mobile_common_data_download_fail".lcMedia_T];
                });
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"保存失败: 视频转码还没成功");
                [LCProgressHUD showMsg:@"mobile_common_data_download_fail".lcMedia_T];
            });
        }
    });
}

- (void)cancleDownloadAll {
    for (LCNewVideotapeDownloadInfo *info in self.downloadQueue.allValues) {
        info.donwloadStatus = LCVideotapeDownloadStatusCancle;
        [[LCOpenSDK_Download shareMyInstance] stopDownload:info.index];
    }
}

- (NSString *)_getDownloadPath:(NSString *)recordId {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];

    NSString *myDirectory = [libraryDirectory stringByAppendingPathComponent:@"lechange"];
    NSString *downloadDirectory = [myDirectory stringByAppendingPathComponent:@"download"];

    NSString *infoPath = [downloadDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%f_download", [[NSDate new]timeIntervalSince1970]]];
    NSString *downPath = [infoPath stringByAppendingString:@".mp4"];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSError *pErr;
    NSLog(@"下载地址 = %@", downPath);
    BOOL isDir;
    if (NO == [fileManage fileExistsAtPath:myDirectory isDirectory:&isDir]) {
        [fileManage createDirectoryAtPath:myDirectory withIntermediateDirectories:YES attributes:nil error:&pErr];
    }
    if (NO == [fileManage fileExistsAtPath:downloadDirectory isDirectory:&isDir]) {
        [fileManage createDirectoryAtPath:downloadDirectory withIntermediateDirectories:YES attributes:nil error:&pErr];
    }
    return downPath;
}

/// 固定通道id
- (NSString *)fixedCameraID {
    for (LCChannelInfo *info in self.currentDevice.channels) {
        if (info.movable == NO) {
            return info.channelId;
        }
    }
    return @"1";
}

/// 移动通道id
- (NSString *)mobileCameraID {
    for (LCChannelInfo *info in self.currentDevice.channels) {
        if (info.movable == YES) {
            return info.channelId;
        }
    }
    return @"0";
}


#pragma mark - 下载回调
- (void)onDownloadReceiveData:(NSInteger)index datalen:(NSInteger)datalen {
//    NSLog(@"REVIEVE_DOWN===data: %ld  index:%ld", (long)datalen, (long)index);
    self.recordReceive += datalen;
    //每隔0.5加载数据，避免过快加载导致UI卡顿
    if (self.recordTime == nil || [[NSDate date] timeIntervalSinceDate:self.recordTime] >= 0.5) {
        self.recordTime = [NSDate date];
        [self updateDownload:index Recieve:self.recordReceive Status:-1];
        self.recordReceive = 0;
    }
}

- (void)onDownloadState:(NSInteger)index code:(NSString *)code type:(NSInteger)type {
    NSInteger codeInteger = [code integerValue];
    NSLog(@"录像下载回调INDEX:%ld  TYEP:%ld  CODE:%@", (long)index, (long)type, code);
    if (type == 0) {
        //设备录像下载
        switch (codeInteger) {
            case 1: {
                [self updateDownload:index Recieve:-1 Status:LCVideotapeDownloadStatusFail];
            }
                break;
            case 4: { //1000
                [self updateDownload:index Recieve:-1 Status:LCVideotapeDownloadStatusBegin];
            }
                break;
            case 5: { //2000
                [self updateDownload:index Recieve:-1 Status:LCVideotapeDownloadStatusEnd];
            }
                break;
            case 7: {
                [self updateDownload:index Recieve:-1 Status:LCVideotapeDownloadStatusTimeout];
            }
                break;
            default:
                break;
        }
    } else if (type == 1) {
        //云录像下载
        switch (codeInteger) {
            case 0: {
                [self updateDownload:index Recieve:-1 Status:LCVideotapeDownloadStatusFail];
            }
                break;
            case 1: {
                [self updateDownload:index Recieve:-1 Status:LCVideotapeDownloadStatusBegin];
            }
                break;
            case 2: {
                [self updateDownload:index Recieve:-1 Status:LCVideotapeDownloadStatusEnd];
            }
                break;
            case 5: {
                [self updateDownload:index Recieve:-1 Status:LCVideotapeDownloadStatusCancle];
            }
                break;
            case 6: {
                [self updateDownload:index Recieve:-1 Status:LCVideotapeDownloadStatusSuspend];
            }
                break;
            case 7: {
                [self updateDownload:index Recieve:-1 Status:LCVideotapeDownloadStatusTimeout];
            }
                break;
            case 9: {
                [self updateDownload:index Recieve:-1 Status:LCVideotapeDownloadStatusPartDownload];
            }
                break;
            case 11: {
                [self updateDownload:index Recieve:-1 Status:LCVideotapeDownloadStatusKeyError];
            }
            case 14: {
                [self updateDownload:index Recieve:-1 Status:LCVideotapeDownloadStatusPasswordError];
            }
                break;
            default:
                break;
        }
    }
    else if (type == 5) {
        if (codeInteger == STATE_LCHTTP_COMPONENT_ERROR ||
            codeInteger == STATE_LCHTTP_BAD_REQUEST ||
            codeInteger == STATE_LCHTTP_UNAUTHORIZED ||
            codeInteger == STATE_LCHTTP_FORBIDDEN ||
            codeInteger == STATE_LCHTTP_NOTFOUND ||
            codeInteger == STATE_LCHTTP_REQ_TIMEOUT ||
            codeInteger == STATE_LCHTTP_SERVER_ERROR ||
            codeInteger == STATE_LCHTTP_SERVER_UNVALILABLE ||
            codeInteger == STATE_LCHTTP_SERVER_DISCONNECT ||
            codeInteger == STATE_LCHTTP_FLOWLIMIT ||
            codeInteger == STATE_LCHTTP_P2P_MAXCONNECT ||
            codeInteger == STATE_LCHTTP_GATEWAY_TIMEOUT||
            codeInteger == STATE_LCHTTP_CLIENT_ERROR ||
            codeInteger == STATE_LCHTTP_KEY_ERROR) {
            [self updateDownload:index Recieve:-1 Status:LCVideotapeDownloadStatusFail];
        }else if (codeInteger == 1000) {
            [self updateDownload:index Recieve:-1 Status:LCVideotapeDownloadStatusBegin];
        }else if (codeInteger == 2000) {
            [self updateDownload:index Recieve:-1 Status:LCVideotapeDownloadStatusEnd];
        }
    }
    else if (type == 99) {
        [self updateDownload:index Recieve:-1 Status:LCVideotapeDownloadStatusFail];
    }
    else {
        //其他错误暂不处理
    }
}

@end

@implementation LCNewVideotapeDownloadInfo

- (instancetype)init {
    if (self = [super init]) {
        //取当前时间戳作为索引
        self.index = [[NSDate new] timeIntervalSince1970];
    }
    return self;
}

@end
