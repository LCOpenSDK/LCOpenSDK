//
//  Copyright © 2018年 dahua. All rights reserved.
//

import UIKit
import LCBaseModule

class DHAddBaseViewController: DHBaseViewController, DHAddBaseVCProtocol, LCSheetViewDelegate {
	
	var btnNaviRight: UIButton!
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.title = DHAddDeviceManager.sharedInstance.isEntryFromWifiConfig ? "device_manager_network_config".lc_T : "add_device_title".lc_T
        self.view.backgroundColor = UIColor.dhcolor_c43()
        
		self.setupNaviRightItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		LCSheetView.dismissAll()
	}
	
	override func onLeftNaviItemClick(_ button: UIButton) {
		let actionType = self.leftActionType()
		if actionType == .back {
            self.popViewController()
		} else if actionType == .quit {
			self.baseExitAddDevice()
		} else if actionType == .backToScan {
			_ = self.baseBackToViewController(cls: DHQRScanViewController.classForCoder())
		}
	}
	
	func setupNaviRightItem() {
		btnNaviRight = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
		btnNaviRight.contentHorizontalAlignment = .right
		btnNaviRight.setImage(UIImage(named: "common_nav_more_n"), for: .normal)
		btnNaviRight.addTarget(self, action: #selector(onRightAction), for: .touchUpInside)
		let item = UIBarButtonItem(customView: btnNaviRight)
		self.navigationItem.lc_rightBarButtonItems = [item]
		
		btnNaviRight.isHidden = self.isRightActionHidden()
	}
	
	func showQuitAlert(action: (() -> ())?) {
		let message = leftActionAlertText()

		DHAlertController.show(withTitle: "add_device_confrim_to_quit".lc_T, message: message, cancelButtonTitle: "common_cancel".lc_T, otherButtonTitle: "common_confirm".lc_T) { (index) in
			if index == 1 {
				action?()
			}
        }
	}
	
	private func setupRightActionContent() {
		var otherTitles = [String]()
        if DHAddDeviceManager.sharedInstance.isAccessory {
            otherTitles.append("add_device_restart".lc_T)
        } else {
            for action in rightActionType() {
                let isWifiConfig = DHAddDeviceManager.sharedInstance.isEntryFromWifiConfig
                otherTitles.append(action.title(isWifiConfig: isWifiConfig))
            }
        }
        
		//隐藏键盘
		view.endEditing(true)
		let sheet = LCSheetView(title: nil, message: nil, delegate: self, cancelButton: "common_cancel".lc_T, otherButtons: otherTitles)
        
        let cancleBtn = sheet?.button(at: 0)
        cancleBtn?.setTitleColor(UIColor.dhcolor_c12(), for: .normal)
		sheet?.show()
	}
	
	// MARK: DHAddBaseVCProtocol
	func leftActionType() -> DHAddBaseLeftAction {
		return .back
	}
	
	func rightActionType() -> [DHAddBaseRightAction] {
        var modes = [DHAddBaseRightAction]()
        switch DHAddDeviceManager.sharedInstance.netConfigMode {
        case .softAp:
            if DHAddDeviceManager.sharedInstance.supportConfigModes.contains(.wired) {
                modes.append(.switchToWired)
            }
            modes.append(.restart)
        case .wifi:
            if DHAddDeviceManager.sharedInstance.supportConfigModes.contains(.wired) {
                modes.append(.switchToWired)
            }
            modes.append(.restart)
        case .wired:
            if DHAddDeviceManager.sharedInstance.supportConfigModes.contains(.wifi) {
                modes.append(.switchToWireless)
            }
            if DHAddDeviceManager.sharedInstance.supportConfigModes.contains(.softAp) {
                modes.append(.switchToSoftAp)
            }
            modes.append(.restart)
        default:
            modes.append(.restart)
        }
        return modes
	}
	
	func isRightActionHidden() -> Bool {
		return false
	}
	
	func enableRightAction(enable: Bool) {
		btnNaviRight.dh_enable = enable
	}
	
	func isLeftActionShowAlert() -> Bool {
		return false
	}
	
	func leftActionAlertText() -> String? {
		return DHAddDeviceManager.sharedInstance.isEntryFromWifiConfig ? "add_device_config_not_complete_tip".lc_T : "add_device_not_complete_tip".lc_T
	}
	
	@objc func onRightAction(button: UIButton) {
		setupRightActionContent()
	}
	
	// MARK: OMS Introdcution Observer
	public func baseAddOMSIntroductionObserver() {
		NotificationCenter.default.addObserver(self, selector: #selector(baseOMSIntroductionUpdated), name: NSNotification.Name(rawValue: "LCNotificationOMSIntrodutionUpdated"), object: nil)
	}
	
	@objc private func baseOMSIntroductionUpdated(notifaction: NSNotification) {
		if let postModel = notifaction.userInfo?["MarketModel"] as? String,
			let marketModel = DHAddDeviceManager.sharedInstance.deviceMarketModel,
			postModel == marketModel {
			self.needUpdateCurrentOMSIntroduction()
		}
	}
    
    // MARK: Complete DeviceAdd Observer
    public func completeDeviceAddObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(completeDeviceAddObserverHandle), name: NSNotification.Name(rawValue: "LCCompleteDeviceAddObserver"), object: nil)
    }
	
    @objc public func completeDeviceAddObserverHandle(notifaction: NSNotification) {
        
    }
    
	func needUpdateCurrentOMSIntroduction() {
		//Do nothing...
	}
	
	// MARK: UIGestureRecognizerDelegate
	@objc func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		let actionType = self.leftActionType()
		if actionType == .back {
			return true
		} else if actionType == .quit {
			self.baseExitAddDevice()
			return false
		}
		
		return true
	}
}

