//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//	WIFI配置：设备指示灯检查

import UIKit

class DHDeviceLightCheckViewController: DHGuideBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		self.baseAddOMSIntroductionObserver()
		self.ajustConstraints()
		

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	private func ajustConstraints() {
		if dh_screenHeight < 667 {
			guideView.updateTopImageViewConstraint(top: 20, width: 210, maxHeight: 210)
			guideView.updateContentLabelConstraint(top: 5)
		} else {
			guideView.updateContentLabelConstraint(top: 10)
		}
	}
	
	private func pushToPhoneVolumeCheckVC() {
		let controller = DHPhoneVolumeCheckViewController()
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	private func pushToResetDeviceVC() {
		let controller = DHResetDeviceViewController()
		let introductionParser = DHAddDeviceManager.sharedInstance.getIntroductionParser()
		controller.placeholderImage = DHIPCLightCheckDefault.imagename
		controller.imageUrl = introductionParser?.lightResetInfo.resetImageUrl
		controller.resetContent = introductionParser?.lightResetInfo.resetOperation ?? DHIPCLightResetDefault.operation
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	// MARK: - DHAddBaseVCProtocol
	override func rightActionType() -> [DHAddBaseRightAction] {
		var actions: [DHAddBaseRightAction] = [.restart]
		if DHAddDeviceManager.sharedInstance.supportConfigModes.contains(.wired) {
			actions.append(.switchToWired)
		}
		
		return actions
	}
	
	// MARK: - DHAddBaseVCProtocol(OMS Introduction)
	override func needUpdateCurrentOMSIntroduction() {
		LCProgressHUD.hideAllHuds(self.view)
		let parser = DHAddDeviceManager.sharedInstance.getIntroductionParser()
		if parser != nil {
			self.setupGuideView()
		}
	}
	
	// MARK: - DHGuideBaseVCProtocol
	override func tipText() -> String? {
		let introductionParser = DHAddDeviceManager.sharedInstance.getIntroductionParser()
		return introductionParser?.lightCheckInfo.lightTwinkleContent ?? DHIPCLightCheckDefault.twinkleContent
	}
	
	override func tipImageName() -> String? {
		return DHIPCLightCheckDefault.imagename
	}
	
	override func tipImageUrl() -> String? {
		let introductionParser = DHAddDeviceManager.sharedInstance.getIntroductionParser()
		return introductionParser?.lightCheckInfo.lightTwinkleImageUrl
	}
	
	override func detailText() -> String? {
		let introductionParser = DHAddDeviceManager.sharedInstance.getIntroductionParser()
		return introductionParser?.lightResetInfo.resetGuide ?? DHIPCLightResetDefault.guide
	}
	
	override func checkText() -> String? {
		let introductionParser = DHAddDeviceManager.sharedInstance.getIntroductionParser()
		return introductionParser?.lightCheckInfo.lightTwinklConfirm ?? DHIPCLightCheckDefault.twinkleConfirm
	}
	
	override func detailImageUrl() -> String? {
		return nil
	}
	
	override func isCheckHidden() -> Bool {
		return false
	}
	
	override func isDetailHidden() -> Bool {
		return false
	}
	
	override func doNext() {
		pushToPhoneVolumeCheckVC()
	}
	
	override func doDetail() {
		pushToResetDeviceVC()
	}
}
