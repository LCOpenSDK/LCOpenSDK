//
//  LCMemoryManagementViewController.swift
//  LeChangeDemo
//
//  Created by WWB on 2022/9/22.
//  Copyright © 2022 Imou. All rights reserved.
//
//import
import LCNetworkModule
import UIKit
import SnapKit
import AVFoundation
import LCBaseModule

@objcMembers class LCMemoryManagementView: UIView {
    
    let statusImageView = UIImageView()
    let statusLabel = UILabel()
    var progressView = UIProgressView()
    let formatBtn = UIButton()
    let memoryLabel = UILabel()
    var total:Float = 0.00
    var used: Float = 0.00
    var totalFl:Float = 0.00
    var useableInt:Int = 0
    var totalSt:String = ""
    
    var formatAction: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(statusImageView)
        statusImageView.snp.makeConstraints{
            (make) in
            make.top.equalTo(self.snp.top).offset(98)
            make.centerX.equalTo(self)
            make.height.equalTo(160)
        }
        
        statusLabel.numberOfLines = 0
        statusLabel.lineBreakMode = NSLineBreakMode.byCharWrapping
        statusLabel.textAlignment = NSTextAlignment.center
        statusLabel.font = UIFont.init(name: "PingFang SC", size: 20)
        statusLabel.textColor = UIColor(red: 44.0/255.0, green: 44.0/255.0, blue: 44.0/255.0, alpha: 1.0)
        self.addSubview(statusLabel)
        statusLabel.snp.makeConstraints{
            (make) in
            make.top.equalTo(statusImageView.snp.bottom).offset(15)
            make.centerX.equalTo(statusImageView.snp.centerX)
          }
        
        progressView.layer.masksToBounds = true
        progressView.layer.cornerRadius = 7.5
        progressView.trackTintColor = UIColor(red: 246.0/255.0, green: 246.0/255.0, blue: 246.0/255.0, alpha: 1.0)
        progressView.progressTintColor = UIColor(red: 19.0/255.0, green: 198.0/255.0, blue: 154.0/255.0, alpha: 1.0)
        self.progressView.isHidden = true
        self.addSubview(progressView)
        progressView.snp.makeConstraints{
            (make) in
            make.top.equalTo(statusImageView.snp.bottom).offset(58)
            make.centerX.equalTo(statusImageView.snp.centerX)
            make.width.equalTo(270)
            make.height.equalTo(15)
        }
        
        memoryLabel.textColor = UIColor(red: 143.0/255.0, green: 143.0/255.0, blue: 143.0/255.0, alpha: 1.0)
        memoryLabel.font = UIFont.init(name: "PingFang SC", size: 14)
        memoryLabel.numberOfLines = 0
        memoryLabel.lineBreakMode = NSLineBreakMode.byCharWrapping
        self.addSubview(memoryLabel)
        memoryLabel.snp.makeConstraints{
            (make) in
            make.top.equalTo(statusImageView.snp.bottom).offset(83)
            make.leading.equalTo(progressView.snp.leading)
        }
        
        formatBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        formatBtn.setTitleColor(UIColor(red: 255.0/255.0, green: 79.0/255.0, blue: 79.0/255.0, alpha: 1.0), for: .normal)
        formatBtn.layer.borderWidth = 1
        formatBtn.layer.borderColor = UIColor(red: 255.0/255.0, green: 79.0/255.0, blue: 79.0/255.0, alpha: 1.0).cgColor
        formatBtn.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        formatBtn.layer.cornerRadius = 25
        formatBtn.setTitle("Alert_Title_Button_Formatting".lc_T, for:.normal)
        formatBtn.isHidden = true
        formatBtn.addTarget(self, action: #selector(self.formatBtnClick), for:UIControl.Event.touchUpInside)
        self.addSubview(formatBtn)
        formatBtn.snp.makeConstraints {
            (make) in
            make.bottom.equalTo(self.snp.bottom).offset(-64)
            make.width.equalTo(300)
            make.centerX.equalToSuperview()
            make.height.equalTo(45)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(result:String, dic:Dictionary<AnyHashable, Any>) {
        if result == "normal" { //"normal"
            statusImageView.image = UIImage.init(named:"normal")
            self.progressView.isHidden = false
            self.formatBtn.isHidden = false
            statusLabel.text = "storage_normal".lc_T
            //memorySize()
            self.total = Float(((dic[AnyHashable("totalBytes")] as? Double) ?? 0.0)/(1024.0*1024*1024))
            self.used = Float(((dic[AnyHashable("usedBytes")] as? Double) ?? 0.0)/(1024.0*1024*1024))
            let useable = total - used
            var useableSt:String = ""
            var usedSt:String = ""
            useableSt = String(format: "%.2f", useable)
            usedSt = String(format: "%.2f", used)
            totalSt = String(format: "%.2f", total)
            let totalInt = Int(total*100)
            totalFl = Float(totalInt)/100
            let usedInt = Int(used*100)
            let usedFL = Float(usedInt)/100
            self.progressView.isHidden = true
            progressView.progress = 0.0
            self.progressView.isHidden = false
            memoryLabel.text = "available_space".lc_T+useableSt+"has_been_used".lc_T+usedSt+"used_size".lc_T
            self.progressView.progress = usedFL/totalFl
        } else if result == "abnormal"  { //"abnormal"
            statusImageView.image = UIImage.init(named:"image")
            self.formatBtn.isHidden = false
            self.progressView.isHidden = true
            statusLabel.text = "storage_exception".lc_T
        } else if result == "formatting" { //"formatting"
            statusImageView.image = UIImage.init(named:"imageFormat")
            self.memoryLabel.isHidden = true
            self.formatBtn.isHidden = true
            statusLabel.text = "storage_format".lc_T
        }
    }
    
    func secondaryFormatting (result:String) {
        if result == "normal" { // "normal"    展示格式化成功的界面
            LCProgressHUD.showMsg("formatting_succeeded".lc_T)
            self.memoryLabel.isHidden = false
            self.formatBtn.isHidden = false
            self.progressView.isHidden = false
            statusImageView.image = UIImage.init(named:"normal")
            statusLabel.text = "storage_normal".lc_T
            self.memoryLabel.text = "available_space".lc_T+totalSt+"used_size_formatting".lc_T
            self.progressView.progress = 0.0
        } else if result == "abnormal" { // "abnormal"    在recoverSDCard方法中解析出abnormal，返回到这里展示内存卡损坏状态
            LCProgressHUD.showMsg("formatting_failed".lc_T)
            statusImageView.image = UIImage.init(named:"image")
            self.formatBtn.isHidden = false
            self.memoryLabel.isHidden = true
            statusLabel.text = "storage_exception".lc_T
        }
    }
    
    func inFormatting() {
        statusImageView.image = UIImage.init(named:"imageFormat")
        self.addSubview(statusImageView)
        memoryLabel.isHidden = true
        formatBtn.isHidden = true
        progressView.isHidden = true
        statusLabel.text = "storage_format".lc_T
    }
    
    func formatBtnClick() {
        if let action = self.formatAction {
            action()
        }
    }
}


