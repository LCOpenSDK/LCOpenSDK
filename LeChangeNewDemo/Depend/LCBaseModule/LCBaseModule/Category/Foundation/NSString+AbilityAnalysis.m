//
//  Copyright © 2020 Imou. All rights reserved.
//

#import "NSString+AbilityAnalysis.h"

@implementation NSString (AbilityAnalysis)

- (BOOL)isSupportWLAN {
    return [self containsString:@"WLAN"];
}

- (BOOL)isSupportCloudStorage {
    return [self containsString:@"CloudStorage"];
}

- (BOOL)isSupportAGW {
    return [self containsString:@"AGW"];
}

- (BOOL)isSupportLocalStorage {
    return [self containsString:@"LocalStorage"];
}

- (BOOL)isSupportLocalStorageEnable {
    return [self containsString:@"LocalStorageEnable"];
}

- (BOOL)isSupportPlaybackByFilename {
    return [self containsString:@"PlaybackByFilename"];
}

- (BOOL)isSupportBreathingLight {
    return [self containsString:@"BreathingLight"];
}

- (BOOL)isSupportShineLight {
    return [self containsString:@"ShineLight"];
}

- (BOOL)isSupportRegCode {
    return [self containsString:@"RegCode"];
}

- (BOOL)isSupportFaceCapture {
    return [self containsString:@"FaceCapture"];
}

- (BOOL)isSupportSLAlarm {
    return [self containsString:@"SLAlarm"];
}

- (BOOL)isSupportLocalRecord {
    return [self containsString:@"LocalRecord"];
}

- (BOOL)isSupportXUpgrade {
    return [self containsString:@"XUpgrade"];
}

- (BOOL)isSupportTimeSync {
    return [self containsString:@"TimeSync"];
}

- (BOOL)isSupportInfraredLight {
    return [self containsString:@"InfraredLight"];
}

- (BOOL)isSupportSearchLight {
    return [self containsString:@"SearchLight"];
}

- (BOOL)isSupportDaySummerTime {
    return [self containsString:@"DaySummerTime"];
}

- (BOOL)isSupportWeekSummerTime {
    return [self containsString:@"WeekSummerTime"];
}

- (BOOL)isSupportRing {
    return [self containsString:@"Ring"];
}

- (BOOL)isSupportCustomRing {
    return [self containsString:@"CustomRing"];
}

- (BOOL)isSupportLinkDevAlarm {
    return [self containsString:@"LinkDevAlarm"];
}

- (BOOL)isSupportLinkAccDevAlarm {
    return [self containsString:@"LinkAccDevAlarm"];
}

- (BOOL)isSupportAbAlarmSound {
    return [self containsString:@"AbAlarmSound"];
}

- (BOOL)isSupportPlaySound {
    return [self containsString:@"PlaySound"];
}

- (BOOL)isSupportPlaySoundModify {
    return [self containsString:@"PlaySoundModify"];
}

- (BOOL)isSupportCheckAbDecible {
    return [self containsString:@"CheckAbDecible"];
}

- (BOOL)isSupportReboot {
    return [self containsString:@"Reboot"];
}

- (BOOL)isSupportSCCode {
    return [self containsString:@"SCCode"];
}

- (BOOL)isSupportAuth {
    return [self containsString:@"Auth"];
}

- (BOOL)isSupportTCM {
    return [self containsString:@"TCM"];
}

- (BOOL)isSupportRingAlarmSound {
    return [self containsString:@"RingAlarmSound"];
}

- (BOOL)isSupportAccessoryAlarmSound {
    return [self containsString:@"AccessoryAlarmSound"];
}

- (BOOL)isSupportInstantDisAlarm {
    return [self containsString:@"InstantDisAlarm"];
}

- (BOOL)isSupportAlarmMD {
    return [self containsString:@"AlarmMD"];
}

- (BOOL)isSupportPTZ {
    return [self containsString:@"PTZ"];
}

- (BOOL)isSupportPT {
    return [self containsString:@"PT"];
}

- (BOOL)isSupportPT1 {
    return [self containsString:@"PT1"];
}

