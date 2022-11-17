//
//  LCRouterResetView.swift
//  LCAddDeviceModule
//
//  Created by 吕同生 on 2022/10/19.
//  Copyright © 2022 Imou. All rights reserved.
//


import UIKit
import SnapKit

enum LCRouterResetType: Int {
    /// 连接到路由器wifi引导页 -- 找不到路由器wifi
    case guide
    
    /// 管理密码验证 -- 忘记密码
    case forgetPassword
}

/// 引导页头部示例图片
public class LCRouterResetView: UIView {

    var resetType: LCRouterResetType = .guide
    
    lazy var backView: UIView = {
        let backView = UIView()
        backView.backgroundColor = UIColor.white
        backView.layer.cornerRadius = 15
        backView.clipsToBounds = true
        return backView
    }()
    
    lazy var titleLab: UILabel = {
        let titleLab = UILabel()
        titleLab.lc_setAttributedText_Normal(text: NSLocalizedString("device_add_connect_reset", comment: ""), font: UIFont.lcFont_t1Bold(), color: UIColor.lccolor_c40(), lineSpace: 10)
        return titleLab
    }()
    
    lazy var resetImageView: UIImageView = {
        let resetImageView = UIImageView()
        resetImageView.image = UIImage.lc_img(withName: "luyouqi_img_help", file: "router", bundle: "LCDeviceAddModule", targetClass: Self.self)
        return resetImageView
    }()
    
    lazy var desLab: UILabel = {
        let desLab = UILabel()
        desLab.numberOfLines = 0
        desLab.lc_setAttributedText_Normal(text: NSLocalizedString("device_add_connect_reset_describe", comment: ""), font: UIFont.lcFont_t5(), color: UIColor.lccolor_c40(), lineSpace: 10)
        return desLab
    }()
    
    lazy var noteLab: UILabel = {
        let noteLab = UILabel()
        noteLab.numberOfLines = 0
        noteLab.lc_setAttributedText_Normal(text: NSLocalizedString("device_add_connect_reset_note", comment: ""), font: UIFont.lcFont_t6(), color: UIColor.lccolor_c30(), lineSpace: 10)
        return noteLab
    }()

    lazy var confirmButton: UIButton = {
        let nxetButton = UIButton()
        nxetButton.layer.cornerRadius = 5
        nxetButton.titleLabel?.font = UIFont.lcFont_t3()
        nxetButton.backgroundColor = UIColor.lccolor_c10()
        nxetButton.setTitleColor(UIColor.white, for: .normal)
        nxetButton.setTitle(NSLocalizedString("common_got_it", comment: ""), for: .normal)
        nxetButton.addTarget(self, action: #selector(confirmButtonClikced), for: .touchUpInside)
        return nxetButton
    }()
    
    init(resetType: LCRouterResetType) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        self.backgroundColor = UIColor.lccolor_c51()
        self.resetType = resetType
        setUpSubViews()
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI() {
        var title = NSLocalizedString("device_add_guide_reset", comment: "")
        var des = NSLocalizedString("device_add_guide_reset_reason", comment: "") + NSLocalizedString("device_add_reset_describe", comment: "")
        if self.resetType == .forgetPassword {
            title = NSLocalizedString("device_add_connect_reset", comment: "")
            des = NSLocalizedString("device_add_connect_reset_reason", comment: "") + NSLocalizedString("device_add_reset_describe", comment: "")
        }
        titleLab.lc_setAttributedText_Normal(text: title, font: UIFont.lcFont_t1Bold(), color: UIColor.lccolor_c40(), lineSpace: 10)
        desLab.lc_setAttributedText_Normal(text: des, font: UIFont.lcFont_t6(), color: UIColor.lccolor_c40(), lineSpace: 10)
    }
    
    func setUpSubViews() {
        self.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(180)
            make.leading.equalTo(self).offset(25)
            make.trailing.equalTo(self).offset(-25)
        }
        
        backView.addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(backView).offset(22)
            make.centerX.equalTo(backView)
            make.height.equalTo(26)
        }
        
        backView.addSubview(resetImageView)
        resetImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(backView).offset(15)
            make.trailing.equalTo(backView).offset(-15)
            make.top.equalTo(titleLab.snp.bottom).offset(15)
            make.height.equalTo(115 * (UIScreen.main.bounds.width - 50 - 30) / 295)
        }
        
        backView.addSubview(desLab)
        desLab.snp.makeConstraints { (make) in
            make.top.equalTo(resetImageView.snp.bottom).offset(22)
            make.leading.equalTo(backView).offset(20)
            make.trailing.equalTo(backView).offset(-20)
        }
        
        backView.addSubview(noteLab)
        noteLab.snp.makeConstraints { (make) in
            make.top.equalTo(desLab.snp.bottom).offset(10)
            make.leading.equalTo(backView).offset(20)
            make.trailing.equalTo(backView).offset(-20)
        }
        
        backView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { (make) in
            make.top.equalTo(noteLab.snp.bottom).offset(10)
            make.centerX.equalTo(backView)
            make.width.equalTo(118)
            make.height.equalTo(45)
            make.bottom.equalTo(backView).offset(-25)
        }
    }

    public func show() {
        let currentWindow = UIApplication.shared.keyWindow ?? UIWindow()
        currentWindow.addSubview(self)
        
        UIView.animate(withDuration: 0.25) {
            self.backView.snp.remakeConstraints { (make) in
                make.centerY.equalTo(self)
//                make.height.equalTo(460)
                make.centerX.equalTo(self)
                make.width.equalTo(self).offset(-50)
            }
            self.setNeedsLayout()
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.25) {
            self.backView.snp.remakeConstraints { (make) in
                make.top.equalTo(self.snp.bottom)
//                make.height.equalTo(460)
                make.centerX.equalTo(self)
                make.width.equalTo(self).offset(-50)
            }
            self.setNeedsLayout()

        } completion: { (success) in
            self.removeFromSuperview()
        }
    }
    
    @objc func confirmButtonClikced() {
        print("点击我知道了")
        self.hide()
    }
}

