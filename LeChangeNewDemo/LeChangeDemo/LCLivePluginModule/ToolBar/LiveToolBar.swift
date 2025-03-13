//
//  LiveToolBar.swift
//  LeChangeDemo
//
//  Created by 梁明哲 on 2024/6/14.
//  Copyright © 2024 dahua. All rights reserved.
//

import UIKit
protocol LiveToolBarDelegate: NSObjectProtocol {
    func clickRecord(isOn:Bool)
    func clickTalk(isOn:Bool)
    func clickScreenShot()
}

class LiveToolBar: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    weak var lcDelegate: LiveToolBarDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.addSubview(screenShotBtn)
        self.addSubview(recordBtn)
        self.addSubview(talkBtn)
        screenShotBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().multipliedBy(0.5)
            make.width.height.equalTo(45)
        }
        
        talkBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().multipliedBy(1)
            make.width.height.equalTo(45)
        }
        
        recordBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().multipliedBy(1.5)
            make.width.height.equalTo(45)
        }
    }

    lazy var screenShotBtn: UIButton = {
        let result = UIButton(type: .custom)
        result.setImage(UIImage.init(named: "live_video_icon_screenshot"), for: .normal)
        result.setImage(UIImage.init(named: "live_video_icon_screenshot_disable"), for: .disabled)
        result.addTarget(self, action: #selector(handleScreenShot), for: .touchUpInside)
        return result
    }()
    
    lazy var recordBtn: UIButton = {
        let result = UIButton(type: .custom)
        result.setImage(UIImage.init(named: "live_video_icon_video"), for: .normal)
        result.setImage(UIImage.init(named: "live_video_icon_video_disable"), for: .disabled)
        result.setImage(UIImage.init(named: "live_video_icon_video_on"), for: .selected)
        result.addTarget(self, action: #selector(handleRecord), for: .touchUpInside)
        return result
    }()
    
    lazy var talkBtn: UIButton = {
        let result = UIButton(type: .custom)
        result.setImage(UIImage.init(named: "live_video_icon_speak"), for: .normal)
        result.setImage(UIImage.init(named: "live_video_icon_speak_disable"), for: .disabled)
        result.setImage(UIImage.init(named: "live_video_icon_speak_on"), for: .selected)
        result.addTarget(self, action: #selector(handleTalk), for: .touchUpInside)
        return result
    }()
    
    @objc func handleScreenShot() {
        lcDelegate?.clickScreenShot()
    }
    
    @objc func handleRecord() {
        recordBtn.isSelected.toggle()
        lcDelegate?.clickRecord(isOn: recordBtn.isSelected)
    }
    
    @objc func handleTalk() {
        talkBtn.isSelected.toggle()
        lcDelegate?.clickTalk(isOn: talkBtn.isSelected)
    }
}