- (BOOL)isSupportFrameReverse {
    return [self containsString:@"FrameReverse"];
}

- (BOOL)isSupportRemoteControl {
    return [self containsString:@"RemoteControl"];
}

- (BOOL)isSupportPanorama {
    return [self containsString:@"Panorama"];
}

- (BOOL)isSupportHeaderDetect {
    return [self containsString:@"HeaderDetect"];
}

- (BOOL)isSupportFaceDetect {
    return [self containsString:@"FaceDetect"];
}

- (BOOL)isSupportCollectionPoint {
    return [self containsString:@"CollectionPoint"];
}

- (BOOL)isSupportTimedCruise {
    return [self containsString:@"TimedCruise"];
}

- (BOOL)isSupportSmartLocate {
    return [self containsString:@"SmartLocate"];
}

- (BOOL)isSupportSmartTrack {
    return [self containsString:@"SmartTrack"];
}

- (BOOL)isSupportNumberStat {
    return [self containsString:@"NumberStat"];
}

- (BOOL)isSupportManNumDec {
    return [self containsString:@"ManNumDec"];
}

- (BOOL)isSupportAlarmPIR {
    return [self containsString:@"AlarmPIR"];
}

- (BOOL)isSupportMobileDetect {
    return [self containsString:@"MobileDetect"];
}

- (BOOL)isSupportZoomFocus {
    return [self containsString:@"ZoomFocus"];
}

- (BOOL)isSupportCloseCamera {
    return [self containsString:@"CloseCamera"];
}

- (BOOL)isSupportHeatMap {
    return [self containsString:@"HeatMap"];
}

- (BOOL)isSupportChnLocalStorage {
    return [self containsString:@"ChnLocalStorage"];
}

- (BOOL)isSupportOSD {
    return [self containsString:@"OSD"];
}

- (BOOL)isSupportAudioTalk {
    return [self containsString:@"AudioTalk"];
}

- (BOOL)isSupportAudioTalkV1 {
    return [self containsString:@"AudioTalkV1"];
}

- (BOOL)isSupportAlarmSound {
    return [self containsString:@"AlarmSound"];
}

- (BOOL)isSupportElectric {
    return [self containsString:@"Electric"];
}

- (BOOL)isSupportWIFI {
    return [self containsString:@"WIFI"];
}

- (BOOL)isCanSetlocalRecord {
    return [self containsString:@"localRecord"];
}

- (BOOL)isCanSetmotionDetect {
    return [self containsString:@"motionDetect"];
}

- (BOOL)isCanSetfaceCapture {
    return [self containsString:@"faceCapture"];
}

- (BOOL)isCanSetspeechRecognition {
    return [self containsString:@"speechRecognition"];
}

- (BOOL)isCanSetbreathingLight {
    return [self containsString:@"breathingLight"];
}

- (BOOL)isCanSetsmartLocate {
    return [self containsString:@"smartLocate"];
}

- (BOOL)isCanSetsmartTrack {
    return [self containsString:@"smartTrack"];
}

- (BOOL)isCanSetregularCruise {
    return [self containsString:@"regularCruise"];
}

- (BOOL)isCanSetautoZoomFocus {
    return [self containsString:@"autoZoomFocus"];
}

- (BOOL)isCanSetlocalStorageEnable {
    return [self containsString:@"localStorageEnable"];
}

- (BOOL)isCanSetwhiteLight {
    return [self containsString:@"whiteLight"];
}

- (BOOL)isCanSetlinkageWhiteLight {
    return [self containsString:@"linkageWhiteLight"];
}

- (BOOL)isCanSetlinkageSiren {
    return [self containsString:@"linkageSiren"];
}

- (BOOL)isCanSetinfraredLight {
    return [self containsString:@"infraredLight"];
}

- (BOOL)isCanSetsearchLight {
    return [self containsString:@"searchLight"];
}

- (BOOL)isCanSetcloseCamera {
    return [self containsString:@"closeCamera"];
}

- (BOOL)isCanSetmobileDetect {
    return [self containsString:@"mobileDetect"];
}

@end
