//
//  LCSingleLivePlayer.swift
//  LeChangeDemo
//
//  Created by 梁明哲 on 2024/6/14.
//  Copyright © 2024 dahua. All rights reserved.
//

import UIKit
import LCOpenMediaSDK
class LCSingleLivePlayer: UIViewController, LCOpenMediaLiveMultiviewDelegate {
    func multiviewWindow(_ livePlugin: LCOpenMediaLivePlugin, doSingleTap channelId: Int) {
     
    }
    
    func multiviewWindow(_ livePlugin: LCOpenMediaLivePlugin, doDoubleTap channelId: Int) {
     
    }
    
    func multiviewWindow(_ livePlugin: LCOpenMediaLivePlugin, doLeftSwipe channelId: Int) {
     
    }
    
    func multiviewWindow(_ livePlugin: LCOpenMediaLivePlugin, doRightSwipe channelId: Int) {
     
    }
    
    func multiviewWindow(_ livePlugin: LCOpenMediaLivePlugin, doUpSwipe channelId: Int) {
     
    }
    
    func multiviewWindow(_ livePlugin: LCOpenMediaLivePlugin, doDownSwipe channelId: Int) {
        
    }
    
    func multiviewWindow(_ livePlugin: LCOpenMediaLivePlugin, changed screenMode: LCScreenMode, littleWindowId: Int) {
        
    }
    
    func multiviewWindow(_ livePlugin: LCOpenMediaLivePlugin, littleWindowBorderColor: Any?) -> UIColor? {
        return UIColor.brown
    }
    
    func multiviewWindow(_ livePlugin: LCOpenMediaLivePlugin, subWindow changedLocation: LCCastQuadrant) {
     
    }
    
    func multiviewWindow(_ livePlugin: LCOpenMediaLivePlugin, bgViewWith isMainWindow: Bool) -> UIView? {
        return nil
    }
    
    func multiviewWindow(_ livePlugin: LCOpenMediaLivePlugin, surfaceRatioWith channelId: Int) -> CGFloat {
        return 16.0 / 9.0
    }
    
    func multiviewWindowSpaceConfig(_ livePlugin: LCOpenMediaLivePlugin) -> LCMediaDoubleCameraSpaceConfig? {
        return nil
    }
    
    func multiviewWindow(_ livePlugin: LCOpenMediaLivePlugin, windowConfigWith channelId: Int) -> LCMediaDoubleCamWindowConfig? {
        return nil
    }
    
    // 播放状态
    var playStatus: VPPlayStatus = .ready
    var isRecording: Bool = false
    
    var recordVideoPath: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.playerCtr)
        
        self.playerCtr.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.view.addSubview(self.activityView)
        self.activityView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        if LCNewDeviceVideoManager.shareInstance().currentDevice.channels.count > 1 && LCNewDeviceVideoManager.shareInstance().currentDevice.catalog.uppercased() != "NVR" {
            self.playerCtr.configPlayerType(.doubleIPC)
            playerCtr.setAssistWindowEnabed(true)
//            playerCtr.configDefaultScreenMode(isLargeScreen: true, isFirstScreen: true)
            playerCtr.screenMode = .singleScreen
        }
        
    }
    
    lazy var activityView: LCActivityIndicatorView = {
        let activity = LCActivityIndicatorView()
        activity.startAnimating()
        return activity
    }()
    fileprivate lazy var playerCtr:LCOpenMediaLivePlugin = {
        let player = LCOpenMediaLivePlugin()
        player.configPlayerType(.singleIPC)
        player.setPlayerListener(self)
        player.setMultiviewWindowListener(self)
        
        return player
    }()

    func startPlay(playItem: LCOpenLiveSource) {
        self.playerCtr.playRtspReal(with: playItem)
    }
    func isPlaying() -> Bool {
        return playStatus == .playing
    }
    func stopPlay() {
        self.playerCtr.stopRtspReal(false)
    }
    
    func playAudio(isOn:Bool) {
        if isOn {
            playerCtr.playAudio()
        }else {
            playerCtr.stopAudio()
        }
    }
    //截图
    func doScreenshot(paths:[String]) {
        self.playerCtr.snapShot()
//        if isScreenshotSuccess {
//            LCProgressHUD.showMsg("ScreenShot Success", duration: 2)
//            DispatchQueue.main.async {
//                paths.forEach { element in
//                    if let image = UIImage(contentsOfFile: element), let fileUrl = URL(string: element) {
//                        PHAsset.saveImage(toCameraRoll: image, url: fileUrl) {} failure: { error in }
//                    }
//                }
//            }
//        } else {
//            LCProgressHUD.showMsg("ScreenShot failed", duration: 2)
//        }
    }
    //开始录制
    func startVideoRecord(paths: [String]) {
        recordVideoPath = paths
        self.playerCtr.startRecord()
    }
    //结束录制
    func stopVideoRecord() {
        self.playerCtr.stopRecord()
    }
}

