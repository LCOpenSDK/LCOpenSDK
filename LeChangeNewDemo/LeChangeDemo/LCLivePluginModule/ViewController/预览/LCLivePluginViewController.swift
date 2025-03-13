//
//  LCLivePluginViewController.swift
//  LeChangeDemo
//
//  Created by 梁明哲 on 2024/6/12.
//  Copyright © 2024 dahua. All rights reserved.
//

import UIKit
import LCNetworkModule
import LCOpenMediaSDK
import LCOpenSDKDynamic

class LCLivePluginViewController: UIViewController {
    
    var playItem: LCOpenLiveSource = LCOpenLiveSource()
    
    var videotapeList: NSMutableArray = [] {
        didSet {
            historyView.reloadData(videotapeList)
        }
    }
    var dayOffset: Int = 0 {
        didSet {
            if historyView.isCurrentCloud == true {
                queryCloudVideo()
            } else {
                queryDeviceVideo()
            }
        }
    }
    
    lazy var previousBtn: UIButton = {
        let result = UIButton()
        result.setTitle("前一天", for: .normal)
        result.setTitleColor(.black, for: .normal)
        result.addTarget(self, action: #selector(queryPreviousDayVideo), for: .touchUpInside)
        return result
    }()
    
    lazy var nextBtn: UIButton = {
        let result = UIButton()
        result.setTitle("后一天", for: .normal)
        result.addTarget(self, action: #selector(queryNextDayVideo), for: .touchUpInside)
        result.setTitleColor(.black, for: .normal)
        return result
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        self.title = LCNewDeviceVideoManager.shareInstance().currentDevice.name

        setupUI()
        //配置实时播放媒体数据
        self.configData()
        //请求云录像
        self.queryCloudVideo()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func setupUI() {
        self.addChildViewController(livePlayer)
        self.view.addSubview(livePlayer.view)
        self.view.addSubview(liveToolBar)
        self.view.addSubview(operationBar)
        self.view.addSubview(historyView)
        self.view.addSubview(previousBtn)
        self.view.addSubview(nextBtn)
        livePlayer.view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.height.equalTo(UIScreen.main.bounds.width*6/9.5)
        }
        operationBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(livePlayer.view)
            make.height.equalTo(45)
        }
        liveToolBar.snp.makeConstraints { make in
            make.top.equalTo(livePlayer.view.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        historyView.snp.makeConstraints { make in
            make.top.equalTo(liveToolBar.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
        }
        previousBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(historyView.snp.bottom)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(40)
        }
        nextBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(historyView.snp.bottom)
            make.leading.equalTo(previousBtn.snp.trailing)
            make.height.equalTo(40)
        }
 
    }
    
    lazy var livePlayer: LCSingleLivePlayer = {
        let result = LCSingleLivePlayer()
        return result
    }()
    
    //MARK: - Lazy Var
    lazy var talkPlayer: LCOpenTalkPlugin = {
        let player = LCOpenTalkPlugin.shareInstance()
        player.delegate = self
        return player
    }()
    
    //直播工具栏
    lazy var liveToolBar: LiveToolBar = {
        let result = LiveToolBar()
        result.lcDelegate = self
        return result
    }()
    lazy var historyView: HistoryVideoListView = {
        let result = HistoryVideoListView()
        result.delegate = self
        return result
    }()
    
    lazy var operationBar: VideoOptionBar = {
        let result = VideoOptionBar()
        result.lcDelegate = self
        return result
    }()
    
    func configData() {
        //277178 - 组装数据 - 开启预览 ⚠️
        playItem.pid = LCNewDeviceVideoManager.shareInstance().currentDevice.productId
        playItem.did = LCNewDeviceVideoManager.shareInstance().currentDevice.deviceId
        playItem.playToken = LCNewDeviceVideoManager.shareInstance().currentDevice.playToken;
        playItem.accessToken = LCApplicationDataManager.token()
        playItem.psk = LCNewDeviceVideoManager.shareInstance().currentPsk
        playItem.isTls = false
        if LCNewDeviceVideoManager.shareInstance().mainChannelInfo.resolutions.count > 0  && LCNewDeviceVideoManager.shareInstance().currentDevice.catalog.uppercased() != "NVR"{
            let resolution = LCNewDeviceVideoManager.shareInstance().currentResolution
            LCNewDeviceVideoManager.shareInstance().currentResolution = resolution
            
            playItem.imageSize = Int(Int32(resolution.imageSize));
            playItem.isMainStream = !LCNewDeviceVideoManager.shareInstance().isSD
        } else {
            playItem.isMainStream = true
        }
        
        repeat {
            LCOpenMediaApiManager.shareInstance().getPlayTokenKey(LCApplicationDataManager.token()) { playTokenkey in
                self.playItem.playTokenKey = playTokenkey
            } failure: { errorCode in
            }

        }while(false)
        
        self.livePlayer.startPlay(playItem: playItem)
    }
    
    func isSupportOpt(ability: String) -> Bool {
        return ability.contains("RTSV1") || ability.contains("RTSV2")
    }
}

extension LCLivePluginViewController: LiveToolBarDelegate {
    
    func clickRecord(isOn: Bool) {
        if isOn {
            let videoRecordPath = NSTemporaryDirectory().appending(String(format: "%d", playItem.cid))
            let videoRecordFileName = videoRecordPath.appending(".mp4")
            var recordPaths: [String] = [videoRecordFileName]
            if let assiciatedItemArray = playItem.associcatChannels, assiciatedItemArray.count > 0 {
                assiciatedItemArray.forEach { element in
                    if element.cid != playItem.cid {
                        let videoRecordPath = NSTemporaryDirectory().appending(String(format: "%d", element.cid))
                        let path = videoRecordPath.appending(".mp4")
                        recordPaths.append(path)
                    }
                }
            }
            //开始录制传入地址
            self.livePlayer.startVideoRecord(paths: recordPaths)
        } else {
            //结束录制
            self.livePlayer.stopVideoRecord()
        }
    }
    
    func clickTalk(isOn: Bool) {
        //申请麦克风权限步骤
        
        if isOn == true {
            // 采用对讲链路，对讲前关闭音频链路
            self.livePlayer.playAudio(isOn: false)
            if self.livePlayer.playStatus == .playing {
                let source = LCOpenTalkSource()
                source.did = playItem.did
                source.cid = playItem.cid
                source.pid = playItem.pid
                source.playToken = playItem.playToken
                source.playTokenKey = playItem.playTokenKey
                source.accessToken = playItem.accessToken
                source.psk =      playItem.psk
                source.isTls = playItem.isTls
                source.talkType = "talk"
                talkPlayer.playTalk(source)
                
            }
        } else {
            talkPlayer.stopTalk()
        }
    }
    
    func clickScreenShot() {
        //主通道保存图片地址
        let mainFilePath = LCFileManager.userFolder()?.appending("\(playItem.cid).jpg") ?? ""
        var paths: [String] = [mainFilePath]
        
        if let assiciatedItemArray = playItem.associcatChannels, assiciatedItemArray.count > 0 {
            //多目逻辑
            assiciatedItemArray.forEach { element in
                if let path = LCFileManager.userFolder()?.appending("\(element.cid).jpg"), path != "", element.cid != playItem.cid {
                    paths.append(path)
                }
            }
        }
        //播放器内部处理截图逻辑
        self.livePlayer.doScreenshot(paths: paths)
    }
}
extension LCLivePluginViewController: VideoOptionBarDelegate {
    func click(function: VideoOperationType, isOn: Bool) {
        if function == .sound {
            self.livePlayer.playAudio(isOn: isOn)
        }
        if function == .pause {
            isOn == true ? self.livePlayer.stopPlay() : self.livePlayer.startPlay(playItem: playItem)
        }
        if function == .stream {
            if isOn {
                playItem.isMainStream = true
                playItem.imageSize  = -2022
                playItem.associcatChannels?.forEach({ element in
                    if let associatedItem = element as? LCOpenLiveSource {
                        associatedItem.isMainStream = true
                        associatedItem.imageSize  = -2022
                    }
                })
            } else {
                playItem.isMainStream = false
                playItem.imageSize = -1
                playItem.associcatChannels?.forEach({ element in
                    if let associatedItem = element as? LCOpenLiveSource {
                        associatedItem.isMainStream = false
                        associatedItem.imageSize  = -1
                    }
                })
            }
            self.livePlayer.startPlay(playItem: playItem)
        }
    }
}

//对讲回调
extension LCLivePluginViewController: LCOpenTalkPluginDelegate {
    func onTalkFailure(_ source: LCOpenTalkSource, talkError error: String, type: Int32) {
        
    }
    
    func onTalkSuccess(_ source: LCOpenTalkSource) {
        LCProgressHUD.showMsg("talk begin", duration: 2)
        self.liveToolBar.talkBtn.isSelected = true
    }
    
    func onTalkLoading(_ source: LCOpenTalkSource) {
        
    }
    
    func onTalkStop(_ source: LCOpenTalkSource) {
        LCProgressHUD.showMsg("talk end", duration: 2)
        self.liveToolBar.talkBtn.isSelected = false
    }
    
}

extension LCLivePluginViewController: HistoryVideoListViewProtocol {
    func selectVideoItem(_ item: Any) {
        let vc = LCPluginRecordViewController()
        if let cloudItem = item as? LCCloudVideotapeInfo {
            let videoInfo: LCOpenCloudSource = LCOpenCloudSource()
            videoInfo.did = playItem.did
            videoInfo.cid = playItem.cid
            videoInfo.pid = playItem.pid
            videoInfo.bindPid = playItem.bindPid
            videoInfo.bindDid = playItem.bindDid
            videoInfo.bindCid = playItem.bindCid
            videoInfo.psk =      playItem.psk
            videoInfo.playToken = playItem.playToken
            videoInfo.playTokenKey = playItem.playTokenKey
            videoInfo.accessToken = playItem.accessToken
            videoInfo.recordRegionId = cloudItem.recordRegionId
            videoInfo.timeout = 10
            videoInfo.speed = 1.0
            vc.node.videoInfo = videoInfo
            vc.node.startTime = cloudItem.beginTime
            vc.node.endTime = cloudItem.endTime
            
            vc.title = "云录像"
        }
        /*按文件播放*/
        if let localItem = item as? LCLocalVideotapeInfo {
            
//            let videoInfo: LCOpenDeviceFileSource = LCOpenDeviceFileSource()
//            videoInfo.did = playItem.did
//            videoInfo.cid = playItem.cid
//            videoInfo.pid = playItem.pid
//            videoInfo.bindPid = playItem.bindPid
//            videoInfo.bindDid = playItem.bindDid
//            videoInfo.bindCid = playItem.bindCid
//            videoInfo.psk = playItem.psk
//            videoInfo.playToken = playItem.playToken
//            videoInfo.playTokenKey = playItem.playTokenKey
//            videoInfo.accessToken = playItem.accessToken
//            videoInfo.fileId = localItem.recordId
//            videoInfo.isTls = playItem.isTls
//            videoInfo.isMainStream = playItem.isMainStream
//            videoInfo.speed = 1
            
            let videoInfo: LCOpenDeviceTimeSource = LCOpenDeviceTimeSource()
            videoInfo.did = playItem.did
            videoInfo.cid = playItem.cid
            videoInfo.pid = playItem.pid
            videoInfo.bindPid = playItem.bindPid
            videoInfo.bindDid = playItem.bindDid
            videoInfo.bindCid = playItem.bindCid
            videoInfo.psk = playItem.psk
            videoInfo.playToken = playItem.playToken
            videoInfo.playTokenKey = playItem.playTokenKey
            videoInfo.accessToken = playItem.accessToken
            videoInfo.startTime = Int(localItem.beginDate.timeIntervalSince1970)
            videoInfo.endTime = Int(localItem.endDate.timeIntervalSince1970)
            videoInfo.isTls = playItem.isTls
            videoInfo.isMainStream = playItem.isMainStream
            videoInfo.speed = 1
            
            vc.node.videoInfo = videoInfo
            vc.node.startTime = localItem.beginTime
            vc.node.endTime = localItem.endTime
            vc.title = "卡录像"
        }
        self.navigationController?.pushViewController(vc, animated: true)
        /*按时间播放
        if let localItem = item as? LCLocalVideotapeInfo {
            let vc = LCPluginRecordViewController()
            let videoInfo: LCDeviceTimeVideoItem = LCDeviceTimeVideoItem()
            videoInfo.deviceId = playItem.deviceId
            videoInfo.channelId = playItem.channelId
            videoInfo.productId = playItem.productId
            videoInfo.psk = playItem.psk
            
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            if let endDate = dateFormatter.date(from: localItem.endTime) {
                videoInfo.endTime = Int(endDate.timeIntervalSince1970)
            }
            
            if let startDate = dateFormatter.date(from: localItem.beginTime) {
                videoInfo.offsetTime = 0
                videoInfo.beginTime  = Int(startDate.timeIntervalSince1970)
            }
            
            videoInfo.associatedItems = playItem.associatedItems
            videoInfo.encrypt = playItem.encrypt
            videoInfo.isOpt = playItem.isOpt
            videoInfo.isTls = playItem.isTls
            videoInfo.password = playItem.password
            videoInfo.streamAddr = playItem.streamAddr
            videoInfo.project =    playItem.project
            videoInfo.rtspToken =  playItem.rtspToken
            videoInfo.salt =       playItem.salt
            videoInfo.type =       playItem.type
            videoInfo.requestType = "playbackByTime"
            videoInfo.streamType = playItem.streamType
            videoInfo.speed = 1
            vc.videoInfo = videoInfo
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
         */
    }
    
    func dataSourceChange(_ index: Int32) {
        if index == 1 {
            queryDeviceVideo()
        } else if index == 0 {
            queryCloudVideo()
        }
    }

}

extension LCLivePluginViewController {
    @objc func queryPreviousDayVideo() {
        dayOffset = dayOffset - 1
    }
    
    @objc func queryNextDayVideo() {
        if dayOffset < 0 {
            dayOffset = dayOffset + 1
        }
        
    }
    
    func queryDeviceVideo() {
        let date = Date().addingTimeInterval(TimeInterval(24*60*60*dayOffset))
        historyView.startAnimation()
        LCVideotapeInterface.queryLocalRecords(forDevice: playItem.did, productId: playItem.pid, channelId: String(format: "%d", playItem.cid), day: date, from: 1, to: 6) { [weak self] videos in
            if (videos.count == 0) {
                self?.videotapeList = []
            } else {
                self?.videotapeList = videos
            }
            self?.historyView.stopAnimation()
        } failure: {[weak self] error in
            self?.historyView.stopAnimation()
        }
    }
    
    func queryCloudVideo() {
//        let date = Date().addingTimeInterval(TimeInterval(24*60*60*dayOffset))
        historyView.startAnimation()
         
        let currentDate = Date()
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "yyyy-MM-dd"
        let startStr = "\(dataFormatter.string(from: currentDate)) 00:00:00"
        let endStr = "\(dataFormatter.string(from: currentDate)) 23:59:59"
        
        let tDataFormatter = DateFormatter()
        tDataFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let beginTime = tDataFormatter.date(from: startStr)?.timeIntervalSince1970 ?? 0
        let endTime = tDataFormatter.date(from: endStr)?.timeIntervalSince1970 ?? 0
        LCVideotapeInterface.getCloudRecords(forDevice: playItem.did, productId: playItem.pid, channelId: String(format: "%d", playItem.cid), beginTime: beginTime, endTime: endTime, count: 6, isMultiple: LCNewDeviceVideoManager.shareInstance().currentDevice.multiFlag) { [weak self] videos in
            self?.historyView.stopAnimation()
            if (videos.count == 0) {
                self?.videotapeList = []
            } else {
                self?.videotapeList = videos
            }
        } failure: { [weak self] error in
            self?.historyView.stopAnimation()
        }

//        LCVideotapeInterface.queryCloudRecords(forDevice: playItem.did, productId: playItem.pid, channelId: String(format: "%d", playItem.cid), day: date, from: 1, to: 6) {[weak self] videos in
//            self?.historyView.stopAnimation()
//            if (videos.count == 0) {
//                self?.videotapeList = []
//            } else {
//                self?.videotapeList = videos
//            }
//        } failure: {[weak self] error in
//            self?.historyView.stopAnimation()
//        }
    }
}
