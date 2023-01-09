//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//	无线配置引导：WIFI检查
//	4G切到WIFI后，若连上了WiFi，返回此页面后迅速搜索局域网是否有设备。菊花旋转3秒

import UIKit
import LCBaseModule
import AFNetworking

class LCWifiCheckViewController: LCGuideBaseViewController {
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	/// 用来标记自动跳转，防止多次push
	private var isWifiChecked: Bool = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		adjustConstraint()
        guideView.updateDetailButtonlConstraint(bottom: -10)
	}
	
	private func adjustConstraint() {
		guideView.updateTopImageViewConstraint(top: 0, width: 375, maxHeight: 300)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		//避免不再当前页，也进行跳转
		self.addNetworkObserver()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		NotificationCenter.default.removeObserver(self)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func addNetworkObserver() {
		NotificationCenter.default.addObserver(self, selector: #selector(networkChanged), name: NSNotification.Name(rawValue: "LCNotificationWifiNetWorkChange"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(networkChanged), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
	}
	
	@objc func networkChanged() {
		guard LCNetWorkHelper.sharedInstance().emNetworkStatus == AFNetworkReachabilityStatus.reachableViaWiFi.rawValue else {
			return
		}
		
		//DTS000450176，切换到后台，停止了局域网搜索，导致直接跳转输入wifi密码界面
		LCNetSDKSearchManager.sharedInstance()?.startSearch()

		LCProgressHUD.show(on: view)
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			guard self.isTopController() else {
				return
			}
			
			LCProgressHUD.hideAllHuds(self.view)
			self.goToWifiConfigByNetWork()
		}
	}
	
	private func goToWifiConfigByNetWork() {

		//局域网搜索到了设备：支持sc的，进入云配置流程 不支持sc的，使用有线方式进行添加，直接跳转设备初始化搜索界面
		if LCAddDeviceManager.sharedInstance.isDeviceFindInLocalNetwork() {
			if LCAddDeviceManager.sharedInstance.isSupportSC {
				basePushToConnectCloudVC()
			} else {
				LCAddDeviceManager.sharedInstance.netConfigMode = .wired
				basePushToInitializeSearchVC()
			}
			
			return
		}
		
		if LCNetWorkHelper.sharedInstance().emNetworkStatus == AFNetworkReachabilityStatus.reachableViaWiFi.rawValue, isWifiChecked == false {
			isWifiChecked = true
			let passwordVc = LCWifiPasswordViewController.storyboardInstance()
			let presenter = LCWifiPasswordPresenter(container: passwordVc)
			passwordVc.setup(presenter: presenter)
			self.navigationController?.pushViewController(passwordVc, animated: true)
		}
	}
	
	// MARK: LCGuideBaseVCProtocol
	override func tipText() -> String? {
		return "add_device_confirm_to_connect_correct_wifi".lc_T
	}
	
	override func tipImageName() -> String? {
		return "adddevice_netsetting_connectwifi"
	}
	
	override func descriptionText() -> String? {
		return "add_device_connect_and_goto_next".lc_T
	}
	
    override func detailText() -> String? {
        return "add_device_goto_connect_wifi".lc_T
    }
	override func isCheckHidden() -> Bool {
		return true
	}
	
	override func isDetailHidden() -> Bool {
        return false
	}
	
	override func isNextStepHidden() -> Bool {
		return true
	}
	
	// MARK: LCAddBaseVCProtocol
	override func rightActionType() -> [LCAddBaseRightAction] {
		var actions: [LCAddBaseRightAction] = [.restart]
		if LCAddDeviceManager.sharedInstance.supportConfigModes.contains(.wired) {
			actions.append(.switchToWired)
		}
		
		return actions
	}
    
    override func doDetail() {
        print("LCWifiCheckViewController doDetail")
        let url = URL.init(string: UIApplicationOpenSettingsURLString)!
        if #available(iOS 10.0, *) {
            //先判断是否有iOS10SDK的方法，如果有，则实现iOS10的跳转
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            // Fallback on earlier versions
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        }
    }
	
    override func doError() {
        let vc = LCDeviceAddErrorController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
