//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	设备重置引导页面

import UIKit

class LCResetDeviceViewController: LCAddBaseViewController, LCCommonErrorViewDelegate {
	
	/// 重置引导图
	public var imageUrl: String?
	
	/// 默认图片
	public var placeholderImage: String = ""
	
	/// 重置内容
	public var resetContent: String? = "add_device_operation_by_instructions".lc_T()
	
	private var errorView: LCCommonErrorView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		setupErrorView()
		setupCustomContents()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	private func setupErrorView() {
		errorView = LCCommonErrorView.init()
		errorView.delegate = self
		
		// 【*】调整图片显示模式，以免风络图片过大，造成显示异常
		//errorView.imageView.contentMode = .scaleAspectFit
		view.addSubview(errorView)
		
		errorView.snp.makeConstraints { make in
			make.edges.equalTo(self.view)
		}
		
		if lc_screenHeight < 667 {
			errorView.updateTopImageViewConstraint(top: 40, width: 240, height: 240)
			errorView.updateContentLabelConstraint(top: 10)
		} else {
			errorView.updateTopImageViewConstraint(top: 70, width: 240, height: 240)
			errorView.updateContentLabelConstraint(top: 20)
		}
	}
	
	private func setupCustomContents() {
		errorView.tryAgainButton.isHidden = true
        errorView.imageView.sd_setImage(with: URL(string: imageUrl ?? ""), placeholderImage: UIImage(lc_named: placeholderImage), context: nil)
		errorView.titleLabel.lc_setAttributedText(text: resetContent, font: UIFont.lcFont_t2())
	}
	
	// MARK: - LCAddBaseVCProtocol
	override func rightActionType() -> [LCAddBaseRightAction] {
		return [.restart]
	}
}

extension LCResetDeviceViewController {
	// MARK: - LCCommonErrorViewDelegate
	func errorViewOnTryAgain(errorView: LCCommonErrorView) {
		
	}
	
	func errorViewOnQuit(errorView: LCCommonErrorView) {
		
	}
}
