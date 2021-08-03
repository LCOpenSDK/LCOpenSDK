//
//  Copyright © 2020 dahua. All rights reserved.
//

#ifndef LCLivePreviewDefine_h
#define LCLivePreviewDefine_h

typedef enum : NSUInteger {
    LCLiveDefinitionSD,
    LCLiveDefinitionHD
} LCLiveDefinition;


//下载状态（demoApp）
typedef enum : NSInteger {
    LCVideotapeDownloadStatusFail =  0,      // 下载失败
    LCVideotapeDownloadStatusBegin =  1,     // 开始下载
    LCVideotapeDownloadStatusEnd =  2,       // 正常下载结束
    LCVideotapeDownloadStatusCancle = 3,      //下载取消(仅下载云录像时有效)
    LCVideotapeDownloadStatusSuspend =  4,    // 下载暂停(仅下载云录像时有效)
    LCVideotapeDownloadStatusTimeout =  5,   // 下载超时(仅下载云录像时有效)
    LCVideotapeDownloadStatusKeyError =  6,   // 解密秘钥错误
    LCVideotapeDownloadStatusPartDownload =  7,   // 片段下载成功
    LCVideotapeDownloadStatusPasswordError =  8,   // 密码错误
} LCVideotapeDownloadState;

typedef NS_ENUM (NSInteger, HLSResultCode) {
    HLS_DOWNLOAD_FAILD = 0, // 下载失败
    HLS_DOWNLOAD_BEGIN = 1,     // 开始下载
    HLS_DOWNLOAD_END = 2,       // 下载结束
    HLS_SEEK_SUCCESS = 3,       // 定位成功
    HLS_SEEK_FAILD = 4,         // 定位失败
    HLS_ABORT_DONE = 5,         // 下载取消
    HLS_RESUME_DONE = 6,        // 下载暂停
    HLS_DOWNLOAD_TIMEOUT = 7,   // 下载超时
    HLS_KEY_ERROR = 11, // 密钥错误
    HLS_PASSWORD_ERROR = 14  // 密码错误
};

#endif /* LCLivePreviewDefine_h */
