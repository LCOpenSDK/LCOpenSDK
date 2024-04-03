//
//  LCBottomControlView.swift
//  LCIphoneAdhocIP
//
//  Created by imou on 2024/3/16.
//  Copyright © 2024 imou. All rights reserved.
//

import UIKit
import SnapKit

@objc public enum CallType: Int {
    case VideoCall //视频呼叫
    case AudioCall //语音呼叫
}

public class LCBottomControlView: UIView {
    
    
    var clickBlock: ((_ callType: CallType) -> ())?
    public init() {
        super.init(frame: .zero)
        setUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.addSubview(bgView)
        self.addSubview(contentView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.bottom.equalToSuperview().offset(-25)
            make.leading.equalToSuperview().offset(12.5)
            make.trailing.equalToSuperview().offset(-12.5)
        }
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        contentView.addSubview(videoCallBtn)
        contentView.addSubview(audioCallBtn)
        contentView.addSubview(bottomLineView)
        contentView.addSubview(cancelBtn)
        
        videoCallBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.leading.equalToSuperview().offset(70)
            make.width.equalTo(50)
            make.height.equalTo(70)
        }
        audioCallBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-70)
            make.width.equalTo(50)
            make.height.equalTo(70)
        }
        bottomLineView.snp.makeConstraints { make in
            make.top.equalTo(audioCallBtn.snp.bottom).offset(20)
            make.height.equalTo(8)
            make.leading.trailing.equalToSuperview()
        }
        cancelBtn.snp.makeConstraints { make in
            make.top.equalTo(bottomLineView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    @objc public func show(on superView: UIView, clickBlock: @escaping (_ callType: CallType) -> ()) {
        self.clickBlock = clickBlock
        superView.addSubview(self)
        self.frame = superView.bounds
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        UIView.animate(withDuration: 0.3) {
            self.contentView.alpha = 1.0
        }
    }
    fileprivate lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .lc_color(withHexString: "#7F000000")
        view.alpha = 1
        
        return view
    }()
    
    fileprivate lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    fileprivate lazy var videoCallBtn: UIView = {
        let view = UIView()
        let button = UIButton()
        button.setImage(UIImage.init(named: "live_video_icon_videocall"), for: .normal)
        
        let label = UILabel()
        label.text = "视频通话"
        label.font = .systemFont(ofSize: 11)
        label.textColor = .lc_color(withHexString: "#2C2C2C")
        
        view.addSubview(button)
        view.addSubview(label)
        
        button.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        button.addTarget(self, action: #selector(videoCallBtnClick), for: .touchUpInside)
        label.snp.makeConstraints { make in
            make.centerX.equalTo(button.snp.centerX)
            make.top.equalTo(button.snp.bottom).offset(5)
        }
        
        return view
    }()
    
    fileprivate lazy var audioCallBtn: UIView = {
        let view = UIView()
        let button = UIButton()
        button.setImage(UIImage.init(named: "live_video_icon_audiocall"), for: .normal)
        
        let label = UILabel()
        label.text = "语音通话"
        label.font = .systemFont(ofSize: 11)
        label.textColor = .lc_color(withHexString: "#2C2C2C")
        
        view.addSubview(button)
        view.addSubview(label)
        
        button.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        button.addTarget(self, action: #selector(audioCallBtnClick), for: .touchUpInside)
        label.snp.makeConstraints { make in
            make.centerX.equalTo(button.snp.centerX)
            make.top.equalTo(button.snp.bottom).offset(5)
        }
        return view
    }()
    
    fileprivate lazy var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lc_color(withHexString: "#EFEFEF")
        return view
    }()
    
    fileprivate lazy var cancelBtn: UIButton = {
        let button = UIButton()
        button.setTitle("取消", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitleColor(.lc_color(withHexString: "#2C2C2C"), for: .normal)
        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.alpha = 0.0
        }) { (isCompleted) in
            self.alpha = 1.0
            self.lc_removeAllSubview()
            self.removeFromSuperview()
        }
    }
    
    @objc private func videoCallBtnClick() {
        if let clickBlock = clickBlock {
            clickBlock(CallType.VideoCall)
        }
        self.dismiss()
    }
    
    @objc private func audioCallBtnClick() {
        if let clickBlock = clickBlock {
            clickBlock(CallType.AudioCall)
        }
        self.dismiss()
    }
}
