//
//  LCBluetoothToastView.swift
//  LCAddDeviceModule
//
//  Created on 2026/1/22.
//  Copyright © 2026 Imou. All rights reserved.
//

import UIKit
import LCBaseModule
import SnapKit

class LCBluetoothToastView: UIView {
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        // 使用蓝牙图标
        imageView.image = UIImage(named: "addevice_icon_bluetooth")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "add_device_bluetooth_toast_message".lc_T
        label.textColor = UIColor.lccolor_c2()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    var tapAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor.lc_color(withHexString: "#E3F2FD")
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        addSubview(iconImageView)
        addSubview(messageLabel)
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.top.greaterThanOrEqualToSuperview().offset(12)
            make.bottom.lessThanOrEqualToSuperview().offset(-12)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
        }
        
        // 添加点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toastTapped))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }
    
    @objc private func toastTapped() {
        tapAction?()
    }
    
    func show(in view: UIView, below viewBelow: UIView, offset: CGFloat = 20) {
        view.addSubview(self)
        snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(viewBelow.snp.bottom).offset(offset)
        }
    }
    
    func hide() {
        removeFromSuperview()
    }
}
