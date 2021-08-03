//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//  WIFI密码界面解释器

import UIKit
import LCBaseModule

protocol DHWifiPasswordPresenterProtocol {
    var container: DHWifiPasswordViewController? {
        set get
    }
    
    init(container: DHWifiPasswordViewController)
	
	func updateContainerViewByNetwork()

    func setupSupportView()
    
	func nextStepAction(wifiSSID: String, wifiPassword: String?)
}

class DHWifiPasswordPresenter: NSObject, DHWifiPasswordPresenterProtocol {
    weak var container: DHWifiPasswordViewController?
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
    required init(container: DHWifiPasswordViewController) {
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
	
	// MARK: - DHWifiPasswordPresenterProtocol
	func updateContainerViewByNetwork() {
		if self.container?.nextButton == nil {
			// 可能还没有创建
			return
		}
		
		//iOS13兼容：iOS13以上需要判断 BSSID是否为系统默认的
		if #available(iOS 13.0, *) {
			if DHMobileInfo.sharedInstance()?.wifibssid == "00:00:00:00:00:00" {
				self.container?.nextButton.dh_enable = false
				self.container?.wifiNameLabel.text = ""
				self.container?.passwordInputView.textField.text = ""
				return
			}
		}
		
		if DHNetWorkHelper.sharedInstance().emNetworkStatus == .reachableViaWiFi {
			self.container?.nextButton.dh_enable = true
			self.container?.wifiNameLabel.text = DHMobileInfo.sharedInstance().wifissid ?? ""
			
			//【*】直接从保存的密码取：如果长度大于0，选中check，并填充密码
			if let password = DHUserManager.shareInstance().ssidPwd(by: self.container?.wifiNameLabel.text), password.count > 0 {
				self.container?.checkButton.isSelected = true
				self.container?.passwordInputView.textField.text = password
			} else {
				self.container?.checkButton.isSelected = false
				self.container?.passwordInputView.textField.text = nil
			}
			
		} else {
			self.container?.nextButton.dh_enable = false
			self.container?.wifiNameLabel.text = ""
			self.container?.passwordInputView.textField.text = ""
		}
	}
	
    func setupSupportView() {
        container?.supportView.isHidden = DHAddDeviceManager.sharedInstance.isSupport5GWifi
		
		if DHAddDeviceManager.sharedInstance.isSupport5GWifi {
			container?.checkWidthConstraint.constant = 250
			container?.imageView.image = UIImage(named: "adddevice_icon_wifipassword")
		} else {
			container?.imageView.image = UIImage(named: "adddevice_icon_wifipassword_nosupport5g")
		}
    }
    
    func nextStepAction(wifiSSID: String, wifiPassword: String?) {
        //跳转设备指示灯检查页面
        let connectVc = DHDeviceLightCheckViewController()
        self.container?.navigationController?.pushViewController(connectVc, animated: true)
    }
}