extension LCSingleLivePlayer: LCOpenMediaLiveDelegate {
    
    /// 开始播放
    /// - Parameter livePlugin: 多窗口预览组件
    func onPlaySuccess(_ videoItem:LCBaseVideoItem) {
        playStatus = .playing
        self.activityView.isHidden = true
    }
    
    /// 开始拉流
    /// - Parameter livePlugin: 多窗口预览组件
    func onPlayLoading(_ videoItem:LCBaseVideoItem) {
        playStatus = .loading
        self.activityView.isHidden = false
    }
    
    /// 停止播放
    /// - Parameter livePlugin: 多窗口预览组件
    func onPlayStop(_ videoItem:LCBaseVideoItem, saveLastFrame:Bool) {
        playStatus = .stop
        self.activityView.isHidden = true
    }
    
    // 录制开始回调
    /// - Parameter livePlugin: 多窗口预览组件
    func onRecordStart(_ videoItem:LCBaseVideoItem) {
        isRecording = true
    }
    
    /// 录制结束回调
    /// - Parameter livePlugin: 多窗口预览组件
    func onRecordFinish(_ videoItem: LCBaseVideoItem, paths: [Int : String]) {
        isRecording = false
        LCProgressHUD.showMsg("record video stoped", duration: 2)
        //录制结束,保存录像到系统相册
        self.recordVideoPath.forEach { element in
            if let videUrl = URL(string: element) {
                PHAsset.saveVideo(at: videUrl) {
                    
                } failure: { error in
                    
                }
            }
        }
    }
    
    /// 播放失败回调
    /// - Parameters:
    ///   - livePlugin: 多窗口预览组件
    ///   - videoError: 失败错误类型
    ///   - errorInfo: 错误信息，json格式
    func onPlayFailure(videoError: String, type: String, videoItem: LCBaseVideoItem) {
        playStatus = .error
        self.activityView.isHidden = true
    }
    
    /// 码流回调信息
    /// - Parameters:
    ///   - livePlugin: 多窗口预览组件
    ///   - videoCode: 码流信息码
    ///   - streamInfo: 码流信息，json格式，如{"proto":"live_count_down", "countDownTime":12, "desc":"devices will sleep after 12s"}
    func onStreamInfo(videoCode: LCVideoPlayError, streamInfo:String?, videoItem:LCBaseVideoItem) {
        
    }
    
    /// 播放码率
    /// - Parameters:
    ///   - livePlugin: 多窗口预览组件
    ///   - byte: 码率(单位:bit)
    func onReceiveData(byteRate byte: Int, videoItem:LCBaseVideoItem) {
        
    }
    
    /// 设置状态层View
    /// - Parameter livePlugin: 多窗口预览组件
    func viewForStateLayer(_ livePlugin: LCOpenMediaLivePlugin) -> UIView? {
        return nil
    }
    
    /// 设置工具层View
    /// - Parameter livePlugin: 多窗口预览组件
    func viewForToolLayer(_ livePlugin: LCOpenMediaLivePlugin) -> UIView? {
        return nil
    }
    
    /// 云台限位  direh代表左右方向 dires代表上下方向
    func onIVSInfo(_ videoItem:LCBaseVideoItem, direh lDireh: DHPtzDirection, dires lDires: DHPtzDirection) {
        
    }
    
    /// 电子放大比例变化
    /// - Parameter livePlugin: 单窗口预览组件
    ///   - EZoom: 电子放大当前比例
    func onEZoomChanged(_ scale:CGFloat, with videoItem:LCBaseVideoItem) {
        
    }
    
    /// 云台旋转角度变化
    /// - Parameters:
    ///   - livePlugin: 多窗口预览组件
    ///   - rotationDirection: 旋转方向: 1 - 左右转向，值取左右转向位置；2 – 上下转向，值取上下转向位置；
    ///   - horizontalAngle: 水平角度, 范围(-1, 1)
    ///   - verticalAngle: 垂直角度, 范围(-1, 1)
    func onPtzAngleChanged(rotationDirection:Int, horizontalAngle:CGFloat, verticalAngle:CGFloat) {
        
    }
    
    /// 网络状态监听
    /// - Parameters:
    ///   - livePlugin: 多窗口预览组件
    ///   - networkStatus: 0-弱网    非0-非弱网
    func onNetStatus(_ networkStatus:Int) {
        
    }
    
    /// 辅助帧回调
    func onAssistFrameInfo(jsonDic: [String: Any]) {
        
    }
    
    func onSoundChanged(_ isAudioOpen: Bool) {
        
    }
    
    func configFilePath(cid:Int, fileType:LCFilePathType) -> String {
        return ""
    }
    
    func onSnapPicFail() {
        
    }
    
    func onSnapPicSuccess(paths: [Int : String]) {
        
    }
    
    func onRecordFail() {
        
    }
}


