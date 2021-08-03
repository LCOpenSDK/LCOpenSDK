//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//	SoftAP：非PaaS接入的设备，进入指示灯选择界面

import UIKit

class DHApP2PTypeDoneViewController: DHGuideBaseViewController {

	public var devicePassword: String = "admin"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.baseAddOMSIntroductionObserver()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: DHAddBaseVCProtocol
	override func rightActionType() -> [DHAddBaseRightAction] {
		return [.restart]
	}
	
	override func leftActionType() -> DHAddBaseLeftAction {
		return .quit
	}
	
	override func isLeftActionShowAlert() -> Bool {
		return true
	}
	
	// MARK: DHAddBaseVCProtocol(OMS Introduction)
	override func needUpdateCurrentOMSIntroduction() {
		LCProgressHUD.hideAllHuds(self.view)
		if let imageUrl = DHAddDeviceManager.sharedInstance.getIntroductionParser()?.doneInfo.guideImageUrl {
			self.guideView.topImageView.lc_setImage(withUrl: imageUrl, placeholderImage: DHOMSSoftAPDoneDefault.imagename, toDisk: true)
		}
	}
	
	// MARK: DHGuideBaseVCProtocol
	override func tipText() -> String? {
		let introductionParser = DHAddDeviceManager.sharedInstance.getIntroductionParser()
		return introductionParser?.doneInfo.content ?? DHOMSSoftAPDoneDefault.content
	}
	
	override func tipImageName() -> String? {
		return DHOMSSoftAPDoneDefault.imagename
	}
	
	override func tipImageUrl() -> String? {
		let introductionParser = DHAddDeviceManager.sharedInstance.getIntroductionParser()
		return introductionParser?.doneInfo.guideImageUrl
	}
	
	override func checkText() -> String? {
		let introductionParser = DHAddDeviceManager.sharedInstance.getIntroductionParser()
		return introductionParser?.doneInfo.guide ?? DHOMSSoftAPDoneDefault.guide
	}
	
	override func detailImageUrl() -> String? {
		return nil
	}
	
	override func isCheckHidden() -> Bool {
		return false
	}
	
	override func isDetailHidden() -> Bool {
		return true
	}
	
	override func nextStepText() -> String? {
		return "add_device_done".lc_T
	}
	
	override func doNext() {
		//添加设备
		LCProgressHUD.show(on: self.view)
		DHAddDeviceManager.sharedInstance.bindDevice(devicePassword: devicePassword, success: {
            DHAddDeviceManager.sharedInstance.addPlicy {
                self.baseExitAddDevice(showAlert: false, backToMain: true)
                LCProgressHUD.hideAllHuds(self.view)
            } failure: { (error) in
                
            }
		}) { (error) in
			
			LCProgressHUD.hideAllHuds(self.view)
#if DEBUG
			//调试时打印具体错误
			error.showTips("Failed to bind...")
#endif
			
			self.pushToConnectFailureView()
		}
	}
	
	private func pushToConnectFailureView() {
		let controller = DHConnectCloudTimeoutViewController()
		controller.failureType = .overseasDoorbell
		self.navigationController?.pushViewController(controller, animated: true)
	}
}

/// 绑定容器(UIViewController)需要实现的协议
extension DHApP2PTypeDoneViewController: DHBindContainerProtocol {
	
	func navigationVC() -> UINavigationController? {
		return self.navigationController
	}
	
	func mainView() -> UIView {
		return self.view
	}
	
	func mainController() -> UIViewController {
		return self
	}
	
	func retry() {
		
	}
}
