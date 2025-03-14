#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "LCOpenMediaSDK.h"
#import "LCMediaAudioTalk.h"
#import "LCMediaCallTagLog.h"
#import "LCMediaCommonLoginManager.h"
#import "LCMediaCommonLoginManagerListener.h"
#import "LCMediaCrypter.h"
#import "LCMediaDefine.h"
#import "LCMediaDownload.h"
#import "LCMediaDownLoadInfo.h"
#import "LCMediaDownloadListener.h"
#import "LCMediaLoginManagerNetSDKInterface.h"
#import "LCMediaPlayer.h"
#import "LCMediaPlayerListener.h"
#import "LCMediaPlayWindow.h"
#import "LCMediaRestApi.h"
#import "LCMediaServerParameter.h"
#import "LCMediaStreamParam.h"
#import "LCMediaTalkerListener.h"
#import "LCMediaUtils.h"
#import "LCOpenPlayTokenModel.h"
#import "LCVideoPlayerDefines.h"
#import "NSString+Data.h"
#import "LCMediaLoginManager.h"
#import "LCMediaLogManager.h"
#import "LCVideoErrorManager.h"
#import "LCBaseVideoPlayer.h"
#import "LCCloudVideoPlayer.h"
#import "LCDeviceVideoPlayer.h"
#import "LCLiveVideoPlayer.h"
#import "LCLocalVideoPlayer.h"
#import "LCVisualTalkCaptureSession.h"
#import "XDXAudioCaptureManager.h"
#import "LCH264Encoder.h"
#import "LCSurfaceView.h"
#import "LCBaseTalkbackSource.h"
#import "LCDhTalkbackSource.h"
#import "LCOpenTalkSource.h"
#import "LCRtspTalkbackSource.h"
#import "LCCloudImageInfo.h"
#import "LCDownloadCloudImageInfo.h"
#import "LCDownloadMultiInfo.h"
#import "LCMediaSampleConfigParam.h"
#import "LCBaseVideoItem.h"
#import "LCCloudDiskVideoItem.h"
#import "LCCloudImagesItem.h"
#import "LCCloudVideoItem.h"
#import "LCDeviceFileVideoItem.h"
#import "LCDeviceTimeDownloadInfo.h"
#import "LCDeviceTimeV2VideoItem.h"
#import "LCDeviceTimeVideoItem.h"
#import "LCDhDeviceVideoItem.h"
#import "LCDhLiveVideoItem.h"
#import "LCLANDeviceFileVideoItem.h"
#import "LCLANDeviceTimeVideoItem.h"
#import "LCLANLiveVideoItem.h"
#import "LCLiveSource.h"
#import "LCLocalVideoItem.h"
#import "LCOpenCloudSource.h"
#import "LCOpenDeviceFileSource.h"
#import "LCOpenDeviceTimeSource.h"
#import "LCOpenLiveSource.h"
#import "libyuv.h"
#import "basic_types.h"
#import "compare.h"
#import "compare_row.h"
#import "convert.h"
#import "convert_argb.h"
#import "convert_from.h"
#import "convert_from_argb.h"
#import "cpu_id.h"
#import "macros_msa.h"
#import "mjpeg_decoder.h"
#import "planar_functions.h"
#import "rotate.h"
#import "rotate_argb.h"
#import "rotate_row.h"
#import "row.h"
#import "scale.h"
#import "scale_argb.h"
#import "scale_row.h"
#import "version.h"
#import "video_common.h"
#import "LCOpenTalkPlugin.h"

FOUNDATION_EXPORT double LCOpenMediaSDKVersionNumber;
FOUNDATION_EXPORT const unsigned char LCOpenMediaSDKVersionString[];

