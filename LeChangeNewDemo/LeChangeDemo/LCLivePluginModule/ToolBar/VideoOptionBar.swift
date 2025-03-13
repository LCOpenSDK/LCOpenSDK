//
//  VideoOptionBar.swift
//  LeChangeDemo
//
//  Created by 梁明哲 on 2024/6/21.
//  Copyright © 2024 dahua. All rights reserved.
//

import UIKit

public enum VideoOperationType: String {
    case sound  = "sound"
    case stream = "stream"
    case pause  = "pause"
}
protocol VideoOptionBarDelegate: NSObjectProtocol {
    func click(function:VideoOperationType, isOn:Bool)
}

class VideoOptionBar: UIView {
    weak var lcDelegate:VideoOptionBarDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.addSubview(pauseBtn)
        self.addSubview(soundBtn)
        
        pauseBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
            make.width.height.equalTo(30)
        }
        
        soundBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(pauseBtn.snp.trailing).offset(5)
            make.width.height.equalTo(30)
        }
        
        self.addSubview(streamBtn)
        streamBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(soundBtn.snp.trailing).offset(5)
            make.width.height.equalTo(30)
        }
    }
    
    lazy var streamBtn: UIButton = {
        let result = UIButton(type: .custom)
        result.isSelected = true
        result.setImage(UIImage.init(named: "live_video_icon_hd"), for: .normal)
        result.setImage(UIImage.init(named: "live_video_icon_hd"), for: .selected)
        result.addTarget(self, action: #selector(handleForStream), for: .touchUpInside)
        return result
    }()
    
    lazy var soundBtn: UIButton = {
        let result = UIButton(type: .custom)
        result.setImage(UIImage.init(named: "live_video_icon_sound_off"), for: .normal)
        result.setImage(UIImage.init(named: "live_video_icon_sound_on"), for: .selected)
        result.addTarget(self, action: #selector(handleSound), for: .touchUpInside)
        return result
    }()
    
    lazy var pauseBtn: UIButton = {
        let result = UIButton(type: .custom)
        result.setImage(UIImage.init(named: "live_video_icon_pause"), for: .normal)
        result.setImage(UIImage.init(named: "live_video_icon_play"), for: .selected)
        result.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        return result
    }()
    
    @objc func handleSound() {
        soundBtn.isSelected.toggle()
        lcDelegate?.click(function: .sound, isOn: soundBtn.isSelected)
    }

    @objc func handlePause() {
        pauseBtn.isSelected.toggle()
        lcDelegate?.click(function: .pause, isOn: pauseBtn.isSelected)
    }
    
    @objc func handleForStream() {
        streamBtn.isSelected.toggle()
        lcDelegate?.click(function: .stream, isOn: streamBtn.isSelected)
        
        if streamBtn.isSelected {
            streamBtn.setImage(UIImage.init(named: "live_video_icon_hd"), for: .normal)
            streamBtn.setImage(UIImage.init(named: "live_video_icon_hd"), for: .selected)
        } else {
            streamBtn.setImage(UIImage.init(named: "live_video_icon_sd"), for: .normal)
            streamBtn.setImage(UIImage.init(named: "live_video_icon_sd"), for: .selected)
        }
    }
}
