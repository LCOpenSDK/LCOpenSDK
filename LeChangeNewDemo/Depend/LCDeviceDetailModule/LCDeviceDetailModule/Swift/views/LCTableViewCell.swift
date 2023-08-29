//
//  LCTableViewCell.swift
//  LeChangeDemo
//
//  Created by yyg on 2022/9/19.
//  Copyright © 2022 Imou. All rights reserved.
//

import UIKit
import SnapKit

public protocol UITableViewCellProtocol {
    func updateCellModel(model: LCTableViewCellModelProtocol?)
}

public class LCTableViewCell: UITableViewCell, UITableViewCellProtocol {
    public func updateCellModel(model: LCTableViewCellModelProtocol?) {
        self.model = model as? LCTableViewCellModel
    }
    
    private var model: LCTableViewCellModel? {
        didSet {
            self.line.isHidden = self.model?.showSeparatedLine == true ? false : true
            self.arrow.isHidden = self.model?.showArrow == true ? false : true
            self.title.text = self.model?.title
            self.subTitle.text = self.model?.subTitle
            self.icon.image = self.model?.icon
            if self.arrow.isHidden {
                self.subTitle.snp.remakeConstraints { make in
                    make.height.equalTo(45)
                    make.trailing.equalToSuperview().offset(-18)
                    make.centerY.equalToSuperview()
                    make.width.lessThanOrEqualTo(180)
                }
            } else {
                self.subTitle.snp.remakeConstraints { make in
                    make.height.equalTo(45)
                    make.trailing.equalTo(self.arrow.snp.leading).offset(-12)
                    make.centerY.equalToSuperview()
                    make.width.lessThanOrEqualTo(180)
                }
            }
            
            if model?.icon == nil {
                self.title.snp.remakeConstraints { make in
                    make.trailing.equalTo(self.subTitle.snp.leading).offset(-12)
                    make.leading.equalTo(25)
                    make.centerY.equalToSuperview()
                }
            } else {
                self.title.snp.remakeConstraints { make in
                    make.trailing.equalTo(self.subTitle.snp.leading).offset(-12)
                    make.leading.equalTo(self.icon.snp.trailing).offset(12)
                    make.centerY.equalToSuperview()
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

    lazy var icon: UIImageView = {  //图标
        let imageView = UIImageView.init()
        return imageView
    }()
    
    lazy var title: UILabel = {  //标题
        let label = UILabel.init()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.init(red: 44.0/255.0, green: 44.0/255.0, blue: 44.0/255.0, alpha: 1)
        return label
    }()
    
    lazy var subTitle: UILabel = {   //小标题
        let label = UILabel.init()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.init(red: 143.0/255.0, green: 143.0/255.0, blue: 143.0/255.0, alpha: 1)
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()

    lazy var arrow: UIImageView = {  //箭头
        let imageView = UIImageView.init(image: UIImage.lc_IMAGENAMED("common_btn_next", withBundleName: "LCDeviceDetailModuleBundle"))
        return imageView
    }()
    
    lazy var  line: UIView = {   //线
        let view = UIView.init()
        view.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1)
        view.isHidden = true
        return view
    }()
    
    lazy var contentMaskView: UIView = {  //内容掩码
        let view = UIView.init()
        view.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.6)
        return view
    }()
    
    private override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {  //
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.contentView.addSubview(self.icon)
        self.contentView.addSubview(self.title)
        self.contentView.addSubview(self.subTitle)
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
        
        self.subTitle.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.trailing.equalTo(self.arrow.snp.leading).offset(-12)
            make.centerY.equalToSuperview()
            make.width.lessThanOrEqualTo(180)
        }
        
        self.title.snp.makeConstraints { make in
            make.trailing.equalTo(self.subTitle.snp.leading).offset(-12)
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

public protocol LCTableViewCellModelProtocol {
    var icon: UIImage? { get set }
    var title: String? { get set }
    var subTitle: String?  { get set }
    var showArrow: Bool { get set }
    var showSeparatedLine: Bool { get set }
    var canUsing: Bool { get set }
    var height: CGFloat { get set }
    var selectAction: (() -> Void)? { get set }
    var reuseIdentifier: String { get set }
}

public class LCTableViewCellModel: LCTableViewCellModelProtocol {
    public var icon: UIImage?
    public var title: String?
    public var subTitle: String?
    public var showArrow: Bool = false
    public var showSeparatedLine: Bool = false
    public var canUsing: Bool = true
    public var height: CGFloat = 70.0
    public var selectAction: (() -> Void)?
    public var reuseIdentifier: String = "LCTableViewCell"
    
    init(icon: UIImage? = nil, title: String? = nil, subTitle: String? = nil, height: CGFloat, showArrow: Bool = false, showSeparatedLine: Bool = false, canusing: Bool = true, selectAction:(() -> Void)? = nil) {
        self.icon = icon
        self.title = title
        self.subTitle = subTitle
        self.showArrow = showArrow
        self.showSeparatedLine = showSeparatedLine
        self.height = height
        self.selectAction = selectAction
        self.canUsing = canusing
    }
    
    deinit {
        
    }
}
