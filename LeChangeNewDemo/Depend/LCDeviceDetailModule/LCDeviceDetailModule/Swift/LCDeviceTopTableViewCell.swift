//
//  LCDeviceTopTableViewCell.swift
//  LeChangeDemo
//
//  Created by yyg on 2022/9/19.
//  Copyright © 2022 Imou. All rights reserved.
//

import UIKit
import SnapKit

@objcMembers class LCDeviceTopTableViewCell: UITableViewCell, UITableViewCellProtocol {
    public func updateCellModel(model: LCTableViewCellModelProtocol?) {
        self.model = model as? LCDeviceTopTableViewCellModel
    }
    
    private var model: LCDeviceTopTableViewCellModel? {
        didSet {
            self.arrow.isHidden = model?.showArrow ?? false
            self.title.text = model?.title
            self.icon.image = model?.icon
        }
    }
    
    lazy var icon: UIImageView = {
        let imageView = UIImageView.init()
        imageView.backgroundColor = .red
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
        let imageView = UIImageView.init(image: UIImage.init(named: "icon_get_into"))
        return imageView
    }()
    
    private override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(self.icon)
        self.contentView.addSubview(self.title)
        self.contentView.addSubview(self.subImage)
        self.contentView.addSubview(self.arrow)
        
        self.setupLayout()
    }
    
    private func setupLayout() {
        self.icon.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.height.width.equalTo(60)
            make.centerY.equalToSuperview()
        }
        
        self.title.snp.makeConstraints { make in
            make.leading.equalTo(self.icon.snp.trailing).offset(5)
            make.top.equalToSuperview().offset(26)
        }
        
        self.subImage.snp.makeConstraints { make in
            make.leading.equalTo(self.title)
            make.top.equalTo(self.title.snp_bottomMargin).offset(8)
            make.centerY.equalToSuperview()
        }
        
        self.arrow.snp.makeConstraints { make in
            make.trailing.equalTo(-18)
            make.height.width.equalTo(21)
            make.centerY.equalToSuperview()
        }
    }
    
    deinit {
        
    }
}

class LCDeviceTopTableViewCellModel: LCTableViewCellModel {
    var subImage: UIImage?
    
    init(icon: UIImage? = nil, title: String? = nil, subTitle: String? = nil, subImage: UIImage? = nil, height: CGFloat, showArrow: Bool = false, showSeparatedLine: Bool = false) {
        super.init(icon: icon, title: title, subTitle: subTitle, height: height, showArrow: showArrow, showSeparatedLine: showSeparatedLine)
        
        self.reuseIdentifier = "LCDeviceTopTableViewCell"
        self.subImage = subImage
    }
}
