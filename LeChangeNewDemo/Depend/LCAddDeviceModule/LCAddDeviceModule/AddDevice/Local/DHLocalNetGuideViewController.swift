//
//  Copyright © 2019 dahua. All rights reserved.
//	设备本地配网引导 

import UIKit

class DHLocalNetGuideViewController: DHGuideBaseViewController {

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
	
	// MARK: DHAddBaseVCProtocol
	override func rightActionType() -> [DHAddBaseRightAction] {
		let actions: [DHAddBaseRightAction] = [.restart]
		return actions
	}
	
	// MARK: DHGuideBaseVCProtocol
	override func tipText() -> String? {
		let introductionParser = DHAddDeviceManager.sharedInstance.getIntroductionParser()
		return introductionParser?.localGuideInfo.content ?? DHOMSSLocalGuideDefault.content 
	}
	
	override func tipImageName() -> String? {
		return DHOMSSLocalGuideDefault.imagename
	}
	
	override func tipImageUrl() -> String? {
		let introductionParser = DHAddDeviceManager.sharedInstance.getIntroductionParser()
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
		if DHAddDeviceManager.sharedInstance.isEntryFromWifiConfig {
			baseExitAddDevice(showAlert: false, backToMain: true)
		} else {
			_ = baseBackToViewController(cls: DHQRScanViewController.self)
		}
	}
}
