//
//  Copyright © 2018年 Zhejiang Imou Technology Co.,Ltd. All rights reserved.
//  WIFI密码界面解释器

import UIKit
import LCBaseModule
import AFNetworking

protocol LCWifiPasswordPresenterProtocol {
    var container: LCWifiPasswordViewController? {
        set get
    }
    
    init(container: LCWifiPasswordViewController)
	
	func updateContainerViewByNetwork()

    func setupSupportView()
    
	func nextStepAction(wifiSSID: String, wifiPassword: String?)
}

class LCWifiPasswordPresenter: NSObject, LCWifiPasswordPresenterProtocol {
    weak var container: LCWifiPasswordViewController?
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
    required init(container: LCWifiPasswordViewController) {
		super.init()
        self.container = container
		self.addNetworkObserver()
		
    }
	
	// MARK: - Network Observer
	func addNetworkObserver() {
		NotificationCenter.default.addObserver(self, selector: #selector(networkChanged), name: NSNotification.Name(rawValue: "LCNotificationWifiNetWorkChange"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(networkChanged), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
	}
	
	@objc func networkChanged() {
		self.updateContainerViewByNetwork()
	}
	
	// MARK: - LCWifiPasswordPresenterProtocol
	func updateContainerViewByNetwork() {
		if self.container?.nextButton == nil {
			// 可能还没有创建
			return
		}
		
		//iOS13兼容：iOS13以上需要判断 BSSID是否为系统默认的
		if #available(iOS 13.0, *) {
			if LCMobileInfo.sharedInstance()?.wifibssid == "00:00:00:00:00:00" {
				self.container?.nextButton.lc_enable = false
				self.container?.wifiNameLabel.text = ""
				self.container?.passwordInputView.textField.text = ""
				return
			}
		}
		
		if LCNetWorkHelper.sharedInstance().emNetworkStatus == AFNetworkReachabilityStatus.reachableViaWiFi.rawValue {
			self.container?.nextButton.lc_enable = true
			self.container?.wifiNameLabel.text = LCMobileInfo.sharedInstance().wifissid ?? ""
			
			//【*】直接从保存的密码取：如果长度大于0，选中check，并填充密码
			if let password = LCUserManager.shareInstance().ssidPwd(by: self.container?.wifiNameLabel.text), password.count > 0 {
				self.container?.checkButton.isSelected = true
				self.container?.passwordInputView.textField.text = password
			} else {
				self.container?.checkButton.isSelected = false
				self.container?.passwordInputView.textField.text = nil
			}
			
		} else {
			self.container?.nextButton.lc_enable = false
			self.container?.wifiNameLabel.text = ""
			self.container?.passwordInputView.textField.text = ""
		}
	}
	
    func setupSupportView() {
        container?.supportView.isHidden = LCAddDeviceManager.sharedInstance.isSupport5GWifi
		
		if LCAddDeviceManager.sharedInstance.isSupport5GWifi {
			container?.checkWidthConstraint.constant = 250
			container?.imageView.image = UIImage(named: "adddevice_icon_wifipassword")
		} else {
			container?.imageView.image = UIImage(named: "adddevice_icon_wifipassword_nosupport5g")
		}
    }
    
    func nextStepAction(wifiSSID: String, wifiPassword: String?) {
        // iot设备
        if let productId = LCAddDeviceManager.sharedInstance.productId, productId.length > 0 {
            LCProgressHUD.show(on: self.container?.view, tip: "add_device_bluetooth_linking".lc_T)
            LCOpenSDK_Bluetooth.startAsyncBLEConfig(wifiSSID, wifiPwd: wifiPassword ?? "", productId: productId, deviceId: LCAddDeviceManager.sharedInstance.deviceId) { success, errorMessage in
                LCProgressHUD.hideAllHuds(self.container?.view)
                if success {
                    LCProgressHUD.showMsg("equipment_distribution_network_succeeded".lc_T)
                    let controller = LCConnectCloudViewController.storyboardInstance()
                    controller.deviceInitialPassword = LCAddDeviceManager.sharedInstance.initialPassword
                    self.container?.navigationController?.pushViewController(controller, animated: true)
                } else {
                    LCProgressHUD.showMsg("设备配网失败，请重试\n" + errorMessage, duration: 5)
                }
            }
        } else {
            //跳转设备指示灯检查页面
            let connectVc = LCDeviceLightCheckViewController()
            self.container?.navigationController?.pushViewController(connectVc, animated: true)
        }
    }
}
