//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	通用的错误页面，适用于图片、文字、按钮固定的场景

import UIKit
import LCBaseModule

protocol LCCommonErrorViewDelegate: NSObjectProtocol {
	
	/// 确定点击事件
	///
	/// - Parameters:
	///   - errorView: self
	func errorViewOnTryAgain(errorView: LCCommonErrorView)
	
	/// 退出点击事件
	///
	/// - Parameters:
	///   - errorView: self
	func errorViewOnQuit(errorView: LCCommonErrorView)
    
}

class LCCommonErrorView: UIView {
	public weak var delegate: LCCommonErrorViewDelegate?
    lazy var imageView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage(lc_named: "adddevice_netsetting_guide_safe"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.lcFont_t1Bold()
        label.numberOfLines = 0
        label.textColor = UIColor.lccolor_c40()
        label.textAlignment = .center
        label.text = "add_device_initialize_failed".lc_T()
        return label
    }()
    
    lazy var descTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.lcFont_t3()
        textView.textColor = UIColor.lccolor_c40()
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        return textView
    }()
    
    lazy var tryAgainButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.layer.cornerRadius = 22.5
        btn.layer.masksToBounds = true
        btn.backgroundColor = UIColor.lccolor_c0()
        btn.titleLabel?.font = UIFont.lcFont_t3Bold()
        btn.setTitle("add_device_cloud_try_again".lc_T(), for: .normal)
        btn.setTitleColor(UIColor.lccolor_c43(), for: .normal)
        btn.addTarget(self, action: #selector(onTryAgainAction(btn:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var quitButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.layer.cornerRadius = 22.5
        btn.layer.masksToBounds = true
        btn.layer.borderWidth = 1.0
        btn.layer.borderColor = UIColor.lccolor_c0().cgColor
        btn.backgroundColor = UIColor.lccolor_c43()
        btn.titleLabel?.font = UIFont.lcFont_t3Bold()
        btn.setTitle("add_device_cloud_quit".lc_T(), for: .normal)
        btn.setTitleColor(UIColor.lccolor_c0(), for: .normal)
        btn.addTarget(self, action: #selector(onQuitAction(btn:)), for: .touchUpInside)
        return btn
    }()
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.backgroundColor = UIColor.lccolor_c43()
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        self.addSubview(descTextView)
        self.addSubview(tryAgainButton)
        self.addSubview(quitButton)
        
        self.imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.top.equalToSuperview()
            make.height.lessThanOrEqualTo(224)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.top.equalTo(self.imageView.snp.bottom).offset(30)
        }
        
        self.quitButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(37.5)
            make.trailing.equalToSuperview().offset(-37.5)
            make.bottom.equalToSuperview().offset(-64)
            make.height.equalTo(45)
        }
        
        self.tryAgainButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(37.5)
            make.trailing.equalToSuperview().offset(-37.5)
            make.bottom.equalTo(self.quitButton.snp.top).offset(-20)
            make.height.equalTo(45)
        }
        
        self.descTextView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(30)
            make.bottom.equalTo(self.tryAgainButton.snp.top).offset(-30)
        }
    }

	@objc func onTryAgainAction(btn: UIButton) {
        delegate?.errorViewOnTryAgain(errorView: self)
	}
	
    @objc func onQuitAction(btn: Any) {
		delegate?.errorViewOnQuit(errorView: self)
	}

	public func dismiss(animated: Bool) {
//		if animated {
//			let animation = CATransition()
//			animation.duration = 0.3
//			animation.type = kCATransitionFade
//			animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//			self.superview?.layer.add(animation, forKey: kCATransitionFade)
//		}
		
		self.removeFromSuperview()
	}
	
	public func showOnView(superView: UIView, animated: Bool) {
//		if animated {
//			let animation = CATransition()
//			animation.duration = 0.3
//			animation.type = kCATransitionFade
//			animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//			superView.layer.add(animation, forKey: kCATransitionFade)
//		}
//
		superView.addSubview(self)
	}
	
	// MARK: Update constraint
	public func updateTopImageViewConstraint(top: CGFloat, width: CGFloat? = nil, height: CGFloat? = nil) {
		imageView.snp.remakeConstraints { make in
			make.top.equalTo(self).offset(top)
			
			if width != nil {
				make.width.lessThanOrEqualTo(width!)
			}
			
			if height != nil {
				make.height.equalTo(height!)
			}
            make.centerX.equalToSuperview()
		}
	}
	
	public func updateContentLabelConstraint(top: CGFloat) {
        titleLabel.snp.updateConstraints { (make) in
			make.top.equalTo(imageView.snp.bottom).offset(top)
		}
	}
}
