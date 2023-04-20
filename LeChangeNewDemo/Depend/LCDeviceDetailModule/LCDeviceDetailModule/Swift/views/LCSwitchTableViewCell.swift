//
//  LCSwitchTableViewCell.swift
//  LeChangeDemo
//
//  Created by yyg on 2022/9/19.
//  Copyright © 2022 Imou. All rights reserved.
//

import UIKit
import SnapKit
//import LCBaseModule

@objcMembers class LCSwitchTableViewCell: UITableViewCell, UITableViewCellProtocol {
    public func updateCellModel(model: LCTableViewCellModelProtocol?) {
        self.model = model as? LCSwitchTableViewCellModel
    }
    
    private var model: LCSwitchTableViewCellModel? {
        didSet {
            self.line.isHidden = model?.showSeparatedLine == true ? false : true
            self.title.text = model?.title
            self.icon.image = model?.icon
            self.switchBtn.isOn = model?.isOpen ?? false
            self.activityView.isHidden = model?.isLoading == true ? false : true
            self.switchBtn.isHidden = !self.activityView.isHidden
            self.subTitle.text = model?.subTitle
            
            var leading = 12
            if model?.icon == nil {
                leading = 25
                self.title.snp.remakeConstraints { make in
                    make.trailing.equalTo(self.switchBtn.snp.leading).offset(-12)
                    make.leading.equalTo(leading)
                    make.centerY.equalToSuperview()
                }
            } else {
                self.title.snp.remakeConstraints { make in
                    make.trailing.equalTo(self.switchBtn.snp.leading).offset(-12)
                    make.leading.equalTo(self.icon.snp.trailing).offset(leading)
                    make.centerY.equalToSuperview()
                }
            }
            
            if model?.subTitle == nil {
                self.title.snp.remakeConstraints { make in
                    if leading == 25 {
                        make.leading.equalTo(leading)
                    } else {
                        make.leading.equalTo(self.icon.snp.trailing).offset(leading)
                    }
                    make.trailing.equalTo(self.switchBtn.snp.leading).offset(-12)
                    make.centerY.equalToSuperview()
                }

                self.switchBtn.snp.remakeConstraints { make in
                    make.trailing.equalToSuperview().offset(-18)
                    make.width.equalTo(44)
                    make.height.equalTo(28)
                    make.centerY.equalTo(self.title)
                }
            } else {
                self.title.snp.remakeConstraints { make in
                    if leading == 25 {
                        make.leading.equalTo(leading)
                    } else {
                        make.leading.equalTo(self.icon.snp.trailing).offset(leading)
                    }
                    make.trailing.equalTo(self.switchBtn.snp.leading).offset(-12)
                    make.top.equalToSuperview().offset(15)
                }
                
                self.switchBtn.snp.remakeConstraints { make in
                    make.trailing.equalToSuperview().offset(-18)
                    make.width.equalTo(44)
                    make.height.equalTo(28)
                    make.centerY.equalTo(self.title).offset(-3)
                }
                
                self.subTitle.snp.makeConstraints { make in
                    make.trailing.equalToSuperview().offset(-18)
                    make.leading.equalTo(self.title)
                    make.top.equalTo(self.title.snp.bottom).offset(7)
                }
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
        label.font = UIFont.systemFont(ofSize: 11)
        label.numberOfLines = 0
        label.textColor = UIColor.init(red: 143.0/255.0, green: 143.0/255.0, blue: 143.0/255.0, alpha: 1)
        return label
    }()
    
    lazy var switchBtn: UISwitch = {
        let sw = UISwitch.init()
        sw.addTarget(self, action: #selector(switchOperated), for: .valueChanged)
        return sw
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
    
    lazy var activityView: LCActivityIndicatorView = {
        let activity = LCActivityIndicatorView()
        activity.startAnimating()
        return activity
        
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
        self.contentView.addSubview(self.switchBtn)
        self.contentView.addSubview(self.activityView)
        self.addSubview(self.line)
        
        self.setupLayout()
    }
    
    private func setupLayout() {
        self.icon.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.height.width.equalTo(28)
            make.centerY.equalToSuperview()
        }
        
        self.switchBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-18)
            make.centerY.equalToSuperview()
            make.width.equalTo(44)
            make.height.equalTo(28)
        }
        
        self.title.snp.makeConstraints { make in
            make.trailing.equalTo(self.switchBtn.snp.leading).offset(-12)
            make.leading.equalTo(self.icon.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
        
        self.subTitle.snp.makeConstraints { make in
            make.trailing.leading.equalTo(self.title)
            make.top.equalTo(self.title.snp.bottom).offset(7)
        }
        
        self.line.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.leading.equalTo(58)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-0.5)
        }
        
        self.activityView.snp.makeConstraints { make in
            make.centerY.equalTo(self.switchBtn)
            make.centerX.equalTo(self.switchBtn)
        }

    }
    
    @objc func switchOperated(s: UISwitch) {
        if let action = self.model?.switchAction {
            action(s.isOn)
        }
    }
    
    deinit {
        
    }
}

class LCSwitchTableViewCellModel: LCTableViewCellModel {
    var switchAction: ((_ isOn: Bool) -> ())?
    var isOpen: Bool = false
    var isLoading: Bool = true
    
    init(icon: UIImage? = nil, title: String? = nil, subTitle: String? = nil, height: CGFloat, showArrow: Bool = false, showSeparatedLine: Bool = false, isOpen: Bool = false, canUsing: Bool = true,  switchAction:((_ isOn: Bool) -> ())? = nil) {
        super.init(icon: icon, title: title, subTitle: subTitle, height: height, showArrow: showArrow, showSeparatedLine: showSeparatedLine)
        if let temp = subTitle {
            let height = temp.lc_height(font: UIFont.systemFont(ofSize: 11), width: UIScreen.main.bounds.width - 40)
            self.height = self.height - 14 + height
        }
        self.reuseIdentifier = "LCSwitchTableViewCell"
        self.isOpen = isOpen
        self.switchAction = switchAction
    }
}
