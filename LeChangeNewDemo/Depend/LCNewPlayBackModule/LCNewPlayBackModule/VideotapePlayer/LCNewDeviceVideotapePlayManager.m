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

@end

@implementation LCNewDeviceVideotapePlayManager

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [LCNewDeviceVideotapePlayManager new];
        manager.isPlay = NO;
        manager.pausePlay = NO;
        manager.isSD = YES;
        manager.isSoundOn = YES;
        manager.isFullScreen = NO;
        manager.isOpenCloudStage = NO;
        manager.isOpenAudioTalk = NO;
        manager.isOpenRecoding = NO;
        manager.isLockFullScreen = NO;
        manager.playSpeed = 1;
    });
    return manager;
}

- (NSMutableDictionary *)downloadQueue {
    if (!_downloadQueue) {
        _downloadQueue = [NSMutableDictionary dictionary];
    }
    return _downloadQueue;
}

- (LCDeviceInfo *)currentDevice {
    return [LCNewDeviceVideoManager shareInstance].currentDevice;
}

- (NSInteger)currentChannelIndex {
    return [LCNewDeviceVideoManager shareInstance].currentChannelIndex;
}

- (void)setCloudVideotapeInfo:(LCCloudVideotapeInfo *)cloudVideotapeInfo {
    _cloudVideotapeInfo = cloudVideotapeInfo;
    _localVideotapeInfo = nil;
}

- (void)setLocalVideotapeInfo:(LCLocalVideotapeInfo *)localVideotapeInfo {
    _localVideotapeInfo = localVideotapeInfo;
    _cloudVideotapeInfo = nil;
}

- (void)startDeviceDownload {
    LCNewVideotapeDownloadInfo *info = [LCNewVideotapeDownloadInfo new];
    info.recordId = self.cloudVideotapeInfo ? self.cloudVideotapeInfo.recordRegionId : self.localVideotapeInfo.recordId;
    info.deviceId = self.currentDevice.deviceId;
    info.channelId = self.currentChannelInfo.channelId;
    info.localPath = [self _getCloudDownloadPath:info.recordId];
    [self.downloadQueue setObject:info forKey:[NSString stringWithFormat:@"%ld", (long)info.index]];
    [[LCOpenSDK_Download shareMyInstance] setListener:self];
    //开始下载进程
    if (self.cloudVideotapeInfo) {
        //开始下载云
        NSInteger result = [[LCOpenSDK_Download shareMyInstance] startDownload:info.index filepath:info.localPath token:[LCApplicationDataManager token] devID:info.deviceId channelID:[info.channelId integerValue] psk:self.currentPsk recordRegionId:info.recordId Type:self.cloudVideotapeInfo.type useTls:[self currentDevice].tlsEnable];
        if (result != 0) {
            NSLog(@"下载云录像返回码：%ld",(long)result);
        }

    } else {
        //开始下载设备录像
        NSInteger result = [[LCOpenSDK_Download shareMyInstance] startDownload:info.index filepath:info.localPath token:[LCApplicationDataManager token] devID:info.deviceId decryptKey:self.currentPsk fileID:info.recordId speed:2 productId:self.currentDevice.productId playToken:self.currentDevice.playToken useTls:[self currentDevice].tlsEnable];
        if (result != 0) {
            NSLog(@"下载设备录像返回码：%ld",(long)result);
        }
    }
}

- (NSString *)currentVideotapeId {
    if (self.cloudVideotapeInfo) {
        return self.cloudVideotapeInfo.recordRegionId;
    }
    if (self.localVideotapeInfo) {
        return self.localVideotapeInfo.recordId;
    }
    return @"";
}

- (LCNewVideotapeDownloadInfo *)currentDownloadInfo {
    LCNewVideotapeDownloadInfo *result = nil;
    NSString *recordId = self.cloudVideotapeInfo ? self.cloudVideotapeInfo.recordRegionId : self.localVideotapeInfo.recordId;
    for (NSString *key in self.downloadQueue) {
        LCNewVideotapeDownloadInfo *info = [self.downloadQueue objectForKey:key];
        if ([info.recordId isEqualToString:recordId]) {
            result = info;
            break;
        }
    }
    return result;
}

- (void)updateDownload:(NSInteger)index Recieve:(NSInteger)recieve Status:(LCVideotapeDownloadState)status {
    if (status != -1) {
        NSLog(@"画面当前状态D:%ld", (long)status);
    }
    if (![self.downloadQueue valueForKey:[NSString stringWithFormat:@"%ld", (long)index]]) {
        return;//如果没有下载池中未保存该状态
    }
    [self willChangeValueForKey:@"downloadQueue"];
    //recieve为-1表示更新下载状态，status为-1表示更新接受到的数据
    LCNewVideotapeDownloadInfo *info = [self currentDownloadInfo];
    if (recieve != -1) {
        info.recieve = recieve;
    }
    if (status != -1) {
        info.donwloadStatus = status;
        if (status == LCVideotapeDownloadStatusEnd) {
            [[LCOpenSDK_Download shareMyInstance] stopDownload:info.index];
            //下载正常结束时，保存到相册
            [self _saveToAlbumWithPath:info.localPath];
        }
    }
    [self didChangeValueForKey:@"downloadQueue"];
}

- (void)_saveToAlbumWithPath:(NSString *)path {
    /* 延时保存相册，因为下载成功之后stopDownload方法在另一个线程，所以转码可能还不成功*/
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
                    [LCProgressHUD showMsg:@"mobile_common_data_download_success".lcMedia_T];
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

- (void)cancleDownload:(NSString *)recordId {
    LCNewVideotapeDownloadInfo *info = [self currentDownloadInfo];
    info.donwloadStatus = LCVideotapeDownloadStatusCancle;
    [[LCOpenSDK_Download shareMyInstance] stopDownload:info.index];
}

- (NSString *)_getCloudDownloadPath:(NSString *)recordId {
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

#pragma mark - 下载回调
- (void)onDownloadReceiveData:(NSInteger)index datalen:(NSInteger)datalen {
    NSLog(@"REVIEVE_DOWN===data: %ld  index:%ld", (long)datalen, (long)index);
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
//                LCVideotapeDownloadInfo *info = [self currentDownloadInfo];
//                if (info.donwloadStatus != LCVideotapeDownloadStatusPartDownload) {
//                    [self updateDownload:index Recieve:-1 Status:LCVideotapeDownloadStatusPartDownload];
//                }
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
