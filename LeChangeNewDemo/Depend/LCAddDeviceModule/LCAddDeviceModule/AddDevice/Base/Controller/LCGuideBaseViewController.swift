//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	引导页基类

import UIKit

class LCGuideBaseViewController: LCAddBaseViewController, LCGuideBaseVCProtocol, LCAddGuideViewDelegate {

	internal var guideView: LCAddGuideView = LCAddGuideView.xibInstance()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.view.addSubview(guideView)
        guideView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
		
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

	}
    
    internal func setGuideImage(uri: String) {
        guideView.topImageView.sd_setImage(with: URL(string: uri))
    }
    
    internal func setOperateText(text: String?) {
        guideView.descriptionLabel.text = text
    }
	
	internal func setNextButton(enable: Bool) {
		guideView.nextButton.lc_enable = enable
	}
	
	// MARK: LCAddGuideViewDelegate
	internal func guideView(view: LCAddGuideView, action: LCAddGuideActionType) {
		if action == .next {
			doNext()
		} else if action == .detail {
			doDetail()
        } else if action == .error {
            doError()
        }
	}
	
	// MARK: LCGuideBaseVCProtocol
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
		return "common_next".lc_T()
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
