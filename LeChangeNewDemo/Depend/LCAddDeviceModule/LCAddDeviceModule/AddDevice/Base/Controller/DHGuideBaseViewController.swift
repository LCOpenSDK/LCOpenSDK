//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//	引导页基类

import UIKit

class DHGuideBaseViewController: DHAddBaseViewController, DHGuideBaseVCProtocol, DHAddGuideViewDelegate {

	internal var guideView: DHAddGuideView = DHAddGuideView.xibInstance()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.view.addSubview(guideView)
		guideView.frame = self.view.bounds
		
		//配置引导图：第一次设置图片需要配置默认图片
		self.setupGuideView(setPlaceholder: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	/// 配置引导信息：
	///
	/// - Parameter setPlaceholder: 是否设置图片的默认图；默认false；数据更新后，不需要设置，
	//							避免网络比较慢的情况下，从旧图片，切换到新图片中间过程会展示默认图的情况
	internal func setupGuideView(setPlaceholder: Bool = false) {
		guideView.delegate = self
		
		if tipImageUrl() != nil {
			let placeHolder = setPlaceholder ? tipImageName() : nil
			guideView.topImageView.lc_setImage(withUrl: tipImageUrl(), placeholderImage: placeHolder, toDisk: true)
			
		} else if let imageName = tipImageName() {
			guideView.topImageView.image = UIImage(named: imageName)
		} else {
			guideView.topImageView = nil
		}
		guideView.topTipLabel.textColor = UIColor.dhcolor_c2()
        guideView.descriptionLabel.textColor = UIColor.dhcolor_c5()
        if dh_screenHeight < 667 {
            guideView.errorButton.titleLabel?.font = UIFont.dhFont_t2()
            guideView.topTipLabel.dh_setAttributedText(text: tipText(), font: UIFont.dhFont_t2())
            guideView.descriptionLabel.dh_setAttributedText(text: descriptionText(), font: UIFont.dhFont_t5())
        } else {
            guideView.errorButton.titleLabel?.font = UIFont.dhFont_t1()
            guideView.topTipLabel.dh_setAttributedText(text: tipText(), font: UIFont.dhFont_t1())
            guideView.descriptionLabel.dh_setAttributedText(text: descriptionText(), font: UIFont.dhFont_t3())
        }
		
		
		guideView.setDetailButton(text: detailText(), useUnderline: false)
		guideView.checkButton.setTitle(checkText(), for: .normal)
		
		guideView.nextButton.isHidden = isNextStepHidden()
		guideView.nextButton.setTitle(nextStepText(), for: .normal)
		
		//文字异常处理：没有文字的确认和Reset按钮，不显示【防止可以点击】
		if checkText() == nil || checkText()?.count == 0 {
			guideView.setCheckHidden(hidden: true)
		} else {
			guideView.setCheckHidden(hidden: isCheckHidden())
		}
		
		if detailText() == nil || detailText()?.count == 0 {
			guideView.setDetailButtonHidden(hidden: true)
		} else {
			guideView.setDetailButtonHidden(hidden: isDetailHidden())
		}
	}
	
	internal func setNextButton(enable: Bool) {
		guideView.nextButton.dh_enable = enable
	}
	
	internal func setCheckButton(enable: Bool) {
		guideView.checkButton.dh_enable = enable
	
		//复选按钮不可点击时，下一步按钮也需要不可点击
		if enable == false {
			guideView.checkButton.isSelected = false
			guideView.nextButton.dh_enable = false
		}
	}
	
	// MARK: DHAddGuideViewDelegate
	internal func guideView(view: DHAddGuideView, action: DHAddGuideActionType) {
		if action == .next {
			doNext()
		} else if action == .detail {
			doDetail()
        } else if action == .error {
            doError()
        }
	}
	
	// MARK: DHGuideBaseVCProtocol
	func tipText() -> String? {
		return "Please input tip text..."
	}
	
	func tipImageUrl() -> String? {
		return nil
	}
	
	func tipImageName() -> String? {
		return nil
	}
	
	func descriptionText() -> String? {
		return nil
	}
	
	func detailText() -> String? {
		return "Please input detail text..."
	}
	
	func checkText() -> String? {
		return "Plase input check text..."
	}
	
	func detailImageUrl() -> String? {
		return ""
	}
	
	func isCheckHidden() -> Bool {
		return false
	}
	
	func isDetailHidden() -> Bool {
		return true
	}
	
	func nextStepText() -> String? {
		return "common_next".lc_T
	}
	
	func isNextStepHidden() -> Bool {
		return false
	}
	
	func doNext() {
		//Override in inherit
	}
	
	func doDetail() {
		//Override in inherit
	}
    
    func doError() {
        
    }
}