extension DHAddBaseViewController {
	// MARK: LCSheetViewDelegate
	func sheetViewCancel(_ sheetView: LCSheetView!) {
		
	}
	
	func sheetView(_ sheetView: LCSheetView!, clickedButtonAt buttonIndex: Int) {
		guard buttonIndex > 0 else {
			return //0是取消，控件缺陷
		}
	
		if let title = sheetView.button(at: buttonIndex).titleLabel?.text {
			let isWifiConfig = DHAddDeviceManager.sharedInstance.isEntryFromWifiConfig
			if title == DHAddBaseRightAction.switchToWireless.title(isWifiConfig: isWifiConfig) {
				baseSwitchToWirelessVC()
			} else if title == DHAddBaseRightAction.switchToWired.title(isWifiConfig: isWifiConfig) {
				baseSwitchToWiredVC()
            } else if title == DHAddBaseRightAction.switchToSoftAp.title(isWifiConfig: false) {
                baseSwitchToApSoftVC()
            } else {
				baseBackToAddDeviceRoot()
			}
		}
	}
}

extension DHAddBaseViewController {
	// MARK: Controller Operation
	/// 退出添加流程：返回到进入添加流程的入口界面，需要区分国内、海外
	///
	/// - Parameters:
	///   - showAlert: 是否显示提示框
	///   - backToMain: 是否需要返回到首页
	func baseExitAddDevice(showAlert: Bool = true, backToMain: Bool = false) {
		
		let action = {
			//重置数据、停止NetSDK搜索
			DHAddDeviceManager.sharedInstance.reset()
			DHNetSDKSearchManager.sharedInstance().stopSearch()
			
			let controllers = self.navigationController?.viewControllers
			guard controllers != nil else {
                self.popToEntry()
				return
			}
			
            
            if backToMain {
                self.popToHome()
            } else {
                self.popToEntry()
            }

		}
		
		if self.isLeftActionShowAlert(), showAlert {
			self.showQuitAlert(action: action)
		} else {
			action()
		}
	}
	
