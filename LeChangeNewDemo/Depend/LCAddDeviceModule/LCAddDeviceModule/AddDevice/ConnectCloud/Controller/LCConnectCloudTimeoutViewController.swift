//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	连接云平台超时

import UIKit

protocol LCConnectCloudTimeoutVCDelegate: NSObjectProtocol {
	
	func cloudTimeOutReconnectAction(controller: LCConnectCloudTimeoutViewController)
}

class LCConnectCloudTimeoutViewController: LCAddBaseViewController {
	
	public var failureType: LCNetConnectFailureType = .commonWithWired {
		didSet {
			if failureView != nil {
				failureView.setFailureType(type: failureType)
			}
		}
	}
	
	/// 特殊需求，将详情重置为空
	public var detailText: String? = ""
	
	public weak var delegate: LCConnectCloudTimeoutVCDelegate?
	
	private var failureView: LCNetConnectFailureView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		setupConnectFailureView()
        
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	public func showOnParent(controller: UIViewController) {
		controller.addChildViewController(self)
		controller.view.addSubview(self.view)
		self.view.frame = controller.view.bounds
		
		controller.view.lc_transitionAnimation(type: .fade, direction: .fromBottom, duration: 0.3)
	}
	
	public func dismiss() {
		self.view.removeFromSuperview()
		self.parent?.view.lc_transitionAnimation(type: .fade, direction: .fromBottom, duration: 0.3)
		self.removeFromParentViewController()
	}
	
	func setupConnectFailureView() {
		failureView = LCNetConnectFailureView.xibInstance()
		failureView.setFailureType(type: failureType)
		failureView.imageView.image = UIImage(named: "adddevice_fail_configurationfailure")
	
		view.addSubview(failureView)
		
		failureView.snp.makeConstraints { make in
			make.edges.equalTo(self.view)
		}
		
		failureView.action = { [unowned self] (failureType, operationType: LCNetConnectFailureOperationType) in
			print(" \(NSStringFromClass(self.classForCoder))::FailureType-\(failureType), OperationType-\(operationType)")
			
			if operationType == .tryAgain {
				//【*】海外门铃类型DB10、DB11、DS11，跳转软AP引导界面
				//【*】国内K5等设备，跳转软AP引导界面
				//【*】通用设备，重新倒计时
				if failureType == .overseasDoorbell || failureType == .door {
					_ = self.baseBackToViewController(cls: LCApGuideViewController.self)
				} else {
					self.delegate?.cloudTimeOutReconnectAction(controller: self)
				}
			} else if operationType == .continueToWait {
				//【*】国内K5等设备，重新倒计时
				self.delegate?.cloudTimeOutReconnectAction(controller: self)
            } else if operationType == .quit {
                self.baseBackToAddDeviceRoot()
            } else {
				self.baseExitAddDevice(showAlert: false, backToMain: false)
			}
		}
		
		failureView.help = {  [unowned self] in
			self.basePushToFAQ()
		}
		
		setupContents(type: failureType)
	}
	
	func setupContents(type: LCNetConnectFailureType) {
		//连接云平台超时，通用提示
		var title = "add_device_config_failed".lc_T
		var detail = ""
		
		//适用于软AP类错误【海外不需要语音提示】
		//【*】k5等显示请按设备语音操作
		if type == .overseasDoorbell {
			title = "add_device_connect_timeout".lc_T
			detail = ""
		} else if type == .door {
			title = "add_device_connect_timeout".lc_T
			detail = "add_device_operation_by_voice_tip".lc_T
		}
		
		if detailText == nil {
			detail = ""
		}
		
		failureView.contentLabel.text = title
		failureView.detailLabel.text = detail
		
	}
	
	// MARK: - LCAddBaseVCProtocol
	override func rightActionType() -> [LCAddBaseRightAction] {
		var actions: [LCAddBaseRightAction] = [.restart]
		if LCAddDeviceManager.sharedInstance.supportConfigModes.contains(.wired) {
			actions.append(.switchToWired)
		}
		
		return actions
	}
	
	override func leftActionType() -> LCAddBaseLeftAction {
		return .quit
	}
	
	override func isLeftActionShowAlert() -> Bool {
		return true
	}
}
