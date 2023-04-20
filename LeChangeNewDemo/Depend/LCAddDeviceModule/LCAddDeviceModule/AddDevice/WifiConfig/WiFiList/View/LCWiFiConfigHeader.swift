//
//  Copyright © 2020 Imou. All rights reserved.
//

import UIKit
import SnapKit

enum LCWiFiConfigHeaderClickType {
    case fiveGDesc
    case wifiDesc
}

protocol LCWiFiConfigHeaderDelegate: class {
    func iconDidClicked(type: LCWiFiConfigHeaderClickType)
}

class LCWiFiConfigHeader: UITableViewHeaderFooterView {
    
    weak var delegate: LCWiFiConfigHeaderDelegate?
    
    public var isAddNetwordTitle: Bool = true {
        didSet {
            descButton.setImage(isAddNetwordTitle ? UIImage(lc_named: "adddevice_icon_help") :  UIImage(lc_named: ""), for: .normal)
            descButton.setTitle(isAddNetwordTitle ? "device_manager_select_wifi".lc_T() : "device_manager_connected_wifi".lc_T(), for: .normal)
//            widthConstraint?.update(offset: isAddNetwordTitle ? 130 : 100)
            if isAddNetwordTitle {
                descButton.addTarget(self, action: #selector(wifiHelpClicked), for: .touchUpInside)
                descButton.setUIButtonImageRightWithTitleLeftUI()
            }
        }
    }
    // MARK: - life cycle
   
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        loadSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private method
    
    private func loadSubviews() {
        addSubview(titleImageView)
        titleImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(topPadding25)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self).offset(-padding3)
            make.top.equalTo(titleImageView.snp.bottom).offset(topPadding14)
        }
        
        addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right)
            make.centerY.equalTo(titleLabel)
        }
        
        addSubview(descButton)
        descButton.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(padding14)
//            widthConstraint = make.width.equalTo(100).constraint
            make.bottom.equalTo(self).offset(-bottompPadding5)
        }
    }
    
    @objc func iconDidClicked() {
        delegate?.iconDidClicked(type: .fiveGDesc)
    }
    
    @objc func wifiHelpClicked() {
        delegate?.iconDidClicked(type: .wifiDesc)
    }
    
    // MARK: - lazy ui
    
    // todo: no picture
    
    lazy var titleImageView: UIImageView = {
        let titleImageView = UIImageView()
        titleImageView.image = UIImage(lc_named: "adddevice_icon_wifipassword")
        
        return titleImageView
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.lcFont_t5()
//        titleLabel.textColor = UIColor.lccolor_c8()
        titleLabel.text = "add_device_device_not_support_5g".lc_T()
        
        return titleLabel
    }()
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(lc_named: "adddevice_icon_help")
        let tap = UITapGestureRecognizer(target: self, action: #selector(iconDidClicked))
        iconImageView.addGestureRecognizer(tap)
        iconImageView.isUserInteractionEnabled = true
        
        return iconImageView
    }()
    
    lazy var descButton: UIButton = {
        let descButton = UIButton()
        descButton.titleLabel?.textAlignment = .left
        descButton.setTitleColor(UIColor.black, for: .normal)
        descButton.titleLabel?.font = UIFont.lcFont_t5()
        descButton.setTitle("device_manager_connected_wifi".lc_T(), for: .normal)
        return descButton
    }()
    
    private let topPadding25: CGFloat = 25.0
    private let topPadding14: CGFloat = 14.0
    private let padding14: CGFloat = 14.0
    private let bottompPadding5: CGFloat = 5.0
    private let padding3: CGFloat = 3.0
    
    private var widthConstraint: Constraint?
}
