//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//	通用的错误页面，适用于图片、文字、按钮固定的场景

import UIKit

protocol DHCommonErrorViewDelegate: NSObjectProtocol {
	
	/// 确定点击事件
	///
	/// - Parameters:
	///   - errorView: self
	func errorViewOnConfirm(errorView: DHCommonErrorView)
	
	/// 退出点击事件
	///
	/// - Parameters:
	///   - errorView: self
	func errorViewOnQuit(errorView: DHCommonErrorView)
	
	/// FAQ点击事件
	///
	/// - Parameters:
	///   - errorView: self
	func errorViewOnFAQ(errorView: DHCommonErrorView)
    
    /// 返回
    ///
    /// - Parameters:
    ///   - errorView: self
    func errorViewOnBackRoot(errorView: DHCommonErrorView)
}

class DHCommonErrorView: UIView {
	
	public weak var delegate: DHCommonErrorViewDelegate?

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var contentLabel: UILabel!
	@IBOutlet weak var detailLabel: UILabel!
	@IBOutlet weak var confrimButton: UIButton!
	@IBOutlet weak var faqButton: UIButton!
	@IBOutlet weak var quitButton: UIButton!
	@IBOutlet weak var faqContainerView: UIView!
	@IBOutlet weak var faqContainerBottomConstraint: NSLayoutConstraint!
	@IBOutlet weak var needHelpButton: UIButton!
	
	public static func xibInstance() -> DHCommonErrorView {
        if let view = Bundle.dh_addDeviceBundle()?.loadNibNamed("DHCommonErrorView", owner: nil, options: nil)!.first as? DHCommonErrorView {
            return view
        }
		return DHCommonErrorView()
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
        
        backgroundColor = UIColor.dhcolor_c43()
        
        contentLabel.textColor = UIColor.dhcolor_c2()
        detailLabel.textColor = UIColor.dhcolor_c5()
		
		faqContainerView.backgroundColor = UIColor.clear
		needHelpButton.setTitle("add_device_i_need_help".lc_T, for: .normal)
		confrimButton.setTitle("add_device_restart".lc_T, for: .normal)
		quitButton.setTitle("add_device_quit_add_process".lc_T, for: .normal)
		
		//填充模式
		imageView.contentMode = .scaleAspectFill
		imageView.image = UIImage(named: "adddevice_fail_undetectable")
		
		//配置颜色、样式
		confrimButton.layer.cornerRadius = DHModuleConfig.shareInstance().commonButtonCornerRadius()
		confrimButton.backgroundColor = DHModuleConfig.shareInstance().commonButtonColor()
        confrimButton.setTitleColor(UIColor.dhcolor_c43(), for: .normal)
		
		quitButton.layer.cornerRadius = DHModuleConfig.shareInstance().commonButtonCornerRadius()
		quitButton.layer.borderWidth = 0.5
		quitButton.layer.borderColor = UIColor.dhcolor_c5().cgColor
        quitButton.setTitleColor(UIColor.dhcolor_c2(), for: .normal)
        
        needHelpButton.setTitleColor(UIColor.dhcolor_c2(), for: .normal)
		
		//默认不显示detail、quit
		detailLabel.text = nil
		quitButton.isHidden = true
		
		setupConstraints()
		
		//开放平台暂时隐藏
		needHelpButton.isHidden = true
		faqContainerView.isHidden = true
	}
	
	private func setupConstraints() {
		imageView.snp.makeConstraints { make in
			make.centerX.equalTo(self)
			make.top.equalTo(self).offset(10)
			make.height.equalTo(208)
			make.width.lessThanOrEqualTo(250)
		}
		
		contentLabel.snp.makeConstraints { make in
			make.leading.equalTo(self).offset(10)
			make.top.equalTo(imageView.snp.bottom).offset(5)
			make.centerX.equalTo(self)
		}
		
		detailLabel.snp.makeConstraints { make in
			make.leading.equalTo(contentLabel)
			make.top.equalTo(contentLabel.snp.bottom).offset(10)
			make.centerX.equalTo(self)
		}
		
		confrimButton.snp.makeConstraints { make in
			make.leading.equalTo(contentLabel)
			make.top.equalTo(detailLabel.snp.bottom).offset(15)
			make.height.equalTo(45)
			make.centerX.equalTo(self)
		}
		
		quitButton.snp.makeConstraints { make in
			make.leading.equalTo(confrimButton)
			make.top.equalTo(detailLabel.snp.bottom).offset(20)
			make.height.equalTo(45)
			make.centerX.equalTo(self)
		}
		
		if dh_isiPhoneX {
			faqContainerBottomConstraint.constant += 15
		}
	}
	
	@IBAction func onConfirmAction(_ button: UIButton) {
        delegate?.errorViewOnBackRoot(errorView: self)
	}
	
	@IBAction func onQuitAction(_ sender: Any) {
		delegate?.errorViewOnQuit(errorView: self)
	}
	
	@IBAction func onFAQAction(_ sender: Any) {
		delegate?.errorViewOnFAQ(errorView: self)
	}
	
	public func dismiss(animated: Bool) {
		if animated {
			let animation = CATransition()
			animation.duration = 0.3
			animation.type = kCATransitionFade
			animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
			self.superview?.layer.add(animation, forKey: kCATransitionFade)
		}
		
		self.removeFromSuperview()
	}
	
	public func showOnView(superView: UIView, animated: Bool) {
		if animated {
			let animation = CATransition()
			animation.duration = 0.3
			animation.type = kCATransitionFade
			animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
			superView.layer.add(animation, forKey: kCATransitionFade)
		}
		
		superView.addSubview(self)
	}
	
	// MARK: Update constraint
	public func updateTopImageViewConstraint(top: CGFloat, width: CGFloat? = nil, height: CGFloat? = nil) {
		imageView.snp.updateConstraints { make in
			make.top.equalTo(self).offset(top)
			
			if width != nil {
				make.width.lessThanOrEqualTo(width!)
			}
			
			if height != nil {
				make.height.equalTo(height!)
			}
		}
	}
	
	public func updateContentLabelConstraint(top: CGFloat) {
		contentLabel.snp.updateConstraints { (make) in
			make.top.equalTo(imageView.snp.bottom).offset(top)
		}
	}
}
