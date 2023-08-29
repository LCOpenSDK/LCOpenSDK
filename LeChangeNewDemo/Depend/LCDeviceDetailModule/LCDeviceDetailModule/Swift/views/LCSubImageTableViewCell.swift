//
//  LCSubImageTableViewCell.swift
//  LeChangeDemo
//
//  Created by yyg on 2022/9/19.
//  Copyright © 2022 Imou. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

@objcMembers class LCSubImageTableViewCell: UITableViewCell, UITableViewCellProtocol {
    public func updateCellModel(model: LCTableViewCellModelProtocol?) {
        self.model = model as? LCSubImageTableViewCellModel
    }
    
    private var model: LCSubImageTableViewCellModel? {
        didSet {
            self.line.isHidden = self.model?.showSeparatedLine == true ? false : true
            self.arrow.isHidden = self.model?.showArrow == true ? false : true
            self.title.text = self.model?.title
            self.icon.image = self.model?.icon
            self.subImage.lc_setThumbImage(withURL:self.model?.subImageURL ?? "", placeholderImage: UIImage.init(named: "common_defaultcover_big") ?? UIImage(), deviceId: self.model?.deviceID ?? "", channelId: self.model?.channelID ?? "")
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
    
    lazy var subImage: UIImageView = {
        let imageView = UIImageView.init()
        return imageView
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
        self.contentView.addSubview(self.subImage)
        self.contentView.addSubview(self.arrow)
        self.addSubview(self.line)
        
        self.setupLayout()
    }
    
    private func setupLayout() {
        self.icon.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.height.width.equalTo(28)
            make.centerY.equalToSuperview()
        }
        
        self.arrow.snp.makeConstraints { make in
            make.trailing.equalTo(-18)
            make.width.height.equalTo(13)
            make.centerY.equalToSuperview()
        }
        
        self.subImage.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.width.equalTo(80)
            make.trailing.equalTo(self.arrow.snp.leading).offset(-12)
            make.centerY.equalToSuperview()
        }
        
        self.title.snp.makeConstraints { make in
            make.trailing.equalTo(self.subImage.snp.leading).offset(-12)
            make.leading.equalTo(self.icon.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
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

@objcMembers class LCSubImageTableViewCellModel: LCTableViewCellModel {
    var subImageURL: String?
    var deviceID: String?
    var channelID: String?
    
    init(icon: UIImage? = nil, title: String? = nil, subTitle: String? = nil, subImage: UIImage? = nil, subImageURL: String? = nil, height: CGFloat, showArrow: Bool = false, showSeparatedLine: Bool = false, deviceID: String? = nil, channelID: String? = nil, canUsing: Bool = true, selectAction: (() -> Void)? = nil) {
        super.init(icon: icon, title: title, subTitle: subTitle, height: height, showArrow: showArrow, showSeparatedLine: showSeparatedLine)
        
        self.reuseIdentifier = "LCSubImageTableViewCell"
        self.subImageURL = subImageURL
        self.deviceID = deviceID
        self.channelID = channelID
        self.selectAction = selectAction
        self.canUsing = canUsing
    }
}
