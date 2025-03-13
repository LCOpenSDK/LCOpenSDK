//
//  LCVideoPlayer.swift
//  LeChangeDemo
//
//  Created by 梁明哲 on 2024/6/18.
//  Copyright © 2024 dahua. All rights reserved.
//

import UIKit
import LCOpenMediaSDK

protocol LCVideoPlayerDelegate:NSObjectProtocol {
    func recordPlayer(videoPaused: Any?)
    func recordPlayer(videoStoped: Any?)
    func recordPlayer(videoFinished: Any?)
    func recordPlayer(playTime: TimeInterval)
}

class LCVideoPlayer: UIViewController {
    // 播放状态
    var playStatus: VPPlayStatus = .ready
    var isRecording: Bool = false
    weak var delegate: LCVideoPlayerDelegate?
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
        // Do any additional setup after loading the view.
        
        if LCNewDeviceVideoManager.shareInstance().currentDevice.channels.count > 1 && LCNewDeviceVideoManager.shareInstance().currentDevice.catalog.uppercased() != "NVR" {
            self.playerCtr.configPlayerType(.doubleIPC)
            playerCtr.screenMode = .singleScreen
        }
    }
    lazy var activityView: LCActivityIndicatorView = {
        let activity = LCActivityIndicatorView()
        activity.startAnimating()
        return activity
    }()
    fileprivate lazy var playerCtr: LCOpenMediaRecordPlugin = {
        let player = LCOpenMediaRecordPlugin()
        player.setPlayerListener(self)
//        player.setGestureListener(self)
//        player.setLogReportListener(self)
//        player.setAssistWindowListener(self)
//        player.setMultiviewWindowListener(self)
        return player
    }()

    public func startVideoRecord(with paths:[String]) {
        recordVideoPath = paths
        self.playerCtr.startRecord()
    }
    
    public func stopVideoRecord() {
        
        self.playerCtr.stopRecord()
    }
    
    func setPlaySpeed(speed:CGFloat) {
        self.playerCtr.setPlaySpeed(speed)
    }
    
    func startPlay(playItem: LCBaseVideoItem) {
        self.playerCtr.playRecordStream(with: playItem)
        
    }
    //暂停
    func pause() {
        self.playerCtr.pauseAsync()
    }
    func resume() {
        self.playerCtr.resumeAsync()
    }
    //截图
    func doScreenshot(paths:[String]) {
        playerCtr.snapShot(isCallback: true)
//        let isScreenshotSuccess = self.playerCtr.doScreenshot(with: paths)
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
    
    func playAudio(isOn:Bool) {
        if isOn {
            playerCtr.playAudio()
        }else {
            playerCtr.stopAudio()
        }
    }
}

extension LCVideoPlayer: LCRecordPluginDelegate {
    func onRecordFinish(_ videoItem: LCBaseVideoItem, paths: [Int : String]) {
        //录制结束,保存录像到系统相册
        self.recordVideoPath.forEach { element in
            if let videUrl = URL(string: element) {
                PHAsset.saveVideo(at: videUrl) {
                    
                } failure: { error in
                    
                }
            }
        }
    }
    
    func onPlaySuccess(_ videoItem: LCBaseVideoItem) {
        self.activityView.isHidden = true
    }
    
    func onPlayLoading(_ videoItem: LCBaseVideoItem) {
        self.activityView.isHidden = false
    }
    
    func onPlayPaused(_ videoItem: LCBaseVideoItem) {
        self.delegate?.recordPlayer(videoPaused: nil)
    }
    
    func onPlayStop(_ videoItem: LCBaseVideoItem, saveLastFrame: Bool) {
        self.delegate?.recordPlayer(videoStoped: nil)
    }
    
    func onPlayFinished(_ videoItem: LCBaseVideoItem) {
        self.delegate?.recordPlayer(videoFinished: nil)
    }
    
    func onRecordStart(_ videoItem: LCBaseVideoItem) {
        
    }
    
    func onPlayFailure(videoError: String, type: String, videoItem: LCBaseVideoItem) {
        self.activityView.isHidden = true
    }
    
    func onStreamInfo(videoError: String, type: String, streamInfo: String?, videoItem: LCBaseVideoItem) {
    
    }
    
    func onReceiveData(byteRate byte: Int, videoItem: LCBaseVideoItem) {
        
    }
    
    func onPlayerTime(_ playTime: TimeInterval, videoItem: LCBaseVideoItem) {
        delegate?.recordPlayer(playTime: playTime)
    }
    
    func onPlaySpeedChange(_ speed: CGFloat, videoItem: LCBaseVideoItem) {
        
    }
    
    func onEZoomChanged(_ scale: CGFloat, with videoItem: LCBaseVideoItem) {
        
    }
    
    func onAssistFrameInfo(jsonDic: [String : Any]) {
        
    }
    
    func processPan(_ dx: CGFloat, dy: CGFloat, channelId: Int) {
        
    }
    
    func processPanBegin(_ channelId: Int) {
        
    }
    
    func processPanEnd(_ channelId: Int) {
        
    }
    
    /// 设置状态层View
    /// - Parameter videoController: 录像播放组件
    func viewForStateLayer(_ plugin: LCOpenMediaRecordPlugin) -> UIView? {
        return nil
    }
    
    /// 设置工具层View
    /// - Parameter videoController: 录像播放组件
    func viewForToolLayer(_ plugin: LCOpenMediaRecordPlugin) -> UIView? {
        return nil
    }
    
    /// 电子放大比例变化
    /// - Parameter videoController: 录像播放组件
    ///   - EZoom: 电子放大当前比例
    func recordPlugin(_ plugin: LCOpenMediaRecordPlugin, EZoom scale:CGFloat, channelId:Int) {
        
    }
    
    //音频开关状态回调
    func onSoundChanged(_ isAudioOpen:Bool) {}
    //配置截图路径
    func configFilePath(cid:Int, fileType:LCFilePathType) -> String {
        return ""
    }
    //截图失败
    func onSnapPicFail() {}
    //截图成功(通道号:截图路径)
    func onSnapPicSuccess(paths:[Int :String]) {}
    //录制失败
    func onRecordFail() {}
    
}


