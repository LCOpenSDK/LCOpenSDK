//
//  VideoToolBar.swift
//  LeChangeDemo
//
//  Created by 梁明哲 on 2024/6/21.
//  Copyright © 2024 dahua. All rights reserved.
//

import UIKit


protocol VideoToolBarDelegate: NSObjectProtocol {
    func clickRecord(isOn:Bool)
    func clickScreenShot()
    func clickSpeed(value: CGFloat)
}

class VideoToolBar: UIView {
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var maxSpeed: CGFloat = 32.0
    var speed: CGFloat = 1.0
    weak var lcDelegate: VideoToolBarDelegate?
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
        self.addSubview(speedBtn)
        screenShotBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().multipliedBy(0.25)
            make.width.height.equalTo(45)
        }
        
        recordBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(45)
        }
        speedBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().multipliedBy(1.75)
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
    lazy var speedBtn: UIButton = {
        let result = UIButton(type: .custom)
        result.setImage(UIImage.init(named: "video_1x"), for: .normal)
        result.addTarget(self, action: #selector(handleSpeed), for: .touchUpInside)
        return result
    }()
    
    @objc func handleScreenShot() {
        lcDelegate?.clickScreenShot()
    }
    
    @objc func handleRecord() {
        recordBtn.isSelected.toggle()
        lcDelegate?.clickRecord(isOn: recordBtn.isSelected)
    }
    @objc func handleSpeed() {
        if speed >= maxSpeed {
            speed = 1
        } else {
            speed = speed * 2
        }
        let speedString = String(format: "video_%dx", Int(speed))
        speedBtn .setImage(UIImage.init(named: speedString), for: .normal)
        lcDelegate?.clickSpeed(value: speed)
    }
    func resetSpeed() {
        speed = 1
        let speedString = String(format: "video_%dx", Int(speed))
        speedBtn.setImage(UIImage.init(named: speedString), for: .normal)
        lcDelegate?.clickSpeed(value: speed)
    }
}
