//
//  Copyright © 2018年 Zhejiang Dahua Technology Co.,Ltd. All rights reserved.
//

import UIKit

class DHApWifiPasswordPresenter: NSObject, DHWifiPasswordPresenterProtocol {
	
    var container: DHWifiPasswordViewController?
	
	/// 设备密码
    var devicePassword: String = "admin"
	
	/// 软AP WIFI列表中选中的WIFI
	var wifiSSID: String = ""
	
	/// 软AP WIFI列表选中WIFI的加密模式
    var encryptionAuthority: Int = 0
	
	/// 软AP 连接WIFI时的网卡，eth2或wlan0
	var netcardName: String = "eth2"
    
    var scDeviceIsInited: Bool = false
    
    required init(container: DHWifiPasswordViewController) {
        self.container = container
    }
	
	// MARK: DHWifiPasswordPresenterProtocol
	func updateContainerViewByNetwork() {
		
		if self.container?.nextButton == nil {
			// 可能还没有创建
			return
		}
		
		//软AP的WIFI名称是从上级界面选中的
		self.container?.wifiNameLabel.text = wifiSSID
		
		//【*】直接从保存的密码取：如果长度大于0，选中check，并填充密码
		if let password = DHUserManager.shareInstance().ssidPwd(by: wifiSSID), password.count > 0 {
			self.container?.checkButton.isSelected = true
			self.container?.passwordInputView.textField.text = password
		} else {
			self.container?.checkButton?.isSelected = false
			self.container?.passwordInputView.textField.text = nil
		}
	}
	
    func setupSupportView() {
		//软AP不显示5g提示及wifi检测
        self.container?.supportView.isHidden = true
		container?.checkWidthConstraint.constant = 250
		container?.wifiDetectButton.isHidden = true
    }
    
    func nextStepAction(wifiSSID: String, wifiPassword: String?) {
        //连接wifi
        let deviceId = DHAddDeviceManager.sharedInstance.deviceId
        let device = DHNetSDKSearchManager.sharedInstance().getNetInfo(byID: deviceId)
        guard device != nil else {
			LCProgressHUD.showMsg("add_device_connect_failed".lc_T)
            return
        }
        
        LCProgressHUD.show(on: self.container?.view)
        
        if true == DHAddDeviceManager.sharedInstance.isSupportSC && false == self.scDeviceIsInited {
            if let pwd = wifiPassword {
                DHNetSDKHelper.scDeviceApConnectWifi(wifiSSID, password: pwd, ip: device!.deviceIP, port: Int(device!.port), encryptionAuthority: Int32(self.encryptionAuthority)) { (error) in
                        LCProgressHUD.hideAllHuds(self.container?.view)
                        self.devicePassword = DHAddDeviceManager.sharedInstance.initialPassword
                        self.connectWifiSuccessProcess()
                    }
                }
            
        } else {
            DHNetSDKHelper.loginWithHighLevelSecurity(byIp: device!.deviceIP, port: Int(device!.port), username: "admin", password: devicePassword, success: { (handle) in
                let ssid = wifiSSID
                let pwd = wifiPassword
                DHNetSDKHelper.connectWIFI(byLoginHandle: handle, ssid: ssid, password: pwd, encryptionAuthority: Int32(self.encryptionAuthority), netcardName: self.netcardName, complete: { success in
                    LCProgressHUD.hideAllHuds(self.container?.view)
                    self.connectWifiSuccessProcess()
                })
                
            }) { (description) in
                LCProgressHUD.hideAllHuds(self.container?.view)
                LCProgressHUD.showMsg("add_device_connect_failed".lc_T)
            }
        }
    }
	
	private func connectWifiSuccessProcess() {
		//【*】新方案不区分p2p、非p2p，进入连接乐橙云平台界面
		//【*】其他设备，进入连接乐橙云平台界面
		self.container?.basePushToConnectCloudVC(devicePassword: devicePassword)
	}
}
