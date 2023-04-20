//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	通用的错误页面，适用于图片、文字、按钮固定的场景

import UIKit

protocol LCCommonErrorViewDelegate: NSObjectProtocol {
	
	/// 确定点击事件
	///
	/// - Parameters:
	///   - errorView: self
	func errorViewOnConfirm(errorView: LCCommonErrorView)
	
	/// 退出点击事件
	///
	/// - Parameters:
	///   - errorView: self
	func errorViewOnQuit(errorView: LCCommonErrorView)
	
	/// FAQ点击事件
	///
	/// - Parameters:
	///   - errorView: self
	func errorViewOnFAQ(errorView: LCCommonErrorView)
    
    /// 返回
    ///
    /// - Parameters:
    ///   - errorView: self
    func errorViewOnBackRoot(errorView: LCCommonErrorView)
}

class LCCommonErrorView: UIView {
	
	public weak var delegate: LCCommonErrorViewDelegate?

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var contentLabel: UILabel!
	@IBOutlet weak var detailLabel: UILabel!
	@IBOutlet weak var confrimButton: UIButton!
	@IBOutlet weak var faqButton: UIButton!
	@IBOutlet weak var quitButton: UIButton!
	@IBOutlet weak var faqContainerView: UIView!
	@IBOutlet weak var faqContainerBottomConstraint: NSLayoutConstraint!
	@IBOutlet weak var needHelpButton: UIButton!
	
	public static func xibInstance() -> LCCommonErrorView {
        if let view = Bundle.lc_addDeviceBundle()?.loadNibNamed("DHCommonErrorView", owner: nil, options: nil)!.first as? LCCommonErrorView {
            return view
        }
		return LCCommonErrorView()
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
        
        backgroundColor = UIColor.lccolor_c43()
        
        contentLabel.textColor = UIColor.lccolor_c2()
        detailLabel.textColor = UIColor.lccolor_c5()
		
		faqContainerView.backgroundColor = UIColor.clear
		needHelpButton.setTitle("add_device_i_need_help".lc_T, for: .normal)
		confrimButton.setTitle("add_device_restart".lc_T, for: .normal)
		quitButton.setTitle("add_device_quit_add_process".lc_T, for: .normal)
		
		//填充模式
		imageView.contentMode = .scaleAspectFill
		imageView.image = UIImage(named: "adddevice_fail_undetectable")
		
		//配置颜色、样式
		confrimButton.layer.cornerRadius = LCModuleConfig.shareInstance().commonButtonCornerRadius()
		confrimButton.backgroundColor = LCModuleConfig.shareInstance().commonButtonColor()
        confrimButton.setTitleColor(UIColor.lccolor_c43(), for: .normal)
		
		quitButton.layer.cornerRadius = LCModuleConfig.shareInstance().commonButtonCornerRadius()
		quitButton.layer.borderWidth = 0.5
		quitButton.layer.borderColor = UIColor.lccolor_c5().cgColor
        quitButton.setTitleColor(UIColor.lccolor_c2(), for: .normal)
        
        needHelpButton.setTitleColor(UIColor.lccolor_c2(), for: .normal)
		
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
		
		if lc_isiPhoneX {
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
