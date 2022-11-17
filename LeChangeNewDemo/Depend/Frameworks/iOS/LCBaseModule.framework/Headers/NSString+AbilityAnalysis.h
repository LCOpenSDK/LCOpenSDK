 //
 //  Copyright © 2020 Imou. All rights reserved.
 //。能力集解析

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (AbilityAnalysis)
///支持接入无线局域网
-(BOOL)isSupportWLAN;
 ///支持TCM
- (BOOL)isSupportTCM;
 ///支持平台云存储
-(BOOL)isSupportCloudStorage;
 ///支持配件接入
-(BOOL)isSupportAGW;
 ///支持设备本地存储，如有SD卡或硬盘
-(BOOL)isSupportLocalStorage;
 ///支持设备本地存储使能开关
-(BOOL)isSupportLocalStorageEnable;
 ///设备支持根据文件名回放
-(BOOL)isSupportPlaybackByFilename;
 ///设备有呼吸灯
-(BOOL)isSupportBreathingLight;
 ///设备有照明灯
-(BOOL)isSupportShineLight;
 ///设备具有验证码
-(BOOL)isSupportRegCode;
 ///人脸识别抓图能力
-(BOOL)isSupportFaceCapture;
 ///设备支持声光告警
-(BOOL)isSupportSLAlarm;
 ///支持设备本地录像设置
-(BOOL)isSupportLocalRecord;
 ///云升级
-(BOOL)isSupportXUpgrade;
 ///设备支持时间同步
-(BOOL)isSupportTimeSync;
 ///红外灯
-(BOOL)isSupportInfraredLight;
 ///探照灯
-(BOOL)isSupportSearchLight;
 ///设备支持按日夏令时
-(BOOL)isSupportDaySummerTime;
 ///设备支持按周夏令时
-(BOOL)isSupportWeekSummerTime;
 ///仅支持铃声设置
-(BOOL)isSupportRing;
 ///自定义铃声
-(BOOL)isSupportCustomRing;
 ///关联设备报警
-(BOOL)isSupportLinkDevAlarm;
 ///关联配件报警
-(BOOL)isSupportLinkAccDevAlarm;
 ///异常报警音
-(BOOL)isSupportAbAlarmSound;
 ///设备提示音开关能力
-(BOOL)isSupportPlaySound;
 ///设备提示音调节能力
-(BOOL)isSupportPlaySoundModify;
 ///异常检测音分贝阈值
-(BOOL)isSupportCheckAbDecible;
 ///设备支持重启
-(BOOL)isSupportReboot;
 ///设备支持SC安全码
-(BOOL)isSupportSCCode;
 ///设备支持Auth能力集
-(BOOL)isSupportAuth;
 ///门铃音量设置
-(BOOL)isSupportRingAlarmSound;
 ///报警网关配件报警音效设置
-(BOOL)isSupportAccessoryAlarmSound;
 ///支持一键撤防能力
-(BOOL)isSupportInstantDisAlarm;
 ///支持动检报警
-(BOOL)isSupportAlarmMD;
 ///支持云台及数字变倍操作
-(BOOL)isSupportPTZ;
 ///支持8方向云台操作
-(BOOL)isSupportPT;
 ///支持4方向云台操作
-(BOOL)isSupportPT1;
 ///支持画面翻转
-(BOOL)isSupportFrameReverse;
 ///支持远程联动
-(BOOL)isSupportRemoteControl;
 ///支持全景图
-(BOOL)isSupportPanorama;
 ///支持人头检测
-(BOOL)isSupportHeaderDetect;
 ///支持人脸检测
-(BOOL)isSupportFaceDetect;
 ///支持收藏点
-(BOOL)isSupportCollectionPoint;
 ///支持定时巡航
-(BOOL)isSupportTimedCruise;
 ///支持听声辨位
-(BOOL)isSupportSmartLocate;
 ///支持智能追踪
-(BOOL)isSupportSmartTrack;
 ///过线客流量数据采集
-(BOOL)isSupportNumberStat;
 ///区域客流量数据采集
-(BOOL)isSupportManNumDec;
 ///有PIR能力
-(BOOL)isSupportAlarmPIR;
 ///移动检测(动检跟PIR进行了合并)
-(BOOL)isSupportMobileDetect;
 ///支持变倍聚焦
-(BOOL)isSupportZoomFocus;
 ///支持关闭摄像头
-(BOOL)isSupportCloseCamera;
 ///热度分析
-(BOOL)isSupportHeatMap;
 ///支持通道本地存储，如有SD卡或硬盘
-(BOOL)isSupportChnLocalStorage;
 ///支持视频通道OSD配置
-(BOOL)isSupportOSD;
 ///支持语音对讲
-(BOOL)isSupportAudioTalk;
 ///支持语音对讲
-(BOOL)isSupportAudioTalkV1;
 ///支持报警音设置
-(BOOL)isSupportAlarmSound;
 ///设备支持电池能力
-(BOOL)isSupportElectric;
 ///设备支持WIFI能力
-(BOOL)isSupportWIFI;
 ///本地录像
-(BOOL)isCanSetlocalRecord;
 ///动检使能
-(BOOL)isCanSetmotionDetect;
 ///人脸自动抓拍
-(BOOL)isCanSetfaceCapture;
 ///设备语音识别
-(BOOL)isCanSetspeechRecognition;
 ///呼吸灯使能
-(BOOL)isCanSetbreathingLight;
 ///听声辩位使能
-(BOOL)isCanSetsmartLocate;
 ///智能追踪使能
-(BOOL)isCanSetsmartTrack;
 ///定时巡航
-(BOOL)isCanSetregularCruise;
 ///自动变倍聚焦
-(BOOL)isCanSetautoZoomFocus;
 ///设备本地存储使能
-(BOOL)isCanSetlocalStorageEnable;
 ///白光灯
-(BOOL)isCanSetwhiteLight;
 ///报警联动白光灯
-(BOOL)isCanSetlinkageWhiteLight;
 ///报警联动警笛
-(BOOL)isCanSetlinkageSiren;
 ///红外灯
-(BOOL)isCanSetinfraredLight;
 ///探照灯
-(BOOL)isCanSetsearchLight;
 ///关闭摄像头
-(BOOL)isCanSetcloseCamera;
 ///移动检测
-(BOOL)isCanSetmobileDetect;






















































































    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


@end

NS_ASSUME_NONNULL_END
