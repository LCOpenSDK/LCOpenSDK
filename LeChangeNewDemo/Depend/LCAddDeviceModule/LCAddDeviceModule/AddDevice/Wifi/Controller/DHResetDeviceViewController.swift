//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//	设备重置引导页面

import UIKit

class DHResetDeviceViewController: DHAddBaseViewController, DHCommonErrorViewDelegate {
	
	/// 重置引导图
	public var imageUrl: String?
	
	/// 默认图片
	public var placeholderImage: String = "adddevice_icon_commondevice"
	
	/// 重置内容
	public var resetContent: String? = "add_device_operation_by_instructions".lc_T
	
	private var errorView: DHCommonErrorView!
	
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
		errorView = DHCommonErrorView.xibInstance()
		errorView.delegate = self
		
		// 【*】调整图片显示模式，以免风络图片过大，造成显示异常
		//errorView.imageView.contentMode = .scaleAspectFit
		view.addSubview(errorView)
		
		errorView.snp.makeConstraints { make in
			make.edges.equalTo(self.view)
		}
		
		if dh_screenHeight < 667 {
			errorView.updateTopImageViewConstraint(top: 40, width: 240, height: 240)
			errorView.updateContentLabelConstraint(top: 10)
		} else {
			errorView.updateTopImageViewConstraint(top: 70, width: 240, height: 240)
			errorView.updateContentLabelConstraint(top: 20)
		}
	}
	
	private func setupCustomContents() {
		errorView.confrimButton.isHidden = true
		errorView.imageView.lc_setImage(withUrl: imageUrl, placeholderImage: placeholderImage, toDisk: true)
		errorView.contentLabel.dh_setAttributedText(text: resetContent, font: UIFont.dhFont_t2())
	}
	
	// MARK: - DHAddBaseVCProtocol
	override func rightActionType() -> [DHAddBaseRightAction] {
		return [.restart]
	}
}

extension DHResetDeviceViewController {
	// MARK: - DHCommonErrorViewDelegate
	func errorViewOnConfirm(errorView: DHCommonErrorView) {
		
	}
	
	func errorViewOnFAQ(errorView: DHCommonErrorView) {
		basePushToFAQ()
	}
	
	func errorViewOnQuit(errorView: DHCommonErrorView) {
		
	}
    
    func errorViewOnBackRoot(errorView: DHCommonErrorView) {

    }
}
