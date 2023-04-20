//
//  Copyright © 2018年 Imou. All rights reserved.
//

import UIKit
import LCBaseModule
import AFNetworking

@objcMembers class LCAddBaseViewController: LCBaseViewController, LCAddBaseVCProtocol, LCSheetViewDelegate {
	var btnNaviRight: UIButton!
    var customNavView: UIView!
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.title = LCAddDeviceManager.sharedInstance.isEntryFromWifiConfig ? "device_manager_network_config".lc_T() : "add_device_title".lc_T()
        self.view.backgroundColor = UIColor.lccolor_c43()
        self.initLeftNavigationItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	override func onLeftNaviItemClick(_ button: UIButton) {
		let actionType = self.leftActionType()
		if actionType == .back {
            self.navigationController?.popViewController(animated: true)
		} else if actionType == .quit {
			self.baseExitAddDevice()
		} else if actionType == .backToScan {
			_ = self.baseBackToViewController(cls: LCQRScanViewController.classForCoder())
		}
	}
	
	func setupNaviRightItem() {
		btnNaviRight = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
		btnNaviRight.contentHorizontalAlignment = .right
        btnNaviRight.imageView?.contentMode = .scaleAspectFit
		btnNaviRight.setImage(UIImage(lc_named: "common_nav_more"), for: .normal)
		btnNaviRight.addTarget(self, action: #selector(onRightAction), for: .touchUpInside)
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btnNaviRight)
		
		btnNaviRight.isHidden = self.isRightActionHidden()
	}
	
	func showQuitAlert(action: (() -> ())?) {
        LCAlertView.lc_ShowAlert(title: "Alert_Title_Notice2".lc_T(), detail: "add_device_config_not_complete_tip".lc_T(), confirmString: "add_device_confrim_to_quit".lc_T(), cancelString: "common_cancel".lc_T()) { isConfirmSelected in
            if isConfirmSelected == true {
                action?()
            }
        }
	}
	
	private func setupRightActionContent() {
		var otherTitles = [String]()
        if LCAddDeviceManager.sharedInstance.isAccessory {
            otherTitles.append("add_device_restart".lc_T())
        } else {
            var modes = [LCAddBaseRightAction]()
            if LCAddDeviceManager.sharedInstance.netConfigMode == .softAp {
                modes.append(.restart)
                if LCAddDeviceManager.sharedInstance.supportWired() {
                    modes.append(.switchToWired)
                }
            } else if LCAddDeviceManager.sharedInstance.netConfigMode == .soundWave || LCAddDeviceManager.sharedInstance.netConfigMode == .soundWaveV2 || LCAddDeviceManager.sharedInstance.netConfigMode == .smartConfig  {
                modes.append(.restart)
                if LCAddDeviceManager.sharedInstance.supportWired() {
                    modes.append(.switchToWired)
                }
            } else if LCAddDeviceManager.sharedInstance.netConfigMode == .lan {
                modes.append(.restart)
                if LCAddDeviceManager.sharedInstance.supportWifi() {
                    modes.append(.switchToWireless)
                }
                if LCAddDeviceManager.sharedInstance.supportSoftAP() {
                    modes.append(.switchToSoftAp)
                }
            } else {
                modes.append(.restart)
            }
            for action in modes {
                otherTitles.append(action.title())
            }
        }
		//隐藏键盘
		view.endEditing(true)
		let sheet = LCSheetView(title: nil, message: nil, delegate: self, cancelButton: "common_cancel".lc_T(), otherButtons: otherTitles)
		sheet?.show()
	}
	
	// MARK: LCAddBaseVCProtocol
	func leftActionType() -> LCAddBaseLeftAction {
		return .back
	}
    
    func rightActionType() -> [LCAddBaseRightAction] {
        return [LCAddBaseRightAction]()
    }
	
	func isRightActionHidden() -> Bool {
		return false
	}
	
	func enableRightAction(enable: Bool) {
		btnNaviRight.lc_enable = enable
	}
	
