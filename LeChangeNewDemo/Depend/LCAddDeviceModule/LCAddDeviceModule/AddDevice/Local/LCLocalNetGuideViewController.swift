//
//  Copyright © 2019 Imou. All rights reserved.
//	设备本地配网引导 

import UIKit

class LCLocalNetGuideViewController: LCGuideBaseViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		adjustConstraint()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	private func adjustConstraint() {
		guideView.topImageView.contentMode = .scaleAspectFit
		guideView.updateTopImageViewConstraint(top: 0, width: view.bounds.width, maxHeight: 350)
	}
	
	// MARK: LCAddBaseVCProtocol
	override func rightActionType() -> [LCAddBaseRightAction] {
		let actions: [LCAddBaseRightAction] = [.restart]
		return actions
	}
	
	// MARK: LCGuideBaseVCProtocol
	override func tipText() -> String? {
		let introductionParser = LCAddDeviceManager.sharedInstance.getIntroductionParser()
		return introductionParser?.localGuideInfo.content ?? LCOMSSLocalGuideDefault.content 
	}
	
	override func tipImageName() -> String? {
		return LCOMSSLocalGuideDefault.imagename
	}
	
	override func tipImageUrl() -> String? {
		let introductionParser = LCAddDeviceManager.sharedInstance.getIntroductionParser()
		return introductionParser?.localGuideInfo.imageUrl
	}
	
	override func isCheckHidden() -> Bool {
		return true
	}
	
	override func nextStepText() -> String? {
		return "add_device_confirm".lc_T
	}
	
	override func doNext() {
		//离线配网：返回主页
		//添加流程：返回扫描页面
		if LCAddDeviceManager.sharedInstance.isEntryFromWifiConfig {
			baseExitAddDevice(showAlert: false, backToMain: true)
		} else {
			_ = baseBackToViewController(cls: LCQRScanViewController.self)
		}
	}
}
