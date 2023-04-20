//
//  LCIotWiFiUnSupportView.swift
//  LCAddDeviceModule
//
//  Created by 吕同生 on 2022/10/17.
//  Copyright © 2022 Imou. All rights reserved.
//

import UIKit
import LCBaseModule

@objc public class LCIotWiFiUnSupportView: UIView {
    
    
    public var contentStr:String = ""
    
    lazy var grayBgView:UIView = {
        let aview = UIView()
        aview.backgroundColor = .lccolor_c51()
        return aview
    }()
    
    lazy var whitBgView:UIView = {
        let aview = UIView()
        aview.backgroundColor = .lccolor_c43()
        aview.layer.cornerRadius = 15
        aview.layer.masksToBounds = true
        return aview
    }()
    
    lazy var konwButton:UIButton = {
        let button = UIButton.init(type: .custom)
        let title = "common_i_know".lc_T()
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor.lccolor_c10()
        button.layer.cornerRadius = 22.5
        button.addTarget(self, action: #selector(konwButtonClick(btn:)), for: .touchUpInside)
        return button
    }()
    
    lazy var titleLable:UILabel = {
        let alabel = UILabel()
        alabel.text = "add_device_connect_2_4g_wifi".lc_T()
        alabel.font = UIFont.lcFont_t1Bold()
        alabel.textColor = .lccolor_c40()
        alabel.textAlignment = .left
        alabel.numberOfLines = 0
        return alabel
    }()
    
    lazy var contentLabelOne:UILabel = {
        let alabel = UILabel()
        alabel.numberOfLines = 0
        let content = "add_device_connect_2_4g_wifi_explain".lc_T()
        alabel.lc_setAttributedText(text: content, font: UIFont.lcFont_t3(), color: UIColor.lccolor_c40(), lineSpace: 5, alignment: .left)
        return alabel
    }()
    
//    lazy var contentLabelTwo:UILabel = {
//        let alabel = UILabel()
//        alabel.numberOfLines = 0
//        let content = "add_device_connect_2_4g_wifi_tips_2".lc_T()
//        alabel.lc_setAttributedText(text: content, font: UIFont.lcFont_t3(), color: UIColor.lccolor_c40(), lineSpace: 5, alignment: .left)
//        return alabel
//    }()
//
//    lazy var phoneNumberTip:UILabel = {
//        let label = UILabel()
//        var titlePre = "add_device_support_email".lc_T()
//        var title = String(format: titlePre + "service.global@imoulife.com")
//
//        if LCModuleConfig.shareInstance().isLeChange {
//            title = String(format: titlePre + "400-672-8169")
//        }
//        let attText: NSMutableAttributedString = NSMutableAttributedString(string: title)
//        attText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.lccolor_c40(), range: NSRange(location: 0, length: titlePre.lc_length))
//        attText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.lccolor_c10(), range: NSRange(location: titlePre.lc_length, length: title.lc_length - titlePre.lc_length))
//        label.attributedText = attText
//        return label
//    }()
    

    public init() {
        super.init(frame: UIScreen.main.bounds)
        self.setupUI()
    }
    
    func setupUI() {
        
        self.addSubview(grayBgView)
        self.addSubview(whitBgView)
       
       
        grayBgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let contentViewH = (iot_screenHeight*2)/3
        
        whitBgView.snp.makeConstraints { (make) in
            make.leading.equalTo(12)
            make.trailing.equalTo(-12)
            make.bottom.equalTo(-25)
            make.height.equalTo(contentViewH)
        }
        
        whitBgView.addSubview(titleLable)
        whitBgView.addSubview(contentLabelOne)
//        whitBgView.addSubview(contentLabelTwo)
//        whitBgView.addSubview(phoneNumberTip)
        whitBgView.addSubview(konwButton)
        
        titleLable.snp.makeConstraints { (make) in
            make.leading.equalTo(25)
            make.trailing.equalTo(-25)
            make.top.equalTo(whitBgView.snp.top).offset(20)
        }
        
        contentLabelOne.snp.makeConstraints { (make) in
            make.leading.equalTo(25)
            make.trailing.equalTo(-25)
            make.top.equalTo(titleLable.snp.bottom).offset(20)
        }
        
//        contentLabelTwo.snp.makeConstraints { (make) in
//            make.leading.equalTo(25)
//            make.trailing.equalTo(-25)
//            make.top.equalTo(contentLabelOne.snp.bottom).offset(15)
//        }
        
//        phoneNumberTip.snp.makeConstraints { make in
//            make.leading.equalTo(25)
//            make.top.equalTo(contentLabelTwo.snp_bottom).offset(20)
//            make.height.equalTo(20)
//        }
        
        konwButton.snp.makeConstraints { (make) in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.bottom.equalTo(whitBgView.snp.bottom).offset(-35)
            make.height.equalTo(45)
        }
        
        self.layoutIfNeeded()
        //用支持view 的底部 进行计算
        let frame: CGRect = contentLabelOne.frame
        let contentViewHNew = frame.maxY + lc_scaleSize(100)
        whitBgView.snp.remakeConstraints { (make) in
            make.leading.equalTo(12)
            make.trailing.equalTo(-12)
            make.bottom.equalTo(-25)
            make.height.equalTo(contentViewHNew)
        }
    }
    
    @objc func konwButtonClick(btn:UIButton){
        self.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var iot_screenHeight: CGFloat {
        return max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
    }
}

extension LCIotWiFiUnSupportView {
    public func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
    }
}

