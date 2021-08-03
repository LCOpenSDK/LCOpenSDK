//
//  Copyright © 2020 dahua. All rights reserved.
//

import UIKit

protocol LCApWifiHeaderViewDelegate: class {
    func iconClicked(headView: LCApWifiHeaderView)
}

class LCApWifiHeaderView: UIView {
    
    weak var delegate: LCApWifiHeaderViewDelegate?
    
    // MARK: - life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private method
    
    private func loadSubviews() {
        backgroundColor = UIColor.dhcolor_c7()
        indicatorView.hidesWhenStopped = true
        
        addSubview(headerLabel)
        headerLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(16)
        }
        
        addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(headerLabel.snp.right).offset(2)
        }
        
        addSubview(indicatorView)
        indicatorView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(iconImageView.snp.right).offset(3)
        }
    }
    
    @objc func iconClicked() {
        delegate?.iconClicked(headView: self)
    }

    // MARK: - lazy ui
    
    lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.font = UIFont.dhFont_t2()
        headerLabel.textColor = UIColor.dhcolor_c2()
        headerLabel.text = "add_device_choose_wifi".lc_T
        
        return headerLabel
    }()
    
    lazy var iconImageView: UIImageView = {
        let iconImage = UIImageView()
        iconImage.image = UIImage(named: "adddevice_icon_help")
        iconImage.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(iconClicked))
        iconImage.addGestureRecognizer(tap)
        
        return iconImage
    }()
    
    lazy var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        
        return indicatorView
    }()
}
