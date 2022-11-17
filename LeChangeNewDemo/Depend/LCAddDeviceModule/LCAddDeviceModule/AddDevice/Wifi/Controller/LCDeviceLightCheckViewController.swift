//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	WIFI配置：设备指示灯检查

import UIKit

class LCDeviceLightCheckViewController: LCGuideBaseViewController {

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
		if lc_screenHeight < 667 {
			guideView.updateTopImageViewConstraint(top: 20, width: 210, maxHeight: 210)
			guideView.updateContentLabelConstraint(top: 5)
		} else {
			guideView.updateContentLabelConstraint(top: 10)
		}
	}
	
	private func pushToPhoneVolumeCheckVC() {
		let controller = LCPhoneVolumeCheckViewController()
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	private func pushToResetDeviceVC() {
		let controller = LCResetDeviceViewController()
		let introductionParser = LCAddDeviceManager.sharedInstance.getIntroductionParser()
		controller.placeholderImage = LCIPCLightCheckDefault.imagename
		controller.imageUrl = introductionParser?.lightResetInfo.resetImageUrl
		controller.resetContent = introductionParser?.lightResetInfo.resetOperation ?? LCIPCLightResetDefault.operation
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	// MARK: - LCAddBaseVCProtocol
	override func rightActionType() -> [LCAddBaseRightAction] {
		var actions: [LCAddBaseRightAction] = [.restart]
		if LCAddDeviceManager.sharedInstance.supportConfigModes.contains(.wired) {
			actions.append(.switchToWired)
		}
		
		return actions
	}
	
	// MARK: - LCAddBaseVCProtocol(OMS Introduction)
	override func needUpdateCurrentOMSIntroduction() {
		LCProgressHUD.hideAllHuds(self.view)
		let parser = LCAddDeviceManager.sharedInstance.getIntroductionParser()
		if parser != nil {
			self.setupGuideView()
		}
	}
	
	// MARK: - LCGuideBaseVCProtocol
	override func tipText() -> String? {
		let introductionParser = LCAddDeviceManager.sharedInstance.getIntroductionParser()
		return introductionParser?.lightCheckInfo.lightTwinkleContent ?? LCIPCLightCheckDefault.twinkleContent
	}
	
	override func tipImageName() -> String? {
		return LCIPCLightCheckDefault.imagename
	}
	
	override func tipImageUrl() -> String? {
		let introductionParser = LCAddDeviceManager.sharedInstance.getIntroductionParser()
		return introductionParser?.lightCheckInfo.lightTwinkleImageUrl
	}
	
	override func detailText() -> String? {
		let introductionParser = LCAddDeviceManager.sharedInstance.getIntroductionParser()
		return introductionParser?.lightResetInfo.resetGuide ?? LCIPCLightResetDefault.guide
	}
	
	override func checkText() -> String? {
		let introductionParser = LCAddDeviceManager.sharedInstance.getIntroductionParser()
		return introductionParser?.lightCheckInfo.lightTwinklConfirm ?? LCIPCLightCheckDefault.twinkleConfirm
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
