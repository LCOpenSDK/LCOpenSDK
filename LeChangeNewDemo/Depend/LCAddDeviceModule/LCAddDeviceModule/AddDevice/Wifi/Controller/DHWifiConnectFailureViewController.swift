//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//	无线配置：网络配置失败（超时）

import UIKit

protocol DHWifiConnectFailureVCProtocol: NSObjectProtocol {
	func reconnectWifiAction(controller: DHWifiConnectFailureViewController)
}

class DHWifiConnectFailureViewController: DHAddBaseViewController {

	public var failureType: DHNetConnectFailureType = .commonWithWired {
		didSet {
			if (failureView != nil) {
				failureView.setFailureType(type: failureType)
			}
		}
	}
	
	public weak var delegate: DHWifiConnectFailureVCProtocol?
	
	private var failureView: DHNetConnectFailureView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		setupConnectFailureView()
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func setupConnectFailureView() {
		failureView = DHNetConnectFailureView.xibInstance()
        
        let manager = DHAddDeviceManager.sharedInstance
        if manager.netConfigMode == .wifi, manager.supportConfigModes.contains(.qrCode) {
            failureView.showQrcodeBtn = true
        }
        
        
		failureView.setFailureType(type: failureType)
		view.addSubview(failureView)
		
		failureView.snp.makeConstraints { make in
			make.edges.equalTo(self.view)
		}
		
		failureView.action = { [unowned self] (failureType, operationType: DHNetConnectFailureOperationType) in
			switch operationType {
			case .inputWifiPassword:
				self.backToInputWifiPassword()
				
			case .complete:
				self.doCompleteOperation()
				
			case .tryAgain:
				self.doTryAgain(failureType: failureType, operationType: operationType)
				
			//K5：接入网络失败，重新倒计时
			case .continueToWait:
				self.delegate?.reconnectWifiAction(controller: self)
				self.dismiss()
				
			case .switchToWired:
				self.baseSwitchToWiredVC()
				
			case .redLightConstantDetail, .redLightTwinkleDetail, .readLightRotateDetail:
				self.gotoLightDetailVC(operationType: operationType)
				
			case .authDevicePassword:
				self.gotoAuthDevicePasswordVC()
				
            case .deviceInitialize:
                self.gotoDeviceInitializeVC()
                
            case .qrCode:
                self.gotoQRCodeMaker()
				
			//A系、C系蓝灯、绿灯长亮优化处理
			case .blueConstantAction, .greenConstantAction:
				self.blueOrGreenConstantAction()
				
			default:
				self.baseBackToAddDeviceRoot()
			}
		}
		
		failureView.help = {  [unowned self] in
			self.basePushToFAQ()
		}
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
	
	private func doTryAgain(failureType: DHNetConnectFailureType, operationType: DHNetConnectFailureOperationType) {
        
        // 增加wifi是否变化判断
        let currentWifiSSID = DHMobileInfo.sharedInstance()?.wifissid ?? ""
        let preWifiSSID = DHAddDeviceManager.sharedInstance.wifiSSID ?? ""
        if currentWifiSSID.compare(preWifiSSID).rawValue != 0 {     //wifi变化，进入wifi密码输入界面

            self.backToInputWifiPassword()
            return
        }

		if failureType == .door {
			//K5: 连接路由器失败：点击后，跳转至开启软AP引导页面；
			_ = self.baseBackToViewController(cls: DHApGuideViewController.self)
		} else {
			self.backToInputWifiPassword()
		}
	}
	
	// MARK: DHAddBaseVCProtocol
	override func rightActionType() -> [DHAddBaseRightAction] {
		var actions: [DHAddBaseRightAction] = [.restart]
		if DHAddDeviceManager.sharedInstance.supportConfigModes.contains(.wired) {
			actions.append(.switchToWired)
		}
		
		return actions
	}
	
	override func leftActionType() -> DHAddBaseLeftAction {
		return .quit
	}
	
	override func isLeftActionShowAlert() -> Bool {
		return true
	}
	
	// MARK: Failure operations
	private func backToInputWifiPassword() {

		for controller in baseStackControllers() {
            DHUserManager.shareInstance().removeSSID(DHAddDeviceManager.sharedInstance.wifiSSID)
			if controller is DHWifiPasswordViewController {
				self.navigationController?.popToViewController(controller, animated: true)
				break
			}
		}
	}
	
	private func doCompleteOperation() {
		if DHAddDeviceManager.sharedInstance.isSupportSC {
			self.basePushToConnectCloudVC()
		} else {
			self.gotoSearchDeviceVC()
		}
	}
	
	private func gotoSearchDeviceVC() {
		let controller = DHInitializeSearchViewController.storyboardInstance()
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	private func gotoLightDetailVC(operationType: DHNetConnectFailureOperationType) {
		let controller = DHLightDetailViewController()
		controller.failureType = failureType
		controller.operationType = operationType
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	private func gotoAuthDevicePasswordVC() {
		let controller = DHAuthPasswordViewController.storyboardInstance()
		controller.presenter = DHAuthPasswordPresenter(container: controller)
		self.navigationController?.pushViewController(controller, animated: true)
	}
    
    private func gotoDeviceInitializeVC() {
        let controller = DHInitializeSearchViewController.storyboardInstance()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func gotoQRCodeMaker() {
        let controller = DHAddByQRCodeVC()
        let present: IDHAddByQRCodePresenter = DHAddByQRCodePresenter()
        controller.presenter = present
        present.container = controller
        self.navigationController?.pushViewController(controller, animated: true)
    }
	
	// MARK: 蓝色、绿灯长亮优化方案
	private func blueOrGreenConstantAction() {
		//【*】支持sc码的设备：进入云配置流程
		let manager = DHAddDeviceManager.sharedInstance
		if manager.isSupportSC {
			self.basePushToConnectCloudVC()
			return
		}
		
		//【*】1、p2p设备：输入设备密码页
		//【*】2、pass设备（未初始化）：初始化页 【需要考虑不在一个局域网，搜索不到的情况】
		//【*】3、pass设备（已初始化）：输入设备密码页
		let device = DHNetSDKSearchManager.sharedInstance().getNetInfo(byID: manager.deviceId)
		if manager.accessType == .p2p || manager.accessType == .easy4ip {
			self.gotoAuthDevicePasswordVC()
		} else if device == nil || device?.deviceInitStatus == .unInit {
			self.gotoDeviceInitializeVC()
		} else {
			self.gotoAuthDevicePasswordVC()
		}
	}
}