    func popViewController() {
        //回跳增加判断,扫码、离线配网、在线切wifi都需要
        if self.isKind(of: NSClassFromString("LCAddDeviceModule.DHQRScanViewController")!) {
            let nowNavi = self.navigationController as! DHNavigationController
            let navi = LCBasicNavigationController.init()
            navi.viewControllers = nowNavi.recordVCArr as! [UIViewController]
            let window : UIWindow = UIApplication.shared.delegate!.window!!
            window.rootViewController = navi
            
            self.navigationController?.popViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func popToEntry() {
        let nowNavi = self.navigationController as! DHNavigationController
        let vcArr = NSMutableArray.init(array: nowNavi.recordVCArr)
        vcArr.removeLastObject()
        vcArr.add(self)
        let navi = LCBasicNavigationController.init()
        navi.viewControllers = vcArr as! [UIViewController]
        let window : UIWindow = UIApplication.shared.delegate!.window!!
        window.rootViewController = navi
        self.navigationController?.popViewController(animated: true)
    }
    
    func popToHome() {
        let nowNavi = self.navigationController as! DHNavigationController
        let vcArr = NSMutableArray.init(array: nowNavi.recordVCArr)
        vcArr.removeLastObject()
        vcArr.add(self)
        let navi = LCBasicNavigationController.init()
        navi.viewControllers = vcArr as! [UIViewController]
        let window : UIWindow = UIApplication.shared.delegate!.window!!
        window.rootViewController = navi
        for clsString in self.baseAddSuccessEntryClasses() {
            if let cls = NSClassFromString(clsString), let _ = self.baseBackToViewController(cls: cls) {
     
            }
        }
    }
    
	/// 返回到添加模块的入口处，重新开始使用
	func baseBackToAddDeviceRoot() {
		
		//【*】从重新开始处寻找
		for clsString in self.baseRestartRootClasses() {
			if let cls = NSClassFromString(clsString), let _ = self.baseBackToViewController(cls: cls) {
                //【*】重新开始后，需要清空保存的数据
                DHAddDeviceManager.sharedInstance.reset()
				return
			}
		}
		
		//【*】未成功返回，从离线配网寻找
		if DHAddDeviceManager.sharedInstance.isEntryFromWifiConfig {
			baseExitToOfflineWifiConfigRoot()
		} else {
			//重置数据、停止NetSDK搜索
			DHAddDeviceManager.sharedInstance.reset()
			DHNetSDKSearchManager.sharedInstance().stopSearch()
			self.navigationController?.popToRootViewController(animated: true)
		}
	}
	
	/// 返回离线配网的入口
	func baseExitToOfflineWifiConfigRoot() {
		DHAddDeviceManager.sharedInstance.reset()
		DHNetSDKSearchManager.sharedInstance().stopSearch()
		
        self.popToEntry()
	}
	
	func basePushToFAQ() {
		let controller = DHAddFAQViewController()
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	func basePushToInitializeSearchVC() {
		let controller = DHInitializeSearchViewController.storyboardInstance()
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
    func baseSwitchToApSoftVC() {
        //有线切换到软AP,从IPC Other 进入的可以切换配网方式
        DHAddDeviceManager.sharedInstance.netConfigMode = .softAp
        
        //找到
		if let vc = baseBackBeforeViewController(cls: DHPowerGuideViewController.self, animated: false) {
		    let controller = DHApGuideViewController()
		    vc.navigationController?.pushViewController(controller, animated: true)
		} else if let vc = baseBackBeforeViewController(cls: DHPlugNetGuideViewController.self, animated: false) {
		    //
		    let controller = DHApGuideViewController()
		    vc.navigationController?.pushViewController(controller, animated: true)
		}
    }
    
	func baseSwitchToWiredVC() {
		//无线切换到有线：跳转插网线引导页
		
		
        // 如果是从softAP切换到wire
        if DHAddDeviceManager.sharedInstance.netConfigMode == .softAp {
            //找到soft第一个页面之前的页面 在push
            if let vc = baseBackBeforeViewController(cls: DHApGuideViewController.self, animated: false) {
                let controller = DHPowerGuideViewController()
                vc.navigationController?.pushViewController(controller, animated: false)
            }
            
        } else if let vc = baseBackToViewController(cls: DHPowerGuideViewController.self, animated: false) {
			let controller = DHPlugNetGuideViewController()
			vc.navigationController?.pushViewController(controller, animated: true)
		} else {
            
        }
        
        DHAddDeviceManager.sharedInstance.netConfigMode = .wired
        
	}
	
	func baseSwitchToWirelessVC() {
        
		//有线切换到无线：当前没有连接WIFI，进入WIFI检查页面；当前已连接WIFI，进入WIFI密码界面
		DHAddDeviceManager.sharedInstance.netConfigMode = .wifi
		
		if let vc = baseBackToViewController(cls: DHPowerGuideViewController.self, animated: false) {
			var controller: UIViewController
			if DHNetWorkHelper.sharedInstance().emNetworkStatus == .reachableViaWiFi {
				let passwordVc = DHWifiPasswordViewController.storyboardInstance()
				let presenter = DHWifiPasswordPresenter(container: passwordVc)
				passwordVc.setup(presenter: presenter)
				controller = passwordVc
			} else {
				controller = DHWifiCheckViewController()
			}

			vc.navigationController?.pushViewController(controller, animated: true)
		}

	}
	
	func basePushToConnectCloudVC(devicePassword: String?) {
		let controller = DHConnectCloudViewController.storyboardInstance()
		controller.deviceInitialPassword = devicePassword
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	/// 内部自己处理密码
	func basePushToConnectCloudVC() {
		let controller = DHConnectCloudViewController.storyboardInstance()
		controller.deviceInitialPassword = DHAddDeviceManager.sharedInstance.initialPassword
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	func basePushToBindSuccessVC(deviceName: String, ap: DHApInfo? = nil) {
		let controller = DHBindSuccessViewController.storyboardInstance()
		controller.deviceName = deviceName
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	// MARK: Navigation Controller Operations
	func baseStackControllers() -> [UIViewController] {
		var controllers: [UIViewController] = [UIViewController]()
		if let stackControllers = self.navigationController?.viewControllers {
			controllers.append(contentsOf: stackControllers)
		}
		return controllers
	}
	
	func baseBackToViewController(cls: AnyClass, animated: Bool = true) -> UIViewController? {
		for vc in baseStackControllers() {
			if vc.classForCoder == cls {
				self.navigationController?.popToViewController(vc, animated: animated)
				return vc
			}
		}
		
		return nil
	}
    
    func baseBackBeforeViewController(cls: AnyClass, animated: Bool = true) -> UIViewController? {
        
        var lastVC: UIViewController?
        for vc in baseStackControllers() {
            
            if let `lastVC` = lastVC, vc.classForCoder == cls {
                self.navigationController?.popToViewController(lastVC, animated: animated)
                return lastVC
            }
            lastVC = vc
        }
        return nil
    }
	
	// MARK: 入口地址
	/// 返回按钮：通用退出添加模块的入口地址
	private func baseExitEntryClasses() -> [String] {
		// 需要注意顺序
		// 1级：首页列表、我的设备

		
		//国内：
		let lechangeEntries = ["LCDeviceListViewController"]
		return lechangeEntries
	}
	
	/// 添加成功：跳转的入口地址
	private func baseAddSuccessEntryClasses() -> [String] {
		// 需要注意顺序
		// 1级 首页列表、我的设备
		let lechangeEntries = ["LCDeviceListViewController"]
		return lechangeEntries
	}
	
	/// 通用重新开始返回的入口地址
	private func baseRestartRootClasses() -> [String] {
		/// 扫描页
		let swiftClasses = ["LCAddDeviceModule.DHQRScanViewController"]
		return swiftClasses
	}
}
