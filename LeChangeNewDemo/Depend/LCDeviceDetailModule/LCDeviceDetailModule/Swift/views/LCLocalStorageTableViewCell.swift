//
//  LCLocalStorageTableViewCell.swift
//  LeChangeDemo
//
//  Created by yyg on 2022/9/21.
//  Copyright © 2022 Imou. All rights reserved.
//

import UIKit
import SnapKit

@objcMembers class LCLocalStorageTableViewCell: UITableViewCell, UITableViewCellProtocol {
    public func updateCellModel(model: LCTableViewCellModelProtocol?) {
        self.model = model as? LCLocalStorageTableViewCellModel
    }
    
    private var model: LCLocalStorageTableViewCellModel? {
        didSet {
            self.line.isHidden = model?.showSeparatedLine == true ? false : true
            self.arrow.isHidden = model?.showArrow == true ? false : true
            self.title.text = model?.title
            self.subTitle.text = model?.subTitle
            self.icon.image = model?.icon
            
            let used = Float(model?.useByte ?? 0)
            let total = Float(model?.totalByte ?? 0)
            self.progressView.progress = total > 0.0 ? (used / total) : 0.0
            let totalM = total / (1024*1024*1024)
            let usedM = used / (1024*1024*1024)
            let totalMSt:String = String(format: "%.2f", totalM)
            let usedMSt:String = String(format: "%.2f", usedM)
            if totalM > 0 {
                self.progressDescribe.text = "\(usedMSt)G/\(totalMSt)G"
            } else {
                self.progressDescribe.text = ""
            }
            //存储卡状态，empty：无SD卡，normal：正常，abnormal：异常，recovering：格式化中
            if model?.status == "empty" {
                self.subTitle.text = "no_SD_card".lc_T
                self.subDescribe.text = ""
                self.subDescribe.textColor = UIColor.init(red: 143.0/255.0, green: 143.0/255.0, blue: 143.0/255.0, alpha: 1)
                self.model?.canUsing = false
            } else if model?.status == "normal" {
                self.subTitle.text = "SD_card".lc_T
                self.subDescribe.text = "local_storage_normal".lc_T
                self.subDescribe.textColor = UIColor.init(red: 143.0/255.0, green: 143.0/255.0, blue: 143.0/255.0, alpha: 1)
                self.model?.canUsing = true
            } else if model?.status == "abnormal" {
                self.subTitle.text = "SD_card".lc_T
                self.subDescribe.text = "local_storage_abnormal".lc_T
                self.subDescribe.textColor = UIColor.init(red: 255.0/255.0, green: 79.0/255.0, blue: 79.0/255.0, alpha: 1)
                self.model?.canUsing = true
            } else if model?.status == "recovering" {
                self.subTitle.text = "SD_card".lc_T
                self.subDescribe.text = "local_storage_formatting".lc_T
                self.subDescribe.textColor = UIColor.init(red: 143.0/255.0, green: 143.0/255.0, blue: 143.0/255.0, alpha: 1)
                self.model?.canUsing = true
            }
            
            if model?.canUsing == false {
                self.addSubview(self.contentMaskView)
                self.contentMaskView.snp.makeConstraints { make in
                    make.edges.equalTo(self)
                }
            } else {
                self.contentMaskView.removeFromSuperview()
            }
        }
    }
    
    lazy var icon: UIImageView = {
        let imageView = UIImageView.init()
        return imageView
    }()
    
    lazy var title: UILabel = {
        let label = UILabel.init()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.init(red: 44.0/255.0, green: 44.0/255.0, blue: 44.0/255.0, alpha: 1)
        return label
    }()
    
    lazy var subTitle: UILabel = {
        let label = UILabel.init()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.init(red: 143.0/255.0, green: 143.0/255.0, blue: 143.0/255.0, alpha: 1)
        return label
    }()
    
    lazy var subDescribe: UILabel = {
        let label = UILabel.init()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.init(red: 143.0/255.0, green: 143.0/255.0, blue: 143.0/255.0, alpha: 1)
        return label
    }()
    
    lazy var progressView: UIProgressView = {
        let progress = UIProgressView.init(progressViewStyle: .default)
        progress.tintColor = UIColor(red: 19.0/255.0, green: 198.0/255.0, blue: 154.0/255.0, alpha: 1)
        progress.trackTintColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1)
        progress.layer.cornerRadius = 4.0
        progress.layer.masksToBounds = true
        return progress
    }()
    
    lazy var progressDescribe: UILabel = {
        let label = UILabel.init()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .left
        label.textColor = UIColor.init(red: 44.0/255.0, green: 44.0/255.0, blue: 44.0/255.0, alpha: 1)
        return label
    }()

    lazy var arrow: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.lc_IMAGENAMED("common_btn_next", withBundleName: "LCDeviceDetailModuleBundle"))
        return imageView
    }()
    
    lazy var line: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1)
        return view
    }()
    
    lazy var contentMaskView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.6)
        return view
    }()
    
    private override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.contentView.addSubview(self.icon)
        self.contentView.addSubview(self.title)
        self.contentView.addSubview(self.subTitle)
        self.contentView.addSubview(self.arrow)
        self.contentView.addSubview(self.subDescribe)
        self.contentView.addSubview(self.progressView)
        self.contentView.addSubview(self.progressDescribe)
        self.addSubview(self.line)
        self.setupLayout()
    }
    
    private func setupLayout() {
        self.icon.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.top.equalToSuperview().offset(26)
            make.height.width.equalTo(28)
        }
        
        self.title.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(29)
            make.leading.equalTo(self.icon.snp.trailing).offset(10)
        }
        
        self.subTitle.snp.makeConstraints { make in
            make.leading.equalTo(self.icon.snp.trailing).offset(10)
            make.top.equalTo(self.title.snp.bottom).offset(12)
        }
        
        self.arrow.snp.makeConstraints { make in
            make.trailing.equalTo(-18)
            make.width.height.equalTo(13)
            make.top.equalTo(self.subTitle)
        }
        
        self.subDescribe.snp.makeConstraints { make in
            make.trailing.equalTo(self.arrow.snp.leading).offset(-12)
            make.top.equalTo(self.subTitle)
        }
        
        self.progressView.snp.makeConstraints { make in
            make.top.equalTo(self.subTitle.snp.bottom).offset(10)
            make.leading.equalTo(self.subTitle.snp.leading)
            make.height.equalTo(8)
            make.width.equalTo(159)
        }
        
        self.progressDescribe.snp.makeConstraints { make in
            make.trailing.equalTo(self.subDescribe)
            make.centerY.equalTo(self.progressView)
        }
        
        self.line.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.leading.equalTo(58)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-0.5)
        }
    }

    deinit {
        
    }
}

class LCLocalStorageTableViewCellModel: LCTableViewCellModel{
    var totalByte: Int64 = 0
    var useByte: Int64 = 0
    var status: String = "empty"
    
    init(icon: UIImage? = nil, title: String? = nil, subTitle: String? = nil, height: CGFloat, showArrow: Bool = false, showSeparatedLine: Bool = false, totalByte: Int64 = 0, useByte: Int64 = 0, status: String = "empty", canUsing: Bool = true, action: (()->())?) {
        super.init(icon: icon, title: title, subTitle: subTitle, height: height, showArrow: showArrow, showSeparatedLine: showSeparatedLine)
        self.status = status
        self.totalByte = totalByte
        self.useByte = useByte
        self.reuseIdentifier = "LCLocalStorageTableViewCell"
        self.selectAction = action
        
    }
}