	func isLeftActionShowAlert() -> Bool {
		return false
	}
	
	
	@objc func onRightAction(button: UIButton) {
		setupRightActionContent()
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

extension LCAddBaseViewController {
	// MARK: LCSheetViewDelegate
	func sheetViewCancel(_ sheetView: LCSheetView!) {
		
	}
	
	func sheetView(_ sheetView: LCSheetView!, clickedButtonAt buttonIndex: Int) {
		guard buttonIndex > 0 else {
			return //0是取消，控件缺陷
		}
        
		if let title = sheetView.button(at: buttonIndex).titleLabel?.text {
			if title == LCAddBaseRightAction.switchToWireless.title() {
				baseSwitchToWirelessVC()
			} else if title == LCAddBaseRightAction.switchToWired.title() {
				baseSwitchToWiredVC()
            } else if title == LCAddBaseRightAction.switchToSoftAp.title() {
                baseSwitchToApSoftVC()
            } else {
				baseBackToAddDeviceRoot()
			}
		}
	}
}

extension LCAddBaseViewController {
	// MARK: Controller Operation
	/// 退出添加流程：返回到进入添加流程的入口界面，需要区分国内、海外
	///
	/// - Parameters:
	///   - showAlert: 是否显示提示框
	///   - backToMain: 是否需要返回到首页
	func baseExitAddDevice(showAlert: Bool = true) {
		let action = { [weak self] in
			LCAddDeviceManager.sharedInstance.reset()
            LCOpenSDK_SearchDevices.share().stop()
            self?.navigationController?.lc_popToViewController(withClassName: "LCDeviceListViewController", animated: true)
		}
		
		if self.isLeftActionShowAlert(), showAlert {
			self.showQuitAlert(action: action)
		} else {
			action()
		}
	}
	
    func popViewController() {
        //回跳增加判断,扫码、离线配网、在线切wifi都需要
        if self.isKind(of: NSClassFromString("LCAddDeviceModule.LCQRScanViewController")!) {
            let nowNavi = self.navigationController as! LCNavigationController
            let navi = LCNavigationController.init()
            navi.viewControllers = nowNavi.recordVCArr as! [UIViewController]
            let window : UIWindow = UIApplication.shared.delegate!.window!!
            window.rootViewController = navi
            
            self.navigationController?.popViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func popToEntry() {
        let nowNavi = self.navigationController as! LCNavigationController
        let vcArr = NSMutableArray.init(array: nowNavi.recordVCArr)
        vcArr.removeLastObject()
        vcArr.add(self)
        let navi = LCNavigationController.init()
        navi.viewControllers = vcArr as! [UIViewController]
        let window : UIWindow = UIApplication.shared.delegate!.window!!
        window.rootViewController = navi
        self.navigationController?.popViewController(animated: true)
    }
    
	/// 返回到添加模块的入口处，重新开始使用
	func baseBackToAddDeviceRoot() {
		//【*】从重新开始处寻找
		for clsString in self.baseRestartRootClasses() {
			if let cls = NSClassFromString(clsString), let _ = self.baseBackToViewController(cls: cls) {
                //【*】重新开始后，需要清空保存的数据
                LCAddDeviceManager.sharedInstance.reset()
				return
			}
		}
		
		//【*】未成功返回，从离线配网寻找
		if LCAddDeviceManager.sharedInstance.isEntryFromWifiConfig {
			baseExitToOfflineWifiConfigRoot()
		} else {
			//重置数据、停止NetSDK搜索
			LCAddDeviceManager.sharedInstance.reset()
			self.navigationController?.popToRootViewController(animated: true)
		}
	}
	
	/// 返回离线配网的入口
	func baseExitToOfflineWifiConfigRoot() {
		LCAddDeviceManager.sharedInstance.reset()
        self.navigationController?.lc_popToViewController(withClassName: "LCDeviceDetailVC", animated: true)
	}
	
	func basePushToFAQ() {
		let controller = LCAddFAQViewController()
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	func basePushToInitializeSearchVC() {
		let controller = LCInitializeSearchViewController.storyboardInstance()
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
    func baseSwitchToApSoftVC() {
        let oldNetConfigMode = LCAddDeviceManager.sharedInstance.changeNetConfigToSoftAP()
        let currentNetConfigMode = LCAddDeviceManager.sharedInstance.netConfigMode
		if let vc = baseBackToViewController(cls: LCPowerGuideViewController.self, animated: false) {
		    let controller = LCApGuideViewController()
		    vc.navigationController?.pushViewController(controller, animated: true)
		}
    }
    
	func baseSwitchToWiredVC() {
        let oldNetConfigMode = LCAddDeviceManager.sharedInstance.changeNetConfigToWired()
        let currentNetConfigMode = LCAddDeviceManager.sharedInstance.netConfigMode
        if currentNetConfigMode == .softAp {
            if let vc = baseBackToViewController(cls: LCPowerGuideViewController.self, animated: false) {
                let controller = LCApGuideViewController()
                vc.navigationController?.pushViewController(controller, animated: false)
            }
            
        } else if let vc = baseBackToViewController(cls: LCQRScanViewController.self, animated: false) {
			let controller = LCWiredOrSIMGuideViewController()
			vc.navigationController?.pushViewController(controller, animated: true)
		}
	}
	
    func baseSwitchToWirelessVC() {
        let oldNetConfigMode = LCAddDeviceManager.sharedInstance.changeNetConfigToWireless()
        let currentNetConfigMode = LCAddDeviceManager.sharedInstance.netConfigMode
        if let vc = baseBackToViewController(cls: LCQRScanViewController.self, animated: false) {
            let passwordVc = LCWifiPasswordViewController.storyboardInstance()
            let presenter = LCWifiPasswordPresenter(container: passwordVc)
            passwordVc.setup(presenter: presenter)
            vc.navigationController?.pushViewController(passwordVc, animated: true)
        }
    }
	
	func basePushToConnectCloudVC(devicePassword: String?) {
		let controller = LCConnectCloudViewController.storyboardInstance()
		controller.deviceInitialPassword = devicePassword
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	func basePushToConnectCloudVC() {
		let controller = LCConnectCloudViewController.storyboardInstance()
		controller.deviceInitialPassword = LCAddDeviceManager.sharedInstance.initialPassword
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
	func basePushToBindSuccessVC(deviceName: String, ap: LCApInfo? = nil) {
		let controller = LCBindSuccessViewController.storyboardInstance()
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
	
	/// 通用重新开始返回的入口地址
	private func baseRestartRootClasses() -> [String] {
		/// 扫描页
		let swiftClasses = ["LCAddDeviceModule.LCQRScanViewController"]
		return swiftClasses
	}
}
