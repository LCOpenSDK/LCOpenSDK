//
//  LCBluetoothPermissionSheetView.swift
//  LCAddDeviceModule
//
//  Created on 2026/1/22.
//  Copyright © 2026 Imou. All rights reserved.
//

import UIKit
import LCBaseModule
import SnapKit

class LCBluetoothPermissionSheetView: UIView {
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lc_color(withHexString: "#000000").withAlphaComponent(0.5)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "add_device_bluetooth_sheet_title".lc_T
        label.textColor = UIColor.lccolor_c2()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "common_popover_cancel"), for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var permissionSection: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var permissionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "add_device_bluetooth_sheet_permission_title".lc_T
        label.textColor = UIColor.lccolor_c2()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var permissionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "add_pic_bluetoothguide01")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var setupButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("add_device_bluetooth_sheet_setup".lc_T, for: .normal)
        button.setTitleColor(UIColor.lc_color(withHexString: "#F18D00"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(setupButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.isHidden = true
        return button
    }()
    
    private lazy var finishedLabel: UILabel = {
        let label = UILabel()
        label.text = "add_device_bluetooth_sheet_finished".lc_T
        label.textColor = UIColor.lc_color(withHexString: "#F18D00")
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()
    
    private lazy var bluetoothSection: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var bluetoothTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "add_device_bluetooth_sheet_bluetooth_title".lc_T
        label.textColor = UIColor.lccolor_c2()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var bluetoothImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "add_pic_bluetoothguide02")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var hasPermission: Bool = false {
        didSet {
            updatePermissionUI()
        }
    }
    
    var isBluetoothPoweredOn: Bool = false {
        didSet {
            updatePermissionUI()
        }
    }
    
    var setupAction: (() -> Void)?
    var dismissAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(backgroundView)
        addSubview(contentView)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(13)
            make.trailing.equalToSuperview().offset(-13)
            make.bottom.equalToSuperview().offset(-LC_bottomSafeMargin)
            make.height.equalTo(341) // 266 + 75
        }
        
        // 标题栏
        contentView.addSubview(titleLabel)
        contentView.addSubview(closeButton)
        
        closeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(closeButton.snp.bottom).offset(10)
        }
        
        // 权限部分
        contentView.addSubview(permissionSection)
        permissionSection.addSubview(permissionTitleLabel)
        permissionSection.addSubview(permissionImageView)
        permissionSection.addSubview(finishedLabel)
        permissionSection.addSubview(setupButton) // 最后添加按钮，确保在最上层
        
        permissionSection.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
        }
        
        // 权限标题和按钮/文字在左侧，图片在右侧
        permissionTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(13)
            make.top.equalToSuperview()
            make.trailing.equalTo(permissionImageView.snp.leading).offset(-16)
        }
        
        setupButton.snp.makeConstraints { make in
            make.leading.equalTo(permissionTitleLabel)
            make.top.equalTo(permissionTitleLabel.snp.bottom).offset(12)
            make.trailing.equalTo(permissionTitleLabel)
            make.height.greaterThanOrEqualTo(30) // 确保按钮有足够的高度可点击
        }
        
        finishedLabel.snp.makeConstraints { make in
            make.leading.equalTo(permissionTitleLabel)
            make.top.equalTo(permissionTitleLabel.snp.bottom).offset(12)
            make.trailing.equalTo(permissionTitleLabel)
        }
        
        permissionImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-13)
            make.top.equalToSuperview()
            make.width.equalTo(140)
            make.height.equalTo(100)
        }
        
        // 确保section底部由文字和按钮决定，图片不强制底部对齐
        setupButton.snp.makeConstraints { make in
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        finishedLabel.snp.makeConstraints { make in
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        // 蓝牙部分
        contentView.addSubview(bluetoothSection)
        bluetoothSection.addSubview(bluetoothTitleLabel)
        bluetoothSection.addSubview(bluetoothImageView)
        
        bluetoothSection.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(permissionSection.snp.bottom).offset(24)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        // 蓝牙标题在左侧，图片在右侧
        bluetoothTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(13)
            make.top.equalToSuperview()
            make.trailing.equalTo(bluetoothImageView.snp.leading).offset(-16).priority(.high)
        }
        
        bluetoothImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-13)
            make.top.equalToSuperview()
            make.width.equalTo(140)
            make.height.equalTo(100)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    private func updatePermissionUI() {
        // 与toastView展示逻辑一致：
        // - 未开启蓝牙权限（!hasPermission）：显示setupButton
        // - 未打开蓝牙开关（!isBluetoothPoweredOn）：显示setupButton
        // - 只有蓝牙权限已开启且蓝牙开关已打开时，才显示finishedLabel
        if hasPermission && isBluetoothPoweredOn {
            setupButton.isHidden = true
            finishedLabel.isHidden = false
        } else {
            setupButton.isHidden = false
            finishedLabel.isHidden = true
        }
    }
    
    @objc private func backgroundTapped() {
        dismiss()
    }
    
    @objc private func closeButtonTapped() {
        dismiss()
    }
    
    @objc private func setupButtonTapped() {
        setupAction?()
    }
    
    func show(in view: UIView) {
        view.addSubview(self)
        snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 先布局，获取正确的frame
        layoutIfNeeded()
        
        // 动画显示
        backgroundView.alpha = 0
        let contentHeight = contentView.frame.height > 0 ? contentView.frame.height : 400
        contentView.transform = CGAffineTransform(translationX: 0, y: contentHeight)
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 1
            self.contentView.transform = .identity
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = 0
            self.contentView.transform = CGAffineTransform(translationX: 0, y: self.contentView.frame.height)
        }) { _ in
            self.removeFromSuperview()
            self.dismissAction?()
        }
    }
}
