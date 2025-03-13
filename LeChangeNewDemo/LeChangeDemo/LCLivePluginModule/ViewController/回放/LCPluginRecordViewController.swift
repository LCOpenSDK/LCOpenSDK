//
//  LCPluginRecordViewController.swift
//  LeChangeDemo
//
//  Created by 梁明哲 on 2024/6/18.
//  Copyright © 2024 dahua. All rights reserved.
//

import UIKit
import LCOpenMediaSDK

class LCPluginRecordViewController: UIViewController {
    
    var node: VideoNode = VideoNode()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        // Do any additional setup after loading the view.
        videoPlayer.startPlay(playItem: node.videoInfo)
    }
    
    func setupUI() {
        self.navigationItem.leftBarButtonItem?.title = ""
        self.view.backgroundColor = .white
        self.view.addSubview(videoPlayer.view)
        self.view.addSubview(videoToolBar)
        self.view.addSubview(operationBar)
        self.view.addSubview(progressBar)
        self.view.addSubview(timeLabel)
        videoPlayer.view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.height.equalTo(UIScreen.main.bounds.width*6/9.5)
        }

        operationBar.snp.makeConstraints { make in
            make.bottom.equalTo(videoPlayer.view.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(45)
        }
        
        videoToolBar.snp.makeConstraints { make in
            make.top.equalTo(videoPlayer.view.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(70)
        }
        
        progressBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(3)
            make.bottom.equalTo(operationBar.snp.top)
        }
        timeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-3)
            make.height.equalTo(30)
            make.bottom.equalTo(progressBar.snp.top)
        }
    }
    
    lazy var videoPlayer: LCVideoPlayer = {
        let result = LCVideoPlayer()
        result.delegate = self
        return result
    }()
    lazy var videoToolBar: VideoToolBar = {
        let result = VideoToolBar()
        result.lcDelegate = self
        return result
    }()
    
    lazy var operationBar: VideoOptionBar = {
        let result = VideoOptionBar()
        result.lcDelegate = self
        result.streamBtn.isHidden = true
        return result
    }()
    lazy var progressBar: UIProgressView = {
        let result = UIProgressView()
        return result
    }()
    lazy var timeLabel: UILabel = {
        let result = UILabel()
        result.font = UIFont.systemFont(ofSize: 13.0)
        result.textColor = .white
        return result
    }()
}

extension LCPluginRecordViewController: VideoToolBarDelegate {
    func clickSpeed(value: CGFloat) {
        self.videoPlayer.setPlaySpeed(speed:value)
    }
    
    func clickRecord(isOn: Bool) {
        if isOn {
            let videoRecordPath = NSTemporaryDirectory().appending(String(format: "%d", node.videoInfo.cid))
            let videoRecordFileName = videoRecordPath.appending(".mp4")
            var recordPaths: [String] = [videoRecordFileName]
            if let assiciatedItemArray = node.videoInfo.associcatChannels, assiciatedItemArray.count > 0 {
                assiciatedItemArray.forEach { element in
                    if element.cid != node.videoInfo.cid {
                        let videoRecordPath = NSTemporaryDirectory().appending(String(format: "%d", element.cid))
                        let path = videoRecordPath.appending(".mp4")
                        recordPaths.append(path)
                    }
                }
            }
            self.videoPlayer.startVideoRecord(with: recordPaths)
        } else {
            self.videoPlayer.stopVideoRecord()
        }
    }
    
    func clickScreenShot() {
        //主通道保存图片地址
        let mainFilePath = LCFileManager.userFolder()?.appending("\(node.videoInfo.cid).jpg") ?? ""
        var paths: [String] = [mainFilePath]
        
        if let assiciatedItemArray = node.videoInfo.associcatChannels, assiciatedItemArray.count > 0 {
            //多目逻辑
            assiciatedItemArray.forEach { element in
                if let path = LCFileManager.userFolder()?.appending("\(element.cid).jpg"), path != "", element.cid != node.videoInfo.cid {
                    paths.append(path)
                }
            }
        }
        self.videoPlayer.doScreenshot(paths: paths)
    }
    
}

extension LCPluginRecordViewController: VideoOptionBarDelegate {
    func click(function: VideoOperationType, isOn: Bool) {
        if function == .sound {
            self.videoPlayer.playAudio(isOn: isOn)
        }
        if function == .pause {
            isOn == true ? self.videoPlayer.pause() : self.videoPlayer.resume()
        }
    }
    
}

extension LCPluginRecordViewController:LCVideoPlayerDelegate {
    
    func recordPlayer(videoStoped: Any?) {
        self.operationBar.pauseBtn.isSelected = true
    }
    func recordPlayer(videoPaused: Any?) {
        self.operationBar.pauseBtn.isSelected = true
        //暂停时，播放速度恢复1倍
        self.videoToolBar.resetSpeed()
        self.videoPlayer.setPlaySpeed(speed: 1.0)
    }
    func recordPlayer(videoFinished: Any?) {
        self.operationBar.pauseBtn.isSelected = true
    }
    func recordPlayer(playTime: TimeInterval) {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let endDate = dateFormatter.date(from: node.endTime ?? ""), let startDate = dateFormatter.date(from: node.startTime ?? "") {
            //播放时间进度条处理
            let restTime = CGFloat(endDate.timeIntervalSince1970) - playTime
            let durantion = CGFloat(endDate.timeIntervalSince1970) - CGFloat(startDate.timeIntervalSince1970)
            let percent:CGFloat = (durantion - restTime) / durantion
            progressBar.progress = Float(percent)
            print("percent = \(percent) , durantion = \(durantion) , restTime = \(restTime)")
            let hour = Int(Int(restTime)/3600)
            let minute = Int(Int(restTime) % 3600)/60
            let second = Int(Int(restTime) % 3600) % 60
            timeLabel.text = "\(String(format: "%02d", hour)):\(String(format: "%02d", minute)):\(String(format: "%02d", second))"
        }
    }
}
